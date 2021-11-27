module mux_LO(
    input wire LO_Src,
    input wire [31:0] LSB, div_result, 
    output wire [31:0] mux_LO_out
);
    
    assign mux_LO_out = (LO_Src == 1'b0) ?  LSB:
                        (LO_Src == 1'b1) ?  div_result:
                        1'bX;


endmodule
