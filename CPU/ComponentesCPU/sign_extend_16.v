module sign_extend_16 (
    input wire [15:0] entrada,
    output reg [31:0] saida
);

assign saida = {{16{entrada[15]}}, entrada};

endmodule //sign_extend_16  