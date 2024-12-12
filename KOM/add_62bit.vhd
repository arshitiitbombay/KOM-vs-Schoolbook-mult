library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_62bit is
    port (
        a : in  std_logic_vector(61 downto 0);  -- 62-bit input
        b : in  std_logic_vector(61 downto 0);  -- 62-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(62 downto 0)   -- 63-bit sum
    );
end entity add_62bit;

architecture struct of add_62bit is

signal carry : std_logic_vector(61 downto 0);

-- Full Adder component declaration
component FA is
  port (
		a : in std_logic_vector(2 downto 0);
		b : out std_logic_vector(1 downto 0)
  );
end component;

begin

	-- First full adder (least significant bit)
	FA0: FA port map (
	  a(0) => a(0),
	  a(1) => b(0),
	  a(2) => cin,  
	  b(0) => z(0),
	  b(1) => carry(0)
	);

	-- Generate adders for the remaining bits (1 to 61)
	gen_adders: for i in 1 to 61 generate
	  FA_i: FA port map (
			a(0) => a(i),
			a(1) => b(i),
			a(2) => carry(i - 1),  -- carry from the previous bit
			b(0) => z(i),
			b(1) => carry(i)
	  );
	end generate gen_adders;
	z(62) <= carry(61);
	
end struct;
