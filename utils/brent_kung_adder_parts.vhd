library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AND_2 is
    port (
        A, B : in std_logic;
        Y : out std_logic
    );
end entity AND_2;

architecture dataflow of AND_2 is
begin
    Y <= A and B;  
end architecture dataflow;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_2 is
    port (
        A, B : in std_logic;
        Y : out std_logic
    );
end entity XOR_2;

architecture dataflow of XOR_2 is
begin
    Y <= A xor B;  
end architecture dataflow;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity APLUSBC is
    port (
        A, B, C : in std_logic;
        Y : out std_logic
    );
end entity APLUSBC;

architecture dataflow of APLUSBC is
begin
    Y <= A or (B and C);  
end architecture dataflow;