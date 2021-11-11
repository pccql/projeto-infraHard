module mux_shift_in(
    input wire [1:0] shiftControl,
    input wire [31:0] a_out, b_out, sign_extend_2,
    output wire [31:0] shift_in
);
    
    assign shift_in = (shiftControl == 2'b00) ?  B_0:
                      (shiftControl == 2'b01) ?  four_1:
                      (shiftControl == 2'b10) ?  sign_extend_2:
                      1'bX;


endmodule
