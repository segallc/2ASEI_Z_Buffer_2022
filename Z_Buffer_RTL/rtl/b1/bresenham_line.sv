//=========================================================
//   Filename    : BRESENHAM_LINE
//   Designer    : SEGALL & TARDY
//   Description : Module brensenham to calculate line FPGA
//=========================================================



module brensenham_line (
	input logic clk, //Main clock
	input logic rst,
	//Communication protocol 
	input  logic req,
	output logic ack,
	//Init variables
	input  logic init,
	input  logic eoc,
	//Output varibale
	output logic eol,
	//Data in data out
	input  logic [23:0] point_a,  //x 23:16 y 15:8 z 7:0
	input  logic [23:0] point_b,  //x 23:16 y 15:8 z 7:0
	output logic [23:0] point_out //x 23:16 y 15:8 z 7:0
);

// == Variables Declaration =========================

	logic [7:0] dx, next_dx;
	logic [7:0] dy, next_dy;
	logic [7:0] dz, next_dz;
	
	logic [7:0] x1, next_x1;
	logic [7:0] y1, next_y1, i_y1;
	logic [7:0] z1, next_z1, i_z1;

	logic [7:0] y_old, next_y_old;
	
	logic [7:0] xs, next_xs;
	logic [7:0] ys, next_ys;
	logic [7:0] zs, next_zs;

	logic [23:0] p_o, next_p_o;


	logic [8:0] p1, next_p1, i_p1;
	logic [8:0] p2, next_p2, i_p2;

	typedef enum {Wait,Init,Axis,Calc_x,Calc_y,Calc_z, Wait_x,Wait_y,Wait_z, Inter_x, Inter_z, End} fsm_t; //state

	fsm_t state,next_state;
 
//==Main code=========================================


