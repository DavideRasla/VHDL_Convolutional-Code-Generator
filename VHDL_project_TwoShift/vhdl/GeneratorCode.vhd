
library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;

library WORK;

    entity ConvolutionalGenerator is
    	port  (
	    clk			: in std_ulogic; 		-- clock signal
	    reset 		: in std_ulogic;		-- reset signal
	    ak_inputGen		: in std_ulogic;		-- the bit-stream is taken bit a bit
	    ak_OutpuTgen	: out std_ulogic;		-- the ak output, the same in input
	    ck_outGen		: out std_ulogic		-- the result of coding 
    	);
    end ConvolutionalGenerator;

architecture struct of ConvolutionalGenerator is
	
	component ShiftRegAK
           generic(N_bit : integer := 5);

	   port(
		ak      : in std_logic;           		-- input ak in the shift register, in feedforward
		q       : out std_logic_vector(1 downto 0);	-- output from two FF in order to take ak-3 and ak-4 
		clk     : in std_logic;				-- clock signal
      	 	a_rst_n : in std_logic				-- reset signal
    	);
	end component;

	component ShiftRegCK is
       generic(N_bit : integer := 10); 				
	   port(
		ck       : in std_logic;   			--  input ck in the shift register, in feedback
		q       : out std_logic_vector(1 downto 0);	--  output from two FF in order to take ck-8 and ck-10 
		clk     : in std_logic;				--  clock signal
	        a_rst_n : in std_logic   			--  reset signal
            );
	end component;


	

	signal ck_out : std_logic;
	signal outShiftAK : std_logic_vector (1 downto 0);
	signal outShiftCK : std_logic_vector (1 downto 0);
	signal XorAK: std_logic;
	signal XorCK: std_logic;
   begin

   	i_ShiftAk: ShiftRegAK	
		port map(
  		ak 	 	 =>ak_inputGen,
		clk  		 => clk,
		a_rst_n		 => reset,
		q 		 => outShiftAK
   			);

	i_ShiftCk: ShiftRegCK	
		port map(
  		ck 	 	 =>ck_out,
		clk  		 => clk,
		a_rst_n		 => reset,
		q 		 => outShiftCK
				);

XorAK <= outShiftAK(0) xor outShiftAK(1);
XorCK <= outShiftCK(0) xor outShiftCK(1);

ck_out 		<=(XorAK xor XorCK) xor ak_inputGen;
ck_outGen 	<= ck_out;
ak_OutpuTgen 	<= ak_inputGen;

end struct;




