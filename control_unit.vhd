library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity control_unit is 
port(
	instruction: in std_logic_vector(31 downto 0);
	reg_write,reg_dst,reg_in_src,alu_src,add_sub,data_write: out std_logic;
	logic_func,func,branch_type,pc_sel: out std_logic_vector(1 downto 0));
end control_unit;

architecture rtl of control_unit is
begin
process(instruction)
	variable op, i_func : std_logic_vector(5 downto 0);
	begin 
	op:= instruction(31 downto 26);
	i_func:= instruction(5 downto 0);
		if op = "000000" then --add/sub/slt/and/or/xor/nor/jr
			
				if i_func = "100000" then --add
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '0';
				data_write <= '0';
				logic_func <= "00";
				func <= "10";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func ="100010" then --sub
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "00";
				func <= "10";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func = "101010" then --slt
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "00";
				func <= "01";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func = "100100" then --and
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "00";
				func <= "11";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func = "100101" then --or
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "01";
				func <= "11";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func ="100110" then --xor
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "10";
				func <= "11";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func = "100111" then --nor
				reg_write <= '1';
				reg_dst <= '1';
				reg_in_src <= '1';
				alu_src <= '0';
				add_sub <= '1';
				data_write <= '0';
				logic_func <= "11";
				func <= "11";
				branch_type <= "00";
				pc_sel <= "00";
				elsif i_func = "001000" then --jr
				reg_write <= '0';
				reg_dst <= '0';
				reg_in_src <= '0';
				alu_src <= '0';
				add_sub <= '0';
				data_write <= '0';
				logic_func <= "00";
				func <= "00";
				branch_type <= "00";
				pc_sel <= "10";
				else -- don't care
				reg_write <= '0';
				reg_dst <= '0';
				reg_in_src <= '0';
				alu_src <= '0';
				add_sub <= '0';
				data_write <= '0';
				logic_func <= "00";
				func <= "00";
				branch_type <= "10";
				pc_sel <= "00";
				end if;
				
		elsif  op = "001111" then --lui
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '0'; -- don't care
			data_write <= '0';
			logic_func <= "00"; -- don't care
			func <= "00";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "001000"  then --addi
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "00";
			func <= "10";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "001010"  then --slti	
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '1';
			data_write <= '0';
			logic_func <= "00";
			func <= "01";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "001100"  then --andi
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '1';
			data_write <= '0';
			logic_func <= "00";
			func <= "11";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "001101"  then --ori
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '1';
			data_write <= '0';
			logic_func <= "01";
			func <= "11";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "001110"  then --xori
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '1';
			alu_src <= '1';
			add_sub <= '1';
			data_write <= '0';
			logic_func <= "10";
			func <= "11";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "100011"  then --lw
			reg_write <= '1';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '1';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "10"; -- don't care
			func <= "10";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "101011"  then --sw
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '1';
			add_sub <= '0';
			data_write <= '1';
			logic_func <= "10"; -- don't care
			func <= "10";
			branch_type <= "00";
			pc_sel <= "00";
		elsif  op = "000010"  then --j
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '0';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "10";
			func <= "10";
			branch_type <= "00";
			pc_sel <= "01";
		elsif  op = "000001"  then --bltz
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '0';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "10";
			func <= "10";
			branch_type <= "11";
			pc_sel <= "00";
		elsif  op = "000100"  then --beq
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '0';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "00";
			func <= "00";
			branch_type <= "01";
			pc_sel <= "00";
		elsif  op = "000101"  then --bne
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '0';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "00";
			func <= "00";
			branch_type <= "10";
			pc_sel <= "00";
		else -- on other cases, set all controls to '0'
			reg_write <= '0';
			reg_dst <= '0';
			reg_in_src <= '0';
			alu_src <= '0';
			add_sub <= '0';
			data_write <= '0';
			logic_func <= "00";
			func <= "00";
			branch_type <= "00";
			pc_sel <= "00";
		end if;
	end process;
end rtl;
