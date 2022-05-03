//================================================
//   Filename    : initiator for Bresenham_line
//   Designer    : SEGALL & TARDY
//   Description : Initiator to find points bresenham FPGA
//================================================



module initiator (
	input 	logic clk,
	input	logic rst,
	//Acquisition and request external signals
	input 	logic req_init,
	output 	logic ack_init,
	input	logic eoc,
	//Input points from the loopback
	input   logic [23:0] point_a,
    input   logic [23:0] point_b,
    input   logic [23:0] point_c,
    input   logic [23:0] point_out_a,
    input   logic [23:0] point_out_b,
    //Output points for the bresenham a and b
    output  logic [23:0] point_max,
    output  logic [23:0] point_1,
    output  logic [23:0] point_2
); 
 
// == Variables Declaration =======================

	typedef enum {Wait, Init_Max, Calc_Max, Req_Init_Br_Max, Wait_Eol, Init_Min, Calc_Min, Req_Init_Br_Min, End} fsm_t;

	fsm_t state, next_state;

    logic [23:0] a, b, c, next_point_max, next_point_1, next_point_2;
    logic [23:0] next_a, next_b, next_c;

//==Main code======================================

    always_ff @ ( posedge clk )
		begin
			if ( rst == 1'b0 )
				begin
					a         <= 0;
					b	      <= 0;
					c	      <= 0;
					point_max <= 0;
					point_1   <= 0;
					point_2   <= 0;
					state     <= Wait;
				end
			else
				begin
                    a         <= next_a;
                    b         <= next_b;
                    c         <= next_c;
                    point_max <= next_point_max;
                    point_1   <= next_point_1;
                    point_2   <= next_point_2;
					state     <= next_state;
				end
		end
    
    always_comb begin
    //state, req_init, point_out_a, point_out_b
    //output : point_max, ack_init, eoc, point_max, point_1, point_2
    //internal : a, next_a, b, next_b, c, next_c, next_point_max, next_point_1, next_point_2, next_ack_init,
            ack_init       = 1'b0;
            next_a         = a;
            next_b         = b;
            next_c         = c;
            next_point_max = point_max;
            next_point_1   = point_1;
            next_point_2   = point_2;
            next_state     = state;
            case (state)
                Wait: begin
                    if ( req_init == 1'b1 ) begin
                            next_state = Init_Max; 
                    end
                end
                Init_Max : begin
                	ack_init = 1'b1;
                	next_state    = Calc_Max;
                end
                Calc_Max: begin
                		ack_init = 1'b1;
                		if ( point_a[15:8] == point_b[15:8] && point_a[15:8] < point_c[15:8] ) begin
                			    next_point_max = point_c;
                                next_point_1   = point_b;
                                next_point_2   = point_a;

                                next_a = point_c;
                                next_b = point_a;
                                next_c = point_c;
                                
                				next_state = Req_Init_Br_Max;
                		end
                		else if ( point_c[15:8] == point_b[15:8] && point_c[15:8] < point_a[15:8] ) begin
                			    next_point_max = point_a;
                                next_point_1   = point_b;
                                next_point_2   = point_c;

                                next_a = point_a;
                                next_b = point_b;
                                next_c = point_c;
                                
                				next_state = Req_Init_Br_Max;
                		end
                		else if ( point_a[15:8] == point_c[15:8] && point_a[15:8] < point_b[15:8] ) begin
                			    next_point_max = point_b;
                                next_point_1   = point_c;
                                next_point_2   = point_a;

                                next_a = point_b;
                                next_b = point_a;
                                next_c = point_c;
                                
                				next_state = Req_Init_Br_Max;
                		end
                        else if ( point_a[15:8] <= point_b[15:8] && point_a[15:8] <= point_c[15:8] ) begin
                                next_point_max = point_a;
                                next_point_1   = point_b;
                                next_point_2   = point_c;

                                next_a = point_a;
                                next_b = point_b;
                                next_c = point_c;
                                
                				next_state = Req_Init_Br_Max;
                            end
                        else if ( point_b[15:8] <= point_a[15:8] && point_b[15:8] <= point_c[15:8] ) begin
                                next_point_max = point_b;
                                next_point_1   = point_a;
                                next_point_2   = point_c;

                                next_a = point_b;
                                next_b = point_a;
                                next_c = point_c;
                                
                				next_state = Req_Init_Br_Max;
                        end
                        else if ( point_c[15:8] <= point_a[15:8] && point_c[15:8] <= point_b[15:8] ) begin
                                next_point_max = point_c;
                                next_point_1   = point_a;
                                next_point_2   = point_b;

                                next_a = point_c;
                                next_b = point_a;
                                next_c = point_b;
                                
                				next_state = Req_Init_Br_Max;
                        end
                        else
                            begin
                                next_state = End;
                            end
                end
                Req_Init_Br_Max: begin
                	ack_init    = 1'b1;
                	next_state  = Wait_Eol;
                end
                Wait_Eol: begin
                    if ( req_init == 1'b1 ) begin
                    	next_state = Init_Min;
                    end
                    else if ( eoc ) begin
                    	next_state = End;
                    end
                end
                Init_Min : begin
                    ack_init      = 1'b1;
                	next_state    = Calc_Min;
                end
                Calc_Min: begin
                	ack_init   = 1'b1;
                	next_state = Req_Init_Br_Min;
                	if ( point_out_b == b ) begin
                		next_point_max = c;
                		next_point_1   = b;
                		next_point_2   = point_out_a;
                	end
                	else if ( point_out_b == c ) begin
                		next_point_max = b;
                		next_point_1   = c;
                		next_point_2   = point_out_a;
                	end
                	else if ( point_out_a == b ) begin
                		next_point_max = c;
                		next_point_1   = b;
                		next_point_2   = point_out_b;
                	end
                	else if ( point_out_a == c ) begin
                		next_point_max = b;
                		next_point_1   = c;
                		next_point_2   = point_out_b;
                	end
                end
                Req_Init_Br_Min : begin
                	ack_init    = 1'b1;
                	next_state  = End;
                end
                End: begin
                	next_state     = Wait;
                end
            default : begin
            	ack_init   = 1'b0;
            	next_state      = Wait;
            end 
            endcase
        end
endmodule
