module LS (
    input wire[1:0] lscontrol,
    input wire[31:0] regData,
    output reg[31:0] lsout
);

    always @(*) begin
        if (lscontrol == 0) begin
            lsout = regData; // lw
        end
        else if (lscontrol == 1) begin
            lsout = {16'd0, regData[15:0]}; // lh
        end

        else if (lscontrol == 2) begin
            lsout = {24'd0, regData[7:0]}; // lb
        end
    end


endmodule