// sequential part
  always_ff @( posedge clk ) begin 

	if( rst == 1'b0 ) begin
		state <= Wait;
		p1    <= 0;
		p2    <= 0;
		x1    <= 0;
		y1    <= 0;
		z1    <= 0;
		p_o   <= 0;
		y_old <= 0;
		dx <= next_dx;
	    dy <= next_dy;
		dz <= next_dz;
	
	end
	else begin
			//mise en memoire de toutes les variables

			p1 <= next_p1;
			p2 <= next_p2;

			x1 <= next_x1;
			y1 <= next_y1;
			z1 <= next_z1;
			
			xs <= next_xs;
			ys <= next_ys;
			zs <= next_zs;
			
			dx <= next_dx;
			dy <= next_dy;
			dz <= next_dz;

			p_o 	<= next_p_o;
			state   <= next_state;
		
			y_old   <= next_y_old;
	end
  end

  always_comb begin
	  // state 
	    
		
		next_p1 = p1;
		next_p2 = p2;
		
		next_x1 = x1;
		next_y1 = y1;
		next_z1 = z1;
		
		next_dx = dx;
		next_dy = dy;
		next_dz = dz;
		
		next_xs = xs;
		next_ys = ys;
		next_zs = zs;
		
		next_y_old = y_old;
		
		next_p_o = p_o;
		next_state = state;
		
		i_y1 = y_old;
		
		ack = 1'b0;
		eol = 1'b0;
		point_out = p_o;
		i_p1=0;
		i_p2=0;
		i_z1=0;
		
	  case (state)

	  	Wait : begin
			next_p1 = 0;
			next_p2 = 0;

			next_x1 = 0;
			next_y1 = 0;
			next_z1 = 0;

			next_y_old = 0;
			 
			  if( init == 1'b1 ) begin
				  next_state = Init;
			  end
		end 


		Init : begin
			ack  = 1'b1	;
			
			next_dx = (point_a[23:16]<point_b[23:16])? (point_b[23:16]-point_a[23:16])     : (point_a[23:16]-point_b[23:16]);
			next_dy = (point_a[15:8]<point_b[15:8])?   (point_b[15:8]-point_a[15:8])       : (point_a[15:8]-point_b[15:8]);
			next_dz = (point_a[7:0]<point_b[7:0])?     (point_b[7:0]-point_a[7:0])         : (point_a[7:0]-point_b[7:0]);

			next_xs = (point_a[23:16]<point_b[23:16])? 1 : -1;
			next_ys = (point_a[15:8] <point_b[15:8])?  1 : -1;
			next_zs = (point_a[7:0]  <point_b[7:0])?   1 : -1;

			next_x1 = point_a[23:16];
			next_y1 = point_a[15:8];
			next_z1 = point_a[7:0];

			next_y_old = point_a[15:8];
			
			next_state = Axis;
			end
			
		Axis : begin
			ack  = 1'b1;
			
			if( dx >= dy && dx >= dz) begin 
				next_p1 = 2*dy - dx;
				next_p2 = 2*dz - dx;

				next_state = Wait_x;
			end

			else if (dy >= dx && dy >=dz ) begin 
				next_p1 = 2*dx - dy;
				next_p2 = 2*dz - dy;

				next_state = Wait_y;
			end

			else begin
				next_p1 = 2*dy - dz;
				next_p2 = 2*dx - dz;

				next_state = Wait_z;
			end
		end 


		Calc_x : begin 
			ack = 1'b1;
			next_x1 = x1 + xs;
			if(p1[8] == 1'b0) begin
				next_y1 = y1 + ys;
				i_y1 = y1 + ys;
				i_p1 = - 2 * dx;
			end
			else begin
				i_p1 = 0;
				end
			if(p2[8] == 1'b0) begin
				next_z1 = z1 + zs;
				i_p2 = - 2 * dx;
			end
			else begin
				i_p2 = 0;
				end

			next_p1 = p1 + i_p1 + 2 * dy;
			next_p2 = p2 + i_p2 + 2 * dz;
			if (y_old == i_y1 &&  i_y1 != point_b[15:8] ) begin
			//if (y_old == i_y1 && x1 != point_b[23:16]) begin
				next_state = Calc_x;
				next_y_old = y_old;
			end
			else begin
				next_y_old = i_y1;
				next_state = Inter_x;
			end 
		
		end 

		Calc_y : begin
			ack = 1'b1;
			next_y1 = y1 + ys;

			if(p1[8] == 1'b0) begin
				next_x1 = x1 + xs;
				i_p1 = - 2 * dy;
			end
			else begin
				i_p1 = 0;
			end
			if(p2[8] == 1'b0) begin
				next_z1 = z1 + zs;
				i_p2 = - 2 * dy;
			end 
			else begin
				i_p2 = 0;
			end

			next_p1 = p1 + i_p1 + 2 * dx;
			next_p2 = p2 + i_p2 + 2 * dz;

			next_y_old = y_old + ys;
			next_state = Wait_y;

		end

		Calc_z : begin 
			ack = 1'b1;
			next_z1 = z1 + zs;
			i_z1 = z1 + zs;

			if(p1[8] == 1'b0) begin
				next_y1 = y1 + ys;
				i_y1 = y1 + ys;
				i_p1 = - 2 * dz;
			end 
			else begin
				i_p1 = 0;
			end 
			if(p2[8] == 1'b0) begin
				next_x1 = x1 + xs;
				i_p2 = - 2 * dz;
			end 
			else begin
				i_p2 = 0;
			end

			next_p1 = p1 + i_p1 + 2 * dy;
			next_p2 = p2 + i_p2 + 2 * dx;
	
			if (y_old == i_y1 && i_y1 != point_b[15:8] && i_z1 != point_b[7:0]) begin
				next_state = Calc_z;
				next_y_old = y_old;
			end
			else begin
				next_state = Inter_z;
			end 
		end

		Wait_x : begin
			
			next_p_o[23:16]  = x1;
			next_p_o[15:8]   = y1;
			next_p_o[7:0]    = z1;
			
			point_out[23:16] = x1;
			point_out[15:8]  = y1;
			point_out[7:0]   = z1;

			if( req ==1'b1 && x1 != point_b[23:16] ) begin
				next_state = Calc_x;
			end
			else if (  x1 == point_b[23:16] && y1 == point_b[15:8] && z1 == point_b[7:0]) begin
				next_state = End;
			end
			else if( init == 1'b1) begin
			next_state = Init;
			end
		end

		Wait_y : begin 

			next_p_o[23:16]  = x1;
			next_p_o[15:8]   = y1;
			next_p_o[7:0]    = z1;

			point_out[23:16] = x1;
			point_out[15:8]  = y1;
			point_out[7:0]   = z1;

			if( req ==1'b1 && y1 != point_b[15:8]  ) begin
				next_state = Calc_y;
			end
			else if ( x1 == point_b[23:16] && y1 == point_b[15:8] && z1 == point_b[7:0]) begin
				next_state = End;
			end
			else if( init == 1'b1) begin
			next_state = Init;
			end
		end


		Wait_z : begin 

			next_p_o[23:16]  = x1;
			next_p_o[15:8]   = y1;
			next_p_o[7:0]    = z1;

			point_out[23:16] = x1;
			point_out[15:8]  = y1;
			point_out[7:0]   = z1;

			if( req == 1'b1 && z1 != point_b[7:0]) begin
				next_state = Calc_z;
			end
			else if ( x1 == point_b[23:16] && y1 == point_b[15:8] && z1 == point_b[7:0]) begin
				next_state = End;
			end
			else if( init == 1'b1) begin
			next_state = Init;
			end
		end
		
		Inter_x : begin
			ack = 1'b1;
			if ( ( x1 != point_b[23:16] || z1 != point_b[7:0] ) && y1 == point_b[15:8] ) begin
				next_state = Calc_x;
			end
			else begin
				next_state = Wait_x;
			end			
		end
		Inter_z : begin
			ack = 1'b1;
			if ( ( x1 != point_b[23:16] || z1 != point_b[7:0] ) && y1 == point_b[15:8] ) begin
				next_state = Calc_z;
			end
			else begin
				next_state = Wait_z;
			end	
		end
		End : begin
		eol = 1'b1;
		if(init == 1'b1) begin
			next_state = Init;
			end 
		else if( eoc == 1'b1 ) begin
			next_state = Wait;
		end 
		end 
		
	  default : begin
	  		next_p1 = p1;
		next_p2 = p2;
		
		next_x1 = x1;
		next_y1 = y1;
		next_z1 = z1;
		
		next_dx = dx;
		next_dy = dy;
		next_dz = dz;
		
		next_xs = xs;
		next_ys = ys;
		next_zs = zs;
		
		
		next_p_o = p_o;
		next_state = state;
		
		
		ack = 1'b0;
		point_out = p_o;
		  	
	  end
	  endcase
	end
endmodule 
