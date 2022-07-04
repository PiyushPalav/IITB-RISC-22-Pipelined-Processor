library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity MA_WB is
    port (
        clk : in std_logic;
        clear_MA_WB : in std_logic;
        enable_MA_WB : in std_logic;
        PC_EX_MA : in std_logic_vector(15 downto 0);
        PC_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
        PC_plus_one_EX_MA : in std_logic_vector(15 downto 0);
        PC_plus_one_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
        Opcode_EX_MA : in std_logic_vector(3 downto 0);
        Opcode_MA_WB : out std_logic_vector(3 downto 0) := (others => '0');
        RegDest_EX_MA : in std_logic_vector(2 downto 0);
        RegDest_MA_WB : out std_logic_vector(2 downto 0) := (others => 'X');
        Reg_WB_EX_MA : in std_logic_vector(0 downto 0);
        Reg_WB_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
        Load0_Store1_EX_MA : in std_logic_vector(0 downto 0);
        Load0_Store1_MA_WB : out std_logic_vector(0 downto 0) := (others => 'X');
        ALU_output_EX_MA : in std_logic_vector(15 downto 0);
        ALU_output_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
        Data_memory_data_out_EX_MA : in std_logic_vector(15 downto 0);
        Data_memory_data_out_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
        ALU_output_flags_EX_MA : in std_logic_vector(1 downto 0);
        ALU_output_flags_MA_WB : out std_logic_vector(1 downto 0) := (others => '0');
        LHI_Instr_EX_MA : in std_logic_vector(0 downto 0);
        LHI_Instr_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
        LHI_instr_WB_data_EX_MA : in std_logic_vector(15 downto 0);
        LHI_instr_WB_data_MA_WB : out std_logic_vector(15 downto 0) := (others => 'X');
        Condition_Code_EX_MA : in std_logic_vector(1 downto 0);
        Condition_Code_MA_WB : out std_logic_vector(1 downto 0) := (others => 'X');
        Flags_modified_EX_MA : in std_logic_vector(1 downto 0); 
        Flags_modified_MA_WB : out std_logic_vector(1 downto 0) := (others => '0')
    );
end entity;

architecture Structural of MA_WB is
begin
    PC_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => PC_EX_MA, data_out => PC_MA_WB
    );

    PC_plus_one_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => PC_plus_one_EX_MA, data_out => PC_plus_one_MA_WB
    );

    Opcode_reg : nbit_register generic map (N => 4) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Opcode_EX_MA, data_out => Opcode_MA_WB
    );

    RegDest_reg : nbit_register generic map (N => 3) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => RegDest_EX_MA, data_out => RegDest_MA_WB
    );

    RegWB_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Reg_WB_EX_MA, data_out => Reg_WB_MA_WB
    );
    
    Load0_Store1_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Load0_Store1_EX_MA, data_out => Load0_Store1_MA_WB
    );

    ALUOutput_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => ALU_output_EX_MA, data_out => ALU_output_MA_WB
    );

    DataMemOutput_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Data_memory_data_out_EX_MA, data_out => Data_memory_data_out_MA_WB
    );

    ALUOutputFlags_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => ALU_output_flags_EX_MA, data_out => ALU_output_flags_MA_WB
    );

    LHIInstr_reg : nbit_register generic map (N => 1) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => LHI_Instr_EX_MA, data_out => LHI_Instr_MA_WB
    );

    LHIInstrWBData_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => LHI_instr_WB_data_EX_MA, data_out => LHI_instr_WB_data_MA_WB
    );

    Condition_Code_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Condition_Code_EX_MA, data_out => Condition_Code_MA_WB
    );

    Flags_modified_reg : nbit_register generic map (N => 2) port map (
        clk => clk, clear => clear_MA_WB, enable => enable_MA_WB, data_in => Flags_modified_EX_MA, data_out => Flags_modified_MA_WB
    );
end architecture Structural;