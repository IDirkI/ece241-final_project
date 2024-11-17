`timescale 1ns / 1ps

module testbench ( );

	parameter 	WII = 9,
				WIF = 16;
				
	parameter	WOI = 9,
				WOF = 16;
	
	parameter	SF = 2.0**WOF;
	
	reg [3:0][3:0][WII+WIF-1:0] H;
	reg [3:0][WII+WIF-1:0] p;
	
	wire [3:0][WOI+WOF-1:0] Pp;

	initial begin
		H[0][0] =  24'd0*(SF);
		H[1][0] = -24'd1*(SF);	// Row 1
		H[2][0] =  24'd0*(SF);
		H[3][0] =  24'd0*(SF);
		
		H[0][1] =  24'd1*(SF);
		H[1][1] =  24'd0*(SF);	// Row 2
		H[2][1] =  24'd0*(SF);
		H[3][1] =  24'd0*(SF);
		
		H[0][2] =  24'd0*(SF);
		H[1][2] =  24'd0*(SF);	// Row 3
		H[2][2] =  24'd1*(SF);
		H[3][2] =  24'd0*(SF);
		
		H[0][3] =  24'd0*(SF);
		H[1][3] =  24'd0*(SF);	// Row 4
		H[2][3] =  24'd0*(SF);
		H[3][3] =  24'd1*(SF);
		
		p[0] = 24'd1*(SF);
		p[1] = 24'd0*(SF);
		p[2] = 24'd0*(SF);
		p[3] = 24'd1*(SF); // alwayS
		
	end // initial
		
	matrix_mul_4x4on4x1 U1 (H, p, Pp);

endmodule
