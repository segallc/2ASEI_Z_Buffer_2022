//================================================
//   Filename    : Brenseham fill
//   Designer    : SEGALL & TARDY
//   Description : Bresenham to fill y-line of FPGA
//================================================



module bresenham_fill (
    //Clock and reset
    input  logic clk, 
    input  logic rst,
    //Acquisition and acknowledge 
    input  logic req_2,
    output logic ack_2, 
    //Input points to fill in
    input  logic [7:0] point_out_a_x,
    input  logic [15:0] point_out_b_xy,
    //color to use
    input  logic [23:0] rgb,
    //To control the ram
    output logic [7:0] rdata,
    output logic [7:0] gdata,
    output logic [7:0] bdata,
    output logic [15:0] waddr,
    output logic we
); 

// ==Variables declaration=========================

    typedef enum {Wait, Compare, Calc_Addr, Wait_To_Write, Write_RGB, Inc, End} fsm_t;

    fsm_t state, next_state;

    logic [7:0] x1, x2, next_x1, next_x2;
    
    reg [15:0] next_waddr;
    reg [7:0]  next_rdata, next_gdata, next_bdata;

//==Main code======================================
    
    always_ff @(posedge clk) begin
        if ( rst == 1'b0 ) begin
            state   <= Wait;
            x1      <= 0;
            x2      <= 0;
            waddr   <= 0;
            rdata   <= 0;
            gdata   <= 0;
            bdata   <= 0;
        end
        else begin
            rdata  <= next_rdata;
            gdata  <= next_gdata;
            bdata  <= next_bdata;
            x1      <= next_x1;
            x2	    <= next_x2;
            waddr   <= next_waddr;
            state   <= next_state;
        end
    end

    always_comb begin
	// input    : state, req_2, point_out_a, point_out_b
	// output   : wdata, waddr, ack_2, we
	// internal : x1, x2, next_x1, next_x2, next_waddr
    	next_state   = state;
    	next_x1      = x1;
    	next_x2	     = x2;
    	next_waddr   = waddr;	
    	next_rdata   = rdata;
    	next_gdata   = gdata;
    	next_bdata   = bdata;
    	next_waddr   = waddr;
		ack_2        = 1'b0;
    	we 		     = 1'b0;
        case (state)
            Wait:
                if ( req_2 == 1'b1 ) begin
                    next_state = Compare;
                end
            Compare: begin
                ack_2      = 1'b1;
				next_state = Calc_Addr;
                if ( point_out_a_x[7:0] >= point_out_b_xy[15:8] ) begin
                    next_x1 = point_out_b_xy[15:8];
                    next_x2 = point_out_a_x[7:0];
                end
                else begin
                    next_x2 = point_out_b_xy[15:8];
                    next_x1 = point_out_a_x[7:0];
                end
            end
            Calc_Addr: begin
                ack_2              = 1'b1;	
                next_waddr[15:8]   = point_out_b_xy[7:0];
       	         next_waddr[7:0]    = x1;
                next_state         = Wait_To_Write;
            end
            Wait_To_Write: begin
                ack_2 = 1'b1;
                next_rdata = rgb[23:16];
                next_gdata = rgb[15:8];
                next_bdata = rgb[7:0];
                next_state = Write_RGB;
            end
            Write_RGB : begin
                ack_2        = 1'b1;
                we           = 1'b1;
                next_state   = Inc;
            end
            Inc : begin
                ack_2      = 1'b1;
                next_x1    = x1 + 1;
                if ( x1 == x2 ) begin
                    next_state = End;
                end
                else begin
                    next_state = Calc_Addr;
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
