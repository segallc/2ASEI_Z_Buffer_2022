//================================================
//   Filename    : Bloc b1 
//   Designer    : SEGALL & TARDY
//   Description : Bloc B1 faisant appel aux autres sous-blocs
//================================================

module b1( 
    input  logic clk,
    input  logic rst,
    //Acquisition and request with other blocks
    input  logic req_1,
    output logic ack_1,
    output logic req_2,
    input  logic ack_2,
    //Input points to be used
    input  logic [23:0] point_a,
    input  logic [23:0] point_b,
    input  logic [23:0] point_c,
    //Output points for b2
    output logic [23:0] point_out_a,
    output logic [23:0] point_out_b
);
 
// == Variables Declaration =======================

logic req_int_a, req_int_b, ack_int_a, ack_int_b;

logic req_init, eoc, eol_a, eol_b, ack_init, init_br;

logic [23:0] point_max, point_1, point_2;

//==Main code======================================

fsm_b1 u_fsm_b1(
	.clk 		  ( clk ),
	.rst 		  ( rst ),
	//Acquisition and request external signals
	.req_1 		  ( req_1 ),
	.req_2 		  ( req_2 ),
	.ack_1 		  ( ack_1 ),
	.ack_2 	      ( ack_2 ),
	//Acquisition and request internal signals
	.req_int_a    ( req_int_a ),
	.req_int_b    ( req_int_b ),
	.ack_int_a    ( ack_int_a ),
	.ack_int_b 	  ( ack_int_b ),
	.req_init     ( req_init ),
	.ack_init     ( ack_init ),
    .init_br      ( init_br ),
    .eoc          ( eoc ),
    .eol_a		  ( eol_a ),
    .eol_b        ( eol_b )
);

initiator u_initiator (
	.clk 		 ( clk ),
	.rst 		 ( rst ),
	//Acquisition and request external signals
	.req_init    ( req_init ),
	.ack_init 	 ( ack_init ),
	.eoc         ( eoc ),
	//Input points from the loopback
	.point_a 	 ( point_a ),
    .point_b 	 ( point_b ),
    .point_c     ( point_c ),
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b ),
    //Output points for the bresenham a and b
    .point_max   ( point_max ),
    .point_1     ( point_1 ),
    .point_2	 ( point_2 )
);

brensenham_line u_bresenham_line_a (
	.clk       ( clk ), //Main clock
	.rst       ( rst ),
	//Communication protocol 
	.req 	   ( req_int_a ),
	.ack 	   ( ack_int_a ),
	//Init variables
	.init 	   ( init_br ),
	.eol       ( eol_a ),
	.eoc 	   ( eoc ),
	//Data in data out
	.point_a   ( point_max ),  //x 23:16 y 15:8 z 7:0
	.point_b   ( point_1 ),  //x 23:16 y 15:8 z 7:0
	.point_out ( point_out_a ) //x 23:16 y 15:8 z 7:0
);

brensenham_line u_bresenham_line_b (
	.clk       ( clk ), //Main clock
	.rst       ( rst ),
	//Communication protocol 
	.req 	   ( req_int_b ),
	.ack 	   ( ack_int_b ),
	//Init variables
	.init 	   ( init_br ),
	.eol       ( eol_b   ),
	.eoc       ( eoc ),
	//Data in data out
	.point_a   ( point_max ),  //x 23:16 y 15:8 z 7:0
	.point_b   ( point_2 ),  //x 23:16 y 15:8 z 7:0
	.point_out ( point_out_b ) //x 23:16 y 15:8 z 7:0
);

endmodule 
