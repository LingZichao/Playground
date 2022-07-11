#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "protocol.h"
#include "datalink.h"
/* 540 + 258 = 798 */
#define DATA_TIMER 3000 // 数据帧超时时间
#define ACK_DELAYED 280	// ACK帧的超时时间
#define SEQ_MAX_LEN 128 // 帧序号的最大值
#define SWINDOW_LEN 64  // NR_BUF , 窗口缓冲区的大小
#define NON_ACK SEQ_MAX_LEN // 不携带ACK帧的特例编号

typedef unsigned char byte;

/* FRAME_DATA */
struct FRAME {
	byte kind; 
	byte ack;
	byte seq;
	byte data[PKT_LEN];
	unsigned int padding;
};

static int phl_ready = 0;

/* slide-window basic tools */
#define PTR_MOV(ptr) (ptr == SEQ_MAX_LEN - 1) ? ptr = 0 : ptr++

/* calculate buffer len */
#define BUFFER_LEN(x , e) 					\
		(    (e >= x##_head) ?   			\
			 (e -  x##_head) :   			\
			 (e +  SEQ_MAX_LEN - x##_head ) )

#define BUFFER_ADD(x) PTR_MOV( x##_tail )
#define BUFFER_DEL(x) {	 									 \
		while( x##_buffer[ x##_head ].kind == FRAME_EMPTY && \
				x##_head != x##_tail ) PTR_MOV( x##_head ); } 
		

/* slide-window for sending data */
static struct FRAME s_buffer[SEQ_MAX_LEN];
static byte s_head = 0, s_tail = 0;

#define SEND_LEN BUFFER_LEN(s , s_tail)
#define SEND_ADD BUFFER_ADD(s)
#define SEND_DEL BUFFER_DEL(s)

/* slide-window for receiving data */
static struct FRAME r_buffer[SEQ_MAX_LEN];
static byte r_head = 0 ,  nbuffered = 0;

#define RECV_LEN BUFFER_LEN(r , f->seq)
#define RECV_ADD BUFFER_ADD(r)
#define RECV_DEL PTR_MOV(r_head)

/* send single frame to phi layer with crc checksum */
static void send_frame_with_crc(byte *frame, int len)
{
	*(unsigned int *)(frame + len) = crc32(frame, len);
	send_frame(frame, len + 4);
	phl_ready = 0;
}

/* send single frame from send_buffer with up-tp-date ACK */
static void send_piggy_frame(byte cur)
{
	s_buffer[cur].kind = FRAME_DATA;
	s_buffer[cur].seq  = cur;
	s_buffer[cur].ack = (nbuffered) ? r_head : NON_ACK; /* initial ACK */

	dbg_frame("Send DATA %d %d, ID %d\n", 
			s_buffer[cur].seq, s_buffer[cur].ack, 
			*(short *)s_buffer[cur].data);

	send_frame_with_crc((byte *)&s_buffer[cur], 3 + PKT_LEN);

	/* handle data and ack timer */
	start_timer(cur , DATA_TIMER);
	stop_ack_timer();
}

/* send single ack from send_buffer */
static void send_ack_frame(byte cur)
{
	struct FRAME s;

	s.kind = FRAME_ACK;
	s.ack  = cur;

	dbg_frame("Send ACK %d\n", s.ack);

	send_frame_with_crc((byte *)&s, 2);
}

/* send single nak from send_buffer */
static void send_nak_frame(byte cur)
{
	struct FRAME s;

	s.kind = FRAME_NAK;
	s.ack  = cur;

	dbg_frame("Send NAK %d\n", s.ack);

	send_frame_with_crc((byte *)&s, 2);
}

/* Submit Frame sequeue in slide-window*/
static void put_frame_seq(void) 
{
	dbg_frame("Submit:%d\n" , r_head);

	while( r_buffer[r_head].kind != FRAME_EMPTY ) {
		dbg_frame("\tPKT_SEQ : %d - %d\n" ,
				 r_buffer[r_head].seq , 
				 *(short *)&r_buffer[r_head].data ); 

		put_packet((byte *)&r_buffer[r_head].data , PKT_LEN); 
		r_buffer[r_head].kind = FRAME_EMPTY;

		PTR_MOV(r_head);
	}
}

/* check whether cur match slide-window length
 *
 *	+----------------------------+ SEQ_MAX_LEN
 *        ^               ^
 *    1   |      0        |   1
 *    r_head           r_tail
 */
static inline int between(int a, int b, int c){
	return((a < b) && (b < c)) || ((c < a) && (a < b)) || ((b < c) && (c < a));
}

/* handle ACK confirm list */
static inline void handle_ACK_part(byte cur)
{
	if(cur == NON_ACK ) return ;
	dbg_frame("HIT %d - %d - %d\n" ,s_head , cur , s_tail);

	while ( between(s_head , cur , s_tail) ) {
		s_buffer[s_head].kind = FRAME_EMPTY;
		stop_timer(s_head);

		PTR_MOV(s_head);
	}
	SEND_DEL;
}

/* receive single frame and detect it */
static inline void dispatch_frame(struct FRAME* f , int len)
{
	switch ( f->kind )
	{
	case FRAME_ACK :
		dbg_frame("Recv ACK %d\n", f->ack);
		handle_ACK_part(f->ack);
		break;

	case FRAME_NAK : 
		dbg_frame("Recv NAK %d\n", f->ack);
		s_buffer[f->ack].kind = FRAME_EMPTY;
		stop_timer(f->ack);
		break;

	case FRAME_DATA : 
		dbg_frame("Recv DATA %d %d, ID %d\n", f->seq,
				f->ack , *(short *)f->data);
		
		/* check whether between */
		if ( RECV_LEN <= SWINDOW_LEN )
			memcpy(&r_buffer[f->seq] , f , sizeof(struct FRAME));
		/* No dump and be expected  */
		if ( f->seq == r_head ) {
			/* Start ACK TIMER before frame put  */
			nbuffered = 1;
			start_ack_timer(ACK_DELAYED);
			put_frame_seq();
		} else
			send_nak_frame(f->seq);

		handle_ACK_part(f->ack);
		break;

	default:
		dbg_warning("**** BAD FRAME KIND!\n");
		break;
	}
}

int main(int argc, char **argv)
{
	int event, arg;
	struct FRAME f;
	int len = 0;

	protocol_init(argc, argv);
	lprintf("Designed by 2020212900 Ling Zichao, based on Pro.Jiang's. "
			"build: " __DATE__ "  "__TIME__"\n");

	disable_network_layer();

	for (;;) {
		event = wait_for_event(&arg);

		switch (event) 
		{
		/* get new packet from top layer */
		case NETWORK_LAYER_READY:
			get_packet( s_buffer[s_tail].data );
			send_piggy_frame(s_tail);
			SEND_ADD; break;

		/* signal from down layer */
		case PHYSICAL_LAYER_READY:
			phl_ready = 1;
			break;

		case FRAME_RECEIVED:
			len = recv_frame((byte *)&f , sizeof f);
			
			/* process crc check */
			if (len < 5 || crc32((byte *)&f , len) != 0) {
				dbg_event("**** Receiver SEQ.%d - ACK.%d Error, Bad CRC Checksum\n" , f.seq , f.ack);
				break;
			}
			dispatch_frame(&f , len);

			break;

		case DATA_TIMEOUT:
			dbg_event("---- DATA %d timeout\n", arg);
			send_piggy_frame(arg);
			break;

		case ACK_TIMEOUT:
			dbg_event("---- ACK %d timeout\n", r_head);
			send_ack_frame(r_head);
			break;

		default :
			dbg_warning("**** Unknown Event\n");
		}
		
		dbg_event("\tS_LEN : [ %d - %d ] = %d || R_LEN [ - %d]\n" ,
					s_tail , s_head , SEND_LEN , r_head);
		if (SEND_LEN < SWINDOW_LEN && phl_ready)
			enable_network_layer();
		else
			disable_network_layer();
	}

	return 0;
}