-------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package components is

    component mux is
        port (
            I0, I1 : in std_logic;
            sel    : in std_logic;
            Y      : out std_logic
        );
    end component;

    component FA is
        port (
            a : in std_logic_vector(2 downto 0);  -- a1, a0, carry
            b : out std_logic_vector(1 downto 0)  -- b1, b0
        );
    end component;

    component convrt is
        port (
            a   : in std_logic_vector(15 downto 0); 
            sel : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_1 is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_1_right is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_2 is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_4 is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_8 is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component shift_16 is
        port (
            a   : in std_logic_vector(31 downto 0);
            set : in std_logic;
            b   : out std_logic_vector(31 downto 0)
        );
    end component;

    component add_32bit is
        port (
            a, b : in std_logic_vector(31 downto 0);
            z    : out std_logic_vector(31 downto 0)
        );
    end component;

    component add_4bit is
        port (
            a, b : in std_logic_vector(3 downto 0);
            z    : out std_logic_vector(4 downto 0)
        );
    end component;
	 
	 component add_64bit is
    port (
        a : in  std_logic_vector(63 downto 0);  
        b : in  std_logic_vector(63 downto 0);  
        z : out std_logic_vector(63 downto 0)   
			);
	 end component;


component add_66bit is
    port (
        a : in  std_logic_vector(65 downto 0);  -- 66-bit input
        b : in  std_logic_vector(65 downto 0);  -- 66-bit input
        z : out std_logic_vector(66 downto 0)   -- 67-bit sum
    );
end component;

component add_130bit is
    port (
        a : in  std_logic_vector(129 downto 0);  -- 130-bit input
        b : in  std_logic_vector(129 downto 0);  -- 130-bit input
        z : out std_logic_vector(129 downto 0)   -- 130-bit sum
    );
end component;

component add_48bit is
    port (
        a : in  std_logic_vector(47 downto 0);  -- 130-bit input
        b : in  std_logic_vector(47 downto 0);  -- 130-bit input
        z : out std_logic_vector(47 downto 0)   -- 130-bit sum
    );
end component;

component add_96bit is
    port (
        a : in  std_logic_vector(95 downto 0);  -- 130-bit input
        b : in  std_logic_vector(95 downto 0);  -- 130-bit input
        z : out std_logic_vector(95 downto 0)   -- 130-bit sum
    );
end component;

component add_192bit is
    port (
        a : in  std_logic_vector(191 downto 0);  -- 130-bit input
        b : in  std_logic_vector(191 downto 0);  -- 130-bit input
        z : out std_logic_vector(191 downto 0)   -- 130-bit sum
    );
end component;



end package components;


----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														--MUX
    );
end entity;

architecture struct of mux is
begin
    Y <= (I0 AND NOT sel) OR (I1 AND sel);
end architecture;

----------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FA is
    port (
        a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
    );
end entity;

architecture Behavioral of FA is
    signal sum_bit, carry_1, carry_2 : std_logic;  							 -- FA
begin
    sum_bit <= a(0) XOR a(2);
    carry_1 <= a(0) AND a(2);

    b(0) <= a(1) XOR sum_bit;
    carry_2 <= a(1) AND sum_bit;

    b(1) <= carry_1 OR carry_2;
end architecture;



-------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity convrt is
    port (
        a : in std_logic_vector(15 downto 0); 
        sel : in std_logic;                    
        b : out std_logic_vector(31 downto 0)  
    );
end entity;

architecture struct of convrt is
    signal x : std_logic_vector(15 downto 0) := (others => '0'); 			-- CONVRT
begin
    converter: for i in 0 to 15 generate
        and_g: b(i) <= sel and a(i);
    end generate converter;

    converter2: for i in 16 to 31 generate
        zero_assign: b(i) <= '0';
    end generate converter2;
end struct;


-----------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_1_right is
    port (
        a : in std_logic_vector(31 downto 0); 
        set : in std_logic;
        b : out std_logic_vector(31 downto 0)
    );
end entity;
																								-- Shift 1 Right
architecture struct of shift_1_right is

component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														--MUX
    );
end component;

begin
    shift_process: for i in 0 to 31 generate
        lsb: if i > 0 generate
            mux_inst: mux port map(I0 => a(i), I1 => a(i - 1), sel => set, Y => b(i));
        end generate lsb;

        msb: if i < 1 generate
            mux_inst: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
        end generate msb;
    end generate shift_process;
end struct;

-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_1 is

port (a : in std_logic_vector(31 downto 0); set : in std_logic;
b : out std_logic_vector(31 downto 0) 
);

end entity;

architecture struct of shift_1 is

component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														--MUX
    );
end component;

begin

n4_bit : for i in 0 to 31 generate													-----SHIFT 1

lsb: if i < 31 generate
b2: mux port map(I0 => a(i), I1 => a(i+1), sel => set, Y => b(i));
end generate lsb;

msb: if i > 30 generate

b2: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
end generate msb;
end generate n4_bit ;

end struct;

-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_2 is

