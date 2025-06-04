onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /queue/clk_10khz
add wave -noupdate /queue/reset
add wave -noupdate /queue/data_in
add wave -noupdate /queue/enqueue_in
add wave -noupdate /queue/dequeue_in
add wave -noupdate /queue/len_out
add wave -noupdate /queue/data_out
add wave -noupdate /deserializer/clk_100mhz
add wave -noupdate /deserializer/reset
add wave -noupdate /deserializer/data_in
add wave -noupdate /deserializer/write_in
add wave -noupdate /deserializer/ack_in
add wave -noupdate /deserializer/data_out
add wave -noupdate /deserializer/data_ready
add wave -noupdate /deserializer/status_out
add wave -noupdate /top_tb/clk
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
WaveRestoreZoom {0 ns} {0.18 ns}
