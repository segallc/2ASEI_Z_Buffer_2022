//================================================
//   Filename    : RAM
//   Designer    : SEGALL & TARDY
//   Description : RAM integrated of FPGA
//================================================



module raminfr (
 
input  logic clk,   
input  logic we,   
input  logic [15:0] waddr,
input  logic [15:0] raddr,   
input  logic [23:0] data_in,   
output logic [23:0] data_out

);

reg [23:0] ram [65535:0];

//==Main code======================================
  always @(posedge clk) begin   
    if (we)   
      ram[waddr] <= data_in;   
    data_out <= ram[raddr];   
  end   
 
endmodule 
