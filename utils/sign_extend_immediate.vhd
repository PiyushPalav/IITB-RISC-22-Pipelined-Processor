library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extend_immediate is
    port (
        Instruction_Register : in std_logic_vector(15 downto 0);
        sign_extend_6_or_9_bit_immediate : in std_logic; -- 0 for 6bit sign extend, 1 for 9bit sign extend
        sign_extended_immediate_data : out std_logic_vector(15 downto 0) := (others => '0')
    );
end entity sign_extend_immediate;

architecture Dataflow of sign_extend_immediate is
    signal sign_extended_6bit_immediate_data : std_logic_vector(15 downto 0) := (others => '0');
    signal sign_extended_9bit_immediate_data : std_logic_vector(15 downto 0) := (others => '0');
begin
    sign_extended_6bit_immediate_data <= (15 downto 6 => Instruction_Register(5)) & Instruction_Register(5 downto 0);
    sign_extended_9bit_immediate_data <= (15 downto 9 => Instruction_Register(8)) & Instruction_Register(8 downto 0);

    sign_extended_immediate_data <= sign_extended_6bit_immediate_data when sign_extend_6_or_9_bit_immediate ='0' else
        sign_extended_9bit_immediate_data when sign_extend_6_or_9_bit_immediate ='1' else
        (others => 'X');
    
end architecture Dataflow;