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
        output reg [1:0] alu_flag,
        output reg [1:0] alu_src_b,
				output reg [1:0] reg_dst,
        output reg [1:0] shift_in_control,
        output reg [1:0] shift_n_control,
        output reg [1:0] ls_control,
        output reg [1:0] ss_control,

        // Sinais de controle 3 bits
        output reg [2:0] pc_src,
        output reg [2:0] data_src,
        output reg [2:0] alu_op,
        output reg [2:0] shift_control,
        output reg [2:0] i_or_d,
        

        // Sinal síncrono
        output reg rst_out
);


reg [5:0] state;
reg [2:0] counter;

//Parametros
        //Estados Principais
        parameter fetch  = 6'd0;
        parameter decode = 6'd1;
        parameter estado_reset = 6'd2;
        parameter close_all_writes = 6'd3;
        parameter add_state = 6'd4;
        parameter addi_state = 6'd5;
        parameter sub_state = 6'd6;
        parameter and_state = 6'd7;
        parameter slt_state = 6'd8;
        parameter jr_state = 6'd9;
        parameter break_state = 6'd10;
        parameter rte_state = 6'd11;
        parameter shift_state = 6'd12;
        parameter sll_state = 6'd13;
        parameter sra_state = 6'd14;
        parameter srl_state = 6'd15;
        parameter sw_state = 6'd16;
        parameter lw_state = 6'd17;

        // Opcodes      
        parameter R = 6'h0;
        parameter addi = 6'h8;
        parameter sw = 6'h2b;
        parameter lw = 6'h23
    
        

        // Funct
        parameter add_funct = 6'h20;
        parameter sub_funct = 6'h22;
        parameter and_funct = 6'h24;
        parameter slt_funct = 6'h2a;
        parameter jr_funct =  6'h8;
        parameter break_funct = 6'hd;
        parameter rte_funct = 6'h13;
        parameter sll_funct = 6'h0;
        parameter srl_funct = 6'h2;
        parameter sra_funct = 6'h3;
        


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
    data_src = 2'b01;
    i_or_d = 3'b000;
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
                  data_src = 3'b001; 
                  i_or_d = 3'b000;
                  reg_ab_w = 1'b0;
                  aluOut_w = 1'b0;
                  alu_src_a = 1'b0;  // 
                  alu_src_b = 2'b01; //
                  alu_op = 3'b001;//
                  reg_dst = 2'b00;
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
                    pc_src = 3'b001;
                    mem_w = 1'b0; 
                    ir_w = 1'b1;  //
                    data_src = 3'b001; 
                    i_or_d = 3'b000;
                    reg_ab_w = 1'b0;
                    aluOut_w = 1'b0;
                    alu_src_a = 1'b0;  
                    alu_src_b = 2'b01; 
                    alu_op = 3'b001; 
                    reg_dst = 2'b00;
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

                  pc_w = 1'b0; //
                  pc_src = 3'b001;
                  mem_w = 1'b0; 
                  ir_w = 1'b0;
                  i_or_d = 3'b000;
                  data_src = 3'b001;   
                  reg_ab_w = 1'b1; //
                  aluOut_w = 1'b1; //
                  alu_src_a = 1'b0; //
                  alu_src_b = 2'b11; //
                  alu_op = 3'b001; //
                  reg_dst = 2'b00;
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
                  ir_w = 1'b0;
                  data_src = 3'b001;   
                  i_or_d = 3'b000;
                  reg_ab_w = 1'b0; // 
                  aluOut_w = 1'b0; //
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
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
                  case (opcode)
                    R: begin
                      case (funct)
                        add_funct: begin
                          state = add_state;
                        end
                        sub_funct: begin
                          state = sub_state;
                        end
                        and_funct: begin
                          state = and_state;
                        end 
                        slt_funct: begin
                          state = slt_state;
                        end
                        jr_funct: begin
                          state = jr_state;
                        end
                        break_funct: begin
                          state  = break_state;
                        end 
                        rte_funct: begin
                          state = rte_state;
                        end
                        sll_funct: begin
                          state = shift_state;
                        end
                        sra_funct: begin
                          state = shift_state;
                        end
                        srl_funct: begin
                          state = shift_state;
                        end
                      endcase
                    end
                    addi: begin
                      state = addi_state;
                    end
                    sw: begin
                      state = sw_state;
                    end
                    lw: begin
                      state = lw_state;
                    end
                  endcase
                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b0;
                  data_src = 3'b001;
                  i_or_d = 3'b000;   
                  reg_ab_w = 1'b0; 
                  aluOut_w = 1'b0; 
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
                  alu_op = 3'b001; 
                  reg_dst = 2'b00;
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
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;   
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
              ir_w = 1'b0;  
              data_src = 3'b001;
              i_or_d = 3'b000; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; // 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
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
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;
              reg_w = 1'b1; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b001;
              reg_dst = 2'b0; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							
              counter = 3'b000;
            end
          
          end

          addi_state: begin
            if (counter == 3'b000) begin
              state = addi_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  //
              alu_src_a = 1'b1;  //
              alu_src_b = 2'b10; //
              alu_op = 3'b001; //
              reg_dst = 2'b00; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = addi_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; //  
              alu_src_a = 1'b1;  
              alu_src_b = 2'b10; 
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
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;   
              alu_src_a = 1'b1;  
              alu_src_b = 2'b10; 
              alu_op = 3'b001; 
              reg_dst = 2'b00; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; //
              
              counter = 3'b000;
            end
          end
          sub_state: begin
            if (counter == 3'b000) begin
              state = sub_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b00; //
              alu_op = 3'b010; //
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
              state = sub_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001; 
              i_or_d = 3'b000; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; // 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b010; 
              reg_dst = 2'b01; 
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
              ir_w = 1'b0;
              data_src = 3'b001; 
              i_or_d = 3'b000; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;
              reg_w = 1'b1; //
              data_src = 3'b001; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b010;
              reg_dst = 2'b01; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							
              counter = 3'b000;
            end
          
          end
          and_state: begin
            if (counter == 3'b000) begin
              state = and_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;  
              i_or_d = 3'b000;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b00; //
              alu_op = 3'b011; //
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
              state = and_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;  
              i_or_d = 3'b000;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; // 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b011; 
              reg_dst = 2'b01; 
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
              ir_w = 1'b0;  
              data_src = 3'b001; //
              i_or_d = 3'b000;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;
              reg_w = 1'b1; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b011;
              reg_dst = 2'b01; 
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							
              counter = 3'b000;
            end
          
          end

          slt_state: begin
            if (counter == 3'b000) begin
              state = slt_state; //
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; //
              alu_flag = 2'b00; //
              data_src = 3'b110; //
              i_or_d = 3'b000;
              reg_dst = 2'b01; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;

              counter = counter + 1;
            end
            else begin
              state = close_all_writes; //
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; //
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; //
              alu_flag = 2'b00; //
              data_src = 3'b110; //
              i_or_d = 3'b000;
              reg_dst = 2'b01; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = 3'b000;
            end
          end

          jr_state: begin
            state = close_all_writes;
            pc_w = 1'b1; //
            mem_w = 1'b0; 
            ir_w = 1'b0; 
            data_src = 3'b001; 
            i_or_d = 3'b000;
            reg_ab_w = 1'b0; 
            aluOut_w = 1'b0; 
            alu_src_a = 1'b1; 
            alu_src_b = 2'b11; 
            alu_op = 3'b000; //
            reg_dst = 2'b01; // 
            hi_w = 1'b0;
            lo_w = 1'b0;
            mdr_w = 1'b0;
            epc_w = 1'b0;
            rst_out = 1'b0;
            reg_w = 1'b0;
            pc_src = 3'b001; //

            counter = 3'b000;
          end

          break_state: begin
            if (counter == 3'b000) begin
              state = break_state;
              pc_w = 1'b1; //
              pc_src = 3'b001; //
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              data_src = 3'b001; 
              i_or_d = 3'b000;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
  
              counter = counter + 1; 
            end
            else begin
              state = break_state;
              pc_w = 1'b0; //
              pc_src = 3'b001; //
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              data_src = 3'b001; 
              i_or_d = 3'b000;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
  
              counter = 3'b001; 
            end
                        
            
          end

          rte_state: begin
            state = close_all_writes;

            pc_w = 1'b1; // 
            pc_src = 3'b011; //  
            mem_w = 1'b0; 
            ir_w = 1'b0;  
            data_src = 3'b001; 
            i_or_d = 3'b000;
            reg_ab_w = 1'b0; 
            aluOut_w = 1'b0; 
            alu_src_a = 1'b0; 
            alu_src_b = 2'b11; 
            alu_op = 3'b001; 
            reg_dst = 2'b01; //
            hi_w = 1'b0;
            lo_w = 1'b0;
            mdr_w = 1'b0;
            epc_w = 1'b0;
            rst_out = 1'b0;
            reg_w = 1'b0;

            counter = 3'b000;
          end

          shift_state: begin
            case(funct)
              srl_funct:begin
                state = srl_state;
              end
              sll_funct:begin
                state = sll_state;
              end
              sra_funct:begin
                state = sra_state;
              end
            endcase

            pc_w = 1'b0; 
            shift_control = 3'b001; //
            shift_in_control = 2'b01; //
            shift_n_control = 2'b01; //
            mem_w = 1'b0; 
            ir_w = 1'b0;  
            reg_ab_w = 1'b0; 
            aluOut_w = 1'b0; 
            alu_src_a = 1'b0; 
            alu_src_b = 2'b11; 
            alu_op = 3'b001; 
            reg_dst = 2'b01; //
            data_src = 3'b100; //
            i_or_d = 3'b000;
            hi_w = 1'b0;
            lo_w = 1'b0;
            mdr_w = 1'b0;
            epc_w = 1'b0;
            rst_out = 1'b0;
            reg_w = 1'b0;

            counter = 3'b000;
          end

          sll_state:begin
            if (counter == 3'b000) begin
              state = sll_state;

              pc_w = 1'b0; 
              shift_control = 3'b010; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              shift_control = 3'b000; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; // 
              counter = 3'b000;
            end
          end

          sra_state: begin
            if (counter == 3'b000) begin
              state = sra_state;

              pc_w = 1'b0; 
              shift_control = 3'b100; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              shift_control = 3'b000; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; // 
              counter = 3'b000;
            end
          end

          srl_state: begin
            if (counter == 3'b000) begin
              state = srl_state;

              pc_w = 1'b0; 
              shift_control = 3'b011; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              shift_control = 3'b000; //
              shift_in_control = 2'b01; 
              shift_n_control = 2'b01;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; 
              i_or_d = 3'b000;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; // 
              counter = 3'b000;
            end
          end
            
          sw_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = sw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b1; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;

              counter = counter + 1;
            end
          end
          lw_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = sw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b00;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b00;

              counter = counter + 1;
            end
          end
          close_all_writes: begin
  
             state = fetch;

              // Zerando Sinais de Escrita

              pc_w = 1'b0; //
              mem_w = 1'b0; 
              ir_w = 1'b0;
              reg_ab_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;
              aluOut_w = 1'b0;
              alu_op = 3'b000;
              alu_src_a = 1'b0;
              alu_src_b = 2'b00;
              reg_dst = 2'b00;
              hi_w = 1'b0;
              lo_w = 1'b0;
              mdr_w = 1'b0;
              reg_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0; // Desapertando reset
              shift_control = 3'b000;

              // Atualizando Counter
              counter = 3'b000;
          end

             
        endcase
  end

end

endmodule //ctrl_unit