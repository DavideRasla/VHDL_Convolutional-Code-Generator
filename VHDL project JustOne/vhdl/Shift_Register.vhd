library IEEE;
use IEEE.std_logic_1164.all;

entity ShiftReg is   											
       generic(N_bit : integer); 								 
	   port(
			ak      : in std_logic;           						--  Shift register input
			clk     : in std_logic;								--  Clock
      	 		a_rst_n : in std_logic;								--  Reset 
			ck_out     : out std_logic							--  Shift register output
							   
						    );
end ShiftReg;

architecture bhv of ShiftReg is 								 

signal  q_s  : std_logic_vector(N_bit - 1 downto 0);
signal  q_g_xor  : std_logic;
signal  q_h_xor  : std_logic;
begin


	shift_reg_proc: process(clk,a_rst_n) 					 	 
		begin
		
			if(a_rst_n = '1') then    							
			   q_s <= (others => '0'); 							   
			
			elsif(rising_edge(clk)) then  						  	 -- Positive edge trigger D-flip-flop register modelling
			   q_s(0)      <= ak xor q_g_xor; 					  	 -- Sampling the input ak
			   q_s(N_bit - 1 downto 1) <= q_s(N_bit - 2 downto 0); 			  	 -- Shifting the internal bits
			end if; 
	end process;

q_g_xor <=  (q_s(7)) xor  (q_s(9)) ; 									 -- Performing ck-8 + ck-10
q_h_xor <=  (ak xor q_g_xor) xor (q_s(2)  xor  q_s(3)) ; 						 -- ak + ck-8 + ck-10 + ak-3 + ak-4
ck_out  <= q_h_xor;											 -- Result to Ck

end bhv;