module mux_reg_dst(
    input wire [1:0] Reg_Dst,
    input wire [4:0] rt_0, rd_1, const_2, const_3,
    output wire [4:0] mux_reg_dst_out
);
    
    assign const_2 = 5'd31;
    assign const_3 = 5'd29;
    
    assign mux_reg_dst_out = (Reg_Dst == 2'b00) ?  rt_0:
                             (Reg_Dst == 2'b01) ?  rd_1:
                             (Reg_Dst == 2'b10) ?  const_2:
                             (Reg_Dst == 2'b11) ?  const_3:
                             2'bX;


endmodule
