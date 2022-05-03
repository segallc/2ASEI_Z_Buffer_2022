//==============================================================================
//  Filename    : Testbench of initiator from bresenham 1                                            
//  Designer    : --
//  Description : Bench of initiator with different points
//==============================================================================
module tbench_initiator ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

//Communication protocole
logic       req_init, ack_init, eoc;

//Input points for the initiator
logic [23:0] point_a, point_b, point_c;

//Output points from the initiator
logic [23:0] point_max, point_1, point_2;

//Input points comming from bresenham_line
logic [23:0] point_out_a;
logic [23:0] point_out_b;

// Other Variables Definition
`define PERIOD 20

//Initiator block
initiator u_initiator (
	.clk         ( clk ),
	.rst         ( rst ),
	//Acquisition and request external signals
	.req_init    ( req_init ),
	.ack_init    ( ack_init ),
	.eoc         ( eoc ),
	//Input points from the loopback
	.point_a     ( point_a ),
  .point_b     ( point_b ),
  .point_c     ( point_c ),
  .point_out_a ( point_out_a ),
  .point_out_b ( point_out_b ),
    //Output points for the bresenham a and b
  .point_max   ( point_max ),
  .point_1     ( point_1 ),
  .point_2     ( point_2 )
); 
 


// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin                                                                     
  	    req_init = 0; rst = 0; point_out_b = 0; point_out_a = 0; eoc = 0;
		    point_a = 24'h64C864; point_b = 24'h326432; point_c = 24'hFAFAFA;#20ns
        rst= 1 ;#40ns
        req_init = 1;#20ns
        req_init = 0;#100ns
        point_out_a = 24'h453265; point_out_b = 24'h64C864; req_init = 1'b1; #20ns
        req_init = 1'b0; #580ns
        rst = 0;#20ns
        rst = 1;#20ns
        req_init = 1;#20ns
        req_init = 0;#80ns
        eoc = 1;#20ns
        eoc = 0;
		$stop;
   end
endmodule

