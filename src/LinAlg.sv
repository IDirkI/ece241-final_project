/*
 *
 *		Dot product for vectors in ℝ⁴
 *
 */
module dot # (
	// Width of input INT and FLOAT portions
		parameter WII = 9,
					 WIF = 16,
		
	// Width of output INT and FLOAT portions
		parameter WOI = 9,
					 WOF = 16
	)
	(
	// Inputs
		v1,
		v2,
		
	// Outputs
		out
	);
	
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
 
/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
 // Inputs
	input wire	signed	[3:0][WII+WIF-1:0] v1; 
	input wire	signed	[3:0][WII+WIF-1:0] v2;
	
 // Outputs
	output logic 	signed	[WOI+WOF:0] out;
	
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
	logic [WOI+WOF-1:0] a0b0;
	logic [WOI+WOF-1:0] a1b1;
	logic [WOI+WOF-1:0] a2b2;
	logic [WOI+WOF-1:0] a3b3;
	
	logic [WOI+WOF-1:0] sum0;
	logic [WOI+WOF-1:0] sum1;
	
	logic 					overflow0;
	logic						overflow1;
	logic						overflow2;
	logic						overflow3;
	
	logic						overflow4;
	logic						overflow5;
	logic						overflow6;
 
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m0 (.ina(v1[0]), .inb(v2[0]), .out(a0b0), .overflow(overflow0));
	
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m1 (.ina(v1[1]), .inb(v2[1]), .out(a1b1), .overflow(overflow1));
	
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m2 (.ina(v1[2]), .inb(v2[2]), .out(a2b2), .overflow(overflow2));
	
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m3 (.ina(v1[3]), .inb(v2[3]), .out(a3b3), .overflow(overflow3));

 // Add a0b0 + a1b1 + a2b2 + a3b3
 fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) a0	(.ina(a0b0), .inb(a1b1), .out(sum0), .overflow(overflow4));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) a1	(.ina(sum0), .inb(a2b2), .out(sum1), .overflow(overflow5));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) a2	(.ina(sum1), .inb(a3b3), .out(out), .overflow(overflow6));
endmodule


/*
 *
 *		4x4 Matrix multiplication with a vector in ℝ⁴
 *
 *									| R 	t |				 	 | cos(α)cos(β)	cos(α)sin(β)sin(γ)-sin(α)cos(γ)	 cos(α)sin(β)cos(γ)+sin(α)sin(γ) |
 *		p' = H*p		---> H = |  	  | ∈ ℝ⁴ˣ⁴ , 	R = | sin(α)cos(β)	sin(α)sin(β)sin(γ)+cos(α)cos(γ)	 sin(α)sin(β)cos(γ)-cos(α)sin(γ) |
 *									| 0 	1 |            	 |   -sin(β)		 			cos(β)sin(γ)					  			 cos(β)cos(γ)		   |
 *											
 *								   | x |
 *						for  p = | y | ∈ ℝ⁴
 *                         | z |
 *									| 1 |
 *
 */

module matrix_mul_4x4on4x1 # (
	// Width of input INT and FLOAT portions
		parameter WII = 9,
					 WIF = 16,
		
	// Width of output INT and FLOAT portions
		parameter WOI = 9,
					 WOF = 16
	)
	(
	// Inputs
		H,
		p,
		
	// Outputs
		Pp
	);
	
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
 
