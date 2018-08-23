---------------------------------------------
--#File prng_tb.vhd
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

entity PRNG_tb is


end PRNG_tb;

architecture interface of PRNG_tb is
signal clock, reset, seed_sel: std_logic := '1';
signal seed: std_logic_vector(31 downto 0);
begin

process
begin
	clock <= not clock;
	wait for 5 ns;
end process;

reset <= '0', '1' after 5 ns, '0' after 200 ns;
seed_sel <= '0', '1' after 10 ns, '0' after 15 ns, '1' after 500 ns, '0' after 510 ns, '1' after 1000 ns, '0' after 1010 ns;
seed <= x"00000000", x"30061173" after 5 ns;

PRNG: entity work.prng
port map (
	clk_in    =>  clock,
	reset_in  =>  reset,
	random    =>  open,
	seed => seed,
	seed_sel => seed_sel
);


end interface;
