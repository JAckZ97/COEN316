library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity alu is 
port(x, y : in std_logic_vector(31 downto 0);

	add_sub : in std_logic ;

	logic_func : in std_logic_vector(1 downto 0 ) ;

	func : in std_logic_vector(1 downto 0 ) ;

	output : out std_logic_vector(31 downto 0) ;

	overflow : out std_logic ;

	zero : out std_logic);
end alu;



architecture rtl of alu is
signal add_sub_out : std_logic_vector(31 downto 0);
signal logic_unit_out : std_logic_vector(31 downto 0 ) ;
--lui


begin
process(add_sub,x,y)
begin
	if add_sub = '0' then
	add_sub_out<=x+y;
	elsif add_sub = '1' then
	add_sub_out<=x-y;
	end if;
end process;





process(x,y,logic_func)
begin
	if logic_func = "00" then
	logic_unit_out<=x AND y;
	elsif logic_func = "01" then
	logic_unit_out<=x OR y;
	elsif logic_func = "10" then
	logic_unit_out<=x XOR y;
	elsif logic_func = "11" then
	logic_unit_out<=x NOR y;
	end if;
end process;


process(x,y,func,add_sub_out,logic_unit_out)--mux
begin

	if func = "00" then
	output<=y;
	elsif func = "01" then
	output<="0000000000000000000000000000000" & add_sub_out(31);
	elsif func = "10" then
	output<=add_sub_out;
	elsif func = "11" then
	output<=logic_unit_out;
	end if;
	
end process;

process(add_sub_out)--zero
	variable all_zero : std_logic_vector (31 downto 0);
begin
	all_zero := (others => '0');
	if add_sub_out = all_zero then
	zero <= '1';
	else
	zero <= '0';
	end if;
end process;

process(x,y,add_sub,add_sub_out)
begin
	if x(31) = '0' AND y(31) = '0' AND add_sub_out(31) = '1' AND add_sub = '0' then
        overflow <= '1'; 
	elsif  x(31) = '1' AND y(31) = '1' AND add_sub_out(31) = '0' AND add_sub = '0' then
        overflow <='1';
	elsif x(31) = '0' AND y(31) = '1' AND add_sub_out(31) = '1' AND add_sub = '1' then
        overflow <='1';
  elsif x(31) = '1' AND y(31) = '1' AND add_sub_out(31) = '0' AND add_sub = '1' then
        overflow <='1';
  else
        overflow <='0';
         
	end if;
end process;

end rtl;

