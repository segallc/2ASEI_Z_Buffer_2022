//==============================================================================
//  Filename    : Testbench of bresenham_line from b1                                            
//  Designer    : --
//  Description : Bench of bresenham_line with few first points to calc
//==============================================================================
module tbench_bresenham_line ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic req_int_a, ack_int_a, init,eol, eoc;

logic [23:0] point_a, point_b, point_out_a;

// Other Variables Definition
`define PERIOD 20

//Bresenham_line

brensenham_line u_bresenham_line (
	.clk       ( clk ), //Main clock
	.rst       ( rst ),

	//Communication protocol 
	.req 	   ( req_int_a ),
	.ack 	   ( ack_int_a ),
	//Init variables
	.init 	   ( init ),
	.eoc       ( eoc  ),
	//Output
	.eol 	   ( eol ), 
	//Data in data out
	.point_a   ( point_a ),  //x 23:16 y 15:8 z 7:0
	.point_b   ( point_b ),  //x 23:16 y 15:8 z 7:0
	.point_out ( point_out_a ) //x 23:16 y 15:8 z 7:0
);

// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin
  	rst = 0; point_a = 24'h9090A0; point_b = 24'h253509;eoc = 0; req_int_a = 0; init = 0;#40ns
  	rst = 1;#20ns
  	init = 1;#40ns
  	init = 0;#80ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #200ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #200ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #200ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #200ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  	
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns
  		req_int_a = 1; #40ns
  	req_int_a = 0; #40ns	
  	
  	point_a = 24'h646464; point_b = 24'h725644;
  	init = 1;#20ns
  	init = 0;#20ns
	$stop;
   end
endmodule

