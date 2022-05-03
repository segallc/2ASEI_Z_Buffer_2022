module tbench_gensync();


timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;

logic	hsync, vsync, img, IMGY_out;

logic [9:0] x;
logic [8:0] y;

// Other Variables Definition
`define PERIOD 20

//Module gensync

gensync u_gensync (
	.CLK      ( clk ),
	.reset    ( rst ),
	.HSYNC    ( hsync ),
	.VSYNC    ( vsync ),
	.IMG   	  ( img ),
	.IMGY_out ( IMGY_out ),
	.X        ( x ),
	.Y        ( y )
);


	// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

	// Clock and Reset Definitin
always
	 #(`PERIOD/2)clk = ~clk;

initial
begin
			rst = 1;#20ns
            rst = 0;#500ns
			$stop;
end	   
endmodule
