module mux_HI(
    input wire HI_Src,
    input wire [31:0] MSB, div_remainder, 
    output wire [31:0] mux_HI_out
);
    
    assign mux_HI_out =   (HI_Src == 1'b0) ?  MSB:
                          (HI_Src == 1'b1) ?  div_remainder:
                          1'bX;


endmodule