port (a : in std_logic_vector(31 downto 0); set : in std_logic;
b : out std_logic_vector(31 downto 0) 
);

end entity;

architecture struct of shift_2 is
component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														
    );
end component;
begin

n4_bit : for i in 0 to 31 generate													-----SHIFT 2

lsb: if i < 30 generate
b2: mux port map(I0 => a(i), I1 => a(i+1), sel => set, Y => b(i));
end generate lsb;

msb: if i > 29 generate

b2: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
end generate msb;
end generate n4_bit ;

end struct;

-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_4 is

port (a : in std_logic_vector(31 downto 0); set : in std_logic;
b : out std_logic_vector(31 downto 0) 
);

end entity;

architecture struct of shift_4 is
component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														
    );
end component;
begin

n4_bit : for i in 0 to 31 generate													-----SHIFT 4

lsb: if i < 28 generate
b2: mux port map(I0 => a(i), I1 => a(i+1), sel => set, Y => b(i));
end generate lsb;

msb: if i > 27 generate

b2: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
end generate msb;
end generate n4_bit ;

end struct;

-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_8 is

port (a : in std_logic_vector(31 downto 0); set : in std_logic;
b : out std_logic_vector(31 downto 0) 
);

end entity;

architecture struct of shift_8 is
component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														
    );
end component;
begin

n4_bit : for i in 0 to 31 generate														-----SHIFT 8

lsb: if i < 24 generate
b2: mux port map(I0 => a(i), I1 => a(i+1), sel => set, Y => b(i));
end generate lsb;

msb: if i > 23 generate

b2: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
end generate msb;
end generate n4_bit;

end struct;

-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_16 is

port (a : in std_logic_vector(31 downto 0); set : in std_logic;
b : out std_logic_vector(31 downto 0) 
);

end entity;

architecture struct of shift_16 is
component mux is
    port (
        I0, I1 : in std_logic;
        sel    : in std_logic;
        Y      : out std_logic														
    );
end component;
begin

n4_bit : for i in 0 to 31 generate														-----SHIFT 16

lsb: if i < 16 generate
b2: mux port map(I0 => a(i), I1 => a(i+1), sel => set, Y => b(i));
end generate lsb;

msb: if i > 15 generate

b2: mux port map(I0 => a(i), I1 => '0', sel => set, Y => b(i));
end generate msb;
end generate n4_bit;

end struct;



--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_32bit is
    port (
        a : in  std_logic_vector(31 downto 0);  
        b : in  std_logic_vector(31 downto 0);  
        z : out std_logic_vector(31 downto 0)   
    );
end entity add_32bit;

architecture struct of add_32bit is

    signal carry : std_logic_vector(31 downto 0);

    component FA is
        port (
        a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
        );
    end component;															--------32 bit adder

begin

    FA0: FA port map (a(0) => a(0),														
            a(1) => b(0),
            a(2) => '0',  
            b(0) => z(0),
            b(1) => carry(0) );  

    gen_adders: for i in 1 to 31 generate
        FA_i: FA port map (
            a(0) => a(i),														
            a(1) => b(i),
            a(2) => carry(i - 1),  
            b(0) => z(i),
            b(1) => carry(i)     
        );
    end generate gen_adders;

end struct;

------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_4bit is
    port (
        a : in  std_logic_vector(3 downto 0);  
        b : in  std_logic_vector(3 downto 0);  
        z : out std_logic_vector(4 downto 0)   
    );
end entity add_4bit;

architecture struct of add_4bit is

    signal carry : std_logic_vector(3 downto 0);

    component FA is
        port (
             a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
        );
    end component;															--------4 bit adder

begin

    FA0: FA port map (a(0) => a(0),														
            a(1) => b(0),
            a(2) => '0',  
            b(0) => z(0),
            b(1) => carry(0)   );  

    gen_adders: for i in 1 to 4 generate
        FA_i: FA port map (
            a(0) => a(i),														
            a(1) => b(i),
            a(2) => carry(i - 1),  
            b(0) => z(i),
            b(1) => carry(i)    
        );
    end generate gen_adders;

end struct;
-----------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_64bit is
    port (
        a : in  std_logic_vector(63 downto 0);  
        b : in  std_logic_vector(63 downto 0);  
        z : out std_logic_vector(63 downto 0)   
    );
end entity add_64bit;

architecture struct of add_64bit is

    signal carry : std_logic_vector(63 downto 0);

    component FA is
        port (
        a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
        );
    end component;															--------64 bit adder

begin

    FA0: FA port map (a(0) => a(0),														
            a(1) => b(0),
            a(2) => '0',  
            b(0) => z(0),
            b(1) => carry(0) );  

    gen_adders: for i in 1 to 63 generate
        FA_i: FA port map (
            a(0) => a(i),														
            a(1) => b(i),
            a(2) => carry(i - 1),  
            b(0) => z(i),
            b(1) => carry(i)     
        );
    end generate gen_adders;

end struct;

-----------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_128bit is
    port (
        a : in  std_logic_vector(127 downto 0);  
        b : in  std_logic_vector(127 downto 0);  
        z : out std_logic_vector(127 downto 0)   
    );
