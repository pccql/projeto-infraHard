module mux_alu_flag (
    input wire [1:0] alu_flag,
    input wire GT_1, LT_0, EQ_2,
    output wire mux_alu_flag_out
);

    assign mux_alu_flag_out = (alu_flag == 0) ? LT_0:
                        (alu_flag == 1) ? GT_1:
                        (alu_flag == 2) ? EQ_2:
                        1'bX;

    
endmodule