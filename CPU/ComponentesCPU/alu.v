
 module alu(out, a, b, cin);
 output [31:0] out;
 input [31:0] a;
 input [31:0] b;
 input cin;
 assign out = a + b + cin;
 endmodule