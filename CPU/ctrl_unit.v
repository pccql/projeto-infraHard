module ctrl_unit (
        input wire clk,
        input wire reset,

        //flags  
        input wire div_0,
        input wire Overflow,
        input wire Negativo,
        input wire Zero,
        input wire EQ,
        input wire GT,
        input wire LT,

        input wire div_finished,

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
        output reg mdr_w,
        output reg epc_w,
        output reg div_control,
        output reg HiLo_control,
        output reg HiLo_w,
        output reg div_start,

        // Sinais de controle 2 bits
        output reg [1:0] alu_flag,
        output reg [1:0] alu_src_b,
				output reg [1:0] reg_dst,
        output reg [1:0] shift_in_control,
        output reg [1:0] shift_n_control,
        output reg [1:0] ls_control,
        output reg [1:0] ss_control,
        output reg [1:0] exception_control,

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
        parameter beq_state = 6'd18;
        parameter lui_state = 6'd19;
        parameter addiu_state = 6'd20;
        parameter srav_state = 6'd21;
        parameter sllv_state = 6'd22;
        parameter lh_state = 6'd23;
        parameter lb_state = 6'd24;
        parameter sh_state = 6'd25;
        parameter sb_state = 6'd26;
        parameter sram_state = 6'd27;
        parameter slti_state = 6'd28;
        parameter j_state = 6'd29;
        parameter jal_state = 6'd30;
        parameter bne_state = 6'd31;
        parameter ble_state = 6'd32;
        parameter bgt_state = 6'd33;
        parameter overflow_state = 6'd34;
        parameter no_opcode_state = 6'd35;
        parameter div_state = 6'd36;
        parameter mfhi_state = 6'd37;
        parameter mflo_state = 6'd38;
        parameter div_0_state = 6'd39;

        
        

        // Opcodes      
        parameter R = 6'h0;
        parameter sram = 6'h1;
        parameter j_offset = 6'h2;
        parameter  jal = 6'h3;
        parameter addi = 6'h8;
        parameter addiu = 6'h9;
        parameter sw = 6'h2b;
        parameter lw = 6'h23;
        parameter lui = 6'hf;
        parameter beq = 6'h4;
        parameter lb = 6'h20;
        parameter lh = 6'h21;
        parameter sb = 6'h28;
        parameter sh = 6'h29;
        parameter bne = 6'h5;
        parameter ble = 6'h6;
        parameter bgt = 6'h7;
        parameter slti = 6'ha;


    

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
        parameter srav_funct = 6'h7;
        parameter sllv_funct = 6'h4;
        parameter div_funct = 6'h1a;
        parameter mfhi_funct = 6'h10;
        parameter  mflo_funct = 6'h12;
      
        


initial begin
        //Sinal assincrono de reset faz o reset na CPU
                rst_out = 1'b1;
                data_src = 3'b101;
                reg_dst = 2'b11;
                reg_w = 1'b0;
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
    data_src = 3'b101;
    reg_w = 1'b1;
    i_or_d = 3'b000;
    aluOut_w = 1'b0;
    alu_src_a = 1'b0;
    alu_src_b = 2'b00;
    reg_dst = 2'b11;
    
    HiLo_w = 1'b0;
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
            reg_w = 1'b0;
            data_src = 3'b101;
            reg_dst = 2'b11;
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
                  HiLo_w = 1'b0;
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
                    HiLo_w = 1'b0;
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
                  HiLo_w = 1'b0;
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
                  HiLo_w = 1'b0;
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
                        srav_funct: begin
                          state = srav_state;
                        end
                        sllv_funct: begin
                          state = sllv_state;
                        end
                        div_funct: begin
                          state = div_state;
                        end
                        mfhi_funct: begin
                          state = mfhi_state;
                        end
                        mflo_funct: begin
                          state = mflo_state;
                        end
                      endcase
                    end
                    addi: begin
                      state = addi_state;
                    end
                    addiu: begin
                      state = addiu_state;
                    end
                    sw: begin
                      state = sw_state;
                    end
                    lw: begin
                      state = lw_state;
                    end

                    lui: begin
                      state = lui_state;
                      end 
                    beq: begin
                      state = beq_state;
                    end
                    bne: begin
                      state = bne_state;
                    end
                    ble: begin
                      state = ble_state;
                    end
                    bgt: begin
                      state = bgt_state;
                    end
                    lb: begin
                      state = lb_state;
                    end
                    lh: begin
                      state = lh_state;
                    end
                    sb: begin
                      state = sb_state;
                    end
                    sh: begin
                      state = sh_state;
                    end
                    sram: begin
                      state = sram_state;
                    end
                    j_offset: begin
                      state = j_state;
                    end
                    jal: begin
                      state = jal_state;
                    end
                    
                    slti: begin
                      state = slti_state;
                    end
                    
                    default: begin
                      state = no_opcode_state;
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
                  HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              counter = counter + 1;

              
            end

            else if (counter == 3'b001) begin
              if (Overflow == 1'b1) begin
                state = overflow_state;
                counter = 3'b000;
              end
              else begin
                state = add_state;
                counter = counter + 1;
              end
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;

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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; //
              
              counter = 3'b000;
            end
          end

          addiu_state: begin
            if (counter == 3'b000) begin
              state = addiu_state;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = addiu_state;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
            HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
            HiLo_w = 1'b0;
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
            HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; // 
              counter = 3'b000;
            end
          end

          srav_state: begin
            if (counter == 3'b000) begin
              state = srav_state;

              pc_w = 1'b0; 
              shift_control = 3'b001; //
              shift_in_control = 2'b00; // 
              shift_n_control = 2'b00; //
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0;
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; //
              data_src = 3'b100; 
              i_or_d = 3'b000;            
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = srav_state;
              pc_w = 1'b0; 
              shift_control = 3'b100; //
              shift_in_control = 2'b00; 
              shift_n_control = 2'b00;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; //
              i_or_d = 3'b000;             
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = 3'b000;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              shift_control = 3'b000; //
              shift_in_control = 2'b00; 
              shift_n_control = 2'b00;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; // 

              counter = 3'b000;
            end
          end

          sllv_state: begin
            if (counter == 3'b000) begin
              state = sllv_state;

              pc_w = 1'b0; 
              shift_control = 3'b001; //
              shift_in_control = 2'b00; // 
              shift_n_control = 2'b00; //
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; //
              data_src = 3'b100; 
              i_or_d = 3'b000;             
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = sllv_state;

              pc_w = 1'b0; 
              shift_control = 3'b010; //
              shift_in_control = 2'b00; 
              shift_n_control = 2'b00;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; //
              i_or_d = 3'b000;            
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0; 
              
              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;

              pc_w = 1'b0; 
              shift_control = 3'b010; //
              shift_in_control = 2'b00; 
              shift_n_control = 2'b00;
              mem_w = 1'b0; 
              ir_w = 1'b0;  
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b01; 
              data_src = 3'b100; //
              i_or_d = 3'b000;             
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              HiLo_w = 1'b0;
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
              aluOut_w = 1'b1;  //
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;             
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = sw_state;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;

              counter = 3'b000;
              
            end
          end

          sb_state: begin
            if (counter == 3'b000 ) begin
              state = sb_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  //
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;            
              HiLo_w = 1'b0;
              mdr_w = 1'b0; 
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b10;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011 || counter == 3'b001 || counter == 3'b010) begin
              state = sb_state;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b10;

              counter = 3'b000;
              
            end
            
          end

          sh_state: begin
            if (counter == 3'b000) begin
              state = sh_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  //
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;         
              HiLo_w = 1'b0;
              mdr_w = 1'b0; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b01;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b001 || counter == 3'b010 || counter == 3'b011) begin
              state = sh_state;
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b01;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
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
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b01;

              counter = 3'b000;
              
            end
          end

          lw_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //           
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b00;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;  
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b00;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;    
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b00;

              counter = 3'b000;
            end
          end
        
          lb_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lb_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //  
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b10;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lb_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;  
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b10;

              counter = 3'b000;
            end
          end

          lh_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lh_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b01;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lh_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b01;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b01;

              counter = 3'b000;
            end
          
          end
          
          lw_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b00;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lw_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b00;

              counter = 3'b000;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b00;

              counter = 3'b000;
            end
          end
        
          lb_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lb_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b10;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lb_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b10;

              counter = 3'b000;
            end
          end

          lh_state: begin
            if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010) begin
              state = lh_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ls_control = 2'b01;

              counter = counter + 1;
                            
            end
            else if (counter == 3'b011) begin
              state = lh_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b01;

              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b000;   
              i_or_d = 3'b001;
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b1; //
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ls_control = 2'b01;

              counter = 3'b000;
            end
          
          end

          beq_state: begin
            if (counter == 3'b000) begin
              state = beq_state;
              pc_w = 1'b0; 
              pc_src = 3'b000;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = beq_state;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              if (EQ == 1'b1) begin
                pc_w = 1'b1;
              end
              else begin
                pc_w = 1'b0;
              end

              counter = 3'b000;
            end
          end

          bne_state: begin
            if (counter == 3'b000) begin
              state = bne_state;
              pc_w = 1'b0; 
              pc_src = 3'b000;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = bne_state;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              if (EQ == 1'b0) begin
                pc_w = 1'b1;
              end
              else begin
                pc_w = 1'b0;
              end

              counter = 3'b000;
            end
          end

          ble_state: begin
            if (counter == 3'b000) begin
              state = ble_state;
              pc_w = 1'b0; 
              pc_src = 3'b000;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = ble_state;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              if (GT == 1'b0) begin
                pc_w = 1'b1;
              end
              else begin
                pc_w = 1'b0;
              end

              counter = 3'b000;
            end
          end

          bgt_state: begin
            if (counter == 3'b000) begin
              state = bgt_state;
              pc_w = 1'b0; 
              pc_src = 3'b000;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = bgt_state;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              pc_src = 3'b000;
              i_or_d = 3'b000;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b0; 
              alu_src_a = 1'b1; 
              alu_src_b = 2'b00; 
              alu_op = 3'b111; 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              if (GT == 1'b1) begin
                pc_w = 1'b1;
              end
              else begin
                pc_w = 1'b0;
              end

              counter = 3'b000;
            end
          end

          lui_state: begin
            if (counter == 3'b000) begin
              state = lui_state;

              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100;//   
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001;
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              shift_n_control = 2'b10; //
              shift_in_control = 2'b10; //
              shift_control = 3'b001; //
            

              counter = counter + 1;
                            
            end
            
            else if (counter == 3'b001) begin
              state = lui_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100;//   
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001;
              reg_dst = 2'b00; 
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;//
              shift_n_control = 2'b10;
              shift_in_control = 2'b10; 
              shift_control = 3'b010; //

              counter = counter + 1;
            end

            else if (counter == 3'b010 ) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100;//   
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b0; 
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001;
              reg_dst = 2'b00; 
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;//
              shift_n_control = 2'b10;
              shift_in_control = 2'b10; 
              shift_control = 3'b010; //

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
              data_src = 3'b001;
              i_or_d = 3'b000;
              aluOut_w = 1'b0;
              alu_op = 3'b000;
              alu_src_a = 1'b0;
              alu_src_b = 2'b00;
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              reg_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0; // Desapertando reset
              shift_control = 3'b000;

              // Atualizando Counter
              counter = 3'b000;
          end

          sram_state: begin
            if (counter == 3'b000 || counter == 3'b001) begin
              state = sram_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100;//   
              i_or_d = 3'b001; //
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  //
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; // 
              alu_op = 3'b001; // 
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              ss_control = 2'b00;
              shift_n_control = 2'b11; //
              shift_in_control = 2'b01; //
              shift_control = 3'b001; //

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = sram_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100;//   
              i_or_d = 3'b001; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  
              alu_src_a = 1'b1; 
              alu_src_b = 2'b10; 
              alu_op = 3'b001;  
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
               
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;
              ss_control = 2'b00;
              shift_n_control = 2'b11; //
              shift_in_control = 2'b01; //
              shift_control = 3'b100; //

              counter = counter + 1;
            end
            else if (counter == 3'b011) begin
              state = sram_state;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100; //   
              i_or_d = 3'b001; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  
              alu_src_a = 1'b1; 
              alu_src_b = 2'b10; 
              alu_op = 3'b001;  
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
               
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; //
              ss_control = 2'b00;
              shift_n_control = 2'b11; //
              shift_in_control = 2'b01; //
              shift_control = 3'b000; // 
              
              counter = counter + 1;
            end
            else if (counter == 3'b100) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b100; //   
              i_or_d = 3'b001; 
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1;  
              alu_src_a = 1'b1; 
              alu_src_b = 2'b10; 
              alu_op = 3'b001;  
              reg_dst = 2'b00;
              HiLo_w = 1'b0;
               
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; //
              ss_control = 2'b00;
              shift_n_control = 2'b11; //
              shift_in_control = 2'b01; //
              shift_control = 3'b000; // 
              
              counter = 3'b000;
            end
          end

          j_state: begin
            if (counter == 3'b000) begin
              state = close_all_writes;
              pc_w = 1'b1; //
              pc_src = 3'b010; //
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
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              counter = 3'b000;
            end
          end

          jal_state: begin
            if (counter == 3'b000) begin
              state = jal_state;
              pc_w = 1'b1; //
              pc_src = 3'b010; //
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b1;
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b000;
              reg_dst = 2'b10;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              counter = counter + 1;
            end
            else if (counter == 3'b001) begin
              state = jal_state;
              pc_w = 1'b1; 
              pc_src = 3'b010; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;   
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b1;
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b000;
              reg_dst = 2'b10;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1; //

              counter = counter + 1;
            end
            else if (counter == 3'b010) begin
              state = close_all_writes;
              pc_w = 1'b1; 
              pc_src = 3'b010;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001; // 
              i_or_d = 3'b000;
              reg_ab_w = 1'b0;  
              aluOut_w = 1'b0;
              alu_src_a = 1'b0; 
              alu_src_b = 2'b11; 
              alu_op = 3'b001;
              reg_dst = 2'b10;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;//

              counter = 3'b000;
            end
          end
          mfhi_state: begin
            if (counter == 3'b000) begin
              state = close_all_writes;
                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b0;
                  data_src = 3'b011;//   
                  i_or_d = 3'b000;
                  reg_ab_w = 1'b0; 
                  aluOut_w = 1'b0; 
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
                  alu_op = 3'b001;
                  reg_dst = 2'b01;//
                  HiLo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b1;//
            end
          end
          mflo_state: begin
            if (counter == 3'b000) begin
              state = close_all_writes;
                  pc_w = 1'b0; 
                  mem_w = 1'b0; 
                  ir_w = 1'b0;
                  data_src = 3'b010; //  
                  i_or_d = 3'b000;
                  reg_ab_w = 1'b0; 
                  aluOut_w = 1'b0; 
                  alu_src_a = 1'b0; 
                  alu_src_b = 2'b11; 
                  alu_op = 3'b001;
                  reg_dst = 2'b01;//
                  HiLo_w = 1'b0;
                  mdr_w = 1'b0;
                  epc_w = 1'b0;
                  rst_out = 1'b0;
									reg_w = 1'b1;//
            end
          end
          overflow_state: begin
            if (counter == 3'b000 || counter == 3'b001) begin
              state = overflow_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; 
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b1;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b01;
              ls_control = 2'b10;
            end
            else if (counter == 3'b010 || counter == 3'b011 || counter == 3'b100) begin
              state = overflow_state;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b01;
              ls_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b101) begin
              state = overflow_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b01;
              ls_control = 2'b10;
            end
            else if (counter == 3'b110) begin
              state = close_all_writes;
              counter = 3'b000;
              pc_w = 1'b1;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b01;
              ls_control = 2'b10;
              counter = 3'b000;
            end
          end
          
          no_opcode_state: begin
            if (counter == 3'b000 || counter == 3'b001) begin
              state = no_opcode_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; 
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b1;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b00;
              ls_control = 2'b10;
            end
            else if (counter == 3'b010 || counter == 3'b011 || counter == 3'b100) begin
              state = no_opcode_state;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b00;
              ls_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b101) begin
              state = no_opcode_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b00;
              ls_control = 2'b10;
            end
            else if (counter == 3'b110) begin
              state = close_all_writes;
              counter = 3'b000;
              pc_w = 1'b1;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b00;
              ls_control = 2'b10;
              counter = 3'b000;
            end
          end
          
          div_0_state: begin
            if (counter == 3'b000 || counter == 3'b001) begin
              state = div_0_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; 
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b1;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b10;
              ls_control = 2'b10;
            end
            else if (counter == 3'b010 || counter == 3'b011 || counter == 3'b100) begin
              state = div_0_state;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b10;
              ls_control = 2'b10;

              counter = counter + 1;
            end
            else if (counter == 3'b101) begin
              state = div_0_state;
              counter = counter + 1;
              pc_w = 1'b0;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b1;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b10;
              ls_control = 2'b10;
            end
            else if (counter == 3'b110) begin
              state = close_all_writes;
              counter = 3'b000;
              pc_w = 1'b1;
              pc_src = 3'b100; 
              mem_w = 1'b0; 
              ir_w = 1'b0;
              data_src = 3'b001;
              i_or_d = 3'b100;   
              reg_ab_w = 1'b0; 
              aluOut_w = 1'b1; // 
              alu_src_a = 1'b0; //
              alu_src_b = 2'b01; //
              alu_op = 3'b010; //
              reg_dst = 2'b01; //
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
							reg_w = 1'b0;
              exception_control = 2'b10;
              ls_control = 2'b10;
              counter = 3'b000;
            end
          end

          slti_state: begin
            if (counter == 3'b000) begin
              state = slti_state;

              pc_w = 1'b0; 
              pc_src = 3'b001;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              i_or_d = 3'b000;
              data_src = 3'b110;//   
              reg_ab_w = 1'b1; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; //
              alu_op = 3'b111; //
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              alu_flag = 2'b00;
              reg_w = 1'b0;

              counter = counter + 1;
            end

            else if (counter == 3'b001) begin
              state = close_all_writes;
              pc_w = 1'b0; 
              pc_src = 3'b001;
              mem_w = 1'b0; 
              ir_w = 1'b0;
              i_or_d = 3'b000;
              data_src = 3'b110;//   
              reg_ab_w = 1'b1; 
              aluOut_w = 1'b1; 
              alu_src_a = 1'b1; //
              alu_src_b = 2'b10; //
              alu_op = 3'b111; //
              alu_flag = 2'b00;//
              reg_dst = 2'b00; //
              HiLo_w = 1'b0;
              
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b1;//

              counter = 3'b000;
            end

          end

          div_state: begin
            if (counter == 3'b000 || counter == 3'b001) begin
              if (div_0 == 1'b1) begin
                state = div_0_state;
                counter = 3'b000;
              end
              else begin
                state = div_state;
                counter = counter + 1;
              end
              div_control = 1'b0; // 
              div_start = 1'b1; //
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
              
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              HiLo_control = 1'b1;
              HiLo_w = 1'b0;

            end
            else if(counter == 3'b010) begin
              if (div_finished == 1'b0) begin
              counter = 3'b010;
              end
              else begin
                counter = counter + 1;
              end
              state = div_state;
            
              div_start = 1'b0;
              div_control = 1'b0; // 
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
              HiLo_control = 1'b1;
              HiLo_w = 1'b0;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
              
              
              

            end
            
            else if (counter == 3'b011) begin
              state = close_all_writes;
              div_control = 1'b0; // 
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
              HiLo_control = 1'b1;
              HiLo_w = 1'b1;
              mdr_w = 1'b0;
              epc_w = 1'b0;
              rst_out = 1'b0;
              reg_w = 1'b0;
            end
            
          end

             
        endcase
  end

end

endmodule //ctrl_unit