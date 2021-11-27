module div (
    input wire clock,
    input wire reset,
    input wire start,

    input wire [31:0] A,
    input wire [31:0] B,

    output reg [31:0] HI,
    output reg [31:0] LO,
    output reg DivBy0,
    output reg finished

);
    reg [4:0] remainingCicles;
    reg [31:0] result; 
    reg [31:0] divideBy;
    reg [31:0] remainder;
    wire [32:0] sub = {remainder[30:0], result[31]} - divideBy; 
    assign DivBy0 = !B;
    assign LO = result; 
    assign HI = remainder;

    always @ (posedge clock) begin
        if(reset == 1'd1) begin 
            remainingCicles = 5'd31;  
            finished = 1'd1;
            result = 0;  
            divideBy = 0;  
            remainder = 0;
            HI[31:0] = 32'd0;
            LO[31:0] = 32'd0;
        end
        else begin
            if (start) begin
                remainingCicles = 5'd31; 
                divideBy = B;
                remainder = 32'd0; 
                result = A;
                finished = 1'b0; 
            end
            else if (finished == 1'b0) begin
                if (sub[32] == 0) begin   
                    remainder = sub[31:0];
                    result = {result[30:0], 1'b1};
                end 
                else begin
                    remainder = {remainder [30:0], result[31]};  
                    result = {result[30:0], 1'b0};
                end
                
                if (remainingCicles == 0) begin // end algorithm
                    finished = 1;
                end 

                else begin
                    finished = 0;
                end
                
                remainingCicles = remainingCicles - 1; 
                
               
            end 
        end
    end


endmodule