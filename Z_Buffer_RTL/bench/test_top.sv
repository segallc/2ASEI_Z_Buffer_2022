//=============================//==============================================================================
//  Filename    : Testbench for all blocks                                           
//  Designer    : SEGALL & TARDY
//  Description : Trying to write into RAM a whole triangle from point
// point_a, point_b and point_c
//==============================================================================
module tbench_top ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;

logic	key1, req_1;



// Other Variables Definition
`define PERIOD 20

//Module ram

top u_top( 
    .clk     ( clk   ),
    .rst     ( rst   ),
    .key1    ( key1  ),
    .req_1   ( req_1 )
);
	// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

	// Clock and Reset Definitin
always
	 #(`PERIOD/2)clk = ~clk;

initial
    begin
            rst = 1'b0;key1 = 1'b1; req_1 = 1'b1; #20ns
            rst = 1;#90ns
            req_1 = 1'b0;#20ns
            req_1 = 1'b1;#1000ns
            key1 = 1'b1;#1298202ns
            key1  = 1'b0;#20ns
            key1 = 1'b1;#1000ns
            req_1 = 1'b0;#20ns
            req_1 = 1'b1;
			$stop;
    end	   
endmodule
