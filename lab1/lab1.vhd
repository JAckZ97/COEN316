
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
port(
x, y : in std_logic_vector(31 downto 0);-- two input operands
add_sub : in std_logic ;-- 0 = add , 1 = sub
logic_func : in std_logic_vector(1 downto 0 ) ;-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
func: in std_logic_vector(1 downto 0 ) ;-- 00 = lui, 01 = setless , 10 = arith , 11 = logic
output: out std_logic_vector(31 downto 0);
overflow: out std_logic;
zero: out std_logic);
end alu;

architecture rtl of alu is 
signal adder_out: std_logic_vector (31 downto 0);
signal logic_unit_out: std_logic_vector (31 downto 0);
signal lui : std_logic_vector (15 downto 0);

begin
-----------------first process
process (x,y,add_sub)
	begin
	case add_sub is
  		when '0' =>   adder_out <= std_logic_vector(unsigned(x)+unsigned(y));
  		when '1' =>   adder_out <= std_logic_vector(unsigned(x)-unsigned(y));
  		when others => null;
	end case;
end process;

-----------------------second process
process(x,y,logic_func)
	begin
	case logic_func is
  		when "00" =>   logic_unit_out <= x AND y;
  		when "01" =>   logic_unit_out <= x OR y;
  		when "10" =>   logic_unit_out <= x XOR y;
  		when "11" =>   logic_unit_out <= x NOR y;
  		when others => null;
	end case;
end process;

----------------------third process
process(adder_out,logic_unit_out,y,func)
  	variable z : std_logic_vector(30 downto 0) := (others => '0');

	begin
	case func is
  		when "00" =>   output <= NOT y;
  		when "01" =>   output <= NOT (z & adder_out(31));
  		when "10" =>   output <= NOT (adder_out);
  		when "11" =>   output <= NOT (logic_unit_out);
  		when others => null;
	end case;	
	
end process;

----------------------last process (zero flag)
process(adder_out)
	begin
	for i in 0 to 31 loop
		if adder_out(i) = '0' then 
			zero <= '1';
		elsif adder_out(i) = '1' then 
			zero <= '0';
		end if;
	end loop;
	
end process;

overflow <= NOT(((NOT x(31)) AND (NOT y(31)) AND (NOT add_sub)) OR (x(31) AND y(31) AND (NOT add_sub)) OR ((NOT x(31)) AND y(31) AND add_sub) OR (x(31) AND (NOT y(31)) AND add_sub));


end rtl;
