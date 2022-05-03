//==============================================================================
//  Filename    : Testbench of initiator from bresenham 1                                            
//  Designer    : --
//  Description : Bench of b2 without z
//==============================================================================
module tbench_b2_without_z ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req_2, ack_2;

logic [23:0] point_out_a;
logic [23:0] point_out_b;
logic [23:0] rgb;

logic [7:0] rdata, gdata, bdata;
logic [15:0] waddr;
logic we;

// Other Variables Definition
`define PERIOD 20

//FSM
b2 u_b2 (
    .clk( clk ), 
    .rst( rst ),
    .req_2( req_2 ),
    .ack_2 (ack_2 ), 
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b  ),
    .rgb ( rgb ),
    .rdata ( rdata ),
    .gdata ( gdata ),
    .bdata ( bdata ),
    .waddr ( waddr ),
    .we ( we )
); 


// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin                                                                     
  	    rst = 1; req_2 = 0; rgb = 24'hAABBCC; point_out_a = 0; point_out_b = 0;#20ns
        rst= 0 ;point_out_a = 24'h003200; point_out_b = 24'h013200;#20ns
        req_2 = 1;#20ns
        req_2 = 0;#1200ns
		$stop;
   end
endmodule

