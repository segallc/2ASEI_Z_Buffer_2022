//================================================
//   Filename    : Brenseham fill
//   Designer    : SEGALL & TARDY
//   Description : Bresenham to fill y-line of FPGA
//================================================



module b2_with_z (
    //Clock and reset
    input  logic clk, 
    input  logic rst,
    //Acquisition and acknowledge 
    input  logic req_2,
    output logic ack_2, 
    //Input points to fill in
    input  logic [23:0] point_out_a, // tout le point
    input  logic [23:0] point_out_b,//  tout le point
    //color to use
    input  logic [23:0] rgb,
    //To control the ram
    output logic [7:0]  rdata,
    output logic [7:0]  gdata,
    output logic [7:0]  bdata,
    output logic [15:0] waddr,
    output logic [15:0] raddr,
    output logic we,

    //To control the ram of z
    output logic [7:0] zdata_out,
    output logic wez,
    input  logic [7:0] zdata_in

); 

// ==Variables declaration=========================

    typedef enum {Wait, Initiate_b,Axis_b, Calc_x_b,X_axis, Z_axis, Calc_z_b, Wait_x_b, Wait_z_b, Calc_Addr,Wait_Addr, Wait_To_Write, Write_RGB, End} fsm_t;

    fsm_t state, next_state;
    
    reg [15:0] next_waddr, next_raddr;
    reg [7:0]  next_rdata, next_gdata, next_bdata, next_zdata;




    //==Virables for bresenham========

	logic [7:0] dx, next_dx;
	logic [7:0] dz, next_dz;
	
	logic [7:0] x1, next_x1;
	logic [7:0] z1, next_z1;
	
	logic [7:0] xs, next_xs;
	logic [7:0] zs, next_zs;

	logic [8:0] p2, next_p2, i_p2;

    logic axis, next_axis;

