module sign_extend_16 (
    input wire [15:0] entrada,
    output wire [31:0] saida
);

assign saida = {16'd0, entrada};

endmodule //sign_extend_16