end entity add_128bit;

architecture struct of add_128bit is

    signal carry : std_logic_vector(127 downto 0);

    component FA is
        port (
        a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
        );
    end component;															--------128 bit adder

begin

    FA0: FA port map (a(0) => a(0),														
            a(1) => b(0),
            a(2) => '0',  
            b(0) => z(0),
            b(1) => carry(0) );  

    gen_adders: for i in 1 to 127 generate
        FA_i: FA port map (
            a(0) => a(i),														
            a(1) => b(i),
            a(2) => carry(i - 1),  
            b(0) => z(i),
            b(1) => carry(i)     
        );
    end generate gen_adders;

end struct;

-----------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_256bit is
    port (
        a : in  std_logic_vector(255 downto 0);  
        b : in  std_logic_vector(255 downto 0);  
        z : out std_logic_vector(255 downto 0)   
    );
end entity add_256bit;

architecture struct of add_256bit is

    signal carry : std_logic_vector(255 downto 0);

    component FA is
        port (
        a : in std_logic_vector(2 downto 0);
        b : out std_logic_vector(1 downto 0)
        );
    end component;															--------256 bit adder

begin

    FA0: FA port map (a(0) => a(0),														
            a(1) => b(0),
            a(2) => '0',  
            b(0) => z(0),
            b(1) => carry(0) );  

    gen_adders: for i in 1 to 255 generate
        FA_i: FA port map (
            a(0) => a(i),														
            a(1) => b(i),
            a(2) => carry(i - 1),  
            b(0) => z(i),
            b(1) => carry(i)     
        );
    end generate gen_adders;

end struct;

------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_33bit is
    port (
        a : in  std_logic_vector(32 downto 0);  -- 33-bit input
        b : in  std_logic_vector(32 downto 0);  -- 33-bit input
        z : out std_logic_vector(32 downto 0)   -- 33-bit sum
    );
end entity add_33bit;

architecture struct of add_33bit is

    signal carry : std_logic_vector(32 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin																						--33 bit adder

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 32)
    gen_adders: for i in 1 to 32 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

end struct;

---------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_130bit is
    port (
        a : in  std_logic_vector(129 downto 0);  -- 130-bit input
        b : in  std_logic_vector(129 downto 0);  -- 130-bit input
        z : out std_logic_vector(129 downto 0)   -- 130-bit sum
    );
end entity add_130bit;

architecture struct of add_130bit is

    signal carry : std_logic_vector(129 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 129)
    gen_adders: for i in 1 to 129 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

end struct;

-----------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_66bit is
    port (
        a : in  std_logic_vector(65 downto 0);  -- 66-bit input
        b : in  std_logic_vector(65 downto 0);  -- 66-bit input
        z : out std_logic_vector(66 downto 0)   -- 67-bit sum
    );
end entity add_66bit;

architecture struct of add_66bit is

    signal carry : std_logic_vector(65 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 129)
    gen_adders: for i in 1 to 65 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

end struct;

-----------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_48bit is
    port (
        a : in  std_logic_vector(47 downto 0);  -- 48-bit input
        b : in  std_logic_vector(47 downto 0);  -- 48-bit input
        z : out std_logic_vector(47 downto 0)   -- 49-bit sum
    );
end entity add_48bit;

architecture struct of add_48bit is

    signal carry : std_logic_vector(47 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 47)
    gen_adders: for i in 1 to 47 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

 

end struct;

--------------------\---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_96bit is
    port (
        a : in  std_logic_vector(95 downto 0);  -- 96-bit input
        b : in  std_logic_vector(95 downto 0);  -- 96-bit input
        z : out std_logic_vector(95 downto 0)   -- 97-bit sum
    );
end entity add_96bit;

architecture struct of add_96bit is

    signal carry : std_logic_vector(95 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 95)
    gen_adders: for i in 1 to 95 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

    

end struct;
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_192bit is
    port (
        a : in  std_logic_vector(191 downto 0);  -- 192-bit input
        b : in  std_logic_vector(191 downto 0);  -- 192-bit input
        z : out std_logic_vector(191 downto 0)   -- 193-bit sum
    );
end entity add_192bit;

architecture struct of add_192bit is

    signal carry : std_logic_vector(191 downto 0);

    -- Full Adder component declaration
    component FA is
        port (
            a : in std_logic_vector(2 downto 0);
            b : out std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- First full adder (least significant bit)
    FA0: FA port map (
        a(0) => a(0),
        a(1) => b(0),
        a(2) => '0',  -- no previous carry for the first bit
        b(0) => z(0),
        b(1) => carry(0)
    );

    -- Generate adders for the remaining bits (1 to 191)
    gen_adders: for i in 1 to 191 generate
        FA_i: FA port map (
            a(0) => a(i),
            a(1) => b(i),
            a(2) => carry(i - 1),  -- carry from the previous bit
            b(0) => z(i),
            b(1) => carry(i)
        );
    end generate gen_adders;

   

end struct;


