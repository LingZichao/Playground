CC=gcc
CFLAGS=-O2 -Wall

datalink: datalink.o protocol.o lprintf.o crc32.o
	$(CC) $(CFLAGS) $^ -o datalink -lm 

clean:
	${RM} *.o datalink *.log

