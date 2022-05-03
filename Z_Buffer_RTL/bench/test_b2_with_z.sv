//==============================================================================
//  Filename    : Testbench of initiator from bresenham 1                                            
//  Designer    : --
//  Description : Bench of b2 with z
//==============================================================================
module tbench_b2_with_z ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req_2, ack_2;

logic [23:0] point_out_a;
logic [23:0] point_out_b;
logic [23:0] rgb;

logic [7:0] rdata, gdata, bdata, zdata_in, zdata_out;
logic [15:0] waddr, raddr;
logic we,wez;

// Other Variables Definition
`define PERIOD 20

//FSM
b2_with_z u_b2_with_Z (
    .clk          ( clk ), 
    .rst          ( rst ),
    .req_2        ( req_2 ),
    .ack_2        (ack_2 ), 
    .point_out_a  ( point_out_a ),
    .point_out_b  ( point_out_b  ),
    .rgb          ( rgb ),
    .rdata        ( rdata ),
    .gdata        ( gdata ),
    .bdata        ( bdata ),
    .zdata_in     ( zdata_in),
    .zdata_out    ( zdata_out),
    .waddr        ( waddr ),
    .raddr		  ( raddr ),
    .we           ( we ),
    .wez          ( wez )    
);

simple_ram_dual_clock u_ram_z (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( wez ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( zdata_out ),
	.q           ( zdata_in )
);


// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin                                                                     
  	    rst = 0; req_2 = 0; rgb = 24'hAABBCC; point_out_a = 0; point_out_b = 0;#20ns
        rst= 1 ;point_out_a = 24'h323215; point_out_b = 24'h403219;#20ns
        req_2 = 1;#20ns
        req_2 = 0;#1800ns
        rst = 0; req_2 = 0; rgb = 24'hAABBCC; point_out_a = 0; point_out_b = 0;#20ns
        point_out_a = 24'h293230; point_out_b = 24'h453230;#20ns
        
        
		$stop;
   end
endmodule

