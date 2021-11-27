module multiplier(output wire [31:0] msb_prod, lsb_prod, 
output wire calculando, 
input wire [31:0] fator_1, fator_2, 
input wire clk, start);


reg [31:0] A, Q, M;
reg Q_1;
reg [5:0] count;

wire [31:0] soma, diferenca;


always @(posedge clk)
begin

    if (start) begin
        A <= 32'b0;
        M <= fator_1;
        Q <= fator_2;
        Q_1 <= 1'b0;
        count <= 6'b0;
    end

    else begin
        
        case ({Q[0], Q_1})

            2'b01 : {A, Q, Q_1} <= {soma[31], soma, Q};
            2'b10 : {A, Q, Q_1} <= {diferenca[31], diferenca, Q};
            default: {A, Q, Q_1} <= {A[31], A, Q};

        endcase
        count <= count + 1'b1;
    end
end

assign soma = A + M + 1'b0;
assign diferenca = A + ~M + 1'b1; 

assign msb_prod = A;
assign lsb_prod = Q;

assign calculando = (count < 32);

endmodule