module ctrl_unit (
        input wire clk,
        input wire reset,

        //flags  
        input wire Overflow,
        input wire Negativo,
        input wire Zero,
        input wire EQ,
        input wire GT,
        input wire LT,


        input wire [5:0] opcode,

        output reg pc_w,
        output reg mem_w,
        output reg ir_w,
        output reg reg_w,
        output reg reg_ab_w,
        output reg [2:0] aluOut_w
        output reg alu_src_a,

        output reg alu_op,

        output reg rst_out

);

endmodule //ctrl_unit