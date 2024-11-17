`timescale 1ns / 1ps

module testbench ( );

	parameter 	WII = 9,
				WIF = 16;
				
	parameter	WOI = 9,
				WOF = 16;
	
	parameter	SF = 2.0**WOF;
	
	// Cube Corners
	 parameter	C1x  = 25'd0*SF,
				C1y  = 25'd0*SF,	// <0, 0, 0>
				C1z  = 25'd8*SF;
					
	 parameter	C2x  = 25'd8*SF,
				C2y  = 25'd0*SF,	// <8, 0, 0>
				C2z  = 25'd8*SF;
					
	 parameter	C3x  = 25'd0*SF,
				C3y  = 25'd8*SF,	// <0, 8, 0>
				C3z  = 25'd0*SF;
					
	 parameter	C4x  = 25'd8*SF,
				C4y  = 25'd8*SF,	// <8, 8, 0>
				C4z  = 25'd0*SF;
					
	 parameter	C5x  = 25'd0*SF,
				C5y  = 25'd0*SF,	// <0, 0, 8>
				C5z  = 25'd8*SF;
					
	 parameter	C6x  = 25'd2*SF,
				C6y  = 25'd5*SF,	// <8, 0, 8>
				C6z  = 25'd16*SF;
					
	 parameter	C7x  = 25'd0*SF,
				C7y  = 25'd8*SF,	// <0, 8, 8>
				C7z  = 25'd8*SF;
					
	 parameter	C8x  = 25'd8*SF,
				C8y  = 25'd8*SF,	// <8, 8, 8>
				C8z  = 25'd8*SF;
	
	reg signed 		[2:0][WOI+WOF-1:0] position;
	reg signed 		[2:0][WOI+WOF-1:0] orientation;
	reg signed 	[2:0][3:0][WII+WIF-1:0] poly;
	
	wire signed 	[2:0][3:0][WII+WIF-1:0] poly_proj;
	
	initial begin
		position[0] = 25'b1;
		position[1] = 25'b0;
		position[2] = 25'b0;
		
		orientation[0] = 25'b0;
		orientation[1] = 25'b0;
		orientation[2] = 25'b0;
		
		poly[0][0] = 	C1x;
		poly[0][1] =	C1y;	// P1
		poly[0][2] =	C1z;
		poly[0][3] =	9'b1;
		
		poly[1][0] =  	C2x;
		poly[1][1] =	C2y;	// P2
		poly[1][2] =	C2z;
		poly[1][3] =	9'b1;
		 
		poly[2][0] =  	C6x;
		poly[2][1] =	C6y;	// P3
		poly[2][2] =	C6z;
		poly[2][3] =	9'b1;
		
		#10 position[0] = 25'b0;
		
	end // initial
		
	projection U1 (position, orientation, poly, poly_proj);

endmodule
