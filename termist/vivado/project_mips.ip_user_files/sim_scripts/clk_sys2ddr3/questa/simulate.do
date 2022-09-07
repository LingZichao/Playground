onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_sys2ddr3_opt

do {wave.do}

view wave
view structure
view signals

do {clk_sys2ddr3.udo}

run -all

quit -force
