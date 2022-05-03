//================================================
//   Filename    : FSM_b1 for Bresenham_line
//   Designer    : SEGALL & TARDY
//   Description : FSM_b1 to control bresenham FPGA
//================================================



module fsm_b1 (
	input 	logic clk,
	input	logic rst,
	//Acquisition and request external signals
	input 	logic req_1,
	output 	logic req_2,
	output 	logic ack_1,
	input  	logic ack_2,
	//Acquisition and request internal signals
	output 	logic req_int_a,
	output 	logic req_int_b,
	input  	logic ack_int_a,
	input  	logic ack_int_b,
	output  logic req_init,
	input   logic ack_init,
	output 	logic init_br,
	output	logic eoc,
	input   logic eol_a,
	input	logic eol_b
); 
 
// == Variables Declaration =======================

	typedef enum {Wait, Req_Init, Init, Init_Br, Calc, Fill_First, Wait_Fill_First, Wait_Calc, Wait_Ack_Fill, Req_Fill, Wait_Ack, Stage_Two, End} fsm_t;

	fsm_t state, next_state;

	logic next_ack_1, stage_2, next_stage_2;
	
//==Main code======================================

	always_ff @ ( posedge clk )
		begin
			if (rst == 1'b0)
				begin
					ack_1   <= 1'b0;
					stage_2 <= 1'b0;
					state   <= Wait;
				end
			else
				begin
					stage_2 <= next_stage_2;
					ack_1   <= next_ack_1;
					state   <= next_state;
				end
		end

	always_comb 
	//state, req_1, ack_init,ack_int_a, ack_int_b, ack_2, eol_a, eol_b
	//output: init_br,req_int_a, req_int_b, req_2, req_init, ack_1, next_state, eoc
		begin
			init_br    	= 1'b0;
			req_int_a  	= 1'b0;
			req_int_b  	= 1'b0;
			req_2      	= 1'b0;		
			req_init   	= 1'b0;
			eoc 		= 1'b0;
			next_ack_1 	 = ack_1;
			next_stage_2 = stage_2;
			next_state 	 = state;
			case (state)
				Wait: begin
					next_ack_1 = 1'b0;
					next_stage_2    = 1'b0;
					if( req_1 == 1'b0 ) begin
							next_state = Req_Init;
					end
				end
				Req_Init : begin
					req_init   = 1'b1;
					next_ack_1 = 1'b1;
					next_state = Init;
				end
				Init :
					if ( ack_init == 1'b0 ) begin
						next_state = Init_Br;
					end
				Init_Br : begin
					init_br    = 1'b1;
					next_state = Calc;
				end
				Calc:
					if ( ack_int_a == 1'b0 && ack_int_b == 1'b0 ) begin
						next_state = Fill_First;
					end
				Fill_First : begin
					req_2 = 1'b1;
					next_state = Wait_Fill_First;
				end
				Wait_Fill_First : begin
					if ( ack_2 == 1'b0 ) begin
						next_state = Wait_Calc;
					end
				end
				Wait_Calc: begin
					req_int_a = 1'b1;
					req_int_b = 1'b1; 
					next_state = Wait_Ack_Fill;
				end
				Wait_Ack_Fill : begin
					if ( ack_int_a == 1'b0 && ack_int_b == 1'b0 )begin
							next_state = Req_Fill;
					end
				end
				Req_Fill: begin
					req_2 = 1'b1;
					next_state = Wait_Ack;
				end
				
				Wait_Ack: begin
					req_2 = 1'b0;
					if ( eoc == 1'b1 ) begin
						next_state = Wait;
					end
					else if ( ( stage_2 == 1'b1 && (eol_a == 1'b1 || eol_b == 1'b1 ) ) && ack_int_a == 1'b0 && ack_int_b == 1'b0 && ack_2 == 1'b0 )begin
						next_state = End;					
					end
					else if ( ( eol_a == 1'b1 && eol_b == 1'b1 ) && ack_int_a == 1'b0 && ack_int_b == 1'b0 && ack_2 == 1'b0 ) begin
						next_state = End;
					end
					else if ( ( eol_a == 1'b1 || eol_b == 1'b1 ) && ack_int_a == 1'b0 && ack_int_b == 1'b0 && ack_2 == 1'b0 ) begin
						next_state = Stage_Two;
					end
					else begin
						if ( ack_2 == 1'b0 ) begin
							next_state = Wait_Calc;
						end
					end
				end
				Stage_Two : begin
					next_stage_2 = 1'b1;
					next_state   = Req_Init;				
				end
				End : begin
					eoc = 1'b1;
					next_state = Wait;
				end
				default : begin
					req_init   	= 1'b0;
					next_ack_1 	= 1'b0;
					req_int_a  	= 1'b0;
					req_int_b  	= 1'b0;
					init_br    	= 1'b0;
					req_2      	= 1'b0;
					next_state 	= Wait;
				end
				endcase
		end
endmodule 
