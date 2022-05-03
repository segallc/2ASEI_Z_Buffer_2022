//================================================
//   Filename    : Bloc b1 
//   Designer    : SEGALL & TARDY
//   Description : Bloc B1 faisant appel aux autres sous-blocs
//================================================

module top( 
    input  logic clk,
    input  logic rst,
    input  logic key1,
    input  logic req_1
);
 
// == Variables Declaration =======================

logic [23:0] point_out_a, point_out_b, color, point_a, point_b, point_c;

logic [7:0]  data_outr, data_outg, data_outb, rdata, gdata, bdata, zdata_in, zdata_out;

logic [15:0] waddr, raddr, zraddr;

logic [9:0] X;
logic [8:0] Y;

logic [3:0] rom_addr;

logic we, wez, ack_1, req_2, ack_2;

//==Main code======================================

b1 u_b1( 
    .clk         ( clk ),
    .rst         ( rst ),
    //Acquisition and request with other blocks
    .req_1       ( req_1 ),
    .ack_1       ( ack_1 ),
    .req_2       ( req_2 ),
    .ack_2       ( ack_2 ),
    //Input points to be used
    .point_a     ( point_a ),
    .point_b     ( point_b ),
    .point_c     ( point_c ),
    //Output points for b2
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b )
);

simple_ram_dual_clock u_ram_r (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( rdata ),
	.q           ( data_outr )
);

simple_ram_dual_clock u_ram_g (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( gdata ),
	.q           ( data_outg )
); 

simple_ram_dual_clock u_ram_b (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( raddr ),
	.write_addr  ( waddr ),
	.data      	 ( bdata ),
	.q           ( data_outb )
);

simple_ram_dual_clock u_ram_z (
	.read_clk 	 ( clk ),
	.write_clk   ( clk ),
	.we     	 ( we ),
	.read_addr   ( zraddr ),
	.write_addr  ( waddr ),
	.data      	 ( zdata_out ),
	.q           ( zdata_in )
);  

b2_with_z u_b2_with_z (
    .clk( clk ), 
    .rst( rst ),
    .req_2( req_2 ),
    .ack_2 (ack_2 ), 
    .point_out_a ( point_out_a ),
    .point_out_b ( point_out_b ),
    .rgb ( color ),
    .rdata ( rdata ),
    .gdata ( gdata ),
    .bdata ( bdata ),
    .waddr ( waddr ),
    .zdata_in ( zdata_in ),
    .zdata_out (zdata_out ),
    .wez( wez ),
    .raddr ( zraddr ),
    .we ( we )
); 

starter u_starter(
    .clk 		 ( clk ),
    .rst 		 ( rst ),
    .req_1 		 ( req_1 ),
    .ack_1		 ( ack_1 ),
    .address     ( rom_addr ),
    .key1		 ( key1 )
);

rom_a u_rom_a (
	.address ( rom_addr ),
	.data_q  ( point_a )
);

rom_b u_rom_b (
	.address ( rom_addr ),
	.data_q  ( point_b )
);

rom_c u_rom_c (
	.address ( rom_addr ),
	.data_q  ( point_c )
);

rom_rgb u_rom_rgb (
	.address ( rom_addr ),
	.data_q  ( color )
);

endmodule 
