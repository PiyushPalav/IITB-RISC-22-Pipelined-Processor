library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity EX_MA is
    port (
        clk : in std_logic;
        clear_EX_MA : in std_logic;
        enable_EX_MA : in std_logic;
        PC_RR_EX : in std_logic_vector(15 downto 0);
        PC_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
        PC_plus_one_RR_EX : in std_logic_vector(15 downto 0);
        PC_plus_one_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
        Opcode_RR_EX : in std_logic_vector(3 downto 0);
        Opcode_EX_MA : out std_logic_vector(3 downto 0) := (others => '0');
        RegSource1_Data_RR_EX, RegSource2_Data_RR_EX : in std_logic_vector(15 downto 0);
        RegSource1_Data_EX_MA, RegSource2_Data_EX_MA : out std_logic_vector(15 downto 0) := (others => 'X');
        RegDest_RR_EX : in std_logic_vector(2 downto 0);
        RegDest_EX_MA : out std_logic_vector(2 downto 0) := (others => 'X');
        Reg_WB_RR_EX : in std_logic_vector(0 downto 0);
        Reg_WB_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
        ALU_output_RR_EX : in std_logic_vector(15 downto 0);
        ALU_output_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
        ALU_output_flags_RR_EX : in std_logic_vector(1 downto 0);
        ALU_output_flags_EX_MA : out std_logic_vector(1 downto 0) := (others => '0');
        Load0_Store1_RR_EX : in std_logic_vector(0 downto 0);
        Load0_Store1_EX_MA : out std_logic_vector(0 downto 0) := (others => 'X');
        LHI_Instr_RR_EX : in std_logic_vector(0 downto 0);
        LHI_Instr_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
        LHI_instr_WB_data_RR_EX : in std_logic_vector(15 downto 0);
        LHI_instr_WB_data_EX_MA : out std_logic_vector(15 downto 0) := (others => 'X');
        Condition_Code_RR_EX : in std_logic_vector(1 downto 0);
        Condition_Code_EX_MA : out std_logic_vector(1 downto 0) := (others => 'X');
        Flags_modified_RR_EX : in std_logic_vector(1 downto 0); 
        Flags_modified_EX_MA : out std_logic_vector(1 downto 0) := (others => '0')
    );
end entity;

architecture Structural of EX_MA is
begin
    PC_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => PC_RR_EX, data_out => PC_EX_MA
    );

    PC_plus_one_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => PC_plus_one_RR_EX, data_out => PC_plus_one_EX_MA
    );

    Opcode_reg : nbit_register generic map (N => 4) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => Opcode_RR_EX, data_out => Opcode_EX_MA
    );
    
    RegSource1Data_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => RegSource1_Data_RR_EX, data_out => RegSource1_Data_EX_MA
    );

    RegSource2Data_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => RegSource2_Data_RR_EX, data_out => RegSource2_Data_EX_MA
    );

    RegDest_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => RegDest_RR_EX, data_out => RegDest_EX_MA
    );

    RegWB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => Reg_WB_RR_EX, data_out => Reg_WB_EX_MA
    );

    ALUOutput_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => ALU_output_RR_EX, data_out => ALU_output_EX_MA
    );

    ALUOutputFlags_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => ALU_output_flags_RR_EX, data_out => ALU_output_flags_EX_MA
    );

    Load0_Store1_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => Load0_Store1_RR_EX, data_out => Load0_Store1_EX_MA
    );
    
    LHIInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => LHI_Instr_RR_EX, data_out => LHI_Instr_EX_MA
    );

    LHIInstrWBData_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => LHI_instr_WB_data_RR_EX, data_out => LHI_instr_WB_data_EX_MA
    );

    Condition_Code_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => Condition_Code_RR_EX, data_out => Condition_Code_EX_MA
    );

    Flags_modified_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_EX_MA, enable => enable_EX_MA, data_in => Flags_modified_RR_EX, data_out => Flags_modified_EX_MA
    );
end architecture Structural;