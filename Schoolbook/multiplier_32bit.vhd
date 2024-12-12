library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_32bit is
    port (
        a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        z : out std_logic_vector(63 downto 0)
    );
end entity;

architecture struct of multiplier_32bit is

    component multiplier_16 is
        port (
            A : in std_logic_vector(15 downto 0);
            B : in std_logic_vector(15 downto 0);
            product : out std_logic_vector(31 downto 0)
        );
    end component;

    component add_48bit is
        port (
            a : in std_logic_vector(47 downto 0);
            b : in std_logic_vector(47 downto 0);
            z : out std_logic_vector(47 downto 0)
        );
    end component;

    type signal_array is array (0 to 3) of std_logic_vector(31 downto 0);
    signal temp : signal_array;

    type answer is array(0 to 2) of std_logic_vector(47 downto 0);
    signal ans : answer;

    signal zero : std_logic_vector(31 downto 0) := (others => '0');

    signal adder1_a, adder1_b : std_logic_vector(47 downto 0);
    signal adder2_a, adder2_b : std_logic_vector(47 downto 0);
    signal temp0_last16 : std_logic_vector(15 downto 0);

begin

    inst1: multiplier_16
        port map (
            A => a(15 downto 0),
            B => b(15 downto 0),
            product => temp(0)
        );

    inst2: multiplier_16
        port map (
            A => a(31 downto 16),
            B => b(15 downto 0),
            product => temp(1)
        );

    inst3: multiplier_16
        port map (
            A => a(15 downto 0),
            B => b(31 downto 16),
            product => temp(2)
        );

    inst4: multiplier_16
        port map (
            A => a(31 downto 16),
            B => b(31 downto 16),
            product => temp(3)
        );

    temp0_last16 <= temp(0)(15 downto 0); 

    adder1_a <= zero & temp(0)(31 downto 16);
    adder1_b <= zero(15 downto 0) & temp(1) ;

    adder1: add_48bit
        port map (
            a => adder1_a,
            b => adder1_b,
            z => ans(0)
        );

    adder2_a <= zero(15 downto 0) & temp(2) ;
    adder2_b <= temp(3) & zero(15 downto 0);

    adder2: add_48bit
        port map (
            a => adder2_a,
            b => adder2_b,
            z => ans(1)
        );

	adder3: add_48bit
        port map (
            a => ans(0)(47 downto 0),
            b => ans(1)(47 downto 0),
            z => ans(2)
        );
		  
	
	z <= ans(2)(47 downto 0) & temp0_last16(15 downto 0) ;

end architecture;
