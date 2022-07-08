library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity IITB_RISC_Pipelined_Processor is
    port (
        clk : in std_logic;
        clear : in std_logic;
        R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(15 downto 0);
        Carry_flag : out std_logic_vector(0 downto 0);
        Zero_flag : out std_logic_vector(0 downto 0)
        -- Data_memory_data_out : out std_logic_vector(15 downto 0) := (others => 'X')
    );
end entity IITB_RISC_Pipelined_Processor;

architecture Structural of IITB_RISC_Pipelined_Processor is
    signal PC_enable : std_logic;
    signal PC_next : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_out : std_logic_vector(15 downto 0) := (others => '0');
    signal Instruction_Register : std_logic_vector(15 downto 0) := (others => '0');

    signal enable_IF_ID : std_logic;
    signal clear_IF_ID : std_logic;
    signal PC_IF_ID : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_for_R7_IF_ID : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one_IF_ID : std_logic_vector(15 downto 0) := (others => '0');
    signal Instruction_Register_IF_ID : std_logic_vector(15 downto 0) := (others => '0');

    signal regsource1, regsource2, regdest : std_logic_vector(2 downto 0);
    signal alu_operation : std_logic_vector(1 downto 0);
    signal register_writeback : std_logic_vector(0 downto 0) := (others => 'X');
    signal load0_store1 : std_logic_vector(0 downto 0);
    signal sign_extend_6_or_9_bit_immediate : std_logic;
    signal sign_extend_immediate_opr2 : std_logic_vector(0 downto 0);
    signal left_shift_registerB : std_logic_vector(0 downto 0);
    signal is_instr_lhi : std_logic_vector(0 downto 0);
    signal condition_code : std_logic_vector(1 downto 0);
    signal flags_modified : std_logic_vector(1 downto 0);

    signal sign_extended_immediate_data : std_logic_vector(15 downto 0);

    signal enable_ID_RR : std_logic;
    signal clear_ID_RR : std_logic;
    signal RegSource1_ID_RR, RegSource2_ID_RR : std_logic_vector(2 downto 0) := (others => 'X');
    signal PC_ID_RR : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_for_R7_ID_RR : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one_ID_RR : std_logic_vector(15 downto 0) := (others => '0');
    signal Opcode_ID_RR : std_logic_vector(3 downto 0) := (others => '0');
    signal RegDest_ID_RR : std_logic_vector(2 downto 0) := (others => 'X');
    signal ALU_operation_ID_RR : std_logic_vector(1 downto 0) := (others => 'X');
    signal Reg_WB_ID_RR : std_logic_vector(0 downto 0) := (others => '0');
    signal Load0_Store1_ID_RR : std_logic_vector(0 downto 0) := (others => 'X');
    signal SE_immediate_Opr2_ID_RR : std_logic_vector(0 downto 0) := (others => '0');
    signal SE_immediate_ID_RR : std_logic_vector(15 downto 0) := (others => '0');
    signal Left_Shift_RegB_ID_RR : std_logic_vector(0 downto 0) := (others => '0');
    signal LHI_Instr_ID_RR : std_logic_vector(0 downto 0) := (others => '0');
    signal Condition_Code_ID_RR : std_logic_vector(1 downto 0) := (others => 'X');
    signal Flags_modified_ID_RR : std_logic_vector(1 downto 0) := (others => '0');

    signal RegSource1_Data_ID_RR, RegSource2_Data_ID_RR : std_logic_vector(15 downto 0) := (others => 'X');
    signal R7_enable : std_logic;

    signal enable_RR_EX : std_logic;
    signal clear_RR_EX : std_logic;
    signal PC_RR_EX : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_for_R7_RR_EX : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one_RR_EX : std_logic_vector(15 downto 0) := (others => '0');
    signal Opcode_RR_EX : std_logic_vector(3 downto 0) := (others => '0');
    signal RegSource1_Data_RR_EX, RegSource2_Data_RR_EX : std_logic_vector(15 downto 0) := (others => 'X');
    signal RegDest_RR_EX : std_logic_vector(2 downto 0) := (others => 'X');
    signal ALU_operation_RR_EX : std_logic_vector(1 downto 0) := (others => 'X');
    signal Reg_WB_RR_EX : std_logic_vector(0 downto 0) := (others => '0');
    signal Load0_Store1_RR_EX : std_logic_vector(0 downto 0) := (others => 'X');
    signal SE_immediate_Opr2_RR_EX : std_logic_vector(0 downto 0) := (others => '0');
    signal SE_immediate_RR_EX : std_logic_vector(15 downto 0) := (others => '0');
    signal Left_Shift_RegB_RR_EX : std_logic_vector(0 downto 0) := (others => '0');
    signal LHI_Instr_RR_EX : std_logic_vector(0 downto 0) := (others => '0');
    signal LHI_instr_WB_data_RR_EX : std_logic_vector(15 downto 0) := (others => 'X');
    signal Condition_Code_RR_EX : std_logic_vector(1 downto 0) := (others => 'X');
    signal Flags_modified_RR_EX : std_logic_vector(1 downto 0) := (others => '0');

    signal RegSource2_Data_for_ADL : std_logic_vector(15 downto 0) := (others => '0');
    signal LeftShiftRegB_or_RegSource2_Data : std_logic_vector(15 downto 0) := (others => '0');
    signal ALU2nd_input : std_logic_vector(15 downto 0) := (others => '0');

    signal ALU_output_RR_EX : std_logic_vector(15 downto 0) := (others => '0');
    signal ALU_output_flags_RR_EX : std_logic_vector(1 downto 0);

    signal enable_EX_MA : std_logic;
    signal PC_EX_MA : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_for_R7_EX_MA : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one_EX_MA : std_logic_vector(15 downto 0) := (others => '0');
    signal Opcode_EX_MA : std_logic_vector(3 downto 0) := (others => '0');
    signal RegSource1_Data_EX_MA, RegSource2_Data_EX_MA : std_logic_vector(15 downto 0) := (others => 'X');
    signal RegDest_EX_MA : std_logic_vector(2 downto 0) := (others => 'X');
    signal Reg_WB_EX_MA : std_logic_vector(0 downto 0) := (others => '0');
    signal ALU_output_EX_MA : std_logic_vector(15 downto 0) := (others => '0');
    signal ALU_output_flags_EX_MA : std_logic_vector(1 downto 0);
    signal Load0_Store1_EX_MA : std_logic_vector(0 downto 0) := (others => 'X');
    signal LHI_Instr_EX_MA : std_logic_vector(0 downto 0) := (others => '0');
    signal LHI_instr_WB_data_EX_MA : std_logic_vector(15 downto 0) := (others => 'X');
    signal Condition_Code_EX_MA : std_logic_vector(1 downto 0) := (others => 'X');
    signal Flags_modified_EX_MA : std_logic_vector(1 downto 0) := (others => '0');

    signal Data_Memory_read_enable : std_logic := 'X';
    signal Data_Memory_write_enable : std_logic := 'X';
    signal Data_memory_data_out : std_logic_vector(15 downto 0) := (others => 'X');

    signal enable_MA_WB : std_logic;
    signal PC_MA_WB : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_for_R7_MA_WB : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_plus_one_MA_WB : std_logic_vector(15 downto 0) := (others => '0');
    signal Opcode_MA_WB : std_logic_vector(3 downto 0) := (others => '0');
    signal RegDest_MA_WB : std_logic_vector(2 downto 0) := (others => 'X');
    signal Reg_WB_MA_WB : std_logic_vector(0 downto 0) := (others => '0');
    signal Load0_Store1_MA_WB : std_logic_vector(0 downto 0) := (others => 'X');
    signal ALU_output_MA_WB : std_logic_vector(15 downto 0) := (others => '0');
    signal Data_memory_data_out_MA_WB : std_logic_vector(15 downto 0) := (others => '0');
    signal ALU_output_flags_MA_WB : std_logic_vector(1 downto 0);
    signal LHI_Instr_MA_WB : std_logic_vector(0 downto 0) := (others => '0');
    signal LHI_instr_WB_data_MA_WB : std_logic_vector(15 downto 0) := (others => 'X');
    signal Condition_Code_MA_WB : std_logic_vector(1 downto 0) := (others => 'X');
    signal Flags_modified_MA_WB : std_logic_vector(1 downto 0) := (others => '0');

    signal Reg_WB_Enable : std_logic_vector(0 downto 0) := (others => '0');
    signal Register_Writeback_data : std_logic_vector(15 downto 0) := (others => 'X');

    signal PC_for_BEQ : std_logic_vector(15 downto 0) := (others => '0');
    signal BEQ_condition_true : std_logic;
