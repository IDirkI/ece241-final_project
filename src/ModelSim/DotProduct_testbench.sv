`timescale 1ns / 1ps

module testbench ( );

	parameter 	WII = 8,
				WIF = 16;
				
	parameter	WOI = 8,
				WOF = 16;
	
	reg [3:0][WII+WIF-1:0] v1; 
	reg [3:0][WII+WIF-1:0] v2;

	wire [WOI+WOF:0]	out;

	initial begin
		v1[0] = 24'b0_0000001_0000000000000000;
		v1[1] = 24'b0;
		v1[2] = 24'b0;
		v1[3] = 24'b0;
		
		v2[0] = 24'b0_0000001_0000000000000000;
		v2[1] = 24'b0;
		v2[2] = 24'b0;
		v2[3] = 24'b0;
		
	end // initial
		
	dot_product U1 (v1[0], v1[1], v1[2], v1[3], v2[0], v2[1], v2[2], v2[3], out);

endmodule
