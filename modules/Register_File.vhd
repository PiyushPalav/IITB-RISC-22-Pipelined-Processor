library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Register_File is
    port (
        read_reg1, read_reg2 : in std_logic_vector(2 downto 0);
        read_data1, read_data2 : out std_logic_vector(15 downto 0) := (others => '0');
        R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(15 downto 0)
        );
end entity Register_File;

architecture Structural of Register_File is
    type reg_array is array(0 to 7) of std_logic_vector (15 downto 0);
    signal register_array : reg_array := (
        "0000000000000000",
        "0000000000000001",
        "0000000000000010",
        "0000000000000011",
        "0000000000000100",
        "0000000000000101",
        "0000000000000110",
        "0000000000000111"
    );
begin
    read_data1 <= register_array(to_integer(unsigned(read_reg1)));
    read_data2 <= register_array(to_integer(unsigned(read_reg2)));
    R0 <= register_array(0);
	R1 <= register_array(1);
	R2 <= register_array(2);
	R3 <= register_array(3);
	R4 <= register_array(4);
	R5 <= register_array(5);
	R6 <= register_array(6);
    R7 <= register_array(7);
end architecture Structural;