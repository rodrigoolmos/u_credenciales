onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gen_trazas_ena_rd_3/clk
add wave -noupdate /gen_trazas_ena_rd_3/nRst
add wave -noupdate -radix unsigned -radixshowbase 0 /gen_trazas_ena_rd_3/cnt_T
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_3/start
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_3/rdy
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_3/nWR_RD
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_3/nCS
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_3/ena_rd
add wave -noupdate -divider Aserciones
add wave -noupdate /gen_trazas_ena_rd_3/ass_2_tics_ena_rd_1
add wave -noupdate /gen_trazas_ena_rd_3/ass_2_tics_ena_rd_2
add wave -noupdate /gen_trazas_ena_rd_3/ass_2_tics_ena_rd_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4512 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 192
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
WaveRestoreZoom {0 ns} {7364 ns}
