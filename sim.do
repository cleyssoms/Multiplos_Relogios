if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work
vlog queue.sv
vlog deserializer.sv
vlog top.sv
quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1
do wave_queue.do
run 1ms
