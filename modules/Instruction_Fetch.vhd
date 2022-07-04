library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- library work;
use work.modules_package.all;

entity Instruction_Fetch is
    port (
        clk : in std_logic;
        clear : in std_logic;
        PC_enable : in std_logic;
        PC_in : in std_logic_vector(15 downto 0);
        PC_plus_one : out std_logic_vector(15 downto 0) := (others => '0');
        PC_out : out std_logic_vector(15 downto 0) := (others => '0');
        -- Instruction_Register : out std_logic_vector(15 downto 0) := (others => '0')
        Instruction_Register : out std_logic_vector(15 downto 0) := "0110000000000000"
    );
end entity;

architecture Structural of Instruction_Fetch is
    signal PC_out_signal : std_logic_vector(15 downto 0) := (others => '0');
begin
    PC_plus_one <= std_logic_vector(unsigned(PC_out_signal) + to_unsigned(1,16));
    
    PC_out <= PC_out_signal;

    PC_reg : nbit_register generic map (N => 16)
        port map (clk => clk, clear => clear, enable => PC_enable, data_in => PC_in, data_out => PC_out_signal);

    Instruction_Mem : Instruction_Memory generic map (Instruction_memory_locations => 65536, Instruction_length => 16)
        port map(Instruction_memory_address => PC_out_signal, Instruction_memory_data_out => Instruction_Register);
end architecture;