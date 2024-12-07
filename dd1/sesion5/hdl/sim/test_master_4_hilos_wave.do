onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Señales Globales}
add wave -noupdate /test_master_spi_4_hilos/dut/clk
add wave -noupdate /test_master_spi_4_hilos/dut/nRst
add wave -noupdate -divider {Interfaz control Master}
add wave -noupdate -divider {Entradas control Master}
add wave -noupdate -radix hexadecimal /test_master_spi_4_hilos/dut/no_bytes
add wave -noupdate /test_master_spi_4_hilos/dut/start
add wave -noupdate /test_master_spi_4_hilos/dut/nWR_RD
add wave -noupdate -radix hexadecimal /test_master_spi_4_hilos/dut/dir_reg
add wave -noupdate -radix hexadecimal /test_master_spi_4_hilos/dut/dato_wr
add wave -noupdate -divider {Salidas Master}
add wave -noupdate /test_master_spi_4_hilos/dut/dato_rd
add wave -noupdate /test_master_spi_4_hilos/dut/ena_rd
add wave -noupdate /test_master_spi_4_hilos/dut/rdy
add wave -noupdate -divider {Bus SPI}
add wave -noupdate /test_master_spi_4_hilos/dut/nCS
add wave -noupdate /test_master_spi_4_hilos/dut/SPC
add wave -noupdate /test_master_spi_4_hilos/dut/SDI
add wave -noupdate /test_master_spi_4_hilos/dut/SDO
add wave -noupdate -divider {Segnales Internas}
add wave -noupdate /test_master_spi_4_hilos/dut/cnt_SPC
add wave -noupdate /test_master_spi_4_hilos/dut/fdc_cnt_SPC
add wave -noupdate /test_master_spi_4_hilos/dut/SPC_posedge
add wave -noupdate /test_master_spi_4_hilos/dut/SPC_negedge
add wave -noupdate /test_master_spi_4_hilos/dut/cnt_bits_SPC
add wave -noupdate /test_master_spi_4_hilos/dut/SDI_syn
add wave -noupdate /test_master_spi_4_hilos/dut/reg_SPI
add wave -noupdate /test_master_spi_4_hilos/dut/fin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {136 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 189
configure wave -valuecolwidth 69
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
WaveRestoreZoom {0 ns} {494 ns}
