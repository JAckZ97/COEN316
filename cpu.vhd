library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity cpu is
port(	reset : in std_logic;
	clk : in std_logic;
	rt_out, rs_out : out std_logic_vector(3 downto 0);
	pc_out : out std_logic_vector (3 downto 0);
	overflow, zero : out std_logic); -- will not be constrained

end cpu;

architecture rtl of cpu is
signal pc_sel : std_logic_vector (1 downto 0);
signal branch_type : std_logic_vector (1 downto 0);
signal reg_dst : std_logic;
signal reg_write : std_logic;
signal alu_src : std_logic;
signal add_sub : std_logic;
signal logic_func : std_logic_vector (1 downto 0);
signal func : std_logic_vector (1 downto 0);
--control signals associataed with data cache
signal data_write : std_logic;
signal reg_in_src : std_logic;
--signals in the datapath used to hook-up the various blocks

--reg file signals
signal rs_field, rt_field : std_logic_vector (4 downto 0);-- tow register source operands
--fields from inctruction
--rs=read_a
--rt=read_b

signal rd_field : std_logic_vector (4 downto 0);--destination register operand
--field from instruction
signal write_address : std_logic_vector(4 downto 0); --  outputs of regfil mux
signal rs,rt :  std_logic_vector (31 downto 0);--two outputs of regfile
--next address signals:
--signal target_address : std_logic_vector (25 downto 0);
signal pc, next_pc : std_logic_vector (31 downto 0);
--alu signal
signal immediate_field : std_logic_vector (15 downto 0);
signal sign_extended_immediate : std_logic_vector (31 downto 0);
signal alu_mux_out : std_logic_vector (31 downto 0);
signal alu_output : std_logic_vector (31 downto 0);
--data cache mux output signal
signal data_cache_mux_out : std_logic_vector (31 downto 0);
signal data_cache_out : std_logic_vector (31 downto 0);
--instruction cache outpit signal
signal instruction : std_logic_vector (31 downto 0);
--component declaration
---------------------------------------------
component regfile 
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

end component;
---------------------------------------------------------------
component next_address
port(
	rt, rs : in std_logic_vector(31 downto 0);-- two register inputs
	pc : in std_logic_vector(31 downto 0);
	instruction : in std_logic_vector(31 downto 0);
	branch_type : in std_logic_vector(1 downto 0);
	pc_sel : in std_logic_vector(1 downto 0);
	next_pc : out std_logic_vector(31 downto 0));
end component;
-------------------------------------------------------------------------------------
component alu
port(	
	x, y : in std_logic_vector(31 downto 0);
	add_sub : in std_logic ;
	logic_func : in std_logic_vector(1 downto 0 ) ;
	func : in std_logic_vector(1 downto 0 ) ;
	output : out std_logic_vector(31 downto 0) ;
	overflow : out std_logic ;
	zero : out std_logic
);
end component;
--------------------------------------------------------------------
component D_cache
port(
	din : in std_logic_vector(31 downto 0);
	address : in std_logic_vector(31 downto 0);
	data_write : in std_logic;
	reset : in std_logic ;
     	clk   : in std_logic ;
	d_out : out std_logic_vector(31 downto 0));
end component;

component control_unit 
port(instruction: in std_logic_vector(31 downto 0);
	reg_write,reg_dst,reg_in_src,alu_src,add_sub,data_write: out std_logic;
	logic_func,func,branch_type,pc_sel: out std_logic_vector(1 downto 0));
end component;

for regfile_inst : regfile use entity work.regfile(rtl);
for next_address_inst : next_address use entity work.next_address(rtl);
for alu_inst : alu use entity work.alu(rtl);
for datacache_inst : D_cache use entity work.D_cache(rtl);
for control_unit_inst : control_unit use entity work.control_unit(rtl);


--port maps begin


begin
rs_out<= rs(3 downto 0);
rt_out<= rt(3 downto 0); 
pc_out<= pc(3 downto 0);
--assign register address fields from the bits of the instruction
rs_field<=instruction (25 downto 21); 
rt_field<=instruction(20 downto 16); 
rd_field <=instruction (15 downto 11);
immediate_field <= instruction(15 downto 0);


