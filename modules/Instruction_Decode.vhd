library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Instruction_Decode is
    port (
        Instruction_Register : in std_logic_vector(15 downto 0);
        regsource1, regsource2, regdest : out std_logic_vector(2 downto 0) := (others => 'X');
        alu_operation : out std_logic_vector(1 downto 0) := (others => 'X'); -- 00 for AND, 01 for NAND, 10 for compare
        register_writeback : out std_logic_vector(0 downto 0) := (others => 'X'); -- 0 for no writeback, 1 for register writeback
        load0_store1 : out std_logic_vector(0 downto 0) := (others => 'X'); -- 0 for load, 1 for store
        sign_extend_6_or_9_bit_immediate : out std_logic := 'X'; -- 0 for 6bit sign extend, 1 for 9bit sign extend
        sign_extend_immediate_opr2 : out std_logic_vector(0 downto 0):= (others => 'X');
        left_shift_registerB : out std_logic_vector(0 downto 0) := (others => '0'); -- '1' for ADL instruction
        is_instr_lhi : out std_logic_vector(0 downto 0) := (others => '0'); -- '1' for LHI instruction
        is_instr_jal : out std_logic_vector(0 downto 0) := (others => '0'); -- '1' for JAL instruction
        is_instr_jlr : out std_logic_vector(0 downto 0) := (others => '0'); -- '1' for JLR instruction
        is_instr_jri : out std_logic_vector(0 downto 0) := (others => '0'); -- '1' for JRI instruction
        condition_code : out std_logic_vector(1 downto 0) := (others => 'X'); -- 00 if no flag needs to be set, 01 if CY, 10 if Z flag needs to be set  
        flags_modified : out std_logic_vector(1 downto 0) := (others => '0') -- 00 for no flags modified, 01 if CY, 10 if Z, 11 if both flags modified
    );
end entity Instruction_Decode;

architecture Behavioral of Instruction_Decode is
    signal RA, RB, RC : std_logic_vector(2 downto 0);
begin
    process(Instruction_Register, RA, RB, RC) begin
        RA <= Instruction_Register(11 downto 9);
        RB <= Instruction_Register(8 downto 6);
        RC <= Instruction_Register(5 downto 3);

        case Instruction_Register(15 downto 12) is
            when "0001" =>              -- ADD, ADC, ADZ
                regsource1 <= RA;
                regsource2 <= RB;
                regdest <= RC;
                alu_operation <= "00";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= 'X';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= Instruction_Register(1 downto 0);
                flags_modified <= "11";
                if (Instruction_Register(1 downto 0) = "11") then   -- ADL
					left_shift_registerB <= (others => '1');
				end if;
            when "0110" =>              -- ADI
                regsource1 <= RA;
                regsource2 <= "XXX";
                regdest <= RB;
                alu_operation <= "00";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= '0';
                sign_extend_immediate_opr2 <= (others => '1');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "11";
            when "0010" =>              -- NDU, NDC, NDZ
                regsource1 <= RA;
                regsource2 <= RB;
                regdest <= RC;
                alu_operation <= "01";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= 'X';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= Instruction_Register(1 downto 0);
                flags_modified <= "10";
            when "0011" =>              -- LHI
                regsource1 <= "XXX";
                regsource2 <= "XXX";
                regdest <= RA;
                alu_operation <= "XX";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= '1';
                sign_extend_immediate_opr2 <= (others => '1');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '1');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "10";
            when "0100" =>              -- LW
                regsource1 <= RB;
                regsource2 <= "XXX";
                regdest <= RA;
                alu_operation <= "00";
                register_writeback <= (others => '1');
                load0_store1 <= (others => '0');
                sign_extend_6_or_9_bit_immediate <= '0';
                sign_extend_immediate_opr2 <= (others => '1');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "10";
            when "0101" =>              -- SW
                regsource1 <= RB;
                regsource2 <= RA;
                regdest <= "XXX";
                alu_operation <= "00";
                register_writeback <= (others => '0');
                load0_store1 <= (others => '1');
                sign_extend_6_or_9_bit_immediate <= '0';
                sign_extend_immediate_opr2 <= (others => '1');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "00";
            when "1000" =>              -- BEQ
                regsource1 <= RA;
                regsource2 <= RB;
                regdest <= "XXX";
                alu_operation <= "10";
                register_writeback <= (others => '0');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= '0';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "10";
            when "1001" =>              -- JAL
                regsource1 <= "XXX";
                regsource2 <= "XXX";
                regdest <= RA;
                alu_operation <= "XX";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= '1';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '1');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "00";
            when "1010" =>              -- JLR
                regsource1 <= RB;
                regsource2 <= "XXX";
                regdest <= RA;
                alu_operation <= "XX";
                register_writeback <= (others => '1');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= 'X';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '1');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "00";
            when "1011" =>              -- JRI
                regsource1 <= RA;
                regsource2 <= "XXX";
                regdest <= "XXX";
                alu_operation <= "XX";
                register_writeback <= (others => '0');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= '1';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '1');
                condition_code <= (others => 'X');
                flags_modified <= "00";
            when others =>
                regsource1 <= "XXX";
                regsource2 <= "XXX";
                regdest <= "XXX";
                alu_operation <= "XX";
                register_writeback <= (others => '0');
                load0_store1 <= (others => 'X');
                sign_extend_6_or_9_bit_immediate <= 'X';
                sign_extend_immediate_opr2 <= (others => '0');
                left_shift_registerB <= (others => '0');
                is_instr_lhi <= (others => '0');
                is_instr_jal <= (others => '0');
                is_instr_jlr <= (others => '0');
                is_instr_jri <= (others => '0');
                condition_code <= (others => 'X');
                flags_modified <= "00";
        end case;
    end process;
end architecture Behavioral;