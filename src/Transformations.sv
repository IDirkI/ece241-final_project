module projection # (
	parameter	WII = 9,
					WIF = 16,
					WOI = 9,
					WOF = 16
	) (
		// Inputs
		position,
		orientation,
		Polygon_in,
		
		// Outputs
		Polygon_out
	);
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
 // Scaling factor
 parameter	SF = 2.0**WOF;
 
 // Projection Constants,	
 parameter	r = 	25'd0_00000100_0000000000000000,	// Right side of camera
				l = 	25'd0_00000100_0000000000000000,	// Left side of camera
				t =	25'd0_00000100_0000000000000000,	// Top of the camera
				b = 	25'd0_00000100_0000000000000000,	// Bottom of the camera
				n = 	25'd0_00000100_0000000000000000,	// Near screen from the eye
				f = 	25'd0_00001100_0000000000000000;	// Far screen from the eye

/*****************************************************************************
 *                             Port Declarations                             *
 ********************************************** *******************************/
 input wire signed 	[2:0][WOI+WOF-1:0] position;
 input wire signed 	[2:0][WOI+WOF-1:0] orientation;
 input wire signed 	[2:0][3:0][WII+WIF-1:0] Polygon_in;
 
 output logic signed [2:0][3:0][WOI+WOF-1:0] Polygon_out;
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 logic	signed 	[WII+WIF-1:0] h00;
 logic	signed 	[WII+WIF-1:0] h11;
 logic	signed 	[WII+WIF-1:0] h22;
 logic	signed 	[WII+WIF-1:0] h32;
 
 logic								  div_of0;
 logic								  div_of1;
 logic								  div_of2;
 logic								  div_of3;
 
 logic								  add_of0;
 logic								  sub_of0;
 logic								  mult_of0;
 logic								  mult_of1;
 logic								  mult_of2;
 
 logic	signed	[WII+WIF-1:0] f_pls_n;		// f+n
 logic	signed	[WII+WIF-1:0] f_min_n;		// f-n
 logic	signed	[WII+WIF-1:0] neg_f_pls_n;	// -(f+n)	
 logic	signed	[WII+WIF-1:0] fn;		// f*n
 logic	signed	[WII+WIF-1:0] neg2_fn;		//	-2(f*n)
 
 
 
 reg signed [3:0][3:0][WII+WIF-1:0] Proj;	// 4x4 projection matrix
 
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 always @ (position, orientation) begin;
	Proj[0][0] <= h00;
	Proj[1][0] <= 25'd0;	// Row 1
	Proj[2][0] <= 25'd0;
	Proj[3][0] <= 25'd0;
	
	Proj[0][1] <= 25'd0;
	Proj[1][1] <= h11;	// Row 2
	Proj[2][1] <= 25'd0;
	Proj[3][1] <= 25'd0;
	
	Proj[0][2] <= 25'd0;
	Proj[1][2] <= 25'd0;	// Row 3
	Proj[2][2] <= h22;
	Proj[3][2] <= h32;
	
	Proj[0][3] <= 25'd0;
	Proj[1][3] <= 25'd0;	// Row 4
	Proj[2][3] <= -25'd1;
	Proj[3][3] <= 25'd0;
 end
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 // n/r
 fxp_div # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) div0 (.dividend(n), .divisor(r), .out(h00), .overflow(div_of0));
	
 // n/t
 fxp_div # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) div1 (.dividend(n), .divisor(t), .out(h11), .overflow(div_of1));
	
 // f + n
 fxp_add # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) add0 (.ina(f), .inb(n), .out(f_pls_n), .overflow(add_of0));

// f - n
 fxp_addsub # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) sub0 (.ina(f), .inb(n), .sub(1'b1), .out(f_min_n), .overflow(sub_of0));
	
 // f*n
 fxp_mul # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) mult0 (.ina(f), .inb(n), .out(fn), .overflow(mult_of0));
	
 // -(f+n)
 fxp_mul # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) mult1 (.ina(f_pls_n), .inb(25'b1_11111111_0000000000000000), .out(neg_f_pls_n), .overflow(mult_of1));
	
 // -2fn
 fxp_mul # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) mult2 (.ina(fn), .inb(25'b1_11111110_0000000000000000), .out(neg2_fn), .overflow(mult_of2));
	
 
 // Calculate H[2][2] and H[2][3]
 fxp_div # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) div2 (.dividend(neg_f_pls_n), .divisor(f_min_n), .out(h22), .overflow(div_of2));

 fxp_div # (
	.WIIA(WII), .WIFA(WIF),
 	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)) div3 (.dividend(neg2_fn), .divisor(f_min_n), .out(h32), .overflow(div_of3));
	
 // Do the projection multilication between Projection matrix in R4x4 and Polygon in R4x1
 matrix_mul_4x4on4x1 # (
	.WII(WII), .WIF(WIF),
	.WOI(WOI), .WOF(WOF)
 ) proj0 (.H(Proj), .p(Polygon_in[0]), .Pp(Polygon_out[0]));

  matrix_mul_4x4on4x1 # (
	.WII(WII), .WIF(WIF),
	.WOI(WOI), .WOF(WOF)
 ) proj1 (.H(Proj), .p(Polygon_in[1]), .Pp(Polygon_out[1]));
 
  matrix_mul_4x4on4x1 # (
	.WII(WII), .WIF(WIF),
	.WOI(WOI), .WOF(WOF)
 ) proj2 (.H(Proj), .p(Polygon_in[2]), .Pp(Polygon_out[2]));

endmodule


/*
 *
 * Create Homogeneous Transformation Matrix 
 *
 *
 */
module transformer # (	// TBD
		parameter 	WII = 9,
						WIF = 16,
						WOI = 9,
						WOF = 16
	) (
		
	);
endmodule
