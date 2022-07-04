library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.modules_package.all;

entity Data_Memory is
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
end entity;

architecture Behavioral of Data_Memory is
    type RAM is array(0 to data_memory_locations-1) of std_logic_vector(data_length-1 downto 0);
    signal Data_memory_RAM : RAM := (others => (others => '0'));
    signal write_en: std_logic_vector(data_memory_locations-1 downto 0);
    signal write_address: std_logic_vector(integer(ceil(log2(real(data_memory_locations))))-1 downto 0);
begin
    -- process (Data_memory_address, Data_memory_RAM) begin
    --     Data_memory_data_out <= Data_memory_RAM(to_integer(unsigned(Data_memory_address)));
    -- end process;

    process(write_address, write_enable)
	begin
		write_en <= (others => '0');
		write_en(to_integer(unsigned(write_address))) <= write_enable;	
	end process;

    Data_Mem_Gen_Reg: for i in 0 to data_memory_locations-1 generate
		Data_Mem_Reg: nbit_register generic map(N => data_length)
			port map(clk => clk, clear => clear, enable => write_en(i), 
				data_in => Data_memory_data_in, data_out => Data_memory_RAM(i));
	end generate Data_Mem_Gen_Reg;

    write_address <= Data_memory_address(integer(ceil(log2(real(data_memory_locations))))-1 downto 0);
    Data_memory_data_out <= Data_memory_RAM(to_integer(unsigned(write_address))) when read_enable='1' else (others => 'X');
end architecture;