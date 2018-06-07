library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Local libraries
library work;

--! Entity/Package Description
entity BoothMultTestBench is
end entity BoothMultTestBench;


architecture tb of BoothMultTestBench is
	-- clock period
	constant T_CLK  : time := 10 ns;
	
	-- network I want to test
	component BoothMult is
  	port ( 
    		m : in  std_logic_vector(7 downto 0); 	-- m is the multiplicand
		r : in  std_logic_vector(7 downto 0);		-- r is the multiplier
		prod : out	std_logic_vector(15 downto 0);	-- prod is the product

		clk, reset      : in  std_logic;   
       		start           : in  std_logic;
       		done            : out std_logic
    );
  	end component;
	
  	signal M_tb 	  : std_logic_vector(7 downto 0);
  	signal R_tb 	  : std_logic_vector(7 downto 0);
  	signal PROD_tb 	  : std_logic_vector(15 downto 0);
  	signal clk_tb 	  : std_logic := '0';
  	signal rst_tb 	  : std_logic ;
	signal start_tb	  : std_logic;
	signal done_tb    : std_logic;
begin
	
  	clk_tb <= not clk_tb after T_CLK/2;
  	comp : BoothMult port map ( M_tb, R_tb, PROD_tb, clk_tb, rst_tb, start_tb, done_tb );  
  	drive_p: process
	-- variable row : line;
  	begin
		rst_tb <= '1';
  		wait for 2 ns;
  	  	rst_tb <= '0';
	
		-- i test every number from -128 to 127
		stimloop : for i in -128 to 127 loop
			M_tb <= std_logic_vector(to_signed(i, M_tb'length)); 
			R_tb <= std_logic_vector(to_signed(i, M_tb'length));
			wait for T_CLK;
		end loop stimloop;
		wait for T_CLK;
		-- end of simulation
		assert false
       			report "simulation ended"
       			severity failure;
 	end process;
end architecture tb;
