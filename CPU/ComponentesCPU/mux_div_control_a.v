module mux_div_control_a(
    input wire div_control,
    input wire [31:0] A, mdr_out, 
    output wire [31:0] mux_div_control_a_out
);
    
    assign mux_div_control_a_out =  (div_control == 1'b0) ?  A:
                                    (div_control == 1'b1) ?  mdr_out:
                                    1'bX;


endmodule
