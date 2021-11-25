module mux_Ior_D(
    input wire [2:0] IorD_Sel,
    input wire [31:0] PC_0, alu_out_1, reg_A_out_2, reg_B_out_3, mux_excecao_out_4,
    output wire [31:0] Ior_D_out
);
    
    
    assign Ior_D_out   = (IorD_Sel == 3'b000) ?  PC_0:
                             (IorD_Sel == 3'b001) ?  alu_out_1:
                             (IorD_Sel == 3'b010) ?  reg_A_out_2:
                             (IorD_Sel == 3'b011) ?  reg_B_out_3:
                             (IorD_Sel == 3'b100) ?  mux_excecao_out_4:
                             3'bX;


endmodule
