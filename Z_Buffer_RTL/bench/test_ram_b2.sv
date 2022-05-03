//=============================//==============================================================================
//  Filename    : Testbench for ram and b2 from general blocks                                            
//  Designer    : --
//  Description : Trying to write into RAM a line calculated
//==============================================================================
module tbench_ram_b2 ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;

logic	we, req_2, ack_2;

logic [15:0] waddr;
logic [15:0] raddr;  
logic [23:0] data_in;   
logic [7:0] data_outr, data_outg, data_outb;
logic [7:0] rdata, gdata, bdata;

logic [23:0] point_out_a, point_out_b, rgb;


// Other Variables Definition
`define PERIOD 20

//Module ram

simple_ram_dual_clock u_ram_r (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( rdata ),
	.q           ( data_outr )
);

simple_ram_dual_clock u_ram_g (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( gdata ),
	.q           ( data_outg )
); 

simple_ram_dual_clock u_ram_b (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( bdata ),
	.q           ( data_outb )
); 

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
			rgb = 24'haabbcc; raddr = 0; rst = 1; point_out_a = 24'h000032; point_out_b = 24'h020064; data_in = 24'haabbcc;#20ns
			rst = 0;req_2 = 1;#20ns
			req_2 = 0; #1000ns
			raddr = 18'h18000;#80ns
			raddr = 18'h18001;#80ns
			raddr = 18'h18002;#160ns
			$stop;
end	   
endmodule
