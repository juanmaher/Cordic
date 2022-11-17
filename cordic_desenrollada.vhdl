library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Arquitectura -> desenrollada.
-- Para la arquitectura desenrollada, deberá agregarse pipelining cada
-- una cantidad genérica de etapas.

entity cordic_desenrollada is
	generic(
		BITS: natural := 18;
		ETAPAS: natural := 2
	);
	port( 
		clk : in std_logic;
		num_etapa : in unsigned(ETAPAS-1 downto 0);
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
end cordic_desenrollada;

architecture cordic_desenrollada_arq of cordic_desenrollada is
	
	signal d: std_logic; 
	
	signal xi_shift: std_logic_vector(BITS-1 downto 0);
	signal yi_shift: std_logic_vector(BITS-1 downto 0);
	
	signal xi_sum: std_logic_vector(BITS-1 downto 0);
	signal yi_sum: std_logic_vector(BITS-1 downto 0);
	
	
	function shift(numero:std_logic_vector; num_etapa:std_logic_vector) return std_logic_vector is		
			
		variable resultado : std_logic_vector(BITS-1 downto 0);
		variable MSB: std_logic;
		
		begin
			MSB := numero(numero'left);
			resultado(BITS-to_integer(num_etapa)-1 downto 0) := numero(BITS-1 downto to_integer(num_etapa)); 
			
			for i in BITS-1 downto BITS-to_integer(num_etapa) loop
				resultado(i) := MSB;
			end loop;
		
		return resultado;
	
	end function;
	
begin
	
	-- Tomo MSB
	d <= zi(zi'left);
	
	-- Shift especial (buscar nombre)
	xi_shift <= shift(xi,num_etapa);
	yi_shift <= shift(yi,num_etapa);

	xi_sum <= xi_shift when not(d) = '0' else not(xi_shift);
	yi_sum <= yi_shift when d = '0' else not(yi_shift);
	atan_sum <= atan when not(d) = '0' else not(atan);
	
	-- Salida
	xi <= std_logic_vector(unsigned(xo) + unsigned(yi_sum) + unsigned(d));
	yi <= std_logic_vector(unsigned(yo) + unsigned(xi_sum) + unsigned(d));
	zi <= std_logic_vector(unsigned(zo) + unsigned(atan_sum) + unsigned(not(d)));
	
end cordic_desenrollada_arq;