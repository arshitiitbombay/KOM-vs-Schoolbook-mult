library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_66bit is
    port (
        a : in  std_logic_vector(65 downto 0);  -- 66-bit input
        b : in  std_logic_vector(65 downto 0);  -- 66-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(66 downto 0)   -- 67-bit sum
    );
end entity add_66bit;

architecture struct of add_66bit is

    signal carry : std_logic_vector(66 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin
	carry(0) <= cin;
    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => cin,  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(1)
    );

    -- Generate adders for the remaining bits (1 to 65)
    gen_adders: for i in 1 to 65 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i+1)
        );
    end generate gen_adders;
	 z(66) <= carry(66);
	 
end struct;

-----------------------------------------------------------------------------------------------------------------