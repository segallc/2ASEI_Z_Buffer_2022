//=============================================
// Filename		: Read-Only Memory
// Designer		: Camille SEGALL et Clement TARDY
// Description : Logic version of ROM, ROM code 
// is coming from package
//=============================================

module rom_c (
	input  logic [3:0] address,
	output logic [23:0] data_q
);

//== Variables Declaration =====================

reg [23:0] rom_c [15:0] = 
	'{
 	24'h4B4Ba0, 24'h4B4Ba0,
 	24'h4B4Ba0, 24'h4B4Ba0,
	// ===================
 	24'h805620, 24'h505625,
 	24'h805660, 24'h565607,
	// ===================
 	24'h805620, 24'h609060,
 	24'h8056A0, 24'h565686,
	// ===================
 	24'h678210, 24'h304070,
 	24'h708080, 24'h253509	
 	};
 	

// == Main code ================================

assign data_q = rom_c[address];

endmodule
