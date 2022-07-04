library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Conditional_Arith_Instr_WB is
    port (
        Opcode : in std_logic_vector(3 downto 0);
        Condition_Code : in std_logic_vector(1 downto 0);
        ALU_output_flags : in std_logic_vector(1 downto 0);
        Reg_WB : in std_logic_vector(0 downto 0);
        Reg_WB_Enable : out std_logic_vector(0 downto 0) := (others => '0')
    );
end entity Conditional_Arith_Instr_WB;

architecture Behavioral of Conditional_Arith_Instr_WB is
begin
    process(Opcode, Condition_Code, ALU_output_flags, Reg_WB)
    begin
        case Opcode is
            when "0001" =>
                case Condition_Code is
                    when "01" => 
                        if (ALU_output_flags(1 downto 1)="1") then
                            Reg_WB_Enable <= "1";
                        else
                            Reg_WB_Enable <= "0";
                        end if;
                    when "10" => 
                        if (ALU_output_flags(0 downto 0)="1") then
                            Reg_WB_Enable <= "1";
                        else
                            Reg_WB_Enable <= "0";
                        end if;                
                    when others => Reg_WB_Enable <= Reg_WB;
                end case;
            when "0010" =>
                case Condition_Code is
                    when "01" => 
                        if (ALU_output_flags(1 downto 1)="1") then
                            Reg_WB_Enable <= "1";
                        else
                            Reg_WB_Enable <= "0";
                        end if;
                    when "10" => 
                        if (ALU_output_flags(0 downto 0)="1") then
                            Reg_WB_Enable <= "1";
                        else
                            Reg_WB_Enable <= "0";
                        end if;                
                    when others => Reg_WB_Enable <= Reg_WB;
                end case; 
            when others => Reg_WB_Enable <= Reg_WB;
        end case;
    end process;
end architecture Behavioral;