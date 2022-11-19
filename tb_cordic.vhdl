library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture tb_cordic_arq of tb_cordic is

	component cordic is
		generic(
			BITS: natural := 18;
			ETAPAS: natural := 2
		);
		port(
			clk	: in std_logic;
			rst	: in std_logic;
			--start : in std_logic;
			modo : in std_logic;
			-- Entrada
			xi_c : in std_logic_vector(BITS-1 downto 0);
			yi_c : in std_logic_vector(BITS-1 downto 0);
			zi_c : in std_logic_vector(BITS-1 downto 0);
			-- Salida
			xo_c : out std_logic_vector(BITS-1 downto 0);
			yo_c : out std_logic_vector(BITS-1 downto 0);
			zo_c : out std_logic_vector(BITS-1 downto 0)
		);
	end component;
	
	constant TB_BITS : natural := 18;
	constant TB_ETAPAS : natural := 2;
	
	signal tb_clk: std_logic := '0';	
	signal tb_rst: std_logic := '0';	
	
	signal tb_xi: std_logic_vector(TB_BITS-1 downto 0) := "101010101101010101";
	signal tb_yi: std_logic_vector(TB_BITS-1 downto 0) := "101010101101010101";
	signal tb_zi: std_logic_vector(TB_BITS-1 downto 0) := "101010101101010101";
																				
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
			xi_c 	=> tb_xi,
			yi_c 	=> tb_yi,
			zi_c 	=> tb_zi,
			xo_c 	=> tb_xo,
			yo_c 	=> tb_yo,
			zo_c 	=> tb_zo
		);
	
end tb_cordic_arq;