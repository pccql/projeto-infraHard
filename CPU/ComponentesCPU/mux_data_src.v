module mux_data_src(
    input wire [2:0] Data_Src,
    input wire [31:0] ls_0, alu_out_1, lo_2, hi_3, shift_register_4, const_5, sign_extd_6, 
    output wire [31:0] mux_data_src_out
);
    
    assign const_5 = 32'd227;
    
    assign mux_data_src_out =   (Data_Src == 3'b000) ?  ls_0:
                                (Data_Src == 3'b001) ?  alu_out_1:
                                (Data_Src == 3'b010) ?  lo_2:
                                (Data_Src == 3'b011) ?  hi_3 :
                                (Data_Src == 3'b100) ?  shift_register_4:
                                (Data_Src == 3'b101) ?  const_5:
                                (Data_Src == 3'b110) ?  sign_extd_6:
                                3'bX;


endmodule
