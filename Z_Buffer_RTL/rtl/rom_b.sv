//=============================================
// Filename		: Read-Only Memory
// Designer		: Camille SEGALL et Clement TARDY
// Description : Logic version of ROM, ROM code 
// is coming from package
//=============================================

module rom_b (
	input  logic [3:0] address,
	output logic [23:0] data_q
);

//== Variables Declaration =====================

reg [23:0] rom_b [15:0] = 
	'{
 	24'h808010, 24'h808010,
 	24'h108010, 24'h801010,
	// ===================
	24'h907520, 24'h909025,
 	24'h808030, 24'h159507,
	// ===================
 	24'h907520, 24'h804060,
 	24'h8080A0, 24'h159507,
	// ===================
 	24'h25B010, 24'h904610,
 	24'h158060, 24'h9090A0
 	};
 	

// == Main code ================================

assign data_q = rom_b[address];

endmodule
