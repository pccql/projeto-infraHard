module mux_controle_excessao(
    input wire [1:0] Exception_Control,
    input wire [31:0] const_1, const_2, const_3,
    output wire [31:0] mux_exception_out
);
    assign const_1 = 32'd253;
    assign const_2 = 32'd254;
    assign const_3 = 32'd255;
    
    assign mux_exception_out = (Exception_Control == 2'b00) ?  const_1:
                               (Exception_Control == 2'b01) ?  const_2:
                               (Exception_Control == 2'b10) ?  const_3:
                                2'bX;


endmodule
