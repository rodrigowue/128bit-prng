---------------------------------------------
--#File: prng.vhd
--#Author: Rodrigo Wuerdig
--#Contact: rodrigo.wuerdig@acad.pucrs.br
---------------------------------------------
--This PRNG uses Fibonacci LFSRs with a 
--estimated period of 3.40282366920938463463374607431768211455 × 10^38 clock cycles
--
--#expression: 
--    X^128 + X^126 + X^101 + X^99 + 1
--
--http://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PRNG is
	port (	
		clk_in:		in std_logic;
		reset_in:	in std_logic;
		random:		out std_logic_vector(127 downto 0);
		seed:		in std_logic_vector(31 downto 0);
		seed_sel:   in std_logic
	);
end PRNG;

architecture interface of PRNG is
signal intermediate: std_logic_vector(127 downto 0);
signal AA, BB, CC: std_logic;
begin
random <= intermediate;

process(clk_in, reset_in, intermediate)
begin
	if reset_in = '1' then
	     intermediate <= x"30061173151173993900000000000000"; --SEED
	     AA <= '0';
	     BB <= '0';
	     CC <= '0';  	  
	else
		if seed_sel = '1' then
			intermediate <= seed & x"000000000000000000000000";
		elsif(clk_in'event and clk_in = '1') then
			AA <= intermediate(127) xnor intermediate(125);
			BB <= intermediate(100) xnor AA;
			CC <= intermediate(98) xnor BB;
			intermediate <= intermediate(126 downto 0) & '0';
			intermediate(0) <= CC;
		end if;
	end if;
end process;
end interface;