begin
    PC_enable <= '1';
    -- PC_next <= PC_plus_one;
    PC_next <= PC_for_BEQ when BEQ_condition_true='1' else PC_plus_one; --PC+Imm when BEQ condition passes else PC+1
    BEQ_condition_true <= '1' when ALU_operation_RR_EX="10" and ALU_output_flags_RR_EX(1 downto 1)="1" else '0';

    InstrFetch : Instruction_Fetch port map(
        clk => clk, clear => clear, PC_enable => PC_enable, PC_in => PC_next, PC_plus_one => PC_plus_one, PC_out => PC_out, Instruction_Register => Instruction_Register 
    );
    
    -- enable_IF_ID <= '1';
    enable_IF_ID <= not clear_IF_ID;
    clear_IF_ID <= clear or BEQ_condition_true;
    
    PC_for_R7_IF_ID_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear, enable => '1', data_in => PC_out, data_out => PC_for_R7_IF_ID
    );

    IF_ID_pipeline_reg : IF_ID port map(
        clk => clk, clear_IF_ID => clear_IF_ID, enable_IF_ID => enable_IF_ID, PC_out => PC_out, PC_IF_ID => PC_IF_ID,
        PC_plus_one => PC_plus_one, PC_plus_one_IF_ID => PC_plus_one_IF_ID,
        Instruction_Register => Instruction_Register, Instruction_Register_IF_ID => Instruction_Register_IF_ID
    );

    InstrDecode : Instruction_Decode port map(
        Instruction_Register => Instruction_Register_IF_ID, regsource1 => regsource1, regsource2 => regsource2, regdest => regdest,
        alu_operation => alu_operation, register_writeback => register_writeback, load0_store1 => load0_store1,
        sign_extend_6_or_9_bit_immediate => sign_extend_6_or_9_bit_immediate, sign_extend_immediate_opr2 => sign_extend_immediate_opr2,
        left_shift_registerB => left_shift_registerB, is_instr_lhi => is_instr_lhi, condition_code => condition_code, flags_modified => flags_modified
    );

    SignExtendImmediate : sign_extend_immediate port map(
        Instruction_Register => Instruction_Register_IF_ID, sign_extend_6_or_9_bit_immediate => sign_extend_6_or_9_bit_immediate,
        sign_extended_immediate_data => sign_extended_immediate_data
    );

    -- enable_ID_RR <= '1';
    enable_ID_RR <= not clear_ID_RR;
    clear_ID_RR <= clear or BEQ_condition_true;
    
    PC_for_R7_ID_RR_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear, enable => '1', data_in => PC_for_R7_IF_ID, data_out => PC_for_R7_ID_RR
    );

    ID_RR_pipeline_reg : ID_RR port map(
        clk => clk, clear_ID_RR => clear_ID_RR, enable_ID_RR => enable_ID_RR, PC_IF_ID => PC_IF_ID, PC_ID_RR => PC_ID_RR,
        PC_plus_one_IF_ID => PC_plus_one_IF_ID, PC_plus_one_ID_RR => PC_plus_one_ID_RR,
        Opcode_IF_ID => Instruction_Register(15 downto 12), Opcode_ID_RR => Opcode_ID_RR, RegSource1_IF_ID => regsource1, RegSource1_ID_RR => RegSource1_ID_RR,
        RegSource2_IF_ID => regsource2, RegSource2_ID_RR => RegSource2_ID_RR, RegDest_IF_ID => regdest, RegDest_ID_RR => RegDest_ID_RR,
        ALU_operation_IF_ID => alu_operation, ALU_operation_ID_RR => ALU_operation_ID_RR,
        Reg_WB_IF_ID => register_writeback, Reg_WB_ID_RR => Reg_WB_ID_RR, 
        Load0_Store1_IF_ID => load0_store1, Load0_Store1_ID_RR => Load0_Store1_ID_RR,
        SE_immediate_Opr2_IF_ID => sign_extend_immediate_opr2, SE_immediate_Opr2_ID_RR => SE_immediate_Opr2_ID_RR,
        SE_immediate_IF_ID => sign_extended_immediate_data, SE_immediate_ID_RR => SE_immediate_ID_RR,
        Left_Shift_RegB_IF_ID => left_shift_registerB, Left_Shift_RegB_ID_RR => Left_Shift_RegB_ID_RR,
        LHI_Instr_IF_ID => is_instr_lhi, LHI_Instr_ID_RR => LHI_Instr_ID_RR,
        Condition_Code_IF_ID => condition_code, Condition_Code_ID_RR => Condition_Code_ID_RR,
        Flags_modified_IF_ID => flags_modified, Flags_modified_ID_RR => Flags_modified_ID_RR
    );
    
    R7_enable <= '1';

    RegisterRead : Register_Read port map(
        clk => clk, clear => clear, read_reg1 => RegSource1_ID_RR, read_reg2 => RegSource2_ID_RR, register_writeback => Reg_WB_Enable,
        R7_enable => R7_enable, write_reg => RegDest_MA_WB, read_data1 => RegSource1_Data_ID_RR, read_data2 => RegSource2_Data_ID_RR,
        PC => PC_for_R7_MA_WB, write_data => Register_Writeback_data, R0 => R0, R1 => R1, R2 => R2, R3 => R3, R4 => R4, R5 => R5, R6 => R6, R7 => R7
    );
    -- Reg_WB_Enable depending on Conditional Arith Instr or reg wb signal from Decode stage carried forward
    
    -- enable_RR_EX <= '1';
    enable_RR_EX <= not clear_RR_EX;
    clear_RR_EX <= clear or BEQ_condition_true;
    
    PC_for_R7_RR_EX_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear, enable => '1', data_in => PC_for_R7_ID_RR, data_out => PC_for_R7_RR_EX
    );

    RR_EX_pipeline_reg : RR_EX port map(
        clk => clk, clear_RR_EX => clear_RR_EX, enable_RR_EX => enable_RR_EX, PC_ID_RR => PC_ID_RR, PC_RR_EX => PC_RR_EX,
        PC_plus_one_ID_RR => PC_plus_one_ID_RR, PC_plus_one_RR_EX => PC_plus_one_RR_EX,
        Opcode_ID_RR => Opcode_ID_RR, Opcode_RR_EX => Opcode_RR_EX, RegSource1_Data_ID_RR => RegSource1_Data_ID_RR, RegSource1_Data_RR_EX => RegSource1_Data_RR_EX,
        RegSource2_Data_ID_RR => RegSource2_Data_ID_RR, RegSource2_Data_RR_EX => RegSource2_Data_RR_EX, RegDest_ID_RR => RegDest_ID_RR, RegDest_RR_EX => RegDest_RR_EX,
        ALU_operation_ID_RR => ALU_operation_ID_RR, ALU_operation_RR_EX => ALU_operation_RR_EX,
        Reg_WB_ID_RR => Reg_WB_ID_RR, Reg_WB_RR_EX => Reg_WB_RR_EX, 
        Load0_Store1_ID_RR => Load0_Store1_ID_RR, Load0_Store1_RR_EX => Load0_Store1_RR_EX,
        SE_immediate_Opr2_ID_RR => SE_immediate_Opr2_ID_RR, SE_immediate_Opr2_RR_EX => SE_immediate_Opr2_RR_EX,
        SE_immediate_ID_RR => SE_immediate_ID_RR, SE_immediate_RR_EX => SE_immediate_RR_EX,
        Left_Shift_RegB_ID_RR => Left_Shift_RegB_ID_RR, Left_Shift_RegB_RR_EX => Left_Shift_RegB_RR_EX,
        LHI_Instr_ID_RR => LHI_Instr_ID_RR, LHI_Instr_RR_EX => LHI_Instr_RR_EX,
        Condition_Code_ID_RR => Condition_Code_ID_RR, Condition_Code_RR_EX => Condition_Code_RR_EX,
        Flags_modified_ID_RR => Flags_modified_ID_RR, Flags_modified_RR_EX => Flags_modified_RR_EX
    );
    
    LHI_instr_WB_data_RR_EX <= SE_immediate_RR_EX(8 downto 0) & "0000000";

    RegSource2_Data_for_ADL <= RegSource2_Data_RR_EX(14 downto 0) & '0';
    LeftShiftRegB_or_RegSource2_Data <= RegSource2_Data_for_ADL when (Left_Shift_RegB_RR_EX = "1") else RegSource2_Data_RR_EX;
    ALU2nd_input <= SE_immediate_RR_EX when (SE_immediate_Opr2_RR_EX = "1") else LeftShiftRegB_or_RegSource2_Data;

    ExecuteStage : Execute port map(
        A => RegSource1_Data_RR_EX, B => ALU2nd_input, Cin => '0', ALU_operation => ALU_operation_RR_EX,
        Output => ALU_output_RR_EX, ALU_output_flags => ALU_output_flags_RR_EX
    );

    PC_for_BEQ <= std_logic_vector(unsigned(PC_RR_EX) + unsigned(SE_immediate_RR_EX));
    
    enable_EX_MA <= '1';
    
    PC_for_R7_EX_MA_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear, enable => '1', data_in => PC_for_R7_RR_EX, data_out => PC_for_R7_EX_MA
    );

    EX_MA_pipeline_reg : EX_MA port map(
        clk => clk, clear_EX_MA => clear, enable_EX_MA => enable_EX_MA, PC_RR_EX => PC_RR_EX, PC_EX_MA => PC_EX_MA,
        PC_plus_one_RR_EX => PC_plus_one_RR_EX, PC_plus_one_EX_MA => PC_plus_one_EX_MA,
        Opcode_RR_EX => Opcode_RR_EX, Opcode_EX_MA => Opcode_EX_MA, RegSource1_Data_RR_EX => RegSource1_Data_RR_EX, RegSource1_Data_EX_MA => RegSource1_Data_EX_MA,
        RegSource2_Data_RR_EX => RegSource2_Data_RR_EX, RegSource2_Data_EX_MA => RegSource2_Data_EX_MA,
        RegDest_RR_EX => RegDest_RR_EX, RegDest_EX_MA => RegDest_EX_MA,
        Reg_WB_RR_EX => Reg_WB_RR_EX, Reg_WB_EX_MA => Reg_WB_EX_MA,
        ALU_output_RR_EX => ALU_output_RR_EX, ALU_output_EX_MA => ALU_output_EX_MA,
        ALU_output_flags_RR_EX => ALU_output_flags_RR_EX, ALU_output_flags_EX_MA => ALU_output_flags_EX_MA,
        Load0_Store1_RR_EX => Load0_Store1_RR_EX, Load0_Store1_EX_MA => Load0_Store1_EX_MA,
        LHI_Instr_RR_EX => LHI_Instr_RR_EX, LHI_Instr_EX_MA => LHI_Instr_EX_MA,
        LHI_instr_WB_data_RR_EX => LHI_instr_WB_data_RR_EX, LHI_instr_WB_data_EX_MA => LHI_instr_WB_data_EX_MA,
        Condition_Code_RR_EX => Condition_Code_RR_EX, Condition_Code_EX_MA => Condition_Code_EX_MA,
        Flags_modified_RR_EX => Flags_modified_RR_EX, Flags_modified_EX_MA => Flags_modified_EX_MA
    );

    Data_Memory_read_enable <= '1' when Load0_Store1_EX_MA="0" else '0'; -- Read from memory for LW
    Data_Memory_write_enable <= '1' when Load0_Store1_EX_MA="1" else '0'; -- Write into memory for SW

    Memory_Access : Data_Memory generic map(data_memory_locations => 256, data_length => 16) port map(
        clk => clk, clear => clear, read_enable => Data_Memory_read_enable, write_enable => Data_Memory_write_enable,
        Data_memory_address => ALU_output_EX_MA, Data_memory_data_in => RegSource2_Data_EX_MA, Data_memory_data_out => Data_memory_data_out
    );
    
    enable_MA_WB <= '1';
    
    PC_for_R7_MA_WB_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear, enable => '1', data_in => PC_for_R7_EX_MA, data_out => PC_for_R7_MA_WB
    );

    MA_WB_pipeline_reg : MA_WB port map(
        clk => clk, clear_MA_WB => clear, enable_MA_WB => enable_MA_WB, PC_EX_MA => PC_EX_MA, PC_MA_WB => PC_MA_WB,
        PC_plus_one_EX_MA => PC_plus_one_EX_MA, PC_plus_one_MA_WB => PC_plus_one_MA_WB,
        Opcode_EX_MA => Opcode_EX_MA, Opcode_MA_WB => Opcode_MA_WB,
        RegDest_EX_MA => RegDest_EX_MA, RegDest_MA_WB => RegDest_MA_WB,
        Reg_WB_EX_MA => Reg_WB_EX_MA, Reg_WB_MA_WB => Reg_WB_MA_WB,
        Load0_Store1_EX_MA => Load0_Store1_EX_MA, Load0_Store1_MA_WB => Load0_Store1_MA_WB,
        ALU_output_EX_MA => ALU_output_EX_MA, ALU_output_MA_WB => ALU_output_MA_WB,
        Data_memory_data_out_EX_MA => Data_memory_data_out, Data_memory_data_out_MA_WB => Data_memory_data_out_MA_WB,
        ALU_output_flags_EX_MA => ALU_output_flags_EX_MA, ALU_output_flags_MA_WB => ALU_output_flags_MA_WB,
        LHI_Instr_EX_MA => LHI_Instr_EX_MA, LHI_Instr_MA_WB => LHI_Instr_MA_WB,
        LHI_instr_WB_data_EX_MA => LHI_instr_WB_data_EX_MA, LHI_instr_WB_data_MA_WB => LHI_instr_WB_data_MA_WB,
        Condition_Code_EX_MA => Condition_Code_EX_MA, Condition_Code_MA_WB => Condition_Code_MA_WB,
        Flags_modified_EX_MA => Flags_modified_EX_MA, Flags_modified_MA_WB => Flags_modified_MA_WB
    );
    
    ConditionalArithInstrWB : Conditional_Arith_Instr_WB port map(
        Opcode => Opcode_MA_WB, Condition_Code => Condition_Code_MA_WB, ALU_output_flags => ALU_output_flags_MA_WB,
        Reg_WB => Reg_WB_MA_WB, Reg_WB_Enable => Reg_WB_Enable
    );

    Register_Writeback_data <= Data_memory_data_out_MA_WB when Load0_Store1_MA_WB="0" else -- Writeback data read from memory for LW
                               LHI_instr_WB_data_MA_WB when LHI_Instr_MA_WB="1" else -- Writeback 7bit left shifted imm data for LHI
                               ALU_output_MA_WB; -- Writeback ALU output
    
    CY_flag : nbit_register generic map(N => 1) port map(
            clk => clk, clear => clear, enable => Flags_modified_MA_WB(0),
            data_in => ALU_output_flags_MA_WB(0 downto 0), data_out => Carry_flag
    );

    Z_flag : nbit_register generic map(N => 1) port map(
        clk => clk, clear => clear, enable => Flags_modified_MA_WB(1),
        data_in => ALU_output_flags_MA_WB(1 downto 1), data_out => Zero_flag
    );
end architecture Structural;