//==Main code======================================
    
    always_ff @(posedge clk) begin
        if ( rst == 1'b0 ) begin
            state       <= Wait;
            waddr       <= 0;
            rdata       <= 0;
            gdata       <= 0;
            bdata       <= 0;
            dx          <= 0;
            dz          <= 0;
            x1          <= 0;
            z1          <= 0;
            xs          <= 0;
            zs          <= 0;
            p2          <= 0;
            axis        <= 0;
            zdata_out   <= 0;
            raddr		<= 0;

        end
        else begin
        	raddr       <= next_raddr;
            rdata       <= next_rdata;
            gdata       <= next_gdata;
            bdata       <= next_bdata;
            zdata_out   <= next_zdata;
            waddr       <= next_waddr;
            state       <= next_state;
            dx          <= next_dx;
            dz          <= next_dz;
            x1          <= next_x1;
            z1          <= next_z1;
            xs          <= next_xs;
            zs          <= next_zs;
            p2          <= next_p2;
            axis        <= next_axis;
        end
    end

    always_comb begin
	// input    : state, req_2, point_out_a, point_out_b
	// output   : wdata, waddr, ack_2, we
	// internal : x1, x2, next_x1, next_x2, next_waddr
    	next_state   = state;	
    	next_rdata   = rdata;
    	next_gdata   = gdata;
    	next_bdata   = bdata;
        next_zdata   = zdata_out ;
        next_dx      = dx;
        next_dz      = dz;
        next_x1      = x1;
        next_z1      = z1;
        next_xs      = xs;
        next_zs      = zs;
        next_p2      = p2;
        next_axis    = axis;
		ack_2        = 1'b0;
    	we 		     = 1'b0;
        wez 		 = 1'b0;
		i_p2 		 = 1'b0;
		next_waddr[15:8]   = point_out_b[15:8];
       	next_waddr[7:0]    = x1;
        next_raddr[15:8]   = point_out_b[15:8];
        next_raddr[7:0]    = x1;
                
        case (state)
            Wait:
                if ( req_2 == 1'b1 ) begin
                    next_state = Initiate_b;
                end

            Initiate_b: begin
                ack_2      = 1'b1; 
				next_state = Calc_Addr;
                //calcul des deltas
                next_dx = (point_out_a[23:16]<point_out_b[23:16])? (point_out_b[23:16]-point_out_a[23:16])     : (point_out_a[23:16]-point_out_b[23:16]);
                next_dz = (point_out_a[7:0]<point_out_b[7:0])?     (point_out_b[7:0]-point_out_a[7:0])         : (point_out_a[7:0]-point_out_b[7:0]);
                //choix du signe des axes
                next_xs = (point_out_a[23:16]<point_out_b[23:16])? 1 : -1;
                next_zs = (point_out_a[7:0]  <point_out_b[7:0])?   1 : -1;
                //initialisation du curseur du segment
                next_x1 = point_out_a[23:16];
                next_z1 = point_out_a[7:0];
            
                next_state = Axis_b;
            end

            Axis_b : begin
                ack_2 = 1'b1;

                if( dx >= dz) begin 
				    next_p2    = 2*dz - dx;
				    next_state = X_axis;
			    end
                else begin
                    next_p2    = 2*dx - dz;
                    next_state = Z_axis;
                end
            end
            
            X_axis : begin
            	ack_2     = 1'b1;
            	next_axis  = 1'b1;
            	next_state = Calc_Addr;
            end 

			
            Z_axis : begin
            	ack_2     = 1'b1;
            	next_axis  = 1'b0;
            	next_state = Calc_Addr;
            end 

            Calc_x_b : begin
                ack_2     = 1'b1;
                next_axis = 1'b1; 
                next_x1   = x1 + xs;
			    if(p2[8] == 1'b0) begin
			    	next_z1 = z1 + zs;
			    	i_p2    = 2 * dx;
			    end
			    else begin
				    i_p2 = 0;
			    end

                next_p2    = p2 - i_p2 + 2 * dz;
                next_state = Calc_Addr;
            end

            Calc_z_b : begin
                ack_2     = 1'b1;
                next_axis = 1'b0;
                next_z1   = z1 + zs;

			    if(p2[8] == 1'b0) begin
				    next_x1 = x1 + xs;
				    i_p2    = 2 * dz;
			    end 
			    else begin
				    i_p2 = 0;
			    end
			    next_p2    = p2 - i_p2 + 2 * dx;
                next_state = Calc_Addr;
            end
            Calc_Addr: begin
                ack_2              = 1'b1;	
                next_zdata = z1;
                next_state         = Wait_Addr;
            end
            
            
            Wait_Addr : begin
            	ack_2              = 1'b1;
            	next_state = Wait_To_Write;
            end

            Wait_To_Write: begin
                ack_2      = 1'b1;
                next_rdata = ( rgb[23:16] < z1 ) ? 0 : rgb[23:16] - z1;
                next_gdata = ( rgb[15:8] < z1 ) ? 0 : rgb[15:8] - z1;
                next_bdata = ( rgb[7:0] < z1 ) ? 0 : rgb[7:0] - z1;

                if( zdata_in < z1 && zdata_in != 0 )begin
                    if(x1 == point_out_b[23:16] && z1 == point_out_b[7:0]) begin
                        next_state   = End;
                    end // peut poser probleme
                    else if(axis == 1'b1) begin
                        next_state   = Calc_x_b;
                    end
                    else begin
                        next_state   = Calc_z_b;
                    end
                end
                else begin
                	next_state = Write_RGB;
                end
            end

            Write_RGB : begin
                ack_2        = 1'b1;
                we           = 1'b1;
                wez          = 1'b1;
                if(x1 == point_out_b[23:16] && z1 == point_out_b[7:0]) begin
                    next_state   = End;
                end // peut poser probleme
                else if(axis == 1'b1) begin
                    next_state   = Calc_x_b;
                end
                else begin
                    next_state   = Calc_z_b;
                end
            end

            End: begin
               ack_2      = 1'b1;
               next_state = Wait; 
            end
            default: begin
            	we		   = 1'b0;
                ack_2      = 1'b0;
            	next_state = Wait;
            	end 
        endcase        
    end
endmodule 
