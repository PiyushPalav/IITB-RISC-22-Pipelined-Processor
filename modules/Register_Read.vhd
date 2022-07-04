library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.modules_package.all;

entity Register_Read is
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
end entity Register_Read;

architecture Structural of Register_Read is
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
    signal write_reg_enable : std_logic_vector(7 downto 0) := (others => 'X');
begin
    read_data1 <= register_array(to_integer(unsigned(read_reg1)));
    read_data2 <= register_array(to_integer(unsigned(read_reg2)));

    process(write_reg, register_writeback)
    begin
        write_reg_enable <= (others => '0');
        case register_writeback is
            when "1" => write_reg_enable(to_integer(unsigned(write_reg))) <= '1';
            when others => write_reg_enable(to_integer(unsigned(write_reg))) <= '0';
        end case;
    end process;

    register_file : for i in 0 to 6 generate
        Reg: nbit_register
			generic map(N => 16)
			port map(clk => clk, clear => clear, enable => write_reg_enable(i), 
				data_in => write_data, data_out => register_array(i));
	end generate register_file;

    R7_reg : nbit_register generic map(N => 16) port map(
        clk => clk, clear => clear, enable => R7_enable,
        data_in => PC, data_out => register_array(7)
    );
    
    R0 <= register_array(0);
    R1 <= register_array(1);
    R2 <= register_array(2);
    R3 <= register_array(3);
    R4 <= register_array(4);
    R5 <= register_array(5);
    R6 <= register_array(6);
    R7 <= register_array(7);
end architecture Structural;