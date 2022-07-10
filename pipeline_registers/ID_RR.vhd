library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity ID_RR is
    port (
        clk : in std_logic;
        clear_ID_RR : in std_logic;
        enable_ID_RR : in std_logic;
        PC_IF_ID : in std_logic_vector(15 downto 0);
        PC_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
        PC_plus_one_IF_ID : in std_logic_vector(15 downto 0);
        PC_plus_one_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
        Opcode_IF_ID : in std_logic_vector(3 downto 0);
        Opcode_ID_RR : out std_logic_vector(3 downto 0) := (others => '0');
        RegSource1_IF_ID, RegSource2_IF_ID, RegDest_IF_ID : in std_logic_vector(2 downto 0);
        RegSource1_ID_RR, RegSource2_ID_RR, RegDest_ID_RR : out std_logic_vector(2 downto 0) := (others => 'X');
        ALU_operation_IF_ID : in std_logic_vector(1 downto 0);
        ALU_operation_ID_RR : out std_logic_vector(1 downto 0) := (others => 'X');
        Reg_WB_IF_ID : in std_logic_vector(0 downto 0);
        Reg_WB_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        Load0_Store1_IF_ID : in std_logic_vector(0 downto 0);
        Load0_Store1_ID_RR : out std_logic_vector(0 downto 0) := (others => 'X');
        SE_immediate_Opr2_IF_ID : in std_logic_vector(0 downto 0);
        SE_immediate_Opr2_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        SE_immediate_IF_ID : in std_logic_vector(15 downto 0);
        SE_immediate_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
        Left_Shift_RegB_IF_ID : in std_logic_vector(0 downto 0);
        Left_Shift_RegB_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        LHI_Instr_IF_ID : in std_logic_vector(0 downto 0);
        LHI_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        JAL_Instr_IF_ID : in std_logic_vector(0 downto 0);
        JAL_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        JLR_Instr_IF_ID : in std_logic_vector(0 downto 0);
        JLR_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        JRI_Instr_IF_ID : in std_logic_vector(0 downto 0);
        JRI_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
        Condition_Code_IF_ID : in std_logic_vector(1 downto 0);
        Condition_Code_ID_RR : out std_logic_vector(1 downto 0) := (others => 'X');
        Flags_modified_IF_ID : in std_logic_vector(1 downto 0); 
        Flags_modified_ID_RR : out std_logic_vector(1 downto 0) := (others => '0')
    );
end entity;

architecture Structural of ID_RR is
begin
    PC_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => PC_IF_ID, data_out => PC_ID_RR
    );

    PC_plus_one_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => PC_plus_one_IF_ID, data_out => PC_plus_one_ID_RR
    );

    Opcode_reg : nbit_register generic map (N => 4) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Opcode_IF_ID, data_out => Opcode_ID_RR
    );

    RegSource1_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => RegSource1_IF_ID, data_out => RegSource1_ID_RR
    );

    RegSource2_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => RegSource2_IF_ID, data_out => RegSource2_ID_RR
    );

    RegDest_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => RegDest_IF_ID, data_out => RegDest_ID_RR
    );

    ALUOp_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => ALU_operation_IF_ID, data_out => ALU_operation_ID_RR
    );

    RegWB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Reg_WB_IF_ID, data_out => Reg_WB_ID_RR
    );

    Load0_Store1_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Load0_Store1_IF_ID, data_out => Load0_Store1_ID_RR
    );
    
    SignExtendImmediateOpr2_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => SE_immediate_Opr2_IF_ID, data_out => SE_immediate_Opr2_ID_RR
    );

    SignExtendImmediate_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => SE_immediate_IF_ID, data_out => SE_immediate_ID_RR
    );

    LeftShiftRegB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Left_Shift_RegB_IF_ID, data_out => Left_Shift_RegB_ID_RR
    );
    
    LHIInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => LHI_Instr_IF_ID, data_out => LHI_Instr_ID_RR
    );

    JALInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => JAL_Instr_IF_ID, data_out => JAL_Instr_ID_RR
    );

    JLRInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => JLR_Instr_IF_ID, data_out => JLR_Instr_ID_RR
    );
    
    JRIInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => JRI_Instr_IF_ID, data_out => JRI_Instr_ID_RR
    );

    Condition_Code_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Condition_Code_IF_ID, data_out => Condition_Code_ID_RR
    );

    Flags_modified_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_ID_RR, enable => enable_ID_RR, data_in => Flags_modified_IF_ID, data_out => Flags_modified_ID_RR
    );
end architecture Structural;