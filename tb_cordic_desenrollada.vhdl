library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cordic_desenrollada is
end tb_cordic_desenrollada;

architecture tb_cordic_desenrollada_arq of tb_cordic_desenrollada is

	component cordic_desenrollada is
		generic(
			BITS: natural := 7;
			ETAPAS: natural := 4
		);
		port(
			clk : in std_logic;
			-- Rotación = 0
			-- Vectorización = 1
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
	constant TB_ETAPAS : natural := 4;
	
	signal tb_clk: std_logic := '0';	
	
	signal tb_xi: std_logic_vector(TB_BITS-1 downto 0) := "1000101"; --1110001
	signal tb_yi: std_logic_vector(TB_BITS-1 downto 0) := "1101000"; --1111010
	signal tb_zi: std_logic_vector(TB_BITS-1 downto 0);
																				
	signal tb_xo: std_logic_vector(TB_BITS-1 downto 0);
	signal tb_yo: std_logic_vector(TB_BITS-1 downto 0);
	signal tb_zo: std_logic_vector(TB_BITS-1 downto 0);

	
	signal tb_modo : std_logic := '1';
	
begin
	
	tb_clk <= not tb_clk after 30 ns;
	
	DUT: cordic_desenrollada
		generic map(
			BITS => TB_BITS,
			ETAPAS => TB_ETAPAS
		)
		port map (
			clk => tb_clk,
			modo => tb_modo,
			xi 	=> tb_xi,
			yi 	=> tb_yi,
			zi 	=> tb_zi,
			xo 	=> tb_xo,
			yo 	=> tb_yo,
			zo 	=> tb_zo
			
		);
		
		-- Demonstrates Use Case #1: Replicating Logic
	  -- Stores just the most significant byte in a new signal
	  -- DUT: for i in 0 to ETAPAS-1 generate
		-- w_VECTOR_MSB_1(ii) <= r_VECTOR(ii+8);
	  -- end generate DUT;
	   
	  -- This code has the same effect as above
	  -- But the above is more compact, easier to read, and less error prone!
	  -- w_VECTOR_MSB_2(0) <= r_VECTOR(8);
	  -- w_VECTOR_MSB_2(1) <= r_VECTOR(9);
	  -- w_VECTOR_MSB_2(2) <= r_VECTOR(10);
	  -- w_VECTOR_MSB_2(3) <= r_VECTOR(11);
	  -- w_VECTOR_MSB_2(4) <= r_VECTOR(12);
	  -- w_VECTOR_MSB_2(5) <= r_VECTOR(13);
	  -- w_VECTOR_MSB_2(6) <= r_VECTOR(14);
	  -- w_VECTOR_MSB_2(7) <= r_VECTOR(15);
	
end tb_cordic_desenrollada_arq;