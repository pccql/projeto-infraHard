onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group CPU /CPU/clk
add wave -noupdate -group CPU /CPU/reset
add wave -noupdate -group CPU /CPU/alu_op
add wave -noupdate -group CPU /CPU/alu_result
add wave -noupdate -group CPU /CPU/alu_src_a
add wave -noupdate -group CPU /CPU/alu_src_b
add wave -noupdate -group CPU /CPU/aluOut_out
add wave -noupdate -group CPU /CPU/aluOut_w
add wave -noupdate -group CPU /CPU/data_src
add wave -noupdate -group CPU /CPU/ir_w
add wave -noupdate -group CPU /CPU/mem_in
add wave -noupdate -group CPU /CPU/mem_out
add wave -noupdate -group CPU /CPU/mem_w
add wave -noupdate -group CPU -radix unsigned /CPU/mux_a_out
add wave -noupdate -group CPU -radix unsigned /CPU/mux_b_out
add wave -noupdate -group CPU /CPU/opcode
add wave -noupdate -group CPU -radix unsigned /CPU/rs
add wave -noupdate -group CPU -radix unsigned /CPU/rt
add wave -noupdate -group CPU -radix hexadecimal /CPU/offset
add wave -noupdate -group CPU /CPU/pc_out
add wave -noupdate -group CPU /CPU/pc_w
add wave -noupdate -group CPU /CPU/reg_a_out
add wave -noupdate -group CPU /CPU/reg_ab_w
add wave -noupdate -group CPU /CPU/reg_b_out
add wave -noupdate -group CPU /CPU/reg_w
add wave -noupdate -group CPU /CPU/regs_out_1
add wave -noupdate -group CPU /CPU/regs_out_2
add wave -noupdate -group {Control Unit} -radix decimal /CPU/unidade_de_controle/counter
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/state
add wave -noupdate -group {Control Unit} -radix unsigned /CPU/unidade_de_controle/funct
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_op
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_src_a
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_src_b
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/aluOut_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/ir_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/mem_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/opcode
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/pc_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/reg_ab_w
add wave -noupdate -group PC /CPU/PC/Entrada
add wave -noupdate -group PC /CPU/PC/Load
add wave -noupdate -group PC /CPU/PC/Saida
add wave -noupdate -group Memory /CPU/Mem/Address
add wave -noupdate -group Memory /CPU/Mem/Datain
add wave -noupdate -group Memory /CPU/Mem/Dataout
add wave -noupdate -group Memory /CPU/Mem/Wr
add wave -noupdate -group Ir /CPU/IR/Entrada
add wave -noupdate -group Ir /CPU/IR/Instr15_0
add wave -noupdate -group Ir /CPU/IR/Instr20_16
add wave -noupdate -group Ir /CPU/IR/Instr25_21
add wave -noupdate -group Ir /CPU/IR/Instr31_26
add wave -noupdate -group Ir /CPU/IR/Load_ir
add wave -noupdate -group Ir /CPU/IR/Entrada
add wave -noupdate -group Ir /CPU/IR/Instr15_0
add wave -noupdate -group Ir /CPU/IR/Instr20_16
add wave -noupdate -group Ir /CPU/IR/Instr25_21
add wave -noupdate -group Ir /CPU/IR/Instr31_26
add wave -noupdate -group Ir /CPU/IR/Load_ir
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/Cluster(10)
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/Cluster(11)
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/Cluster(12)
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadData1
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadData2
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadReg1
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadReg2
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/RegWrite
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/WriteData
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/WriteReg
add wave -noupdate -group MuxAB /CPU/mux_a/a_out
add wave -noupdate -group MuxAB /CPU/mux_a/selector
add wave -noupdate -group MuxAB /CPU/mux_b/AluSrcB
add wave -noupdate -group MuxAB -radix decimal /CPU/mux_b/b_out
add wave -noupdate -group AB /CPU/A/Entrada
add wave -noupdate -group AB /CPU/A/Load
add wave -noupdate -group AB /CPU/A/Saida
add wave -noupdate -group AB /CPU/B/Entrada
add wave -noupdate -group AB /CPU/B/Load
add wave -noupdate -group AB /CPU/B/Saida
add wave -noupdate -group ULA /CPU/ALU/A
add wave -noupdate -group ULA /CPU/ALU/B
add wave -noupdate -group ULA -radix decimal /CPU/ALU/S
add wave -noupdate -group ULA /CPU/ALU/Seletor
add wave -noupdate -group ALUOUT /CPU/aluOut/Entrada
add wave -noupdate -group ALUOUT /CPU/aluOut/Load
add wave -noupdate -group ALUOUT /CPU/aluOut/Saida
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1194 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 221
configure wave -valuecolwidth 50
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
WaveRestoreZoom {0 ps} {6745 ps}
