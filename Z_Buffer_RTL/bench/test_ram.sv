//==============================================================================
//  Filename    : Testbench for ram from general blocks                                            
//  Designer    : --
//  Description : Bench of ram with different adress to write on
//==============================================================================
module tbench_ram ();

timeunit      1ns;
timeprecision 1ns;

bit clk;

logic	we;

logic [15:0] addr_write;
logic [15:0] addr_read;  
logic [7:0] data_in;   
logic [7:0] data_out;   

// Other Variables Definition
`define PERIOD 20

//Module ram
simple_ram_dual_clock u_ram (
	.data   	 ( data_in ),       //data to be written
	.read_addr   ( addr_read ),     //address for read operation
	.write_addr  ( addr_write ),    //address for write operation
	.we 	     ( we ),            //write enable signal
  	.read_clk    ( clk ),   		//clock signal for read operation
	.write_clk   ( clk ),  	        //clock signal for write operation
	.q 	 		 ( data_out )       //read data
);

	// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

	// Clock and Reset Definitin
always
	 #(`PERIOD/2)clk = ~clk;

initial
begin
	  		data_in = 8'hff; addr_write = 16'h3232; we = 0;#20ns
	  		we = 1;#20ns
	  		we = 0;#50ns
	  		data_in = 8'hA0; addr_write = 16'h6464; we = 1;#30ns
	  		addr_read = 16'h3232; we = 0;#30ns                                                                 
			$stop;
end	   
endmodule
