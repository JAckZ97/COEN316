-- 32 x 32 register file
-- two read ports, one write port with write enable

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
signal reg:reg_array;

begin
-----------------first process
process (clk,reset,write_address)
	
        --reset the reg;
        --clk;
        --store the din to specific reg;

        begin
        if (reset= '1') then
                for i in 0 to 31 loop
                        reg(i) <= "00000000000000000000000000000000";
                        --reg(i) <= (others => (others => '0'));	
                end loop;
        elsif (clk'event and clk = '1') then
                if (write = '1') then
                        reg(to_integer(unsigned(write_address))) <= din;
                end if;

        end if;

end process;

-----------------reading process
process(read_a,read_b)
        begin

        out_a <= reg(to_integer(unsigned(read_a)));
        out_b <= reg(to_integer(unsigned(read_b)));

end process;


end rtl;

