onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_timer_25/nRst
add wave -noupdate /test_timer_25/clk
add wave -noupdate /test_timer_25/tic_25
add wave -noupdate -divider Aserción
add wave -noupdate -childformat {{/test_timer_25/dut/div_param -radix unsigned}} -expand -subitemconfig {/test_timer_25/dut/div_param {-height 15 -radix unsigned -radixshowbase 0}} /test_timer_25/dut/assert__tic_N_periodico
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9894 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {10763 ns}
