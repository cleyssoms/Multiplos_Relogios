if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work
vlog queue.sv
vlog deserializer.sv
vlog top.sv
vlog top_tb.sv
vsim work.top_tb
quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1
do wave.do
run 2ms
