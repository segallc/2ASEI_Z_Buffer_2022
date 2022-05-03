//==============================================================================
//  Filename    : Testbench of initiator from bresenham 1                                            
//  Designer    : --
//  Description : Bench of starter with different points
//==============================================================================
module tbench_starter ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req1, ack1, key1;

logic [23:0] point_a, point_b, point_c, color;

logic [3:0] addr;

// Other Variables Definition
`define PERIOD 20

//FSM
starter u_starter(
    .clk 		 ( clk ),
    .rst 		 ( rst ),
    .req_1 		 ( req1 ),
    .ack_1		 ( ack1 ),
    .address     ( addr ),
    .key1		 ( key1 )
);

rom_a u_rom_a (
	.address ( addr ),
	.data_q  ( point_a )
);

rom_b u_rom_b (
	.address ( addr ),
	.data_q  ( point_b )
);

rom_c u_rom_c (
	.address ( addr ),
	.data_q  ( point_c )
);

rom_rgb u_rom_rgb (
	.address ( addr ),
	.data_q  ( color )
);

// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin                                                                     
  	    rst = 0; ack1 = 0; key1 = 1; #40ns
        rst= 1;#20ns
        key1 = 0;#20ns;
        key1 = 1; ack1 = 1;#500ns
        ack1 = 1;#50ns
        ack1=0;#40ns
 		key1 = 0;#20ns;
        key1 = 1; ack1 = 1;#500ns
        ack1 = 1;#50ns
        ack1=0;#40ns
        key1 = 0;#20ns;
        key1 = 1; ack1 = 1;#500ns
        ack1 = 1;#50ns
        ack1=0;#40ns
        key1 = 0;#20ns;
        key1 = 1; ack1 = 1;#500ns
        ack1 = 1;#50ns
        ack1=0;#40ns
		$stop;
   end
endmodule

