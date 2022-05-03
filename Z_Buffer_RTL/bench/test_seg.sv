//=============================//==============================================================================
//  Filename    : Segmented testbench for b1                                           
//  Designer    : SEGALL & TARDY
//  Description : Bench with added modules whenever it works
//==============================================================================
module tbench_seg ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req_1, req_2, ack_1, ack_2;
logic       req_int_a, req_int_b, ack_int_a, ack_int_b, req_init, ack_init, eoc, init_br, req_init_br;

logic [23:0] point_a, point_b, point_c, point_out_a, point_out_b, point_max, point_1, point_2;

// Other Variables Definition
`define PERIOD 20

//Module fsm

fsm_b1 u_fsm_b1 (
    .clk         ( clk ) ,
	.rst         ( rst ),
	//Acquisition and request external signals
	.req_1       ( req_1 ),
	.req_2       ( req_2 ),
	.ack_1       ( ack_1 ),
	.ack_2       ( ack_2 ),
	//Acquisition and request internal signals
	.req_int_a   ( req_int_a ),
	.req_int_b   ( req_int_b ),
	.ack_int_a   ( ack_int_a ),
	.ack_int_b   ( ack_int_b ),
	.req_init    ( req_init ),
	.ack_init  	 ( ack_init ),
	.eoc       	 ( eoc ),
	.req_init_br ( req_init_br ),
	.init_br   	 ( init_br )

);

//Module initiator

initiator u_initiator(
    .clk         ( clk ),
    .rst 		 ( rst ),
    .req_init 	 ( req_init ),
    .ack_init 	 ( ack_init ),
    .req_init_br ( req_init_br ),
    .eoc      	 ( eoc ),
    .point_a  	 ( point_a ),
    .point_b  	 ( point_b ),
    .point_c     ( point_c ),
    .point_max   ( point_max ),
    .point_1     ( point_1 ),
    .point_2     ( point_2 ),
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b )
);

	// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

	// Clock and Reset Definitin
always
	 #(`PERIOD/2)clk = ~clk;

initial
    begin
    		point_out_a = 0; point_out_b = 0;
            rst = 1; req_1 = 0;point_a = 24'h013201; point_b = 24'h324501; point_c = 24'h206001;#20ns
            rst = 0;#20ns
            req_1 = 1;#20ns
            req_1 = 0;#1000ns
			$stop;
    end	   
endmodule
