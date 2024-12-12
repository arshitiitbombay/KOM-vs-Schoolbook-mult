library ieee;
use ieee.std_logic_1164.all;

entity add_96bit is
	port (
		a : in std_logic_vector(95 downto 0);
		b : in std_logic_vector(95 downto 0);
		z : out std_logic_vector(95 downto 0)
	);
end add_96bit;

architecture arch of add_96bit is

component FA is
  port (
		a : in std_logic_vector(2 downto 0);
		b : out std_logic_vector(1 downto 0)
  );
end component;

 -- Custom types for 2D array
type std_logic_vector_2 is array (95 downto 0) of std_logic_vector(1 downto 0); -- 2D array
type std_logic_vector_3 is array (95 downto 0) of std_logic_vector(2 downto 0); -- 2D array


 -- Signal arrays for intermediate values
signal ain_array : std_logic_vector_3; -- 3-bit ain for each iteration
signal bout_array : std_logic_vector_2; -- 2-bit bout for each iteration
signal temp, at, bt : std_logic_vector(95 downto 0);
signal c : std_logic_vector(96 downto 0);

begin
	c(0) <= '0';

	addition : for i in 0 to 95 generate
	-- Form the 3-bit input for the FA
        ain_array(i)(0) <= a(i);  -- Input bit from `a`
        ain_array(i)(1) <= b(i);  -- Input bit from `b`
        ain_array(i)(2) <= c(i); -- Carry-in

        -- Instantiate FA
        inst: FA port map(
            a => ain_array(i)(2 downto 0),
            b => bout_array(i)(1 downto 0)
        );

        -- Capture sum and carry-out
        temp(i) <= bout_array(i)(0); -- Sum output
        c(i+1) <= bout_array(i)(1);      -- Carry-out becomes next carry-in
    end generate addition;
	
	z <= temp;
end architecture;