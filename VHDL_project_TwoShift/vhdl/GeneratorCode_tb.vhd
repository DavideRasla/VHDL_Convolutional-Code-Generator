library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
 
entity ConvolutionalGenerator_tb is  
end ConvolutionalGenerator_tb;

architecture bhv of ConvolutionalGenerator_tb is 							-- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
	constant T_CLK   : time := 10 ns; 								-- Clock period
	constant T_RESET : time := 25 ns; 								-- Period before the reset deassertion
  	constant c_WIDTH : natural := 16;								-- Size of the bit-stream
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
	signal clk_tb : std_logic := '0'; 								-- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1';								-- reset signal
	signal ak_tb    : std_ulogic;       								-- ak input signal to connect to the ak port of the simulator
 	signal ak_out_tb    : std_ulogic;	       							-- ak output signal 
    	signal ck_tb    : std_logic;	      								-- ck output signal
	signal end_sim : std_logic := '1'; 								-- signal used to stop the simulation when there is nothing else to test
 	signal r_InputFromSimulator : std_ulogic_vector(c_WIDTH -1  downto 0) := (others => '0');	-- signal used to read from the file 'InputVhd.txt'
    -----------------------------------------------------------------------------------
  file file_VECTORS : text;										-- file used to read 'InputVhd.txt'
  file file_RESULTS : text;										-- file used to write 'OutputVhd.txt'
    -----------------------------------------------------------------------------------
    -- Component to test
    -----------------------------------------------------------------------------------
        component ConvolutionalGenerator is   
    	port  (
	    clk			: in std_ulogic;
	    reset 		: in std_ulogic;
	    ak_inputGen		: in std_ulogic;
	    ak_OutpuTgen	: out std_ulogic;
	    ck_outGen		: out std_ulogic
    	);
    end component;
	
	
	begin
	
	  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  
	  rst_tb <= '0' after T_RESET; 
	  
	  test_ConvolutionalGenerator: ConvolutionalGenerator 
             port map(
			ak_inputGen     => ak_tb,
			ak_OutpuTgen    => ak_out_tb,
			ck_outGen 	=> ck_tb,
			clk     	=> clk_tb,
	       		reset 		=> rst_tb
	           );
	  
	  d_process: process(clk_tb, rst_tb) 
    variable t : integer := 0; 
    variable v_InputLine     : line;									  -- variable used to read a line from 'InputVhd.txt' 
    variable v_OutputLine     : line;									  -- variable used to write a line in 'OutputVhd.txt' 
    variable FileInputSimulator : std_ulogic_vector(c_WIDTH-1 downto 0);
	  begin
	    if(rst_tb = '1') then
	       file_open(file_VECTORS, "InputVhd.txt",  read_mode);					  -- open the file 'InputVhd.txt' 				
	       file_open(file_RESULTS, "OutputVhd.txt",  write_mode);					  -- open the file 'OutputVhd.txt' 	
	-- reads until the end the file 'InputVhd.txt' 	--
	        while not endfile(file_VECTORS) loop
		      readline(file_VECTORS, v_InputLine);
		      read(v_InputLine, FileInputSimulator);
		      r_InputFromSimulator <= FileInputSimulator;
	        end loop;
		  file_close(file_VECTORS);
		  ak_tb <= '0';
		  t := 0;
		elsif(rising_edge(clk_tb)) then
	-- for each value of t reads the next input of the bit-stream --
		 case(t) is  
		   	when 1 => ak_tb  <= r_InputFromSimulator(15); write(v_OutputLine, ck_tb, right, 1); 
			when 2 => ak_tb  <= r_InputFromSimulator(14); write(v_OutputLine, ck_tb, right, 1);
			when 3 => ak_tb  <= r_InputFromSimulator(13); write(v_OutputLine, ck_tb, right, 1);
			when 4 => ak_tb  <= r_InputFromSimulator(12); write(v_OutputLine, ck_tb, right, 1);
			when 5 => ak_tb  <= r_InputFromSimulator(11); write(v_OutputLine, ck_tb, right, 1);
			when 6 => ak_tb  <= r_InputFromSimulator(10); write(v_OutputLine, ck_tb, right, 1);
			when 7 => ak_tb  <= r_InputFromSimulator(9); write(v_OutputLine, ck_tb, right, 1);
			when 8 => ak_tb  <= r_InputFromSimulator(8); write(v_OutputLine, ck_tb, right, 1);
			when 9 => ak_tb  <= r_InputFromSimulator(7); write(v_OutputLine, ck_tb, right, 1);
			when 10 => ak_tb <= r_InputFromSimulator(6); write(v_OutputLine, ck_tb, right, 1);
			when 11 => ak_tb <= r_InputFromSimulator(5); write(v_OutputLine, ck_tb, right, 1);
			when 12 => ak_tb <= r_InputFromSimulator(4); write(v_OutputLine, ck_tb, right, 1);
			when 13 => ak_tb <= r_InputFromSimulator(3); write(v_OutputLine, ck_tb, right, 1);
			when 14 => ak_tb <= r_InputFromSimulator(2); write(v_OutputLine, ck_tb, right, 1);
			when 15 => ak_tb <= r_InputFromSimulator(1); write(v_OutputLine, ck_tb, right, 1);
			when 16 => ak_tb <= r_InputFromSimulator(0); write(v_OutputLine, ck_tb, right, 1);
			when 17 => write(v_OutputLine, ck_tb, right, 1); end_sim <= '0'; writeline(file_RESULTS, v_OutputLine); file_close(file_RESULTS);
            when others => null; 
		  end case;
			  t := t + 1; 
		end if;
	  end process;

end bhv;