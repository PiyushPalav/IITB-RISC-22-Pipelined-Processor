library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Execute is
    port (
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        Cin : in std_logic;
        ALU_operation : in std_logic_vector(1 downto 0);
        Output : out std_logic_vector(15 downto 0);
        ALU_output_flags : out std_logic_vector(1 downto 0) -- ALU_output_flags(1) = Z, ALU_output_flags(0) = CY
    );
end entity Execute;

architecture mixed_style of Execute is
    signal output_add : std_logic_vector(15 downto 0);
    signal output_signal : std_logic_vector(15 downto 0);
    signal carry : std_logic_vector(16 downto 0);

    signal Cout : std_logic;
    signal Zero : std_logic;
begin

    adder: brent_kung_16bit_adder port map(
        A => A, B => B, Cin => Cin, Sum => output_add, Carry => carry
    );

    Cout <= carry(16);

    process(A, B, ALU_operation, output_add)
    begin
        case ALU_operation is
            when "00" =>
                -- Output <= std_logic_vector(unsigned(A) + unsigned(B));
                output_signal <= output_add;
            when "01" =>
                output_signal <= A nand B;
            when others =>
                output_signal <= (others => 'X');
        end case;
    end process;

    Output <= output_signal;
    Zero <= '1' when (to_integer(unsigned(output_signal)) = 0) else '0';

    ALU_output_flags <= Zero & Cout;

end architecture mixed_style;