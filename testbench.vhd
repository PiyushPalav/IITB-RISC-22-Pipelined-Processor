library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity testbench is
end entity;

architecture test of testbench is
    component IITB_RISC_Pipelined_Processor is
        port (
            clk : in std_logic;
            clear : in std_logic;
            R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(15 downto 0);
            Carry_flag : out std_logic_vector(0 downto 0);
            Zero_flag : out std_logic_vector(0 downto 0)
            -- Data_memory_data_out : out std_logic_vector(15 downto 0) := (others => 'X')
        );
    end component IITB_RISC_Pipelined_Processor;

    signal clk_test : std_logic;
    signal R0_test, R1_test, R2_test, R3_test, R4_test, R5_test, R6_test, R7_test : std_logic_vector(15 downto 0);
    signal Carry_flag_test : std_logic_vector(0 downto 0);
    signal Zero_flag_test : std_logic_vector(0 downto 0);
    -- signal Data_memory_data_out_test : std_logic_vector(15 downto 0) := (others => '0');
begin
    dut : IITB_RISC_Pipelined_Processor port map (
        clk_test, '0', R0_test, R1_test, R2_test, R3_test, R4_test, R5_test, R6_test, R7_test, Carry_flag_test, Zero_flag_test
    );

    process
    begin
        clk_test <= '0';
        wait for 50 ns;
        clk_test <= '1';
        wait for 50 ns;
    end process;

end architecture;