library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nbit_register is
    generic (
        N : integer := 8
    );
    port (
        clk, clear, enable : in std_logic;
        data_in : in std_logic_vector(N-1 downto 0);
        data_out : out std_logic_vector(N-1 downto 0) := (others => '0')
    );
end entity;

architecture Behavioral of nbit_register is
begin
    process (clk, clear)
    begin
        if (clk'event and clk='1') then
            if (clear='1') then
                data_out <= (others => '0');
            end if;
            if (enable='1') then
                data_out <= data_in;
            end if;
        end if;
    end process;
end architecture;