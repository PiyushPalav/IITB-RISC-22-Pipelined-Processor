library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity RR_EX is
    port (
        clk : in std_logic;
        clear_RR_EX : in std_logic;
        enable_RR_EX : in std_logic;
        PC_ID_RR : in std_logic_vector(15 downto 0);
        PC_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
        PC_plus_one_ID_RR : in std_logic_vector(15 downto 0);
        PC_plus_one_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
        Opcode_ID_RR : in std_logic_vector(3 downto 0);
        Opcode_RR_EX : out std_logic_vector(3 downto 0) := (others => '0');
        RegSource1_ID_RR, RegSource2_ID_RR : in std_logic_vector(2 downto 0);
        RegSource1_RR_EX, RegSource2_RR_EX : out std_logic_vector(2 downto 0) := (others => 'X');
        ALU1st_input_forwarded_data, ALU2nd_input_forwarded_data : in std_logic_vector(15 downto 0);
        ALU1st_input_forwarded_data_RR_EX, ALU2nd_input_forwarded_data_RR_EX : out std_logic_vector(15 downto 0) := (others => 'X');
        RegDest_ID_RR : in std_logic_vector(2 downto 0);
        RegDest_RR_EX : out std_logic_vector(2 downto 0) := (others => 'X');
        ALU_operation_ID_RR : in std_logic_vector(1 downto 0);
        ALU_operation_RR_EX : out std_logic_vector(1 downto 0) := (others => 'X');
        Reg_WB_ID_RR : in std_logic_vector(0 downto 0);
        Reg_WB_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        Load0_Store1_ID_RR : in std_logic_vector(0 downto 0);
        Load0_Store1_RR_EX : out std_logic_vector(0 downto 0) := (others => 'X');
        SE_immediate_Opr2_ID_RR : in std_logic_vector(0 downto 0);
        SE_immediate_Opr2_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        SE_immediate_ID_RR : in std_logic_vector(15 downto 0);
        SE_immediate_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
        Left_Shift_RegB_ID_RR : in std_logic_vector(0 downto 0);
        Left_Shift_RegB_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        LHI_Instr_ID_RR : in std_logic_vector(0 downto 0);
        LHI_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        JAL_Instr_ID_RR : in std_logic_vector(0 downto 0);
        JAL_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        JLR_Instr_ID_RR : in std_logic_vector(0 downto 0);
        JLR_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
        Condition_Code_ID_RR : in std_logic_vector(1 downto 0);
        Condition_Code_RR_EX : out std_logic_vector(1 downto 0) := (others => 'X');
        Flags_modified_ID_RR : in std_logic_vector(1 downto 0); 
        Flags_modified_RR_EX : out std_logic_vector(1 downto 0) := (others => '0')
    );
end entity;

architecture Structural of RR_EX is
begin
    PC_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => PC_ID_RR, data_out => PC_RR_EX
    );

    PC_plus_one_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => PC_plus_one_ID_RR, data_out => PC_plus_one_RR_EX
    );

    Opcode_reg : nbit_register generic map (N => 4) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Opcode_ID_RR, data_out => Opcode_RR_EX
    );
    
    RegSource1_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => RegSource1_ID_RR, data_out => RegSource1_RR_EX
    );

    RegSource2_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => RegSource2_ID_RR, data_out => RegSource2_RR_EX
    );

    ALUInput1ForwardedData_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => ALU1st_input_forwarded_data, data_out => ALU1st_input_forwarded_data_RR_EX
    );

    ALUInput2ForwardedData_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => ALU2nd_input_forwarded_data, data_out => ALU2nd_input_forwarded_data_RR_EX
    );

    RegDest_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => RegDest_ID_RR, data_out => RegDest_RR_EX
    );

    ALUOp_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => ALU_operation_ID_RR, data_out => ALU_operation_RR_EX
    );

    RegWB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Reg_WB_ID_RR, data_out => Reg_WB_RR_EX
    );

    Load0_Store1_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Load0_Store1_ID_RR, data_out => Load0_Store1_RR_EX
    );
    
    SignExtendImmediateOpr2_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => SE_immediate_Opr2_ID_RR, data_out => SE_immediate_Opr2_RR_EX
    );

    SignExtendImmediate_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => SE_immediate_ID_RR, data_out => SE_immediate_RR_EX
    );

    LeftShiftRegB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Left_Shift_RegB_ID_RR, data_out => Left_Shift_RegB_RR_EX
    );

    LHIInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => LHI_Instr_ID_RR, data_out => LHI_Instr_RR_EX
    );

    JALInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => JAL_Instr_ID_RR, data_out => JAL_Instr_RR_EX
    );

    JLRInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => JLR_Instr_ID_RR, data_out => JLR_Instr_RR_EX
    );

    Condition_Code_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Condition_Code_ID_RR, data_out => Condition_Code_RR_EX
    );

    Flags_modified_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_RR_EX, enable => enable_RR_EX, data_in => Flags_modified_ID_RR, data_out => Flags_modified_RR_EX
    );
end architecture Structural;