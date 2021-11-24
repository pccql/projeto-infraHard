module mux_pc_src(
    input wire [2:0] PC_Src,
    input wire [31:0] alu_out_0, ula_1, shift_left_2, epc_3, ls_4,
    output wire [31:0] mux_pc_src_out
);
    
    
    assign mux_pc_src_out = (PC_Src == 3'b000) ?  alu_out_0:
                            (PC_Src == 3'b001) ?  ula_1:
                            (PC_Src == 3'b010) ?  shift_left_2:
                            (PC_Src == 3'b011) ?  epc_3 :
                            (PC_Src == 3'b100) ?  ls_4:
                            3'bX;


endmodule
