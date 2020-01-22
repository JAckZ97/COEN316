library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity D_cache is
port( 	
	din : in std_logic_vector(31 downto 0);
	address : in std_logic_vector(31 downto 0);
	data_write : in std_logic;
	reset : in std_logic ;
     	clk   : in std_logic ;
	d_out : out std_logic_vector(31 downto 0));

end D_cache;



architecture rtl of D_cache is

type locations is array (0 to 31) of std_logic_vector(31 downto 0);
signal cache_loc : locations;
signal fivebitadd : std_logic_vector(4 downto 0);

begin
fivebitadd <= address(4 downto 0);
d_out <= cache_loc(conv_integer(fivebitadd));
process(clk, reset, data_write, din, address) 
begin
	if (reset = '1') then
		for i in 0 to 31 loop
			cache_loc(i) <=(others =>'0'); -- all locations euqal to zero
		end loop;
	elsif (clk'event and clk = '1') then
	        if (data_write = '1') then
	            cache_loc(conv_integer(fivebitadd)) <= din;
	        end if;
	end if;
end process;




end rtl;
