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

        // instrução
        input wire [5:0] opcode,

        // Sinais de controle 1 bit
        output reg pc_w,
        output reg mem_w,
        output reg ir_w,
        output reg reg_w,
        output reg reg_ab_w,
        output reg aluOut_w,
        output reg alu_src_a,
        output reg reg_dst,
        output reg hi_w,
        output reg lo_w,
        output reg a_w,
        output reg b_w,
        output reg mdr_w,
        output reg epc_w,
        
        // Sinais de controle 2 bits
        output reg [1:0] alu_op,

        // Sinais de controle 3 bits
        output reg [2:0] data_src,

        // Sinal assíncrono
        output reg rst_out
);


// reg [1:0] state;
// reg [2:0] counter;

// //Parametros
//         //Estados Principais
//         parameter estado_comum  = 2'b00;
//         parameter estado_ADD    = 2'b01;
//         parameter estado_reset  = 2'b10;
//         parameter close_all_writes = 2'b11;

//         // Opcodes      
//         parameter ADD = 6'b000000;

// initial 
//         begin
//         //Sinal assincrono de reset faz o reset na CPU
//                 rst_out = 1'b1;
                
//         end


// always @(posedge clk) begin
//   if ( rst_out == 1'b1 ) begin
//     if ( state != estado_reset) begin
//       //Fazendo procedimento do reset
      
//       state = estado_reset;
//       reg_dst = 2'b11;
//       data_src = 3'b110;
//       reg_w = 1'b1;

//       // Zerando Sinais de Escrita

//       pc_w = 1'b0;
//       mem_w = 1'b0;
//       ir_w = 1'b0;
//       reg_ab_w = 1'b0;
//       aluOut_w = 1'b0;
//       alu_src_a = 1'b0;
//       reg_dst = 1'b0;
//       hi_w = 1'b0;
//       lo_w = 1'b0;
//       a_w = 1'b0;
//       b_w = 1'b0;
//       mdr_w = 1'b0;
//       epc_w = 1'b0;
//       rst_out = 1'b1; // Mantendo reset apertado

//       // Atualizando Counter
//       counter = 3'b000;
//     end
//       else begin

//         //Fazendo procedimento do reset
        
//         state = estado_comum;

//         // Zerando Sinais de Escrita

//         pc_w = 1'b0;
//         mem_w = 1'b0;
//         ir_w = 1'b0;
//         reg_ab_w = 1'b0;
//         aluOut_w = 1'b0;
//         alu_src_a = 1'b0;
//         reg_dst = 1'b0;
//         hi_w = 1'b0;
//         lo_w = 1'b0;
//         a_w = 1'b0;
//         b_w = 1'b0;
//         mdr_w = 1'b0;
//         epc_w = 1'b0;
//         rst_out = 1'b0; // Desapertando reset

//         // Atualizando Counter
//         counter = 3'b000;
            
//       end

                  

//   end
// begin
        
    
// end

endmodule //ctrl_unit