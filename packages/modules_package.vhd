library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package modules_package is
    component Instruction_Memory is
        generic (
            Instruction_memory_locations : integer := 65536;
            Instruction_length : integer := 16
        );
        port (
            Instruction_memory_address : in std_logic_vector(integer(ceil(log2(real(Instruction_memory_locations))))-1 downto 0);
            -- Instruction_memory_data_out : out std_logic_vector(Instruction_length-1 downto 0) := (others => '0')
            Instruction_memory_data_out : out std_logic_vector(Instruction_length-1 downto 0) := "0110000000000000"
        );
    end component;

    component nbit_register is
        generic (
            N : integer
        );
        port (
            clk, clear, enable : in std_logic;
            data_in : in std_logic_vector(N-1 downto 0);
            data_out : out std_logic_vector(N-1 downto 0) := (others => '0')
        );
    end component;

    component Instruction_Fetch is
        port (
            clk : in std_logic;
            clear : in std_logic;
            PC_enable : in std_logic;
            PC_in : in std_logic_vector(15 downto 0);
            PC_plus_one : out std_logic_vector(15 downto 0) := (others => '0');
            PC_out : out std_logic_vector(15 downto 0) := (others => '0');
            -- Instruction_Register : out std_logic_vector(15 downto 0) := (others => '0')
            Instruction_Register : out std_logic_vector(15 downto 0) := "0110000000000000"
        );
    end component;

    component IF_ID is
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
    end component;

    component Instruction_Decode is
        port (
            Instruction_Register : in std_logic_vector(15 downto 0);
            regsource1, regsource2, regdest : out std_logic_vector(2 downto 0) := (others => 'X');
            alu_operation : out std_logic_vector(1 downto 0) := (others => 'X'); -- 00 for AND, 01 for NAND
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
    end component Instruction_Decode;

    component sign_extend_immediate is
        port (
            Instruction_Register : in std_logic_vector(15 downto 0);
            sign_extend_6_or_9_bit_immediate : in std_logic; -- 0 for 6bit sign extend, 1 for 9bit sign extend
            sign_extended_immediate_data : out std_logic_vector(15 downto 0) := (others => '0')
        );
    end component sign_extend_immediate;

    component ID_RR is
        port (
            clk : in std_logic;
            clear_ID_RR : in std_logic;
            enable_ID_RR : in std_logic;
            PC_IF_ID : in std_logic_vector(15 downto 0);
            PC_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
            PC_plus_one_IF_ID : in std_logic_vector(15 downto 0);
            PC_plus_one_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
            Opcode_IF_ID : in std_logic_vector(3 downto 0);
            Opcode_ID_RR : out std_logic_vector(3 downto 0) := (others => '0');
            RegSource1_IF_ID, RegSource2_IF_ID, RegDest_IF_ID : in std_logic_vector(2 downto 0);
            RegSource1_ID_RR, RegSource2_ID_RR, RegDest_ID_RR : out std_logic_vector(2 downto 0) := (others => 'X');
            ALU_operation_IF_ID : in std_logic_vector(1 downto 0);
            ALU_operation_ID_RR : out std_logic_vector(1 downto 0) := (others => 'X');
            Reg_WB_IF_ID : in std_logic_vector(0 downto 0);
            Reg_WB_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            Load0_Store1_IF_ID : in std_logic_vector(0 downto 0);
            Load0_Store1_ID_RR : out std_logic_vector(0 downto 0) := (others => 'X');
            SE_immediate_Opr2_IF_ID : in std_logic_vector(0 downto 0);
            SE_immediate_Opr2_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            SE_immediate_IF_ID : in std_logic_vector(15 downto 0);
            SE_immediate_ID_RR : out std_logic_vector(15 downto 0) := (others => '0');
            Left_Shift_RegB_IF_ID : in std_logic_vector(0 downto 0);
            Left_Shift_RegB_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            LHI_Instr_IF_ID : in std_logic_vector(0 downto 0);
            LHI_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            JAL_Instr_IF_ID : in std_logic_vector(0 downto 0);
            JAL_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            JLR_Instr_IF_ID : in std_logic_vector(0 downto 0);
            JLR_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            JRI_Instr_IF_ID : in std_logic_vector(0 downto 0);
            JRI_Instr_ID_RR : out std_logic_vector(0 downto 0) := (others => '0');
            Condition_Code_IF_ID : in std_logic_vector(1 downto 0);
            Condition_Code_ID_RR : out std_logic_vector(1 downto 0) := (others => 'X');
            Flags_modified_IF_ID : in std_logic_vector(1 downto 0); 
            Flags_modified_ID_RR : out std_logic_vector(1 downto 0) := (others => '0')
        );
    end component;

    component Register_Read is
        port (
            clk : in std_logic;
            clear : in std_logic;
            read_reg1, read_reg2 : in std_logic_vector(2 downto 0);
            register_writeback : in std_logic_vector(0 downto 0);
            R7_enable : in std_logic;
            write_reg : in std_logic_vector(2 downto 0);
            read_data1, read_data2 : out std_logic_vector(15 downto 0) := (others => '0');
            PC : in std_logic_vector(15 downto 0);
            write_data : in std_logic_vector(15 downto 0);
            R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(15 downto 0)
        );
    end component Register_Read;

    component Register_File is
        port (
            read_reg1, read_reg2 : in std_logic_vector(2 downto 0);
            read_data1, read_data2 : out std_logic_vector(15 downto 0) := (others => '0');
            R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(15 downto 0)
            );
    end component Register_File;

    component RR_EX is
        port (
            clk : in std_logic;
            clear_RR_EX : in std_logic;
            enable_RR_EX : in std_logic;
            PC_ID_RR : in std_logic_vector(15 downto 0);
            PC_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
            PC_plus_one_ID_RR : in std_logic_vector(15 downto 0);
            PC_plus_one_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
            Opcode_ID_RR : in std_logic_vector(3 downto 0);
            Opcode_RR_EX : out std_logic_vector(3 downto 0) := (others => '0');
            RegSource1_Data_ID_RR, RegSource2_Data_ID_RR : in std_logic_vector(15 downto 0);
            RegSource1_Data_RR_EX, RegSource2_Data_RR_EX : out std_logic_vector(15 downto 0) := (others => 'X');
            RegDest_ID_RR : in std_logic_vector(2 downto 0);
            RegDest_RR_EX : out std_logic_vector(2 downto 0) := (others => 'X');
            ALU_operation_ID_RR : in std_logic_vector(1 downto 0);
            ALU_operation_RR_EX : out std_logic_vector(1 downto 0) := (others => 'X');
            Reg_WB_ID_RR : in std_logic_vector(0 downto 0);
            Reg_WB_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            Load0_Store1_ID_RR : in std_logic_vector(0 downto 0);
            Load0_Store1_RR_EX : out std_logic_vector(0 downto 0) := (others => 'X');
            SE_immediate_Opr2_ID_RR : in std_logic_vector(0 downto 0);
            SE_immediate_Opr2_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            SE_immediate_ID_RR : in std_logic_vector(15 downto 0);
            SE_immediate_RR_EX : out std_logic_vector(15 downto 0) := (others => '0');
            Left_Shift_RegB_ID_RR : in std_logic_vector(0 downto 0);
            Left_Shift_RegB_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            LHI_Instr_ID_RR : in std_logic_vector(0 downto 0);
            LHI_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            JAL_Instr_ID_RR : in std_logic_vector(0 downto 0);
            JAL_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            JLR_Instr_ID_RR : in std_logic_vector(0 downto 0);
            JLR_Instr_RR_EX : out std_logic_vector(0 downto 0) := (others => '0');
            Condition_Code_ID_RR : in std_logic_vector(1 downto 0);
            Condition_Code_RR_EX : out std_logic_vector(1 downto 0) := (others => 'X');
            Flags_modified_ID_RR : in std_logic_vector(1 downto 0); 
            Flags_modified_RR_EX : out std_logic_vector(1 downto 0) := (others => '0')
        );
    end component;

    component brent_kung_16bit_adder is
        port (
            A : in std_logic_vector(15 downto 0);
            B : in std_logic_vector(15 downto 0);
            Cin : in std_logic;
            Sum : out std_logic_vector(15 downto 0);
            Carry : buffer std_logic_vector(16 downto 0)
        );
    end component brent_kung_16bit_adder;

    component Execute is
        port (
            A : in std_logic_vector(15 downto 0);
            B : in std_logic_vector(15 downto 0);
            Cin : in std_logic;
            ALU_operation : in std_logic_vector(1 downto 0);
            Output : out std_logic_vector(15 downto 0);
            ALU_output_flags : out std_logic_vector(1 downto 0) -- ALU_output_flags(1) = CY, ALU_output_flags(0) = Z 
        );
    end component Execute;

    component EX_MA is
        port (
            clk : in std_logic;
            clear_EX_MA : in std_logic;
            enable_EX_MA : in std_logic;
            PC_RR_EX : in std_logic_vector(15 downto 0);
            PC_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
            PC_plus_one_RR_EX : in std_logic_vector(15 downto 0);
            PC_plus_one_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
            Opcode_RR_EX : in std_logic_vector(3 downto 0);
            Opcode_EX_MA : out std_logic_vector(3 downto 0) := (others => '0');
            RegSource1_Data_RR_EX, RegSource2_Data_RR_EX : in std_logic_vector(15 downto 0);
            RegSource1_Data_EX_MA, RegSource2_Data_EX_MA : out std_logic_vector(15 downto 0) := (others => 'X');
            RegDest_RR_EX : in std_logic_vector(2 downto 0);
            RegDest_EX_MA : out std_logic_vector(2 downto 0) := (others => 'X');
            Reg_WB_RR_EX : in std_logic_vector(0 downto 0);
            Reg_WB_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
            ALU_output_RR_EX : in std_logic_vector(15 downto 0);
            ALU_output_EX_MA : out std_logic_vector(15 downto 0) := (others => '0');
            ALU_output_flags_RR_EX : in std_logic_vector(1 downto 0);
            ALU_output_flags_EX_MA : out std_logic_vector(1 downto 0) := (others => '0');
            Load0_Store1_RR_EX : in std_logic_vector(0 downto 0);
            Load0_Store1_EX_MA : out std_logic_vector(0 downto 0) := (others => 'X');
            LHI_Instr_RR_EX : in std_logic_vector(0 downto 0);
            LHI_Instr_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
            JAL_Instr_RR_EX : in std_logic_vector(0 downto 0);
            JAL_Instr_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
            JLR_Instr_RR_EX : in std_logic_vector(0 downto 0);
            JLR_Instr_EX_MA : out std_logic_vector(0 downto 0) := (others => '0');
            LHI_instr_WB_data_RR_EX : in std_logic_vector(15 downto 0);
            LHI_instr_WB_data_EX_MA : out std_logic_vector(15 downto 0) := (others => 'X');
            Condition_Code_RR_EX : in std_logic_vector(1 downto 0);
            Condition_Code_EX_MA : out std_logic_vector(1 downto 0) := (others => 'X');
            Flags_modified_RR_EX : in std_logic_vector(1 downto 0); 
            Flags_modified_EX_MA : out std_logic_vector(1 downto 0) := (others => '0')
        );
    end component;

    component Data_Memory is
        generic (
            data_memory_locations : integer := 256;
            data_length : integer := 16
        );
        port (
            clk : in std_logic;
            clear : in std_logic;
            read_enable : in std_logic;
            write_enable : in std_logic;
            -- Data_memory_address : in std_logic_vector(integer(ceil(log2(real(data_memory_locations))))-1 downto 0);
            Data_memory_address : in std_logic_vector(data_length-1 downto 0);
            Data_memory_data_in : in std_logic_vector(data_length-1 downto 0);
            Data_memory_data_out : out std_logic_vector(data_length-1 downto 0)
        );
    end component;

    component MA_WB is
        port (
            clk : in std_logic;
            clear_MA_WB : in std_logic;
            enable_MA_WB : in std_logic;
            PC_EX_MA : in std_logic_vector(15 downto 0);
            PC_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
            PC_plus_one_EX_MA : in std_logic_vector(15 downto 0);
            PC_plus_one_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
            Opcode_EX_MA : in std_logic_vector(3 downto 0);
            Opcode_MA_WB : out std_logic_vector(3 downto 0) := (others => '0');
            RegDest_EX_MA : in std_logic_vector(2 downto 0);
            RegDest_MA_WB : out std_logic_vector(2 downto 0) := (others => 'X');
            Reg_WB_EX_MA : in std_logic_vector(0 downto 0);
            Reg_WB_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
            Load0_Store1_EX_MA : in std_logic_vector(0 downto 0);
            Load0_Store1_MA_WB : out std_logic_vector(0 downto 0) := (others => 'X');
            ALU_output_EX_MA : in std_logic_vector(15 downto 0);
            ALU_output_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
            Data_memory_data_out_EX_MA : in std_logic_vector(15 downto 0);
            Data_memory_data_out_MA_WB : out std_logic_vector(15 downto 0) := (others => '0');
            ALU_output_flags_EX_MA : in std_logic_vector(1 downto 0);
            ALU_output_flags_MA_WB : out std_logic_vector(1 downto 0) := (others => '0');
            LHI_Instr_EX_MA : in std_logic_vector(0 downto 0);
            LHI_Instr_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
            JAL_Instr_EX_MA : in std_logic_vector(0 downto 0);
            JAL_Instr_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
            JLR_Instr_EX_MA : in std_logic_vector(0 downto 0);
            JLR_Instr_MA_WB : out std_logic_vector(0 downto 0) := (others => '0');
            LHI_instr_WB_data_EX_MA : in std_logic_vector(15 downto 0);
            LHI_instr_WB_data_MA_WB : out std_logic_vector(15 downto 0) := (others => 'X');
            Condition_Code_EX_MA : in std_logic_vector(1 downto 0);
            Condition_Code_MA_WB : out std_logic_vector(1 downto 0) := (others => 'X');
            Flags_modified_EX_MA : in std_logic_vector(1 downto 0); 
            Flags_modified_MA_WB : out std_logic_vector(1 downto 0) := (others => '0')
        );
    end component;

    component Conditional_Arith_Instr_WB is
        port (
            Opcode : in std_logic_vector(3 downto 0);
            Condition_Code : in std_logic_vector(1 downto 0);
            ALU_output_flags : in std_logic_vector(1 downto 0);
            Reg_WB : in std_logic_vector(0 downto 0);
            Reg_WB_Enable : out std_logic_vector(0 downto 0) := (others => '0')
        );
    end component Conditional_Arith_Instr_WB;
end package modules_package;