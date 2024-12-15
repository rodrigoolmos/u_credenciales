onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gen_trazas_start_then_ncs_low/clk
add wave -noupdate /gen_trazas_start_then_ncs_low/nRst
add wave -noupdate -radix unsigned -radixshowbase 0 /gen_trazas_start_then_ncs_low/cnt_T
add wave -noupdate /gen_trazas_start_then_ncs_low/start
add wave -noupdate /gen_trazas_start_then_ncs_low/rdy
add wave -noupdate -divider Consecuente
add wave -noupdate /gen_trazas_start_then_ncs_low/nCS
add wave -noupdate -divider Asercion
add wave -noupdate /gen_trazas_start_then_ncs_low/ass_start_then_nCS_low
add wave -noupdate /gen_trazas_start_then_ncs_low/asm_gu_start_tic
add wave -noupdate -divider Cover
add wave -noupdate /gen_trazas_start_then_ncs_low/cover_start_rdy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1390 ns} 0}
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
WaveRestoreZoom {0 ns} {1746 ns}
