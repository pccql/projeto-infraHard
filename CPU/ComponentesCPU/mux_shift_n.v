module mux_shift_n(
    input wire [1:0] nControl,
    input wire [4:0] rt, inst, sixteen, mdr,
    output wire [4:0] shift_n
);
    assign sixteen = 5'd16;
    assign shift_n = (nControl == 2'b00) ?  rt:
                     (nControl == 2'b01) ?  inst:
                     (nControl == 2'b10) ?  sixteen:
                     (nControl == 2'b11) ?  mdr:
                     1'bX;


endmodule
