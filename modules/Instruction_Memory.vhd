library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity Instruction_Memory is
    generic (
        Instruction_memory_locations : integer := 65536;
        Instruction_length : integer := 16
    );
    port (
        Instruction_memory_address : in std_logic_vector(integer(ceil(log2(real(Instruction_memory_locations))))-1 downto 0);
        -- Instruction_memory_data_out : out std_logic_vector(Instruction_length-1 downto 0) := (others => '0')
        Instruction_memory_data_out : out std_logic_vector(Instruction_length-1 downto 0) := "0110000000000000"
    );
end entity;

architecture Behavioral of Instruction_Memory is
    type ROM is array(0 to Instruction_memory_locations-1) of std_logic_vector(Instruction_length-1 downto 0);
    signal Instruction_ROM : ROM := (others => (others => '0'));
begin
    Instruction_ROM(0) <= "0011000000000000"; -- LHI R0,#000000000
    Instruction_ROM(1) <= "0011001000000001"; -- LHI R1,#000000001
    Instruction_ROM(2) <= "0011010000000001"; -- LHI R2,#000000001
    Instruction_ROM(3) <= "0011011000000001"; -- LHI R3,#000000001
    Instruction_ROM(4) <= "0011100000000001"; -- LHI R4,#000000001
    Instruction_ROM(5) <= "0011101000000001"; -- LHI R5,#000000001
    Instruction_ROM(6) <= "0011110000000001"; -- LHI R6,#000000001

    Instruction_ROM(7) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(8) <= "1000001010000110"; -- BEQ R1,R2,#6
    Instruction_ROM(9) <= "0001001010100000"; -- ADD R4=R1+R2
    Instruction_ROM(10) <= "0001000000101001"; -- ADZ R5=R0+R0
    Instruction_ROM(11) <= "0001011010011000"; -- ADD R3=R3+R2
    Instruction_ROM(12) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(13) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(14) <= "0001001011110011"; -- ADL R6=R1+R3<<1
    Instruction_ROM(15) <= "0001011010011000"; -- ADD R3=R3+R2
    Instruction_ROM(16) <= "0000100010011011"; -- ADI R2=R4+SE(011011)

    Instruction_ROM(17) <= "0010001010011000"; -- NDU R3=R1 NAND R2

    Instruction_ROM(18) <= "0101110000011001"; -- SW M[R0+SE(011001)]=R6
    Instruction_ROM(19) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(20) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(21) <= "0100001000011001"; -- LW R1=M[R0+SE(011001)]

    Instruction_ROM(22) <= "1001001000000110"; -- JAL R1,#6
    Instruction_ROM(23) <= "0001001010100000"; -- ADD R4=R1+R2
    Instruction_ROM(24) <= "0001000000101001"; -- ADZ R5=R0+R0
    Instruction_ROM(25) <= "0001011010011000"; -- ADD R3=R3+R2
    Instruction_ROM(26) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(27) <= "0001001010011000"; -- ADD R3=R1+R2
    Instruction_ROM(28) <= "0001010011110011"; -- ADL R6=R2+R3<<1

    Instruction_ROM(29) <= "1010001100000000"; -- JLR R1,R4
    Instruction_ROM(30) <= "0001001010100000"; -- ADD R4=R1+R2
    Instruction_ROM(31) <= "0001000000101001"; -- ADZ R5=R0+R0

    Instruction_ROM(128) <= "0001001010100000"; -- ADD R4=R1+R2
    Instruction_ROM(129) <= "0001001011110011"; -- ADL R6=R1+R3<<1
    
    process (Instruction_memory_address, Instruction_ROM) begin
        Instruction_memory_data_out <= Instruction_ROM(to_integer(unsigned(Instruction_memory_address)));
    end process;
end architecture;