library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
  port (
		a : in std_logic_vector(2 downto 0);
		b : out std_logic_vector(1 downto 0)
  );
end entity;

architecture arch of FA is

begin
	b(0) <= ((a(0) xor a(1)) xor a(2));
	b(1) <= ((a(2) and (a(1) or a(0))) or ((not(a(2))) and (a(1) and a(0))));
end architecture;
