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
        input wire [5:0] funct,

        // Sinais de controle 1 bit
        output reg pc_w,
        output reg mem_w,
        output reg ir_w,
        output reg reg_w,
        output reg reg_ab_w,
        output reg aluOut_w,
        output reg alu_src_a,
        output reg hi_w,
        output reg lo_w,
        output reg mdr_w,
        output reg epc_w,
        
        // Sinais de controle 2 bits
        output reg [1:0]alu_src_b,
				output reg [1:0]reg_dst,

        // Sinais de controle 3 bits
        output reg [2:0] data_src,
        output reg [2:0] alu_op,

        // Sinal síncrono
        output reg rst_out
);


reg [2:0] state;
reg [2:0] counter;

//Parametros
        //Estados Principais
        parameter fetch  = 3'b000;
        parameter decode = 3'b001;
        parameter estado_reset = 3'b010;
        parameter close_all_writes = 3'b011;
        parameter add_state = 3'b100;

        // Opcodes      
        parameter R = 6'b000000;

        // Funct
        parameter add_funct = 6'b100000;

initial begin
        //Sinal assincrono de reset faz o reset na CPU
                rst_out = 1'b1;
        end


always @(posedge clk) begin
  if ( reset == 1'b1 ) begin
   
    //Fazendo procedimento do reset
    
    state = estado_reset;
    //       reg_dst = 2'b11;
    //       data_src = 3'b110;
    //       reg_w = 1'b1;

    // Zerando Sinais de Escrita

    pc_w = 1'b0;
    mem_w = 1'b0;
    ir_w = 1'b0;
    reg_ab_w = 1'b0;
    aluOut_w = 1'b0;
    alu_src_a = 1'b0;
    alu_src_b = 2'b00;
    reg_dst = 2'b00;
    hi_w = 1'b0;
    lo_w = 1'b0;
    mdr_w = 1'b0;
    epc_w = 1'b0;
    
    rst_out = 1'b1; // Mantendo reset apertado

    // Atualizando Counter
    counter = 3'b000;

  
  end
  else begin
        case (state)
          estado_reset: begin
            state = fetch;
            counter = 3'b000;
          end
          fetch: begin
              if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
                  state = fetch;

                  pc_w = 1'b0;
                  mem_w = 1'b0; // 
                  ir_w = 1'b0; 
                  reg_ab_w = 1'b0;
                  aluOut_w = 1'b0;
                  alu_src_a = 1'b0;  // 
                  alu_src_b = 2'b01; //
                  alu_op = 3'b001;//
                  reg_dst = 1'b0;
                  hi_w = 1'b0;
                  lo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b0;
									
                  // Atualizando Counter
                  counter = counter + 1;
							end
							
              else if (counter == 3'b011) begin
                    state = decode;

                    pc_w = 1'b1; //
                    mem_w = 1'b0; 
                    ir_w = 1'b1;  //
                    reg_ab_w = 1'b0;
                    aluOut_w = 1'b0;
                    alu_src_a = 1'b0;  
                    alu_src_b = 2'b01; 
                    alu_op = 3'b001; 
                    reg_dst = 1'b0;
                    hi_w = 1'b0;
                    lo_w = 1'b0;
                    mdr_w = 1'b0;
                    epc_w = 1'b0;
                    rst_out = 1'b0;
										reg_w = 1'b0;

                    counter = 3'b000;
              end
          end
          decode: begin
                if (counter == 3'b000) begin
                  state = decode;

                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b1;  
                  reg_ab_w = 1'b1; //
                  aluOut_w = 1'b1; //
                  alu_src_a = 1'b0; //
                  alu_src_b = 2'b11; //
                  alu_op = 3'b001; //
                  reg_dst = 1'b0;
                  hi_w = 1'b0;
                  lo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b0;

                  counter = counter + 1;
                end

				        else if (counter == 3'b001) begin
                  state = decode;
                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b1;  
                  reg_ab_w = 1'b0; // 
                  aluOut_w = 1'b0; //
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
                  alu_op = 3'b001;
                  reg_dst = 1'b0;
                  hi_w = 1'b0;
                  lo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b0;

                  counter = counter + 1;
                end

                else if (counter == 3'b010) begin
                  case (funct)
                    add_funct: begin
                      state = add_state;
                  end 
                  endcase
                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b1;  
                  reg_ab_w = 1'b0; 
                  aluOut_w = 1'b0; 
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
                  alu_op = 3'b001; 
                  reg_dst = 1'b0;
                  hi_w = 1'b0;
                  lo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b0;

                  counter = 3'b000;
                end
          end
          
          add_state: begin
            if (counter == 3'b000) begin
              state = add_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b1;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b00; //
              alu_op = 3'b001; //
              reg_dst = 2'b01; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;

              counter = counter + 1;
            end

            else if (counter == 3'b001) begin
              state = add_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b1;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; // 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b001; 
              reg_dst = 2'b00; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;

              counter = counter + 1;
            end

            else if (counter == 3'b010) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b1;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;
              reg_w = 1'b1; //
              data_src = 3'b001; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b001;
              reg_dst = 2'b00; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							
              counter = 3'b000;
            end
          
          end
          close_all_writes: begin
  
             state = fetch;

              // Zerando Sinais de Escrita

              pc_w = 1'b0; //
              mem_w = 1'b0; 
              ir_w = 1'b0;
              reg_ab_w = 1'b0;
              aluOut_w = 1'b0;
              alu_src_a = 1'b0;
              alu_src_b = 2'b00;
              reg_dst = 2'b00;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0; // Desapertando reset

              // Atualizando Counter
              counter = 3'b000;
          end
             
        endcase
  end

end

endmodule //ctrl_unit