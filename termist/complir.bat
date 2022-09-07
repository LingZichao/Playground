set target=mips

iverilog -y ./src -I ./src -o %target%.out ./%target%_tb.v 
vvp %target%.out