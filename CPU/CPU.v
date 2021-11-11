// `include "./Componentes do Projeto/Banco_reg.vhd";
// `include "./Componentes do Projeto/Instr_Reg.vhd";
// `include "./Componentes do Projeto/instruções.vhd";
// `include "./Componentes do Projeto/Memoria.vhd";
// `include "./Componentes do Projeto/RegDesloc.vhd";
// `include "./Componentes do Projeto/Registrador.vhd";


module CPU (
    input clk, reset    
);
    // control wires  
    wire pc_w;
    wire aluOut_w;
    wire mem_w;
    wire ir_w;
    wire reg_w;
    wire alu_src_a;
    wire [1:0] alu_src_b;
    wire reg_ab_w;
    wire hi_w;
    wire lo_w;
    wire [1:0]reg_dst;
    wire mdr_w;
    wire epc_w;
    

    
    //control wires 2 bits
    wire [1:0] shift_in_w;
    wire [1:0] shift_n_w;
    

    //contol wires 3 bits
    wire [2:0] shift_ctrl;
    wire [2:0] data_src;
    wire [2:0] alu_op;
    
    //data wires
    // wire [31:0] pc_in;
    wire [31:0] pc_out;
    wire [31:0] alu_result;
    wire [31:0] aluOut_out;
    wire [31:0] mem_in;
    wire [31:0] mem_out;


    //wire [4:0] read_reg_1;
    //wire [4:0] read_reg_2;
    //wire [4:0] write_reg;
    //wire [31:0] write_data;

    wire [31:0] regs_out_1;
    wire [31:0] regs_out_2;
    wire [4:0] shift_n;
    wire [31:0] shift_in;
    wire [31:0] shift_out;
    

    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [15:0] offset;

   // wire [31:0] reg_a_in;
    wire [31:0] reg_a_out;
    wire [31:0] mux_a_out;

  //  wire [31:0] reg_b_in;
    wire [31:0] reg_b_out;
    
    
    // Sign extend  
    wire [31:0] extended_out;

    // Shift 2 sem conc
    wire [31:0] shift_2_out;

    wire [31:0] four;
    
    wire [31:0] mux_b_out;

    // flags alu
    wire LT;
    wire GT;
    wire EQ;
    wire Overflow;
    wire Zero;
    wire Negativo;
    
    Registrador PC(
        clk,
        reset,
        pc_w,
        alu_result,
        pc_out
    );

    Memoria Mem(
        pc_out,
        clk,
        mem_w,
        mem_in,
        mem_out
    );
    
    
    Registrador aluOut(
        clk,
        reset,
        aluOut_w,
        alu_result,
        aluOut_out
    );

    Instr_Reg IR(
        clk,
        reset,
        ir_w,
        mem_out,
        opcode,
        rs,
        rt,
        offset
    );

    Banco_reg Regs(
        clk,
        reset,
        reg_w,
        rs, // Read reg 1
        rt, // Read reg 2
        offset[15:11], // Write reg
        aluOut_out, // Write data
        regs_out_1,
        regs_out_2
        
    );

    

    Registrador A(
        clk,
        reset,
        reg_ab_w,
        regs_out_1, //reg_a_in
        reg_a_out

    );

    mux_alu_src_A mux_a(
        alu_src_a,
        pc_out,
        reg_a_out,
        mux_a_out    
    );

    Registrador B(
        clk,
        reset, 
        reg_ab_w,
        regs_out_2, // reg_b_in
        reg_b_out
    );

    ula32 ALU(
        reg_a_out,
        reg_b_out,
        alu_op,
        alu_result,
        Overflow,
        Negativo,
        Zero,
        EQ,
        GT,
        LT
    );


    ctrl_unit unidade_de_controle(
        clk,
        reset,  
        Overflow,
        Negativo,
        Zero,
        EQ,
        GT,
        LT,
        opcode,
        pc_w,
        mem_w,
        ir_w,
        reg_w,
        reg_ab_w,
        aluOut_w,
        alu_src_a,
        hi_w,
        lo_w,
        mdr_w,
        epc_w,
        alu_src_b,
        reg_dst,
        data_src,
        alu_op,
        rst_out
    );

    sign_extend_16 sign_extend_16(
        offset,
        extended_out
    );

    shift_left_2 shift_left_2(
        extended_out,
        shift_2_out
    );

    mux_alu_src_B mux_b(
        reg_b_out,
        four,
        extended_out,
        shift_2_out,
        mux_b_out
    );

    

    // // Reg desloc
    // mux_shift_in mux_shift(
    //     shift_in_w,
    //     reg_a_out,
    //     reg_b_out,
    //     extended_out
    //     shift_in
    // );

    // mux_shift_n mux_shiftn(
    //     shift_n_w,
    //     //fio com rt[4..0]
    //     //fio com inst[16..10]
    //     // fio com valor 16
    //     //fio com mdr
    //     shift_n
    // );
    // RegDesloc reg_desloc(
    //     clk,
    //     rst,
    //     shift_ctrl,
    //     shift_n,
    //     shift_in,
    //     shift_out     
    // );


  
    
endmodule //CPU