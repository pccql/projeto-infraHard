module sign_extend_32 (
    input wire entrada,
    output reg [31:0] saida
);

assign saida = {31'd0 , entrada};

endmodule //sign_extend_32  