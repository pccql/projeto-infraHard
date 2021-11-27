module mux_div_control_b(
    input wire div_control,
    input wire [31:0] B, mem_out, 
    output wire [31:0] mux_div_control_b_out
);
    
    assign mux_div_control_b_out =  (div_control == 1'b0) ?  B:
                                    (div_control == 1'b1) ?  mem_out:
                                    1'bX;


endmodule
