module shift_left_2_conc (
    input wire [25:0] entrada,
    input wire [31:0] pc_in,
    output wire [31:0] saida_conc
);
    wire [27:0] saida_temp;
    assign saida_temp = {entrada[25:0], 2'b00};
    assign saida_conc = {pc_in[31:28], saida_temp[27:0]};

endmodule //shift_left_2_conc