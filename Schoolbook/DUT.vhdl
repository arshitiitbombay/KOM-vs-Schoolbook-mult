library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port (
        clk : in std_logic; -- Clock signal for sequential operation
        rst : in std_logic; -- Reset signal
        input_chunk : in std_logic_vector(31 downto 0); -- Smaller input bus
        output_chunk : out std_logic_vector(31 downto 0); -- Smaller output bus
        load_input : in std_logic; -- Control signal to load input
        read_output : in std_logic; -- Control signal to read output
        ready : out std_logic -- Status signal
    );
end entity;

architecture DutWrap of DUT is
    signal input_vector : std_logic_vector(255 downto 0); -- Full input vector (internal)
    signal output_vector : std_logic_vector(255 downto 0); -- Full output vector (internal)
    signal input_chunk_counter : integer range 0 to 7 := 0; -- To track 32-bit chunks
    signal output_chunk_counter : integer range 0 to 7 := 0; -- To track 32-bit chunks

    -- Declare the multiplier_128bit component
    component multiplier_128bit is
        port (
            a : in std_logic_vector(127 downto 0);
            b : in std_logic_vector(127 downto 0);
            z : out std_logic_vector(255 downto 0)
        );
    end component;

begin
    -- Chunk loading for input_vector
    process(clk, rst)
    begin
        if rst = '1' then
            input_vector <= (others => '0');
            input_chunk_counter <= 0;
        elsif rising_edge(clk) then
            if load_input = '1' then
                input_vector(input_chunk_counter * 32 + 31 downto input_chunk_counter * 32) <= input_chunk;
                input_chunk_counter <= input_chunk_counter + 1;
                if input_chunk_counter = 7 then
                    input_chunk_counter <= 0; -- Reset counter after loading full input
                end if;
            end if;
        end if;
    end process;

    -- Instantiate the multiplier_128bit
    multiplier_instance: multiplier_128bit
        port map (
            a => input_vector(255 downto 128),
            b => input_vector(127 downto 0),
            z => output_vector
        );

    -- Chunk reading for output_vector
    process(clk, rst)
    begin
        if rst = '1' then
            output_chunk_counter <= 0;
        elsif rising_edge(clk) then
            if read_output = '1' then
                output_chunk <= output_vector(output_chunk_counter * 32 + 31 downto output_chunk_counter * 32);
                output_chunk_counter <= output_chunk_counter + 1;
                if output_chunk_counter = 7 then
                    output_chunk_counter <= 0; -- Reset counter after reading full output
                end if;
            end if;
        end if;
    end process;

    -- Ready signal generation
    ready <= '1' when input_chunk_counter = 0 and output_chunk_counter = 0 else '0';

end DutWrap;

---------------------------------------------------------------------------------------

--library ieee;
--use ieee.std_logic_1164.all;
--
--entity DUT is
--    port(input_vector: in std_logic_vector(255 downto 0);
--       	output_vector: out std_logic_vector(255 downto 0));
--end entity;
--
--architecture DutWrap of DUT is
--   component multiplier_128bit is
--    port (
--        a : in std_logic_vector(127 downto 0);
--        b : in std_logic_vector(127 downto 0);
--        z : out std_logic_vector(255 downto 0)
--    );
--   end component;
----component multiplier_16 is
----    port (
------			clk : in std_logic;
----        a : in std_logic_vector(15 downto 0);
----        b : in std_logic_vector(15 downto 0);
----        product : out std_logic_vector(31 downto 0)
----    );
----end component;
--begin
--
--   -- input/output vector element ordering is critical,
--   -- and must match the ordering in the trace file!
--   add_instance: multiplier_128bit
--			port map (
----					clk => clk,
--					a=> input_vector(255 downto 128),
--					b=> input_vector(127 downto 0),
--					z=> output_vector);
--end DutWrap;



