onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top/clk_100khz
add wave -noupdate /top/clk_10khz
add wave -noupdate /top_tb/deserializer_rst
add wave -noupdate /top_tb/queue_rst
add wave -noupdate /top_tb/data_in
add wave -noupdate /top_tb/write_in
add wave -noupdate /top_tb/dequeue_in
add wave -noupdate /top_tb/queue_data_out
add wave -noupdate /top/deserialized_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 140
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 ns}
