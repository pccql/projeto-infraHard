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
   
    wire reg_ab_w;
    wire hi_w;
    wire lo_w;
    
    wire MDR_w;
    wire epc_w;

    wire div_control;
    wire HiLo_w;
    wire HiLo_control;
    wire div_0;
    wire start;
    wire finished;

    wire mult_start;

    
    
    //control wires 2 bits
    wire [1:0] shift_in_w;
    wire [1:0] shift_n_w;
    wire [1:0] reg_dst;
    wire [1:0] alu_src_b;
    wire [1:0] ls_control;
    wire [1:0] ss_control;
    wire [1:0] exception_control;

    

    //control wires 3 bits
    wire [2:0] i_or_d_sel;
    wire [2:0] pc_src;
    wire [2:0] shift_ctrl;
    wire [2:0] data_src;
    wire [2:0] alu_op;
    wire [1:0] alu_flag;
    
    //data wires
    wire mult_calculando;
    wire [31:0] pc_in;
    wire [31:0] pc_out;
    wire [31:0] alu_result;
    wire [31:0] aluOut_out;
    wire [31:0] mem_in;
    wire [31:0] mem_out;
    wire [31:0] MDR_out;
    wire [31:0] epc_out; 
    wire [31:0] ls_out;
    wire [31:0] ss_out;
    wire [31:0] mux_pc_src_out;

    wire [63:0] mult_produto;

    wire [31:0] lo_out;
    wire [31:0] hi_out;
    wire [31:0] mux_data_src_out;

    
    wire [31:0] mux_excecao_out;
    wire [31:0] i_or_d_out;

    //wire [4:0] read_reg_1;
    //wire [4:0] read_reg_2;
    //wire [4:0] write_reg;
    //wire [31:0] write_data;

    wire [4:0] sixteen;

    wire [31:0] regs_out_1;
    wire [31:0] regs_out_2;
    wire [4:0] shift_n;
    wire [31:0] shift_in;
    wire [31:0] shift_out;
    

    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [15:0] immediate;
    //
    wire [25:0] offset;
    assign offset = {rs, rt, immediate};
   //
    wire mux_alu_flag_out;

   // wire [31:0] reg_a_in;
    wire [31:0] reg_a_out;
    wire [31:0] mux_a_out;

    //  wire [31:0] reg_b_in;
    wire [31:0] reg_b_out;

    wire [31:0] reg_hi_out;
    wire [31:0] reg_lo_out;

    wire[31:0] quocient;
    wire[31:0] remainder;

    wire[31:0] msb_mult;
    wire[31:0] lsb_mult;

    wire[31:0] mux_div_control_a_out;
    wire[31:0] mux_div_control_b_out;

    wire[31:0] mux_hi_out;
    wire [31:0] mux_lo_out;

    
    
    
    
    // Sign extend  
    wire [31:0] extended_out;
    wire sign_extd_32_in;
    wire [31:0] sign_extd_32_out;

    
    
    // Shift 2 sem conc
    wire [31:0] shift_2_out;

    wire [31:0] four;
    
    wire [31:0] mux_b_out;

   
    wire [4:0] reg_dst_out;

    //Shift 2 com conc
    wire [31:0] shift_left_2_conc_out;

    

    // flags alu
    wire LT;
    wire GT;
    wire EQ;
    wire Overflow;
    wire Zero;
    wire Negativo;

    //Constantes
    wire [4:0] const_2;
    wire [4:0] const_3;
    wire [31:0] const_5;
    wire [31:0] const_253;
    wire [31:0] const_254;
    wire [31:0] const_255;


    
    Registrador PC(
        clk,
        reset,
        pc_w,
        mux_pc_src_out,
        pc_out
    );

    LS ls (
        ls_control,
        MDR_out,
        ls_out
    );

    SS ss (
        ss_control,
        reg_b_out,
        MDR_out,
        ss_out
    );
    
    Memoria Mem(
        i_or_d_out,
        clk,
        mem_w,
        ss_out,
        mem_out
    );
    
    
    Registrador aluOut(
        clk,
        reset,
        aluOut_w,
        alu_result,
        aluOut_out
    );

    Registrador MDR(
        clk,
        reset,
        MDR_w,
        mem_out,
        MDR_out
    );

    Registrador EPC(
        clk,
        reset,
        epc_w,
        alu_result,
        epc_out
    );


    mux_pc_src PCSrc(
        pc_src,
        aluOut_out, 
        alu_result,
        shift_left_2_conc_out,
        epc_out,
        ls_out,
        mux_pc_src_out 
    );
    
    
    Instr_Reg IR(
        clk,
        reset,
        ir_w,
        mem_out,
        opcode, //31:26 
        rs,   //25:21
        rt,   //20:16
        immediate // 15:0
    );

    
    mux_controle_excessao mux_exception(
        exception_control,
        const_253,
        const_254,
        const_255,
        mux_excecao_out
    );

    mux_data_src mux_data_src (
        data_src, 
        ls_out, 
        aluOut_out, 
        lo_out, 
        hi_out, 
        shift_out, 
        const_5, 
        sign_extd_32_out,
        mux_data_src_out
    );

    mux_reg_dst Mreg (
        reg_dst,
        rt,
        immediate[15:11], // rd
        const_2,
        const_3,
        reg_dst_out
    );

    mux_Ior_D IorD(
        i_or_d_sel,
        pc_out,
        aluOut_out, 
        reg_a_out, 
        reg_b_out, 
        mux_excecao_out,
        i_or_d_out
    );

    
    
    Banco_reg Regs(
        clk,
        reset,
        reg_w,
        rs, // Read reg 1
        rt, // Read reg 2
        reg_dst_out, // Write reg
        mux_data_src_out, // Write data
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

    mux_alu_src_B mux_b(
        alu_src_b,
        reg_b_out,
        four,
        extended_out,
        shift_2_out,
        mux_b_out
    );
    Registrador B(
        clk,
        reset, 
        reg_ab_w,
        regs_out_2, // reg_b_in
        reg_b_out
    );

    ula32 ALU(
        mux_a_out,
        mux_b_out,
        alu_op,
        alu_result,
        Overflow,
        Negativo,
        Zero,
        EQ,
        GT,
        LT
    );

    mux_alu_flag mux_alu_flag (
        alu_flag,
        GT,
        LT,
        EQ,
        mux_alu_flag_out
    );

    sign_extend_32 sign_extend_32 (
        mux_alu_flag_out,
        sign_extd_32_out 
    );


    ctrl_unit unidade_de_controle(
        clk,
        reset,  
        div_0,
        Overflow,
        Negativo,
        Zero,
        EQ,
        GT,
        LT,
        finished,
        mult_calculando,
        opcode,
        immediate[5:0],
        pc_w,
        mem_w,
        ir_w,
        reg_w,
        reg_ab_w,
        aluOut_w,
        alu_src_a,
        MDR_w,
        epc_w,
        div_control,
        HiLo_control,
        HiLo_w,
        start,
        mult_start,
        alu_flag,
        alu_src_b,
        reg_dst,
        shift_in_w,
        shift_n_w,
        ls_control,
        ss_control,
        exception_control,
        pc_src,
        data_src,
        alu_op,
        shift_ctrl,
        i_or_d_sel,
        rst_out
    );

    sign_extend_16 sign_extend_16(
        immediate,
        extended_out
    );

    shift_left_2 shift_left_2(
        extended_out,
        shift_2_out
    );

     shift_left_2_conc shift_left_2_conc(
        offset,
        pc_out,
        shift_left_2_conc_out
    );
    

    // Reg desloc
    mux_shift_in mux_shift(
        shift_in_w,
        reg_a_out,
        reg_b_out,
        extended_out,
        shift_in
    );

    mux_shift_n mux_shiftn(
        shift_n_w,
        reg_b_out[4:0],
        offset[10:6],
        sixteen,
        MDR_out[4:0],
        shift_n
    );
    RegDesloc reg_desloc(
        clk,
        rst,
        shift_ctrl,
        shift_n,
        shift_in,
        shift_out     
    );

    mux_div_control_a mux_div_control_a(
        div_control,
        reg_a_out,
        MDR_out,
        mux_div_control_a_out
    );

    mux_div_control_b mux_div_control_b(
        div_control,
        reg_b_out,
        mem_out,
        mux_div_control_b_out
    );

    div div(
        clk,
        reset,
        start,
        mux_div_control_a_out,
        mux_div_control_b_out,
        remainder,
        quocient,
        div_0,
        finished
    );

    mux_LO mux_lo (
        HiLo_control,
        lsb_mult,
        quocient,
        mux_lo_out
    );

    mux_HI mux_hi (
        HiLo_control,
        msb_mult,
        remainder,
        mux_hi_out
    );

    Registrador HI(
        clk,
        rst,
        HiLo_w,
        mux_hi_out,
        hi_out
    );

    Registrador LO(
        clk,
        rst,
        HiLo_w,
        mux_lo_out,
        lo_out
    );

    multiplier multiplicador(msb_mult,
    lsb_mult, 
    mult_calculando, 
    reg_a_out, 
    reg_b_out, 
    clk, 
    mult_start
    );


  
    
endmodule //CPU