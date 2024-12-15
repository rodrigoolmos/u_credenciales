onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gen_trazas_ena_rd_1/clk
add wave -noupdate /gen_trazas_ena_rd_1/nRst
add wave -noupdate -radix unsigned -radixshowbase 0 /gen_trazas_ena_rd_1/cnt_T
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_1/start
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_1/rdy
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_1/nWR_RD
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_1/nCS
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_1/ena_rd
add wave -noupdate /gen_trazas_ena_rd_1/ass_2_tics_ena_rd_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170 ns} 0}
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
