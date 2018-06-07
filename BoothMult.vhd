library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BoothMult is
	generic (
		X : positive := 8;	--X is the number of bit of m
		Y : positive := 8); --Y is the number of bit of r
    port ( 
    	--the algorithm works with numbers represented in two's complement; 
    	--so m and r are two's complements number on X and Y bits.
    	m : in  std_logic_vector(X-1 downto 0); 	-- m is the multiplicand
		r : in  std_logic_vector(Y-1 downto 0);		-- r is the multiplier
		prod : out	std_logic_vector(X+Y-1 downto 0);	-- prod is the product

		clk, reset      : in  std_logic;   
        start           : in  std_logic;
        done            : out std_logic
    );
end BoothMult;

architecture boothmultarch of BoothMult is
	--The alghoritm uses tree variables a, s, and p. They are represent on X+Y+1 bits. 
	 
   	signal a, s, p : signed((X+Y) downto 0);
	signal pp : signed((X+Y)-1 downto 0); --!!!!!!!!!!!RIGUARDA
	signal count : integer := 0;
 	signal todo  : std_logic_vector(1 downto 0);
 	signal ppp : signed((X+Y+1) downto 0);
 	signal ddd  : boolean;

begin
	--a is (m;0) m on X bits and then there is Y+1 bits set to 0.
	--s is ((~m+1);0) the complement of m on X bits and then Y+1 bits set to 0.
	--p is (0;r;0) with the first X bits set to 0, r, and the remaining ones set to 0.
	a(X+Y downto Y+1) <= signed(m(X-1 downto 0));
	a(Y downto 0) <= (others => '0');
	s(X+Y downto Y+1) <= signed(not(m(X-1 downto 0))) + 1;
	s(Y downto 0) <= (others => '0');
	p(X+Y downto Y+1) <= (others => '0');
	p(Y downto 1) <= signed(r(Y-1 downto 0));
	p(0) <= '0';
	
mult: process(clk) --!!!!!!!!!!commentale meglio
 begin
  
  --testing code
  todo <= ppp(1) & ppp(0);
  
  if rising_edge(clk) then
  
	  if (reset = '1') then
		 ppp <= (others => '0');
		 count <= 0;
		 ddd <= false;
	  elsif (start = '1') then
		 ppp <= p;
		 count <= 0;
		 ddd <= false;
	  elsif (count = Y) then
		 ddd <= true;
	  else
		 if (todo = "01") then
			ppp <= ppp + a;
		 elsif (todo = "10") then
			ppp <= ppp + s;
		 end if;
		 count <= count + 1;
		 ppp <= shift_right(ppp,1); --signed shift that maintain the sign of the original number.
		   end if;
		
		pp(X+Y downto 0) <= ppp(X+Y+1 downto 1);
		
		if ddd then
			done <= '1';
		else
			done <= '0';
		end if;
		
	end if;
   
end process;

   --product <= std_logic_vector(s(2*N downto 1));
    --prod((X+Y)-1) <= r(Y-1) xor m(X-1);
    prod((X+Y-1) downto 0) <= std_logic_vector(pp((X+Y) downto 1));

end boothmultarch;


