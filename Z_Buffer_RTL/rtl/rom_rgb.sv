//=============================================
// Filename		: Read-Only Memory
// Designer		: Camille SEGALL et Clement TARDY
// Description : Logic version of ROM, ROM code 
// is coming from package
//=============================================

module rom_rgb (
	input  logic [3:0] address,
	output logic [23:0] data_q
);

//== Variables Declaration =====================

reg [23:0] rom_rgb [15:0] = 
	'{
 	24'hffffff, 24'hffffff,
 	24'hffffff, 24'hffffff,
	// ===================
	24'hffffff, 24'hff0000,
 	24'h00ff00, 24'h0000ff,
	// ===================
	24'hffffff, 24'hff0000,
 	24'h00ff00, 24'h0000ff,
	// ===================
	24'hffA000, 24'h6700FF,
 	24'h00ff00, 24'hA056FF
 	};
 	

// == Main code ================================

assign data_q = rom_rgb[address];

endmodule
