module mux_alu_src_B(
    input wire [1:0] AluSrcB,
    input wire [31:0] B_0, four_1, sign_extend_2 , shift_left_3,
    output wire [31:0] b_out
);
    
    assign four_1 = 32'd4;
    
    assign b_out = (AluSrcB == 2'b00) ?  B_0:
                   (AluSrcB == 2'b01) ?  four_1:
                   (AluSrcB == 2'b10) ?  sign_extend_2:
                   (AluSrcB == 2'b11) ?  shift_left_3 :
                   1'bX;


endmodule
