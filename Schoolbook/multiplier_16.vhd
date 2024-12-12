library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.components.all;

entity multiplier_16 is
    Port (
--        clock     : in  std_logic;               -- Clock input 
        A       : in  std_logic_vector(15 downto 0);   -- 16-bit input A
        B       : in  std_logic_vector(15 downto 0);   -- 16-bit input B
        product : out std_logic_vector(31 downto 0)    -- 32-bit product output
    );
end multiplier_16;

architecture behavioral of multiplier_16 is

    -- Declare intermediate signals
    type signal_array is array (0 to 15) of std_logic_vector(31 downto 0);
    signal bb      : signal_array;
    signal temp    : signal_array;
    signal addn    : signal_array;
    signal zero    : std_logic_vector(31 downto 0) := (others => '0');
    
begin

    -- Process block triggered on clock and reset
            -- First stage: Perform conversion and addition for the least significant bit
            inst3 : convrt port map (a => A, sel => B(0), b => temp(0));
            inst4 : add_32bit port map (a => zero, b => temp(0)(31 downto 0), z => addn(0));

            -- Generate for each bit of B from 1 to 15
            gen_inst : for i in 1 to 15 generate
                inst1 : convrt port map (a => A, sel => B(i), b => temp(i));
                bb(i) <= temp(i)(31-i downto 0) & zero(i-1 downto 0);
                inst2 : add_32bit port map (a => addn(i-1), b => bb(i), z => addn(i));
            end generate gen_inst;
--    process(clock)
--    begin
--        
--        if rising_edge(clock) then
--
--        end if;
--    end process;

    -- The final product is assigned to the output
    product <= addn(15);

end architecture;
