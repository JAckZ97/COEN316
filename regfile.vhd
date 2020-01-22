library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity regfile is
port( 
	din: in std_logic_vector(31 downto 0);

	reset : in std_logic;

	clk: in std_logic;

	write : in std_logic;

	read_a : in std_logic_vector(4 downto 0);

	read_b : in std_logic_vector(4 downto 0);

	write_address : in std_logic_vector(4 downto 0);

	out_a : out std_logic_vector(31 downto 0);

	out_b : out std_logic_vector(31 downto 0));

end regfile ;



architecture rtl of regfile is
	
	type reg_array is array (0 to 31) of std_logic_vector (31 downto 0);
	signal Reg : reg_array;


begin
process (clk, reset, write, write_address)
begin
			
		if reset = '1' then
		for i in 0 to 31 loop
		Reg(i)<="00000000000000000000000000000000";
		end loop;
		
		elsif clk'event and clk ='1' and write = '1' then
		Reg(to_integer((unsigned(write_address)))) <= din; --convert write_address to binary
		end if;

--reset regfile
--on the clk write din to regfile

end process;


--process(write,read_a,read_b)--reading
--begin
--output data to the output ports
 	--if write = '0' then
 	out_a <= Reg(to_integer((unsigned(read_a))));
  	out_b <= Reg(to_integer((unsigned(read_b))));
	--end if;
--end process;

end rtl;
