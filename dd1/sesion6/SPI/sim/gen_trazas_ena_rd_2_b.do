onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gen_trazas_ena_rd_2_b/clk
add wave -noupdate /gen_trazas_ena_rd_2_b/nRst
add wave -noupdate -radix unsigned -radixshowbase 0 /gen_trazas_ena_rd_2_b/cnt_T
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_2_b/start
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_2_b/rdy
add wave -noupdate -expand -group Antecedente /gen_trazas_ena_rd_2_b/nWR_RD
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_2_b/nCS
add wave -noupdate -expand -group Consecuente /gen_trazas_ena_rd_2_b/ena_rd
add wave -noupdate -divider Aserciones
add wave -noupdate /gen_trazas_ena_rd_2_b/ass_2_tics_ena_rd_1
add wave -noupdate /gen_trazas_ena_rd_2_b/ass_2_tics_ena_rd_2
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
