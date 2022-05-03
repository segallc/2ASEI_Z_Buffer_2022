//=========================================================
//   Filename    : BRESENHAM_LINE
//   Designer    : SEGALL & TARDY
//   Description : Module to initiate the calcul
//=========================================================

module starter (
 
input  logic clk,
input  logic rst,
//Communication protocol 
output  logic req_1,
input   logic ack_1,
//switch
input   logic key1,
//address for the rom
output  logic[3:0] address
);

// == Variables Declaration =========================

typedef enum {Init, Req, Wait, Compare, Inc, End} starter_t;

starter_t state,next_state;

logic [3:0] next_address;

//==Main code=========================================


// sequential part
	  always_ff @( posedge clk ) begin
	  if( rst == 1'b0 ) begin
			state   <= Init;
			address   <= 0;
	  end
	  else begin
	  		address    <= next_address;
	  		state      <= next_state;
	  end
	 end 
	 
	 always_comb begin
	 	 req_1 = 1'b0;
		 next_state   = state;
		 next_address = address;
		 case (state)
		 	Init : begin
		 		if( key1 == 1'b0 ) begin
		 			next_state = Wait;
		 		end	
		 	end
			Wait : begin
				if ( key1 == 1'b1 ) begin
					next_state = Req;
				end
			end
		 	Req : begin 
		 		req_1 = 1'b1;
		 		next_state = Compare;
		 	end
		 	Compare : begin
		 		req_1 = 1'b0;
		 		if(ack_1 == 1'b0 && address == 15) begin
		 			next_state = End;
		 		end
		 		else if ( ack_1 == 1'b0 && address != 15) begin
		 			next_state = Inc;
		 		end
		 	end
		 	Inc : begin
		 		next_address = address + 1;
		 		next_state   = Init;
		 	end
		 	End : begin
		 		next_address = 0;
		 		next_state   = Init;
		 	end
		 	default: begin
		 		next_state = state;
		 	end
		 endcase
	 end
 endmodule
