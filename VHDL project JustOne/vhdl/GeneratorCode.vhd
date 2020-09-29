
library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;

library WORK;

    entity ConvolutionalGenerator is
    	port  (
	    clk			: in std_ulogic; 	-- clock signal
	    reset 		: in std_ulogic;	-- reset signal
	    ak_inputGen		: in std_ulogic;	-- the bit-stream is taken bit a bit
	    ak_OutpuTgen	: out std_ulogic;	-- the ak output, the same in input
	    ck_outGen		: out std_ulogic	-- the result of coding 
    	);
    end ConvolutionalGenerator;

architecture struct of ConvolutionalGenerator is
	
	component ShiftReg
           generic(N_bit : integer := 10);

	   port(
			ak      : in std_logic;           	
			clk     : in std_logic;
      	 	a_rst_n : in std_logic;
			ck_out     : out std_logic			   
    	);
	end component;



	

	signal ck_out : std_logic;
	
   begin

   i_Shift: ShiftReg	
		port map(
  		ak 	 		=>ak_inputGen,
		clk  		 => clk,
		a_rst_n		 => reset,
		ck_out 		 => ck_outGen
   			);

ak_OutpuTgen <= ak_inputGen;
end struct;




