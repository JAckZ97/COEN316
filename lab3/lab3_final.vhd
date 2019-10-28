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
signal branch_out : in std_logic_vector(31 downto 0);

begin 
variable pc_unsigned: unsigned(31 downto 0);
variable sign_extended_offset: unsigned(31 downto 0); -- assumes 2's complement offset

pc_unsigned := unsigned(pc);
		
if (target_address(15) = '0') then
	sign_extended_offset := unsigned("0000000000000000" & target_address(15 downto 0));
elsif
	sign_extended_offset := unsigned("1111111111111111" & target_address(15 downto 0));
end if;

--------------first process brach checker process
process (branch_type, pc_unsigned, sign_extended_offset, rs, rt)

	begin
	case branch_type is 
  		when "00" =>   
  			branch_out <= std_logic_vector(pc_unsigned + 1);
  		when "01" =>   
			if (rs = rt) then 
				branch_out <= std_logic_vector(pc_unsigned + 1 + sign_extended_offset);
			elsif 				
				branch_out <= std_logic_vector(pc_unsigned + 1);	
			end if;
  		when "10" =>   
			if (rs /= rt) then 
				branch_out <= std_logic_vector(pc_unsigned + 1 + sign_extended_offset);
			elsif 				
				branch_out <= std_logic_vector(pc_unsigned + 1);	
			end if;  			
  		when "11" =>   
			if (signed(rs) < 0) then 
				branch_out <= std_logic_vector(pc_unsigned + 1 + sign_extended_offset);
			elsif 		
				branch_out <= std_logic_vector(pc_unsigned + 1);
			end if;
  		when others => 
  		  	branch_out <= std_logic_vector(pc_unsigned + 1);
	end case;
end process;

--------------second process pc_selection 
process (branch_out, target_address, rs, pc_unsigned)
	begin 
	case pc_sel is
		when "00" => 
			next_pc <= branch_out;
		when "01" => 
			next_pc <= "000000" & target_address;
		when "10" => 
			next_pc <= rs;
		when others =>
			next_pc <= std_logic_vector(pc_unsigned + 1);	
	end case;	
	
end process;
end rtl;
