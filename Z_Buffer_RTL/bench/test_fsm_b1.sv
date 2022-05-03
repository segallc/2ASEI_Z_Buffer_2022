//==============================================================================
//  Filename    : Testbench of fsm from bresenham 1                                            
//  Designer    : --
//  Description : Bench of fsm with different controls
//==============================================================================
module tbench_fsm_b1 ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit rst;        

logic       req_1, req_2, ack_1, ack_2;
logic       req_int_a, req_int_b, ack_int_a, ack_int_b, req_init, ack_init, eoc, init_br, req_init_br;

// Other Variables Definition
`define PERIOD 20

//FSM
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


// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
always
  #(`PERIOD/2)clk = ~clk;

initial
  begin                                                                     
  	rst = 1; req_1 = 0; ack_2 = 0; ack_int_a = 0; ack_int_b = 0; ack_init = 0; eoc = 0;#40ns
  	rst = 0; #40ns
  	req_1 = 1; #10ns
  	ack_init = 1;#10ns
  	req_1 = 0; #100ns
  	ack_init = 0;#50ns
  	ack_int_a = 1; ack_int_b = 1; #50ns
  	ack_int_a = 0; ack_int_b = 0; #10ns
  	req_init_br = 1; #20ns
  	req_init_br = 0;#20ns
  	ack_2 = 1; #100ns
  	ack_2 = 0; #20ns
    ack_int_a = 1; ack_int_b = 1; #50ns
    ack_int_a = 0; ack_int_b = 0;
    eoc = 1; #20ns
    eoc = 0;
	$stop;
   end
endmodule

