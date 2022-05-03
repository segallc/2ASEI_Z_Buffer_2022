//==============================================================================
//  Filename    : Testbench of initiator from bresenham 1                                            
//  Designer    : --
//  Description : Bench of initiator with different points
//==============================================================================
module tbench_b2 ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req_2, ack_2;

logic [23:0] point_out_a;
logic [23:0] point_out_b;
logic [23:0] rgb;

logic [7:0] rdata, gdata, bdata;
logic [17:0] waddr;
logic we;

// Other Variables Definition
`define PERIOD 20

//FSM
bresenham_fill u_bresenham_fill (
    .clk( clk ), 
    .rst( rst ),
    .req_2( req_2 ),
    .ack_2 (ack_2 ), 
    .point_out_a_x ( point_out_a[23:16] ),
    .point_out_b_xy ( point_out_b[23:8]  ),
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

