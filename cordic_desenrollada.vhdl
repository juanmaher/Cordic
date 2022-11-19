library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Arquitectura -> desenrollada.
-- Para la arquitectura desenrollada, deberá agregarse pipelining cada
-- una cantidad genérica de etapas.

entity cordic_desenrollada is
	generic(
		BITS: natural := 18;
		ETAPAS: natural := 2;
		MEM_BITS: natural:= 18;
		WORD_BITS: natural := 16
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
end cordic_desenrollada;

architecture cordic_desenrollada_arq of cordic_desenrollada is
	
	component atan_rom is
		generic(
			MEM_BITS: natural:= 18;
			WORD_BITS: natural := 16
		);
		port(
			atan_address: in integer;
			rom_out: out std_logic_vector(MEM_BITS-1 downto 0)
		);
	end component;
	
	signal d: std_logic_vector(0 downto 0); 
	
	signal xi_shift: std_logic_vector(BITS-1 downto 0);
	signal yi_shift: std_logic_vector(BITS-1 downto 0);
	
	signal xi_sum: std_logic_vector(BITS-1 downto 0);
	signal yi_sum: std_logic_vector(BITS-1 downto 0);
	signal atan_sum: std_logic_vector(BITS-1 downto 0);
	
	signal atan: std_logic_vector(BITS-1 downto 0);
	signal rom_out: std_logic_vector(BITS-1 downto 0);
	
	
	function shift(numero:std_logic_vector; num_etapa:integer) return std_logic_vector is		
			
		variable resultado : std_logic_vector(BITS-1 downto 0);
		variable MSB: std_logic;
		
		begin
			MSB := numero(numero'left);
			resultado(BITS-num_etapa-1 downto 0) := numero(BITS-1 downto num_etapa); 
			
			for i in BITS-1 downto BITS-num_etapa loop
				resultado(i) := MSB;
			end loop;
		
		return resultado;
	
	end function;
	
begin
	
	ROM: atan_rom 
		generic map(
			MEM_BITS => MEM_BITS,
			WORD_BITS => WORD_BITS
		)
		port map(num_etapa, rom_out);
	
	-- Tomo MSB
	d <= zi(zi'left downto zi'left);
	
	-- Shift especial (buscar nombre)
	xi_shift <= shift(xi,num_etapa);
	yi_shift <= shift(yi,num_etapa);
	
	-- Tomo el valor de atan de ROM
	atan <= rom_out;
	
	xi_sum <= xi_shift when not(d) = "0" else not(xi_shift);
	yi_sum <= yi_shift when d = "0" else not(yi_shift);
	atan_sum <= atan when not(d) = "0" else not(atan);
	
	-- Salida
	xo <= std_logic_vector(unsigned(xi) + unsigned(yi_sum) + unsigned(d));
	yo <= std_logic_vector(unsigned(yi) + unsigned(xi_sum) + unsigned(d));
	zo <= std_logic_vector(unsigned(zi) + unsigned(atan_sum) + unsigned(not(d)));
	
end cordic_desenrollada_arq;