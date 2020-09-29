library IEEE;
use IEEE.std_logic_1164.all;

entity ShiftRegCK is   				
       generic(N_bit : integer := 10); 				
	   port(
		ck       : in std_logic;   							 --  Shift register input
		q       : out std_logic_vector(1 downto 0);					 --  Shift register output
		clk     : in std_logic;							  	 --  clk
	        a_rst_n : in std_logic   							 --  Asynchronous active low reset
	       );
end ShiftRegCK;

architecture bhv of ShiftRegCK is 		

signal q_s : std_logic_vector(N_bit - 1 downto 0);						 -- internal signal used to map the internal registers

begin
	
	shift_reg_proc: process(clk,a_rst_n) 					 	  	 -- Process realizing a sequential network with asynchronous reset
		begin
		
			if(a_rst_n = '1') then    							
			   q_s <= (others => '0'); 							   
			
			elsif(rising_edge(clk)) then  						 -- Positive edge trigger D-flip-flop register modelling
			   q_s(0)                  <= ck; 					 -- Sampling the input d
			   q_s(N_bit - 1 downto 1) <= q_s(N_bit - 2 downto 0);			 -- Shifting the internal bits
			end if; 
	end process;      

    q(0) <= q_s(7);										 -- takes the output of ck-8
    q(1) <= q_s(9);										 -- takes the output of ck-10
end bhv;

