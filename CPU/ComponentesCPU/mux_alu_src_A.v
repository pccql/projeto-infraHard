module mux_alu_src_A(
    input wire selector,
    input wire[31:0] pc_0,
    input wire[31:0] reg_a_1, 
    output wire[31:0] a_out
);

    assign a_out = (selector) ? reg_a_1 : pc_0;

endmodule
