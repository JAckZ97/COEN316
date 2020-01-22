library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity next_address is
	port(
	rt, rs : in std_logic_vector(31 downto 0);-- two register inputs
	pc : in std_logic_vector(31 downto 0);
	instruction : in std_logic_vector(31 downto 0);
	branch_type : in std_logic_vector(1 downto 0);
	pc_sel : in std_logic_vector(1 downto 0);
	next_pc : out std_logic_vector(31 downto 0));
end next_address ;


architecture rtl of next_address is



begin
process(rt,rs,pc,instruction,branch_type,pc_sel)

variable branch_offset_sign_exd : unsigned(31 downto 0);



variable target_address : std_logic_vector(25 downto 0);
variable pc_unsigned : unsigned(31 downto 0);
	

begin
  --sign extended offset
target_address:=instruction(25 downto 0);

if (target_address (15) = '0') then
  branch_offset_sign_exd := unsigned ("0000000000000000" & target_address(15 downto 0));
else
  branch_offset_sign_exd := unsigned ("1111111111111111" & target_address(15 downto 0));
end if;

--pc conversion		
pc_unsigned := unsigned(pc);

if (pc_sel="00") then
		if (branch_type = "00") then
		next_pc <= std_logic_vector(pc_unsigned +1);

		elsif (branch_type = "01") then
		if (rs=rt) then
			next_pc <= std_logic_vector(pc_unsigned + 1 +branch_offset_sign_exd);
		else 
			next_pc <= std_logic_vector(pc_unsigned +1);
		end if;

		elsif (branch_type = "10") then
		if (rs/=rt) then 
			next_pc <= std_logic_vector(pc_unsigned + 1 +branch_offset_sign_exd);
		else 
			next_pc <= std_logic_vector(pc_unsigned +1);
		end if;

		elsif (branch_type = "11") then
		if (signed(rs) < 0) then
			next_pc <= std_logic_vector(pc_unsigned + 1 +branch_offset_sign_exd);
		
		else 
			next_pc <= std_logic_vector(pc_unsigned +1);
		end if;
		end if;
elsif (pc_sel="01") then
		next_pc <= "000000" & target_address;
elsif (pc_sel = "10") then
		next_pc <= rs;
elsif (pc_sel = "11") then
		next_pc <= std_logic_vector(pc_unsigned +1);
end if;
		
		
		
		

end process;


end rtl;



