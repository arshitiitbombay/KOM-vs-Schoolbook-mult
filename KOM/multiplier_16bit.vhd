library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_16bit is
    port (
        a : in std_logic_vector(15 downto 0);
        b : in std_logic_vector(15 downto 0);
        z : out std_logic_vector(31 downto 0)
    );
end multiplier_16bit;

architecture struct of multiplier_16bit is

    component multiplier_8bit is
        port (
            A : in std_logic_vector(7 downto 0);
            B : in std_logic_vector(7 downto 0);
            z : out std_logic_vector(15 downto 0)
        );
    end component;

    component add_24bit is
        port (
            a : in std_logic_vector(23 downto 0);
            b : in std_logic_vector(23 downto 0);
            z : out std_logic_vector(23 downto 0)
        );
    end component;

    type signal_array is array (0 to 3) of std_logic_vector(15 downto 0);
    signal temp : signal_array;

    
    type answer is array(0 to 2) of std_logic_vector(23 downto 0);
    signal ans : answer;

    signal zero : std_logic_vector(15 downto 0) := (others => '0');

    signal adder1_a, adder1_b : std_logic_vector(23 downto 0);
    signal adder2_a, adder2_b : std_logic_vector(23 downto 0);
    signal temp0_last8 : std_logic_vector(7 downto 0);

begin

    
    inst1: multiplier_8bit
        port map (
            A => a(7 downto 0),
            B => b(7 downto 0),
            z => temp(0)
        );

    inst2: multiplier_8bit
        port map (
            A => a(15 downto 8),
            B => b(7 downto 0),
            z => temp(1)
        );

    inst3: multiplier_8bit
        port map (
            A => a(7 downto 0),
            B => b(15 downto 8),
            z => temp(2)
        );

    inst4: multiplier_8bit
        port map (
            A => a(15 downto 8),
            B => b(15 downto 8),
            z => temp(3)
        );

    
    temp0_last8 <= temp(0)(7 downto 0); 

    adder1_a <= zero & temp(0)(15 downto 8);
    adder1_b <= zero(7 downto 0) & temp(1) ;

    adder1: add_24bit
        port map (
            a => adder1_a,
            b => adder1_b,
            z => ans(0)
        );

    adder2_a <= zero(7 downto 0) & temp(2) ;
    adder2_b <= temp(3) & zero(7 downto 0);

    adder2: add_24bit
        port map (
            a => adder2_a,
            b => adder2_b,
            z => ans(1)
        );

	adder3: add_24bit
        port map (
            a => ans(0)(23 downto 0),
            b => ans(1)(23 downto 0),
            z => ans(2)
        );
		  
	
	z <= ans(2) & temp0_last8 ;

end architecture;
