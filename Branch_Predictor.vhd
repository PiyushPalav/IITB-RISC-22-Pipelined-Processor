library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Branch_Predictor is
    port (
        clk : in std_logic;
        clear : in std_logic;
        PC : in std_logic_vector(15 downto 0);
        PC_update : in std_logic_vector(15 downto 0);
        BHT_Update : in std_logic;
        Branch_Direction : in std_logic;
        Branch_Target_Address_in : in std_logic_vector(15 downto 0);
        Branch_Target_Address_out : out std_logic_vector(15 downto 0);
        Prediction : out std_logic_vector(0 downto 0);
        HistoryBits : out std_logic_vector(1 downto 0);
        BHT_Hit : out boolean := false
    );
end entity;

architecture Behavioral of Branch_Predictor is
    constant bht_entries : integer := 8;
    type bht is record
        BIA : std_logic_vector(15 downto 0);
        BTA : std_logic_vector(15 downto 0);
        HB : std_logic_vector(1 downto 0);
        Pred : std_logic_vector(0 downto 0);
    end record bht;
    type bht_array is array(0 to bht_entries-1) of bht;
    signal Branch_History_Table : bht_array := (
        0 => (BIA => "0000000000000001",BTA => "0000000000000010",HB => (others => '0'),
        Pred => (others => '0')),
        1 => (BIA => "0000000000000010",BTA => "0000000000000011",HB => (others => '0'),
        Pred => (others => '0')),
		others => (BIA => "0000000000000011",BTA => "0000000000000100",
        HB => (others => '0'), Pred => (others => '0'))
    );
    signal Branch_History_Table_search_index : integer := 0;
    signal Branch_History_Table_update_index : integer := 0;
    signal HistoryBits_signal : std_logic_vector(1 downto 0) := (others => '0');
    signal BHT_Hit_signal : boolean;
    signal BHT_Update_entry_found : boolean;
    signal Update_BHT : std_logic;
    signal Prediction_signal : std_logic_vector(0 downto 0);
begin
    process (Branch_History_Table, PC) begin
        for i in Branch_History_Table'range loop
            if (Branch_History_Table(i).BIA = PC) then
                Branch_History_Table_search_index <= i;
                BHT_Hit_signal <= true;
                exit;
            else
                Branch_History_Table_search_index <= 0;
                BHT_Hit_signal <= false;
            end if;
        end loop;
    end process;

    Branch_Target_Address_out <= Branch_History_Table(Branch_History_Table_search_index).BTA
                        when (BHT_Hit_signal = true and
                        Branch_History_Table(Branch_History_Table_search_index).Pred = "1")
                        else std_logic_vector(unsigned(PC) + to_unsigned(1,16));
    BHT_Hit <= BHT_Hit_signal;
    -- HistoryBits <= HistoryBits_signal;

    process (Branch_History_Table, PC_update) begin
            for i in Branch_History_Table'range loop
                if (Branch_History_Table(i).BIA = PC_update) then
                    Branch_History_Table_update_index <= i;
                    BHT_Update_entry_found <= true;
                    exit;
                else
                    Branch_History_Table_update_index <= 0;
                    BHT_Update_entry_found <= false;
                end if;
            end loop;
    end process;

    process (BHT_Update, Branch_History_Table, Branch_History_Table_update_index,
        Branch_Direction)
    begin
            case (Branch_History_Table(Branch_History_Table_update_index).HB) is
                when "00" =>
                    if (Branch_Direction='0') then
                        HistoryBits_signal <= "00";
                        Prediction_signal <= "0";
                    elsif (Branch_Direction='1') then
                        HistoryBits_signal <= "01";
                        Prediction_signal <= "0";
                    else
                        HistoryBits_signal <= "XX";
                        Prediction_signal <= "0";
                    end if;
                when "01" =>
                    if (Branch_Direction='0') then
                        HistoryBits_signal <= "00";
                        Prediction_signal <= "0";
                    elsif (Branch_Direction='1') then
                        HistoryBits_signal <= "10";
                        Prediction_signal <= "1";
                    else
                        HistoryBits_signal <= "XX";
                        Prediction_signal <= "0";
                    end if;
                when "10" =>
                    if (Branch_Direction='0') then
                        HistoryBits_signal <= "01";
                        Prediction_signal <= "0";
                    elsif (Branch_Direction='1') then
                        HistoryBits_signal <= "11";
                        Prediction_signal <= "1";
                    else
                        HistoryBits_signal <= "XX";
                        Prediction_signal <= "0";
                    end if;
                when "11" =>
                    if (Branch_Direction='0') then
                        HistoryBits_signal <= "10";
                        Prediction_signal <= "1";
                    elsif (Branch_Direction='1') then
                        HistoryBits_signal <= "11";
                        Prediction_signal <= "1";
                    else
                        HistoryBits_signal <= "XX";
                        Prediction_signal <= "0";
                    end if;
                when others => 
                    HistoryBits_signal <= "XX";
                    Prediction_signal <= "0";
            end case;
    end process;

    Update_BHT <= '1' when (BHT_Update = '1' and BHT_Update_entry_found = true) else '0';

    process (clk, Update_BHT)
    begin
    if (clk'event and clk='1') then
    if (Update_BHT='1') then
    Branch_History_Table(Branch_History_Table_update_index).BIA <= PC_update;
    Branch_History_Table(Branch_History_Table_update_index).BTA <= Branch_Target_Address_in;
    Branch_History_Table(Branch_History_Table_update_index).HB <= HistoryBits_signal;
    Branch_History_Table(Branch_History_Table_update_index).Pred <= Prediction_signal;
    HistoryBits <= HistoryBits_signal;
    Prediction <= Prediction_signal;
    end if;
    end if;
    end process;
    
end architecture Behavioral;