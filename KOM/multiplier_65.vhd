library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_65 is
    Port (
        A      : in  std_logic_vector(64 downto 0);  -- 65-bit input
        B      : in  std_logic_vector(64 downto 0);  -- 65-bit input
        product : out std_logic_vector(129 downto 0) -- 130-bit product
    );
end multiplier_65;

architecture structural of multiplier_65 is
-------------------------------------------------------------------------------------
component multiplier_64bit is
    port (
        a : in std_logic_vector(63 downto 0);
        b : in std_logic_vector(63 downto 0);
        z : out std_logic_vector(127 downto 0)
    );
end component;
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
component add_64bit is
    port (
        a : in  std_logic_vector(63 downto 0);  -- 64-bit input
        b : in  std_logic_vector(63 downto 0);  -- 64-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(64 downto 0)   -- 65-bit sum
    );
end component add_64bit;
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
component FA is
  port (
		a : in std_logic_vector(2 downto 0);
		b : out std_logic_vector(1 downto 0)
  );
end component;
-------------------------------------------------------------------------------------

    -- Array to store partial products and accumulated sums
    type signal_array is array (0 to 64) of std_logic_vector(129 downto 0);
	
	signal mid1, mid2, left1, left2 : std_logic_vector(63 downto 0);
	signal mid3, mido : std_logic_vector(64 downto 0);
	signal temp : std_logic_vector(129 downto 0);
	signal lefto : std_logic_vector(127 downto 0);
	signal zero : std_logic_vector(63 downto 0) := (others=>'0');
   signal ain : std_logic_vector(2 downto 0);
begin
	
	left1 <= a(63 downto 0);
	left2 <= b(63 downto 0);
	
	mult1: multiplier_64bit port map(a=>left1, b=>left2, z=> lefto);
	temp(63 downto 0) <= lefto(63 downto 0);			-- left 64 bits --
	
	
	mid1 <= left1 when b(64) = '1' else zero;
   mid2 <= left2 when a(64) = '1' else zero;
	
	add1: add_64bit port map(a=>mid1, b=>mid2, cin=>'0', z=>mid3);
	add2: add_64bit port map(a=>mid3(63 downto 0), b=>lefto(127 downto 64), cin=>'0', z=>mido);
	temp(127 downto 64) <= mido(63 downto 0);			-- middle 64 bits --
	
	
	ain(2)<=mid3(64);
	ain(1)<=mido(64);
	ain(0)<=a(64) and b(64);
	
	add3: FA port map(a=>ain, b=>temp(129 downto 128));		-- right 2 bits --
	
	
	product <= temp;		-- FINAL ASSIGNMENT -- 
	
end architecture;