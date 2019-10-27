library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity next_address is
	port(
	--input
	rt, rs : in std_logic_vector(31 downto 0); -- two register inputs
	pc: in std_logic_vector(31 downto 0);
	target_address : in std_logic_vector(25 downto 0);
	branch_type: in std_logic_vector(1 downto 0);
	pc_sel: in std_logic_vector(1 downto 0);
	--output
	next_pc: out std_logic_vector(31 downto 0));
end next_address ;


architecture rtl of next_address is 
--signals => 5 signals

begin 
	(CSA) perform the 2's compliment 
--------------first process brach checker process
	process ()
	begin
	
	case statement 
	end process;
--------------second process pc_selection 
	process ()

	end process;

end rtl;