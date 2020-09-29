library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
 
entity ConvolutionalGenerator_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end ConvolutionalGenerator_tb;

architecture bhv of ConvolutionalGenerator_tb is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns; -- Period before the reset deassertion
	-----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
	signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1'; -- reset signal
	signal ak_tb    : std_logic;        -- d signal to connect to the d port of the component
    signal ak_out_tb    : std_logic;	       -- q signal to connect to the q port of the component
    signal ck_tb    : std_logic;	       -- q signal to connect to the q port of the component
	signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test

  -----------------------------------------------------------------------------
  file file_VECTORS : text;
  file file_RESULTS : text;
  constant c_WIDTH : natural := 16;

  signal InputFile : std_logic_vector(c_WIDTH -1  downto 0) := (others => '0');
  signal ck_To_test : std_logic_vector( 31 downto 0) := (others => '0'); --
    -----------------------------------------------------------------------------------
    -- Component to test (DUT) declaration
    -----------------------------------------------------------------------------------
        component ConvolutionalGenerator is      
    	port  (
	    clk				: in std_ulogic;
	    reset 			: in std_ulogic;
	    ak_inputGen		: in std_ulogic;
	    ak_OutpuTgen	: out std_ulogic;
	    ck_outGen		: out std_ulogic
    	);
    end component;
	
	
	begin
	
	  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	  rst_tb <= '0' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
	  
	  test_ConvolutionalGenerator: ConvolutionalGenerator  -- Shift register instantiation
             port map(
			ak_inputGen       => ak_tb,
			ak_OutpuTgen       => ak_out_tb,
			ck_outGen => ck_tb,
			clk     => clk_tb,
	        reset => rst_tb
	           );
	  
	  d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
		variable t : integer := 0; -- variable used to count the clock cycle after the reset
	    variable v_InputLINE     : line;
	variable k : integer := 0;
    variable v_OutputLINE     : line;
    variable v_InputFile : std_logic_vector(c_WIDTH-1 downto 0);
	  begin
	    if(rst_tb = '1') then
		if(k = 0) then
	       		file_open(file_VECTORS, "InputVhd.txt",  read_mode);
	       		file_open(file_RESULTS, "OutputVhd.txt",  write_mode);
			k:= k+1;		
	        while not endfile(file_VECTORS) loop
		      readline(file_VECTORS, v_InputLINE);
		      read(v_InputLINE, v_InputFile);
		      InputFile <= v_InputFile;
		         end loop;
		   file_close(file_VECTORS);
			  k:= k+1;
		end if;
		  ak_tb <= '0';
		  t := 0;

		elsif(rising_edge(clk_tb)) then
		 case(t) is  
		   	when 1 => ak_tb  <= InputFile(15); write(v_OutputLINE, ck_tb, right, 1);
			when 2 => ak_tb  <= InputFile(14); write(v_OutputLINE, ck_tb, right, 1);
			when 3 => ak_tb  <= InputFile(13); write(v_OutputLINE, ck_tb, right, 1);
			when 4 => ak_tb  <= InputFile(12); write(v_OutputLINE, ck_tb, right, 1);
			when 5 => ak_tb  <= InputFile(11); write(v_OutputLINE, ck_tb, right, 1);
			when 6 => ak_tb  <= InputFile(10); write(v_OutputLINE, ck_tb, right, 1);
			when 7 => ak_tb  <= InputFile(9); write(v_OutputLINE, ck_tb, right, 1);
			when 8 => ak_tb  <= InputFile(8); write(v_OutputLINE, ck_tb, right, 1);
			when 9 => ak_tb  <= InputFile(7); write(v_OutputLINE, ck_tb, right, 1);
			when 10 => ak_tb <= InputFile(6); write(v_OutputLINE, ck_tb, right, 1);
			when 11 => ak_tb <= InputFile(5); write(v_OutputLINE, ck_tb, right, 1);
			when 12 => ak_tb <= InputFile(4); write(v_OutputLINE, ck_tb, right, 1);
			when 13 => ak_tb <= InputFile(3); write(v_OutputLINE, ck_tb, right, 1);
			when 14 => ak_tb <= InputFile(2); write(v_OutputLINE, ck_tb, right, 1);
			when 15 => ak_tb <= InputFile(1); write(v_OutputLINE, ck_tb, right, 1);
			when 16 => ak_tb <= InputFile(0); write(v_OutputLINE, ck_tb, right, 1);
			when 17 =>  write(v_OutputLINE, ck_tb, right, 1); end_sim <= '0'; writeline(file_RESULTS, v_OutputLINE); file_close(file_RESULTS);
            when others => null; 
		  end case;
			  t := t + 1; 
		end if;
	  end process;
	
end bhv;