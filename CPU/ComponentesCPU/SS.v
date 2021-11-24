module SS (
    input wire[1:0] sscontrol, //0 -> 0 do memData (sw)    1-> sh   2 -> sb
    input wire[31:0] regData,
    input wire[31:0] memData, 
    output reg[31:0] ssout
);

    always @(*) 
    begin
      
    
        if (sscontrol == 0)
            ssout = regData; // sw
        
        else if (sscontrol == 1) 
            ssout = {memData[31:16], regData[15:0]}; // sh
        
        else if (sscontrol == 2) 
            ssout = {memData[31:8], regData[7:0]}; // sb
    
    end


endmodule