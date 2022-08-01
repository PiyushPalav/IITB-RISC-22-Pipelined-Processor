library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity ForwardingUnit is
  port (
    RegSource1_ID_RR, RegSource2_ID_RR : in std_logic_vector(2 downto 0);
    Reg_WB_RR_EX : in std_logic_vector(0 downto 0);
    RegDest_RR_EX : in std_logic_vector(2 downto 0);
    LHI_Instr_RR_EX : in std_logic_vector(0 downto 0);
    JAL_Instr_RR_EX : in std_logic_vector(0 downto 0);
    JLR_Instr_RR_EX : in std_logic_vector(0 downto 0);
    LHI_instr_WB_data_RR_EX : in std_logic_vector(15 downto 0);
    PC_plus_one_RR_EX : in std_logic_vector(15 downto 0);
    ALU_output_RR_EX : in std_logic_vector(15 downto 0);
    Reg_WB_EX_MA : in std_logic_vector(0 downto 0);
    RegDest_EX_MA : in std_logic_vector(2 downto 0);
    LHI_Instr_EX_MA : in std_logic_vector(0 downto 0);
    JAL_Instr_EX_MA : in std_logic_vector(0 downto 0);
    JLR_Instr_EX_MA : in std_logic_vector(0 downto 0);
    LHI_instr_WB_data_EX_MA : in std_logic_vector(15 downto 0);
    PC_plus_one_EX_MA : in std_logic_vector(15 downto 0);
    ALU_output_EX_MA : in std_logic_vector(15 downto 0);
    Reg_WB_MA_WB : in std_logic_vector(0 downto 0);
    RegDest_MA_WB : in std_logic_vector(2 downto 0);
    LHI_Instr_MA_WB : in std_logic_vector(0 downto 0);
    JAL_Instr_MA_WB : in std_logic_vector(0 downto 0);
    JLR_Instr_MA_WB : in std_logic_vector(0 downto 0);
    Load0_Store1_MA_WB : in std_logic_vector(0 downto 0);
    LHI_instr_WB_data_MA_WB : in std_logic_vector(15 downto 0);
    PC_plus_one_MA_WB : in std_logic_vector(15 downto 0);
    ALU_output_MA_WB : in std_logic_vector(15 downto 0);
    Data_memory_data_out_MA_WB : in std_logic_vector(15 downto 0);
    Forward_Operand1_Data_Control : out std_logic;
    Forward_Operand2_Data_Control : out std_logic;
    Forwarded_Operand1_Data : out std_logic_vector(15 downto 0);
    Forwarded_Operand2_Data : out std_logic_vector(15 downto 0)
  );
end ForwardingUnit;

architecture dataflow of ForwardingUnit is
  signal forward_operand1_control : std_logic_vector(1 downto 0);
  signal forward_operand2_control : std_logic_vector(1 downto 0);
begin
  process(Reg_WB_RR_EX, RegDest_RR_EX, RegSource1_ID_RR, Reg_WB_EX_MA, RegDest_EX_MA, Reg_WB_MA_WB, RegDest_MA_WB)
  begin
    if ((Reg_WB_RR_EX = "1") and (RegDest_RR_EX = RegSource1_ID_RR) and (RegDest_RR_EX /= "111")) then
      Forward_Operand1_Data_Control <= '1';
      forward_operand1_control <= "01";
    elsif ((Reg_WB_EX_MA = "1") and (RegDest_EX_MA = RegSource1_ID_RR) and (RegDest_EX_MA /= "111")) then
      Forward_Operand1_Data_Control <= '1';
      forward_operand1_control <= "10";
    elsif ((Reg_WB_MA_WB = "1") and (RegDest_MA_WB = RegSource1_ID_RR) and (RegDest_MA_WB /= "111")) then
      Forward_Operand1_Data_Control <= '1';
      forward_operand1_control <= "11";
    else
      Forward_Operand1_Data_Control <= '0';
      forward_operand1_control <= (others => '0');
    end if ;
  end process;

  process(Reg_WB_RR_EX, RegDest_RR_EX, RegSource2_ID_RR, Reg_WB_EX_MA, RegDest_EX_MA, Reg_WB_MA_WB, RegDest_MA_WB)
  begin
    if ((Reg_WB_RR_EX = "1") and (RegDest_RR_EX = RegSource2_ID_RR) and (RegDest_RR_EX /= "111")) then
      Forward_Operand2_Data_Control <= '1';
      forward_operand2_control <= "01";
    elsif ((Reg_WB_EX_MA = "1") and (RegDest_EX_MA = RegSource2_ID_RR) and (RegDest_EX_MA /= "111")) then
      Forward_Operand2_Data_Control <= '1';
      forward_operand2_control <= "10";
    elsif ((Reg_WB_MA_WB = "1") and (RegDest_MA_WB = RegSource2_ID_RR) and (RegDest_MA_WB /= "111")) then
      Forward_Operand2_Data_Control <= '1';
      forward_operand2_control <= "11";
    else
      Forward_Operand2_Data_Control <= '0';
      forward_operand2_control <= (others => '0');
    end if ;
  end process;

