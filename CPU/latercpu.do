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
add wave -noupdate -group CPU -radix decimal /CPU/rs
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
add wave -noupdate -group {Control Unit} -radix unsigned /CPU/unidade_de_controle/counter
add wave -noupdate -group {Control Unit} -radix unsigned /CPU/unidade_de_controle/state
add wave -noupdate -group {Control Unit} -radix hexadecimal /CPU/unidade_de_controle/funct
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_op
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_src_a
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/alu_src_b
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/aluOut_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/ir_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/mem_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/opcode
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/pc_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/reg_ab_w
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/LT
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/GT
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/EQ
add wave -noupdate -group {Control Unit} /CPU/unidade_de_controle/div_finished
add wave -noupdate -group PC -radix decimal /CPU/PC/Entrada
add wave -noupdate -group PC /CPU/PC/Load
add wave -noupdate -group PC -radix unsigned /CPU/PC/Saida
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/reg_B_out_3
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/reg_A_out_2
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/PC_0
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/mux_excecao_out_4
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/IorD_Sel
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/Ior_D_out
add wave -noupdate -group IorD -radix unsigned /CPU/IorD/alu_out_1
add wave -noupdate -group Memory -radix decimal /CPU/Mem/Address
add wave -noupdate -group Memory -radix binary /CPU/Mem/Datain
add wave -noupdate -group Memory -radix binary /CPU/Mem/Dataout
add wave -noupdate -group Memory /CPU/Mem/Wr
add wave -noupdate -group MDR -radix binary /CPU/MDR/Saida
add wave -noupdate -group MDR /CPU/MDR/Load
add wave -noupdate -group MDR -radix binary /CPU/MDR/Entrada
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
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/Data_Src
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/ls_0
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/alu_out_1
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/lo_2
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/hi_3
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/shift_register_4
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/const_5
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/sign_extd_6
add wave -noupdate -group Data_src_muux /CPU/mux_data_src/mux_data_src_out
add wave -noupdate -group Reg_Dst -radix unsigned /CPU/Mreg/mux_reg_dst_out
add wave -noupdate -group Reg_Dst /CPU/Mreg/Reg_Dst
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(10)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(11)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(12)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(13)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(29)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/Cluster(31)
add wave -noupdate -group Reg -radix decimal /CPU/Regs/ReadData1
add wave -noupdate -group Reg -radix decimal /CPU/Regs/ReadData2
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadReg1
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/ReadReg2
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/RegWrite
add wave -noupdate -group Reg -radix decimal /CPU/Regs/WriteData
add wave -noupdate -group Reg -radix unsigned /CPU/Regs/WriteReg
add wave -noupdate -group MuxAB /CPU/mux_a/a_out
add wave -noupdate -group MuxAB /CPU/mux_a/selector
add wave -noupdate -group MuxAB /CPU/mux_b/AluSrcB
add wave -noupdate -group MuxAB -radix decimal /CPU/mux_b/b_out
add wave -noupdate -group AB /CPU/A/Entrada
add wave -noupdate -group AB /CPU/A/Load
add wave -noupdate -group AB -radix decimal /CPU/A/Saida
add wave -noupdate -group AB -radix decimal /CPU/B/Entrada
add wave -noupdate -group AB /CPU/B/Load
add wave -noupdate -group AB -radix decimal /CPU/B/Saida
add wave -noupdate -group ULA -radix decimal /CPU/ALU/A
add wave -noupdate -group ULA -radix decimal /CPU/ALU/B
add wave -noupdate -group ULA -radix decimal /CPU/ALU/S
add wave -noupdate -group ULA /CPU/ALU/Seletor
add wave -noupdate -group ULA /CPU/ALU/Menor
add wave -noupdate -group ULA /CPU/ALU/Maior
add wave -noupdate -group ULA /CPU/ALU/Igual
add wave -noupdate -group ULA /CPU/ALU/Overflow
add wave -noupdate -group ALUOUT -radix decimal /CPU/aluOut/Entrada
add wave -noupdate -group ALUOUT /CPU/aluOut/Load
add wave -noupdate -group ALUOUT -radix decimal /CPU/aluOut/Saida
add wave -noupdate -group shift_reg -radix decimal /CPU/reg_desloc/Entrada
add wave -noupdate -group shift_reg -radix decimal /CPU/reg_desloc/N
add wave -noupdate -group shift_reg /CPU/reg_desloc/n_shift
add wave -noupdate -group shift_reg -radix unsigned /CPU/reg_desloc/Saida
add wave -noupdate -group shift_reg /CPU/reg_desloc/Shift
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/nControl
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/sixteen
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/shift_n
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/rt
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/mdr
add wave -noupdate -group mux_shift_n /CPU/mux_shiftn/inst
add wave -noupdate -group mux_shift_enntrada /CPU/mux_shift/sign_extend_2
add wave -noupdate -group mux_shift_enntrada /CPU/mux_shift/shiftControl
add wave -noupdate -group mux_shift_enntrada -radix decimal /CPU/mux_shift/shift_in
add wave -noupdate -group mux_shift_enntrada /CPU/mux_shift/b_out
add wave -noupdate -group mux_shift_enntrada /CPU/mux_shift/a_out
add wave -noupdate -group LS/SS /CPU/ls/regData
add wave -noupdate -group LS/SS /CPU/ls/lsout
add wave -noupdate -group LS/SS /CPU/ls/lscontrol
add wave -noupdate -group LS/SS /CPU/ss/ssout
add wave -noupdate -group LS/SS /CPU/ss/sscontrol
add wave -noupdate -group LS/SS /CPU/ss/regData
add wave -noupdate -group LS/SS /CPU/ss/memData
add wave -noupdate -group EPC -radix decimal /CPU/EPC/Saida
add wave -noupdate -group EPC /CPU/EPC/Load
add wave -noupdate -group EPC /CPU/EPC/Entrada
add wave -noupdate -group PC_SRC /CPU/PCSrc/ula_1
add wave -noupdate -group PC_SRC /CPU/PCSrc/shift_left_2
add wave -noupdate -group PC_SRC /CPU/PCSrc/PC_Src
add wave -noupdate -group PC_SRC /CPU/PCSrc/mux_pc_src_out
add wave -noupdate -group PC_SRC /CPU/PCSrc/ls_4
add wave -noupdate -group PC_SRC /CPU/PCSrc/epc_3
add wave -noupdate -group PC_SRC /CPU/PCSrc/alu_out_0
add wave -noupdate -expand -group Div /CPU/div/start
add wave -noupdate -expand -group Div /CPU/div/finished
add wave -noupdate -expand -group Div -radix unsigned /CPU/div/remainingCicles
add wave -noupdate -expand -group Div -radix decimal /CPU/div/result
add wave -noupdate -expand -group Div -radix decimal /CPU/div/remainder
add wave -noupdate -expand -group Div -radix decimal /CPU/div/HI
add wave -noupdate -expand -group Div -radix decimal /CPU/div/LO
add wave -noupdate -expand -group Div -radix decimal /CPU/div/A
add wave -noupdate -expand -group Div -radix decimal /CPU/div/B
add wave -noupdate -expand -group Div /CPU/div/DivBy0
add wave -noupdate -group HI/LO -radix decimal /CPU/HI/Saida
add wave -noupdate -group HI/LO /CPU/HI/Reset
add wave -noupdate -group HI/LO /CPU/HI/Load
add wave -noupdate -group HI/LO -radix decimal /CPU/HI/Entrada
add wave -noupdate -group HI/LO -radix decimal /CPU/LO/Saida
add wave -noupdate -group HI/LO /CPU/LO/Reset
add wave -noupdate -group HI/LO /CPU/LO/Load
add wave -noupdate -group HI/LO -radix decimal /CPU/LO/Entrada
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6905 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 221
configure wave -valuecolwidth 177
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
WaveRestoreZoom {6027 ps} {7051 ps}
