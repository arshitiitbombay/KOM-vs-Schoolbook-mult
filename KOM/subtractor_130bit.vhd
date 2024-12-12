library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtractor_130bit is
    port (
        a    : in  std_logic_vector(129 downto 0); -- 130-bit input A
        b    : in  std_logic_vector(129 downto 0); -- 130-bit input B
        y    : out std_logic_vector(129 downto 0); -- 130-bit result Y = A - B
        cout : out std_logic                     -- Carry out (underflow indicator)
    );
end entity subtractor_130bit;

architecture struct of subtractor_130bit is

component FS is
	port (
			a, b, bin : in std_logic;
			d, bout : out std_logic
			);
end component;

signal borrow : std_logic_vector(130 downto 0); 
signal temp: std_logic_vector(129 downto 0); 

begin

   borrow(0) <= '0';
	subt: for i in 0 to 129 generate
		inst: FS port map(a=>a(i), b=>b(i), bin=>borrow(i), d=>temp(i), bout=>borrow(i+1));
	end generate subt;
	
	y <= temp(129 downto 0);
	cout <= borrow(130);
end struct;