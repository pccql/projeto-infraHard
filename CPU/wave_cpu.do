onerror {resume}
quietly set dataset_list [list sim waveform]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CPU sim:/CPU/clk
add wave -noupdate -expand -group CPU sim:/CPU/reset
add wave -noupdate -expand -group CPU sim:/CPU/alu_op
add wave -noupdate -expand -group CPU sim:/CPU/alu_result
add wave -noupdate -expand -group CPU sim:/CPU/alu_src_a
add wave -noupdate -expand -group CPU sim:/CPU/alu_src_b
add wave -noupdate -expand -group CPU sim:/CPU/aluOut_out
add wave -noupdate -expand -group CPU sim:/CPU/aluOut_w
add wave -noupdate -expand -group CPU sim:/CPU/data_src
add wave -noupdate -expand -group CPU sim:/CPU/ir_w
add wave -noupdate -expand -group CPU sim:/CPU/mem_in
add wave -noupdate -expand -group CPU -radix decimal sim:/CPU/mem_out
add wave -noupdate -expand -group CPU sim:/CPU/mem_w
add wave -noupdate -expand -group CPU sim:/CPU/mux_a_out
add wave -noupdate -expand -group CPU sim:/CPU/mux_b_out
add wave -noupdate -expand -group CPU sim:/CPU/opcode
add wave -noupdate -expand -group CPU sim:/CPU/rs
add wave -noupdate -expand -group CPU sim:/CPU/rt
add wave -noupdate -expand -group CPU sim:/CPU/offset
add wave -noupdate -expand -group CPU sim:/CPU/pc_out
add wave -noupdate -expand -group CPU sim:/CPU/pc_w
add wave -noupdate -expand -group CPU sim:/CPU/reg_a_out
add wave -noupdate -expand -group CPU sim:/CPU/reg_ab_w
add wave -noupdate -expand -group CPU sim:/CPU/reg_b_out
add wave -noupdate -expand -group CPU sim:/CPU/reg_w
add wave -noupdate -expand -group CPU sim:/CPU/regs_out_1
add wave -noupdate -expand -group CPU sim:/CPU/regs_out_2
add wave -noupdate -group {Unidade controle} -radix decimal sim:/CPU/unidade_de_controle/counter
add wave -noupdate -group {Unidade controle} -radix decimal sim:/CPU/unidade_de_controle/state
add wave -noupdate -group {Unidade controle} -radix unsigned sim:/CPU/unidade_de_controle/funct
add wave -noupdate -group {Unidade controle} -radix decimal sim:/CPU/unidade_de_controle/alu_op
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/alu_src_a
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/alu_src_b
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/aluOut_w
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/ir_w
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/mem_w
add wave -noupdate -group {Unidade controle} -radix decimal sim:/CPU/unidade_de_controle/opcode
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/pc_w
add wave -noupdate -group {Unidade controle} sim:/CPU/unidade_de_controle/reg_ab_w
add wave -noupdate -expand -group PC -radix decimal sim:/CPU/PC/Entrada
add wave -noupdate -expand -group PC sim:/CPU/PC/Load
add wave -noupdate -expand -group PC -radix octal sim:/CPU/PC/Saida
add wave -noupdate -group Memoria -radix hexadecimal sim:/CPU/Mem/Address
add wave -noupdate -group Memoria sim:/CPU/Mem/Datain
add wave -noupdate -group Memoria sim:/CPU/Mem/Dataout
add wave -noupdate -group Memoria sim:/CPU/Mem/Wr
add wave -noupdate -group IR sim:/CPU/IR/Entrada
add wave -noupdate -group IR sim:/CPU/IR/Instr15_0
add wave -noupdate -group IR sim:/CPU/IR/Instr20_16
add wave -noupdate -group IR sim:/CPU/IR/Instr25_21
add wave -noupdate -group IR sim:/CPU/IR/Instr31_26
add wave -noupdate -group IR sim:/CPU/IR/Load_ir
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/Cluster(10)
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/Cluster(11)
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/Cluster(12)
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/ReadData1
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/ReadData2
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/ReadReg1
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/ReadReg2
add wave -noupdate -group {Banco Reg} sim:/CPU/Regs/RegWrite
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/WriteData
add wave -noupdate -group {Banco Reg} -radix decimal sim:/CPU/Regs/WriteReg
add wave -noupdate -expand -group Muxab sim:/CPU/mux_a/a_out
add wave -noupdate -expand -group Muxab sim:/CPU/mux_a/selector
add wave -noupdate -expand -group Muxab sim:/CPU/mux_b/AluSrcB
add wave -noupdate -expand -group Muxab sim:/CPU/mux_b/b_out
add wave -noupdate -group RegAB sim:/CPU/A/Entrada
add wave -noupdate -group RegAB sim:/CPU/A/Load
add wave -noupdate -group RegAB sim:/CPU/A/Saida
add wave -noupdate -group RegAB sim:/CPU/B/Entrada
add wave -noupdate -group RegAB sim:/CPU/B/Load
add wave -noupdate -group RegAB sim:/CPU/B/Saida
add wave -noupdate -group ALU sim:/CPU/ALU/A
add wave -noupdate -group ALU sim:/CPU/ALU/B
add wave -noupdate -group ALU sim:/CPU/ALU/S
add wave -noupdate -group ALU sim:/CPU/ALU/Seletor
add wave -noupdate -group Aluout sim:/CPU/aluOut/Entrada
add wave -noupdate -group Aluout sim:/CPU/aluOut/Load
add wave -noupdate -group Aluout sim:/CPU/aluOut/Saida
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2255 ps}
