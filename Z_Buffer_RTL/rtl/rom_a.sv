//=============================================
// Filename		: Read-Only Memory
// Designer		: Camille SEGALL et Clement TARDY
// Description : Logic version of ROM, ROM code 
// is coming from package
//=============================================

module rom_a (
	input  logic [3:0] address,
	output logic [23:0] data_q
);

//== Variables Declaration =====================

reg [23:0] rom_a [15:0] = 
	'{
 	24'h108010, 24'h801010,
 	24'h101010, 24'h101010,
	// ===================
 	24'h304020, 24'hA02225,
 	24'h242230, 24'h402607,
	// ===================
 	24'h304020, 24'h202020,
 	24'h2422A0, 24'h151507,
	// ===================
 	24'h157210, 24'h292910,
 	24'h702010, 24'h863045
 	};
 	

// == Main code ================================

assign data_q = rom_a[address];

endmodule
