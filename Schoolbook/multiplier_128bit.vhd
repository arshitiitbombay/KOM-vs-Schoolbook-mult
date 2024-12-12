library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_128bit is
    port (
        a : in std_logic_vector(127 downto 0);
        b : in std_logic_vector(127 downto 0);
        z : out std_logic_vector(255 downto 0)
		 
    );
end entity;

architecture struct of multiplier_128bit is

    component multiplier_64bit is
        port (
            A : in std_logic_vector(63 downto 0);
            B : in std_logic_vector(63 downto 0);
            z : out std_logic_vector(127 downto 0)
        );
    end component;

    component add_192bit is
        port (
            a : in std_logic_vector(191 downto 0);
            b : in std_logic_vector(191 downto 0);
            z : out std_logic_vector(191 downto 0)
        );
    end component;

    type signal_array is array (0 to 3) of std_logic_vector(127 downto 0);
    signal temp : signal_array;

    type answer is array(0 to 2) of std_logic_vector(191 downto 0);
    signal ans : answer;

    signal zero : std_logic_vector(127 downto 0) := (others => '0');

    signal adder1_a, adder1_b : std_logic_vector(191 downto 0);
    signal adder2_a, adder2_b : std_logic_vector(191 downto 0);
    signal temp0_last64 : std_logic_vector(63 downto 0);

begin

    inst1: multiplier_64bit
        port map (
            A => a(63 downto 0),
            B => b(63 downto 0),
            z => temp(0)
        );

    inst2: multiplier_64bit
        port map (
            A => a(127 downto 64),
            B => b(63 downto 0),
            z => temp(1)
        );

    inst3: multiplier_64bit
        port map (
            A => a(63 downto 0),
            B => b(127 downto 64),
            z => temp(2)
        );

    inst4: multiplier_64bit
        port map (
            A => a(127 downto 64),
            B => b(127 downto 64),
            z => temp(3)
        );

    temp0_last64 <= temp(0)(63 downto 0);

    adder1_a <= zero & temp(0)(127 downto 64);
    adder1_b <= zero(63 downto 0) & temp(1);

    adder1: add_192bit
        port map (
            a => adder1_a,
            b => adder1_b,
            z => ans(0)
        );

    adder2_a <= zero(63 downto 0) & temp(2);
    adder2_b <= temp(3) & zero(63 downto 0);

    adder2: add_192bit
        port map (
            a => adder2_a,
            b => adder2_b,
            z => ans(1)
        );

    adder3: add_192bit
        port map (
            a => ans(0),
            b => ans(1),
            z => ans(2)
        );
	
	
    z <= ans(2) & temp0_last64;

end architecture;
