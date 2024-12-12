library ieee;
use ieee.std_logic_1164.all;


entity kom is
port (a,b: in std_logic_vector(127 downto 0);
		opt: out std_logic_vector(255 downto 0)
		);
end entity;

architecture arch of kom is

--------------------------------------------------------------------------
component multiplier_65 is
    Port (
        A      : in  std_logic_vector(64 downto 0);  -- 65-bit input
        B      : in  std_logic_vector(64 downto 0);  -- 65-bit input
        product : out std_logic_vector(129 downto 0) -- 130-bit product
    );
end component;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
component multiplier_64bit is
    port (
        a : in std_logic_vector(63 downto 0);
        b : in std_logic_vector(63 downto 0);
        z : out std_logic_vector(127 downto 0)
    );
end component;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
component add_66bit is
    port (
        a : in  std_logic_vector(65 downto 0);  -- 66-bit input
        b : in  std_logic_vector(65 downto 0);  -- 66-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(66 downto 0)   -- 67-bit sum
    );
end component add_66bit;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
component add_64bit is
    port (
        a : in  std_logic_vector(63 downto 0);  -- 64-bit input
        b : in  std_logic_vector(63 downto 0);  -- 64-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(64 downto 0)   -- 65-bit sum
    );
end component add_64bit;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
component add_62bit is
    port (
        a : in  std_logic_vector(61 downto 0);  -- 62-bit input
        b : in  std_logic_vector(61 downto 0);  -- 62-bit input
		  cin: in std_logic;								-- input carry
        z : out std_logic_vector(62 downto 0)   -- 63-bit sum
    );
end component add_62bit;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
component subtractor_130bit is
    port (
        a    : in  std_logic_vector(129 downto 0); -- 130-bit input A
        b    : in  std_logic_vector(129 downto 0); -- 130-bit input B
        y    : out std_logic_vector(129 downto 0);	-- 130-bit result Y = A - B
        cout : out std_logic                    	-- Carry out (underflow indicator)
    );
end component subtractor_130bit;
--------------------------------------------------------------------------

signal al, ar, bl, br : std_logic_vector(63 downto 0);
signal am, bm : std_logic_vector(64 downto 0);
signal opl, opr : std_logic_vector(127 downto 0);
signal opm: std_logic_vector(129 downto 0);
signal xm,xm_1: std_logic_vector(129 downto 0);
signal y1: std_logic_vector(64 downto 0);
signal y2: std_logic_vector(66 downto 0);
signal addit: std_logic_vector(61 downto 0);
signal slast: std_logic_vector(62 downto 0);
signal cout, c1, c2: std_logic;
signal opls,oprs : std_logic_vector(129 downto 0);
signal zero : std_logic :='0';

begin

al <= a(127 downto 64);
ar <= a(63 downto 0);
bl <= b(127 downto 64);
br <= b(63 downto 0);

add1: add_64bit port map(a=>al, b=>ar, cin=>'0', z=>am);			--add both halves of a--
add2: add_64bit port map(a=>bl, b=>br, cin=>'0', z=>bm);			--add both halves of b--

multiply1: multiplier_64bit port map(a=> al, b=> bl, z=> opl);			--multiply lefthalf--
multiply2: multiplier_64bit port map(a=> ar, b=> br, z=> opr);			--multiply righthalf--
multiply3: multiplier_65 port map(a=> am, b=> bm, product=> xm);				--multiply sum of halves--

opls <= "00" & opl;
oprs <= "00" & opr;

subt1: subtractor_130bit port map(a=>xm, b=>opls, y=>xm_1, cout=>c1);						--Xm - opl--
subt2: subtractor_130bit port map(a=>xm_1, b=>oprs, y=>opm, cout=>c2);						--(Xm - opl) - opr--

opt(63 downto 0) <= opr(63 downto 0);								-- first 64 bits--
add3: add_64bit port map(a=>opr(127 downto 64), b=>opm(63 downto 0), cin=>zero, z=>y1);
opt(127 downto 64) <= y1(63 downto 0);								-- next 64 bits--
add4: add_66bit port map(a=>opm(129 downto 64), b=>opl(65 downto 0),cin=>y1(64), z=>y2);
opt(193 downto 128) <= y2(65 downto 0);							-- ls66bit in the second half--

assign: for i in 0 to 61 generate
	addit(i) <='0';
end generate assign;								-- left 62 bits--
add5: add_62bit port map(a=>opl(127 downto 66), b=>addit, cin=>y2(66), z=>slast);	
opt(255 downto 194) <= slast(61 downto 0);
end arch;