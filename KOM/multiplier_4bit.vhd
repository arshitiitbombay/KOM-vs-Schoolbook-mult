library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_4bit is
    port (
        a : in std_logic_vector(3 downto 0);
        b : in std_logic_vector(3 downto 0);
        z : out std_logic_vector(7 downto 0)
    );
end multiplier_4bit;

architecture arch of multiplier_4bit is 

component add_8bit is
	port (
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end component;

signal b0a, b1a, b2a, b3a : std_logic_vector(3 downto 0);
signal b0, b1, b2, b3 : std_logic_vector(7 downto 0);
signal till1, till2, temp : std_logic_vector(7 downto 0);

begin

	prod1: for i in 0 to 3 generate
		b0a(i) <= b(0) and a(i);
	end generate prod1;
	
	prod2: for i in 0 to 3 generate
		b1a(i) <= b(1) and a(i);
	end generate prod2;
	
	prod3: for i in 0 to 3 generate
		b2a(i) <= b(2) and a(i);
	end generate prod3;
	
	prod4: for i in 0 to 3 generate
		b3a(i) <= b(3) and a(i);
	end generate prod4;
	
	b0 <= "0000" & b0a;
	b1 <= "000" & b1a & "0";
	b2 <= "00" & b2a & "00";
	b3 <= "0" & b3a & "000";

-- now we'll add these four prodlines in a 7 bit adder --

inst1: add_8bit port map (a=>b0, b=>b1, z=>till1);
inst2: add_8bit port map (a=>till1, b=>b2, z=>till2);
inst3: add_8bit port map (a=>till2, b=>b3, z=> temp);

z <= temp;

end architecture;