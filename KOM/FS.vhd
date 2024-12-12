library ieee;
use ieee.std_logic_1164.all;

entity FS is
	port (
			a, b, bin : in std_logic;
			d, bout : out std_logic
			);
end FS;

architecture arch of FS is
begin
	
	d <= ((a xor b) xor bin);
	bout <= (bin and ((not a) or b)) or ((not a) and (b and (not bin)));
	
end arch;