Forwarded_Operand1_Data <= LHI_instr_WB_data_RR_EX when (LHI_Instr_RR_EX="1" and forward_operand1_control="01") else
                            PC_plus_one_RR_EX when (JAL_Instr_RR_EX="1" and forward_operand1_control="01") else
                            PC_plus_one_RR_EX when (JLR_Instr_RR_EX="1" and forward_operand1_control="01") else
                            ALU_output_RR_EX when forward_operand1_control="01" else
                            LHI_instr_WB_data_EX_MA when (LHI_Instr_EX_MA="1" and forward_operand1_control="10") else
                            PC_plus_one_EX_MA when (JAL_Instr_EX_MA="1" and forward_operand1_control="10") else
                            PC_plus_one_EX_MA when (JLR_Instr_EX_MA="1" and forward_operand1_control="10") else
                            ALU_output_EX_MA when forward_operand1_control="10" else
                            LHI_instr_WB_data_MA_WB when (LHI_Instr_MA_WB="1" and forward_operand1_control="11") else
                            PC_plus_one_MA_WB when (JAL_Instr_MA_WB="1" and forward_operand1_control="11") else
                            PC_plus_one_MA_WB when (JLR_Instr_MA_WB="1" and forward_operand1_control="11") else
                            Data_memory_data_out_MA_WB when (Load0_Store1_MA_WB="0" and forward_operand1_control="11") else
                            ALU_output_MA_WB when forward_operand1_control="11" else
									          (others => 'X');

Forwarded_Operand2_Data <= LHI_instr_WB_data_RR_EX when (LHI_Instr_RR_EX="1" and forward_operand2_control="01") else
                            PC_plus_one_RR_EX when (JAL_Instr_RR_EX="1" and forward_operand2_control="01") else
                            PC_plus_one_RR_EX when (JLR_Instr_RR_EX="1" and forward_operand2_control="01") else
                            ALU_output_RR_EX when forward_operand2_control="01" else
                            LHI_instr_WB_data_EX_MA when (LHI_Instr_EX_MA="1" and forward_operand2_control="10") else
                            PC_plus_one_EX_MA when (JAL_Instr_EX_MA="1" and forward_operand2_control="10") else
                            PC_plus_one_EX_MA when (JLR_Instr_EX_MA="1" and forward_operand2_control="10") else
                            ALU_output_EX_MA when forward_operand2_control="10" else
                            LHI_instr_WB_data_MA_WB when (LHI_Instr_MA_WB="1" and forward_operand2_control="11") else
                            PC_plus_one_MA_WB when (JAL_Instr_MA_WB="1" and forward_operand2_control="11") else
                            PC_plus_one_MA_WB when (JLR_Instr_MA_WB="1" and forward_operand2_control="11") else
                            Data_memory_data_out_MA_WB when (Load0_Store1_MA_WB="0" and forward_operand2_control="11") else
                            ALU_output_MA_WB when forward_operand2_control="11" else
									          (others => 'X');
end dataflow;