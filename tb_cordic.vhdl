library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture tb_cordic_arq of tb_cordic is

	component cordic is
		generic(
			BITS: natural := 7;
			ETAPAS: natural := 2
		);
		port(
			clk	: in std_logic;
			rst	: in std_logic;
			--start : in std_logic;
			modo : in std_logic;
			-- Entrada
			xi : in std_logic_vector(BITS-1 downto 0);
			yi : in std_logic_vector(BITS-1 downto 0);
			zi : in std_logic_vector(BITS-1 downto 0);
			-- Salida
			xo : out std_logic_vector(BITS-1 downto 0);
			yo : out std_logic_vector(BITS-1 downto 0);
			zo : out std_logic_vector(BITS-1 downto 0)
		);
	end component;
	
	constant TB_BITS : natural := 7;
	constant TB_ETAPAS : natural := 2;
	
	signal tb_clk: std_logic := '0';	
	signal tb_rst: std_logic := '0';	
	
	signal tb_xi: std_logic_vector(TB_BITS-1 downto 0) := "1010101";
	signal tb_yi: std_logic_vector(TB_BITS-1 downto 0) := "1010101";
	signal tb_zi: std_logic_vector(TB_BITS-1 downto 0) := "1010101";
																				
	signal tb_xo: std_logic_vector(TB_BITS-1 downto 0);
	signal tb_yo: std_logic_vector(TB_BITS-1 downto 0);
	signal tb_zo: std_logic_vector(TB_BITS-1 downto 0);

	signal tb_modo : std_logic := '1';
	signal tb_start : std_logic := '1';
	
begin
	
	tb_clk <= not tb_clk after 30 ns;
	tb_rst <= '0' after 1 ns;
	
	DUT: cordic
		generic map(
			BITS => TB_BITS,
			ETAPAS => TB_ETAPAS
		)
		port map (
			clk => tb_clk,
			rst => tb_rst,
			modo => tb_modo,
			xi 	=> tb_xi,
			yi 	=> tb_yi,
			zi 	=> tb_zi,
			xo 	=> tb_xo,
			yo 	=> tb_yo,
			zo 	=> tb_zo
		);
	
end tb_cordic_arq;