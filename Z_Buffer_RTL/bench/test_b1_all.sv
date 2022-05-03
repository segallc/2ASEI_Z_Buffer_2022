//=============================//==============================================================================
//  Filename    : Testbench for b1                                           
//  Designer    : SEGALL & TARDY
//  Description : Trying to use b1 to calculate points
//==============================================================================
module tbench_b1_all ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;

logic	req_1, ack_1, req_2, ack_2;
logic   we;

logic [23:0] point_a, point_b, point_c, point_out_a, point_out_b, data_out, rgb; 
logic [7:0] rdata, gdata, bdata;

logic [15:0] waddr, raddr;


// Other Variables Definition
`define PERIOD 20

//Module ram

b1 u_b1( 
    .clk         ( clk ),
    .rst         ( rst ),
    //Acquisition and request with other blocks
    .req_1       ( req_1 ),
    .ack_1       ( ack_1 ),
    .req_2       ( req_2 ),
    .ack_2       ( ack_2 ),
    //Input points to be used
    .point_a     ( point_a ),
    .point_b     ( point_b ),
    .point_c     ( point_c ),
    //Output points for b2
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b )
);

bresenham_fill u_b2 (
    .clk         ( clk ), 
    .rst         ( rst ),
    .req_2       ( req_2 ),
    .ack_2       ( ack_2 ), 
    .point_out_a_x ( point_out_a[23:16] ),
    .point_out_b_xy	 ( point_out_b[23:8] ),
    .rgb         ( rgb ),
    .rdata       ( rdata ),
    .gdata       ( gdata ),
    .bdata       ( bdata ),
    .waddr       ( waddr ),
    .we          ( we )
);


	// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

	// Clock and Reset Definitin
always
	 #(`PERIOD/2)clk = ~clk;

initial
    begin
            rgb = 24'hffffff; raddr = 0;
            rst = 0; req_1 = 1;point_a = 24'h863045; point_b = 24'h9090A0; point_c = 24'h253509;#20ns
            rst = 1	;#20ns
            req_1 = 0;#20ns
            req_1 = 1;#1000ns
			$stop;
    end	   
endmodule
