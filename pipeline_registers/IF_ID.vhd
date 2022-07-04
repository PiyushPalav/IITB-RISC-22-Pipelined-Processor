library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity IF_ID is
    port (
        clk : in std_logic;
        clear_IF_ID : in std_logic;
        enable_IF_ID : in std_logic;
        PC_out : in std_logic_vector(15 downto 0);
        PC_IF_ID : out std_logic_vector(15 downto 0) := (others => '0');
        PC_plus_one : in std_logic_vector(15 downto 0);
        PC_plus_one_IF_ID : out std_logic_vector(15 downto 0) := (others => '0');
        Instruction_Register : in std_logic_vector(15 downto 0);
        Instruction_Register_IF_ID : out std_logic_vector(15 downto 0) := (others => '0')
    );
end entity;

architecture Structural of IF_ID is
begin
    PC_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_IF_ID, enable => enable_IF_ID, data_in => PC_out, data_out => PC_IF_ID
    );

    PC_plus_one_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_IF_ID, enable => enable_IF_ID, data_in => PC_plus_one, data_out => PC_plus_one_IF_ID
    );

    Instruction_Register_reg : nbit_register generic map (N => 16) port map (
        clk => clk, clear => clear_IF_ID, enable => enable_IF_ID, data_in => Instruction_Register, data_out => Instruction_Register_IF_ID
    );
end architecture Structural;