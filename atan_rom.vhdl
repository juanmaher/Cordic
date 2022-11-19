library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity atan_rom is
	generic(
		MEM_BITS: natural := 18;
		WORD_BITS: natural := 16
	);
	port(
		atan_address: in integer;
		rom_out: out std_logic_vector(MEM_BITS-1 downto 0)
	);
end;

architecture atan_rom_arq of atan_rom is

	type memoria is array (WORD_BITS-1 downto 0) of std_logic_vector(MEM_BITS-1 downto 0);
	signal ROM: memoria := (
							0 => "01000000000000000", --32768
							1 => "00100101110010000", --19344
							2 => "00010011111101101", --10221
							3 => "00001010001000100", --5188
							4 => "00000101000101100", --2604
							5 => "00000010100010111", --1303
							6 => "00000001010001100", --652
							7 => "00000000101000110", --326
							8 => "00000000010100011", --163
							9 => "00000000001010001", --81
							10 => "00000000000101001", --41
							11 => "00000000000010100", --20
							12 => "00000000000001010", --10
							13 => "00000000000000101", --5
							14 => "00000000000000011", --3
							15 => "00000000000000001" --1
						);
	
begin

	rom_out <= ROM(atan_address);

end;