------------------------------------------------------------------------------------------------------
--pc register
pc_reg : block
begin
process(clk, reset)
begin
	if reset ='1' then
		pc<=(others=>'0');
	elsif clk'event and clk='1' then
	pc<=next_pc;
end if;
end process;
end block;
--------------------------------------------------------------------------
inst_cache : block
begin
process(pc)
variable men_address : std_logic_vector(4 downto 0);
begin
men_address := pc(4 downto 0); -- use only 5 bit for implementation
case men_address is
	when "00000" => instruction <= "00100000000000110000000000000000"; --addi r3, rO, 0
        when "00001" => instruction <= "00100000000000010000000000000000"; --addi rl, rO, 0
        when "00010" => instruction <= "00100000000000100000000000000101"; -- addi r2,r0,5
        when "00011" => instruction <= "00000000001000100000100000100000"; --add rl,r1,r2
        when "00100" => instruction <= "00100000010000101111111111111111";--addi r2, r2, -1
        when "00101" => instruction <= "00010000010000110000000000000001"; -- be1 r2,r3 (+1)
        when "00110" => instruction <= "00001000000000000000000000000011"; -- jump 3
        when "00111" => instruction <= "10101100000000010000000000000000"; --sw rl, 0(rO)
        when "01000" => instruction <= "10001100000001000000000000000000"; --lw r4, O(rO)
        when "01001" => instruction <= "00110000100001000000000000001010"; --andi r4,r4, Ox000A
        when "01010" => instruction <= "00110100100001000000000000000001"; -- on r4,r4, Ox0001
        when "01011" => instruction <= "00111000100001000000000000001011"; --xori r4,r4, OxB
        when "01100" => instruction <= "00111000100001000000000000000000"; --xori r4,r4, Ox0000
        when others => instruction <= "00000000000000000000000000000000"; -- dont care
end case;
end process;
end block;
--------------------------------------------------------------
reg_mux:block
begin
process(reg_dst,rt_field,rd_field)
begin
 if reg_dst = '0' then
            write_address <= rt_field;
            else
            write_address <= rd_field;
            end if;
end process;
end block;
----------------------------------------------------------
sign_extend:block
begin
process(immediate_field,func)
begin
case func is
	when "00" =>
		sign_extended_immediate <= (immediate_field & "0000000000000000");
	when "01" =>
		if (immediate_field(15)='0') then 
		sign_extended_immediate <= "0000000000000000" & immediate_field;
		elsif (immediate_field(15)='1') then 
		sign_extended_immediate <= "1111111111111111" & immediate_field;
		end if;

	when "10" =>
		if (immediate_field(15)='0') then 
		sign_extended_immediate <= "0000000000000000" & immediate_field;
		elsif (immediate_field(15)='1') then
		sign_extended_immediate <= "1111111111111111" & immediate_field;
		end if;

	when others =>
		sign_extended_immediate <= "0000000000000000" & immediate_field;
	end case;	

end process;
end block;
---------------------------------------------------------
regfile_inst : regfile port map(data_cache_mux_out,reset,clk,reg_write,rs_field,rt_field,write_address,rs,rt);
next_address_inst : next_address port map(rt,rs,pc,instruction,branch_type,pc_sel,next_pc);
------------------------------------------------------------
alu_mux_block : block
begin
process(alu_src, rt, sign_extended_immediate)
begin
	if alu_src = '0' then
	alu_mux_out <= rt;
	else
        alu_mux_out <= sign_extended_immediate;
	end if;
end process;
end block;
-----------------------------------------------------
alu_inst : alu port map(rs,alu_mux_out,add_sub,logic_func,func,alu_output,overflow,zero);
datacache_inst : D_cache port map (rt,alu_output,data_write,reset,clk,data_cache_out);
-------------------------------------------------------------------
data_cache_mux : block
            begin
            process(reg_in_src, alu_output, data_cache_out)
            begin
            if reg_in_src = '0' then
            data_cache_mux_out <= data_cache_out;
            else
            data_cache_mux_out <= alu_output;
            end if;
            end process;
            end block;
--------------------------------------------------------------
control_unit_inst : control_unit port map(instruction,reg_write,reg_dst,reg_in_src,alu_src,add_sub,data_write,logic_func,func,branch_type,pc_sel);

end rtl;