/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
 // Inputs
	input wire	signed	[3:0][3:0][WII+WIF-1:0] 	H; // Homogeneous transformation matrix 
	input wire	signed	[3:0][WII+WIF-1:0] 			p; // Point
	
 // Outputs
	output logic 	signed	[3:0][WOI+WOF-1:0] Pp;				// Transformed point p' = H*p
	
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
	// Multiplication results
	logic	[WOI+WOF-1:0] h00;
	logic [WOI+WOF-1:0] h01;
	logic [WOI+WOF-1:0] h02;
	logic [WOI+WOF-1:0] h03;
	logic [WOI+WOF-1:0] h04;
	logic [WOI+WOF-1:0] h10;
	logic [WOI+WOF-1:0] h11;
	logic [WOI+WOF-1:0] h12;
	logic [WOI+WOF-1:0] h13;
	logic [WOI+WOF-1:0] h20;
	logic [WOI+WOF-1:0] h21;
	logic [WOI+WOF-1:0] h22;
	logic [WOI+WOF-1:0] h23;
	logic [WOI+WOF-1:0] h30;
	logic [WOI+WOF-1:0] h31;
	logic [WOI+WOF-1:0] h32;
	logic [WOI+WOF-1:0] h33;
	
	// Sum results
	logic [WOI+WOF-1:0] sum00;
	logic [WOI+WOF-1:0] sum01;
	logic [WOI+WOF-1:0] sum02;
	logic [WOI+WOF-1:0] sum03;
	logic [WOI+WOF-1:0] sum10;
	logic [WOI+WOF-1:0] sum11;
	logic [WOI+WOF-1:0] sum12;
	logic [WOI+WOF-1:0] sum13;

	
	// Sum and Mult overflow flags
	logic 					mult_of00;
	logic 					mult_of01;
	logic 					mult_of02;
	logic 					mult_of03;
	logic 					mult_of10;
	logic 					mult_of11;
	logic 					mult_of12;
	logic 					mult_of13;
	logic 					mult_of20;
	logic 					mult_of21;
	logic 					mult_of22;
	logic 					mult_of23;
	logic 					mult_of30;
	logic 					mult_of31;
	logic 					mult_of32;
	logic 					mult_of33;
	
	logic 					sum_of00;
	logic 				 	sum_of10;
	logic						sum_of01;
	logic 	 				sum_of11;
	logic 					sum_of02;
	logic  					sum_of12;
	logic 					sum_of03;
	logic 				 	sum_of13;

	
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 /*
 always @ (*) begin
	Pp[0] = H[0][0]*p[0] + H[1][0]*p[1] + H[2][0]*p[2] + H[3][0]*p[3];
	Pp[1] = H[0][1]*p[0] + H[1][1]*p[1] + H[2][1]*p[2] + H[3][1]*p[3];
	Pp[2] = H[0][2]*p[0] + H[1][2]*p[1] + H[2][2]*p[2] + H[3][2]*p[3];
	Pp[3] = H[0][3]*p[0] + H[1][3]*p[1] + H[2][3]*p[2] + H[3][3]*p[3];
 end
 */
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
/*
 *			MULT	-	ROW 1
 */
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m00 (.ina(H[0][0]), .inb(p[0]), .out(h00), .overflow(mult_of00));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m10 (.ina(H[1][0]), .inb(p[1]), .out(h10), .overflow(mult_of10));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m20 (.ina(H[2][0]), .inb(p[2]), .out(h20), .overflow(mult_of20));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m30 (.ina(H[3][0]), .inb(p[3]), .out(h30), .overflow(mult_of30));
 
 /*
 *			MULT	-	ROW 2
 */
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m01 (.ina(H[0][1]), .inb(p[0]), .out(h01), .overflow(mult_of01));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m11 (.ina(H[1][1]), .inb(p[1]), .out(h11), .overflow(mult_of11));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m21 (.ina(H[2][1]), .inb(p[2]), .out(h21), .overflow(mult_of21));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m31 (.ina(H[3][1]), .inb(p[3]), .out(h31), .overflow(mult_of31));
 
 /*
 *			MULT	-	ROW 3
 */
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m02 (.ina(H[0][2]), .inb(p[0]), .out(h02), .overflow(mult_of02));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m12 (.ina(H[1][2]), .inb(p[1]), .out(h12), .overflow(mult_of12));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m22 (.ina(H[2][2]), .inb(p[2]), .out(h22), .overflow(mult_of22));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m32 (.ina(H[3][2]), .inb(p[3]), .out(h32), .overflow(mult_of32));
 
 /*
 *			MULT	-	ROW 4
 */
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m03 (.ina(H[0][3]), .inb(p[0]), .out(h03), .overflow(mult_of03));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m13 (.ina(H[1][3]), .inb(p[1]), .out(h13), .overflow(mult_of13));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m23 (.ina(H[2][3]), .inb(p[2]), .out(h23), .overflow(mult_of23));
 
 fxp_mul #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) m33 (.ina(H[3][3]), .inb(p[3]), .out(h33), .overflow(mult_of33));
 
/*
 *			SUM	-	ROW 1
 */
 fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s00	(.ina(h00), .inb(h10), .out(sum00), .overflow(sum_of00));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s10	(.ina(sum00), .inb(h20), .out(sum10), .overflow(sum_of10));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s20	(.ina(sum10), .inb(h30), .out(Pp[0]), .overflow(sum_of20)); // Assign final answer to p'
 
/*
 *			SUM	-	ROW 2
 */
 fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s01	(.ina(h01), .inb(h11), .out(sum01), .overflow(sum_of01));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s11	(.ina(sum01), .inb(h21), .out(sum11), .overflow(sum_of11));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s21	(.ina(sum11), .inb(h31), .out(Pp[1]), .overflow(sum_of21)); // Assign final answer to p'
 
/*
 *			SUM	-	ROW 3
 */
 fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s02	(.ina(h02), .inb(h12), .out(sum02), .overflow(sum_of02));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s12	(.ina(sum02), .inb(h22), .out(sum12), .overflow(sum_of12));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s22	(.ina(sum12), .inb(h32), .out(Pp[2]), .overflow(sum_of22)); // Assign final answer to p'
 
/*
 *			SUM	-	ROW 4
 */
 fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s03	(.ina(h03), .inb(h13), .out(sum03), .overflow(sum_of03));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s13	(.ina(sum03), .inb(h23), .out(sum13), .overflow(sum_of13));
 
  fxp_add #(
	.WIIA(WII), .WIFA(WIF),
	.WIIB(WII), .WIFB(WIF),
	.WOI(WOI),	.WOF(WOF),
	.ROUND(0)
 ) s23	(.ina(sum13), .inb(h33), .out(Pp[3]), .overflow(sum_of23)); // Assign final answer to p'
	
endmodule


