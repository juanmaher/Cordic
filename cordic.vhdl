library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic is
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
end cordic;

architecture cordic_arq of cordic is
	
	component cordic_desenrollada is
		generic(
			BITS: natural := 18;
			ETAPAS: natural := 2
		);
		port(
			clk : in std_logic;
			num_etapa : in integer;
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
	
	type signals is array (natural range <>) of std_logic_vector(BITS-1 downto 0);
	
	signal x : signals(ETAPAS downto 0);
	signal y : signals(ETAPAS downto 0);
	signal z : signals(ETAPAS downto 0);
	
begin
	
	cordic_i: for i in 0 to ETAPAS-1 generate
		cordic_desenrollada_inst: cordic_desenrollada 
		generic map(
			BITS => BITS,
			ETAPAS => ETAPAS
		)
		port map(
			clk => clk,
			xi => x(i),
			yi => y(i),
			zi => z(i),
			xo => x(i+1),
			yo => y(i+1),
			zo => z(i+1),
			num_etapa => i+1, -- Revisar si no es i solamente
			modo => modo
		);
	end generate;
	x(0) <= xi_c;
	y(0) <= yi_c;
	z(0) <= zi_c;
	
	xo_c <= x(ETAPAS);
	yo_c <= y(ETAPAS);
	zo_c <= z(ETAPAS);
	
end cordic_arq;