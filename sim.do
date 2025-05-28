if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work
vlog deserializer.sv
vlog deserializer_tb.sv
vsim work.deserializer_tb
quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1
do wave.do
run 1ms