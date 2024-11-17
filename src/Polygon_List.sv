module Polygon_List # (
			parameter 	WOI = 9,
							WOF = 16
	)
	(
		// Outputs
		Poly1,
		Poly2,
		Poly3,
		Poly4,
		Poly5,
		Poly6,
		Poly7,
		Poly8,
		Poly9,
		Poly10,
		Poly11,
		Poly12
	);
	
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
// Scaling Factor
parameter 	SF   = 2.0**WOF; 
				
// Cube Corners
 parameter	C1x  = 25'd0*SF,
				C1y  = 25'd0*SF,	// <0, 0, 0>
				C1z  = 25'd0*SF;
				
 parameter	C2x  = 25'd8*SF,
				C2y  = 25'd0*SF,	// <8, 0, 0>
				C2z  = 25'd0*SF;
				
 parameter	C3x  = 25'd0*SF,
				C3y  = 25'd8*SF,	// <0, 8, 0>
				C3z  = 25'd0*SF;
				
 parameter	C4x  = 25'd8*SF,
				C4y  = 25'd8*SF,	// <8, 8, 0>
				C4z  = 25'd0*SF;
				
 parameter	C5x  = 25'd0*SF,
				C5y  = 25'd0*SF,	// <0, 0, 8>
				C5z  = 25'd8*SF;
				
 parameter	C6x  = 25'd8*SF,
				C6y  = 25'd0*SF,	// <8, 0, 8>
				C6z  = 25'd8*SF;
				
 parameter	C7x  = 25'd0*SF,
				C7y  = 25'd8*SF,	// <0, 8, 8>
				C7z  = 25'd8*SF;
				
 parameter	C8x  = 25'd8*SF,
				C8y  = 25'd8*SF,	// <8, 8, 8>
				C8z  = 25'd8*SF;
				
 
/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

 /*											
  *											|	x₁		x₂		x₃	|	(1+8+16 bits signed)
  *											|	y₁		y₂		y₃	|	(1+8+16 bits signed)
  *			|Poly_n| = 16x25 ===>	|	z₁		z₂		z₃	|	(1+8+16 bits signed)
  *											|	1		1		1	|	(1+8+16 bits, 25'b1)
  *
  *			{Poly1, Poly2, ...} ---> 4800 bits -> 4.8 kB
  */
 
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly1;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly2;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly3;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly4;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly5;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly6;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly7;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly8;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly9;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly10;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly11;
	output reg	signed [2:0][3:0][WOI+WOF-1:0] Poly12;


	
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*
 *
 *	 FRONT
 *
 */
 
/*
 *		Polygon 1	:	C1 -> C2 -> C3
 */
 assign Poly1[0][0] =  	C1x;
 assign Poly1[0][1] =	C1y;	// P1
 assign Poly1[0][2] =	C1z;
 assign Poly1[0][3] =	9'b1;
 
 assign Poly1[1][0] =  	C2x;
 assign Poly1[1][1] =	C2y;	// P2
 assign Poly1[1][2] =	C2z;
 assign Poly1[1][3] =	9'b1;
 
 assign Poly1[2][0] =  	C3x;
 assign Poly1[2][1] =	C3y;	// P3
 assign Poly1[2][2] =	C3z;
 assign Poly1[2][3] =	9'b1;
 
/*
 *		Polygon 2	:	C2 -> C4 -> C3
 */
 assign Poly2[0][0] =  	C2x;
 assign Poly2[0][1] =	C2y;	// P1
 assign Poly2[0][2] =	C2z;
 assign Poly2[0][3] =	9'b1;
 
 assign Poly2[1][0] =  	C4x;
 assign Poly2[1][1] =	C4y;	// P2
 assign Poly2[1][2] =	C4z;
 assign Poly2[1][3] =	9'b1;
 
 assign Poly2[2][0] =  	C3x;
 assign Poly2[2][1] =	C3y;	// P3
 assign Poly2[2][2] =	C3z;
 assign Poly2[2][3] =	9'b1;
 
/*
 *
 *							RIGHT
 *
 */
 

 /*
 *		Polygon 3	:	C2 -> C8 -> C4
 */
 assign Poly3[0][0] =  	C2x;
 assign Poly3[0][1] =	C2y;	// P1
 assign Poly3[0][2] =	C2z;
 assign Poly3[0][3] =	9'b1;
 
 assign Poly3[1][0] =  	C8x;
 assign Poly3[1][1] =	C8y;	// P2
 assign Poly3[1][2] =	C8z;
 assign Poly3[1][3] =	9'b1;
 
 assign Poly3[2][0] =  	C4x;
 assign Poly3[2][1] =	C4y;	// P3
 assign Poly3[2][2] =	C4z;
 assign Poly3[2][3] =	9'b1;
 
/*
 *		Polygon 4	:	C2 -> C6 -> C8
 */
 assign Poly4[0][0] =  	C2x;
 assign Poly4[0][1] =	C2y;	// P1
 assign Poly4[0][2] =	C2z;
 assign Poly4[0][3] =	9'b1;
 
 assign Poly4[1][0] =  	C6x;
 assign Poly4[1][1] =	C6y;	// P2
 assign Poly4[1][2] =	C6z;
 assign Poly4[1][3] =	9'b1;
 
 assign Poly4[2][0] =  	C8x;
 assign Poly4[2][1] =	C8y;	// P3
 assign Poly4[2][2] =	C8z;
 assign Poly4[2][3] =	9'b1;

/*
 *
 *							LEFT
 *
 */
 
/*
 *		Polygon 5	:	C1 -> C3 -> C7
 */
 assign Poly5[0][0] =  	C1x;
 assign Poly5[0][1] =	C1y;	// P1
 assign Poly5[0][2] =	C1z;
 assign Poly5[0][3] =	9'b1;
 
 assign Poly5[1][0] =  	C3x;
 assign Poly5[1][1] =	C3y;	// P2
 assign Poly5[1][2] =	C3z;
 assign Poly5[1][3] =	9'b1;
 
 assign Poly5[2][0] =  	C7x;
 assign Poly5[2][1] =	C7y;	// P3
 assign Poly5[2][2] =	C7z;
 assign Poly5[2][3] =	9'b1;
 
/*
 *		Polygon 6	:	C1 -> C7 -> C5
 */
 assign Poly6[0][0] =  	C1x;
 assign Poly6[0][1] =	C1y;	// P1
 assign Poly6[0][2] =	C1z;
 assign Poly6[0][3] =	9'b1;
 
 assign Poly6[1][0] =  	C7x;
 assign Poly6[1][1] =	C7y;	// P2
 assign Poly6[1][2] =	C7z;
 assign Poly6[1][3] =	9'b1;

 assign Poly6[2][0] =  	C5x;
 assign Poly6[2][1] =	C5y;	// P3
 assign Poly6[2][2] =	C5z;
 assign Poly6[2][3] =	9'b1;

/*
 *							TOP
 */
 
/*
 *		Polygon 7	:	C3 -> C4 -> C7
 */
 assign Poly7[0][0] =  	C3x;
 assign Poly7[0][1] =	C3y;	// P1
 assign Poly7[0][2] =	C3z;
 assign Poly7[0][3] =	9'b1;
 
 assign Poly7[1][0] =  	C4x;
 assign Poly7[1][1] =	C4y;	// P2
 assign Poly7[1][2] =	C4z;
 assign Poly7[1][3] =	9'b1;
 
 assign Poly7[2][0] =  	C7x;
 assign Poly7[2][1] =	C7y;	// P3
 assign Poly7[2][2] =	C7z;
 assign Poly7[2][3] =	9'b1;

/*
 *		Polygon 8	:	C4 -> C8 -> C7
 */
 assign Poly8[0][0] =  	C4x;
 assign Poly8[0][1] =	C4y;	// P1
 assign Poly8[0][2] =	C4z;
 assign Poly8[0][3] =	9'b1;

 assign Poly8[1][0] =  	C8x;
 assign Poly8[1][1] =	C8y;	// P2
 assign Poly8[1][2] =	C8z;
 assign Poly8[1][3] =	9'b1;
 
 assign Poly8[2][0] =  	C7x;
 assign Poly8[2][1] =	C7y;	// P3
 assign Poly8[2][2] =	C7z;
 assign Poly8[2][3] =	9'b1;

/*
 *
 *							BOTTOM
 *
 */
 
/*
 *		Polygon 9	:	C1 -> C5 -> C2
 */
 assign Poly9[0][0] =  	C1x;
 assign Poly9[0][1] =	C1y;	// P1
 assign Poly9[0][2] =	C1z;
 assign Poly9[0][3] =	9'b1;

 assign Poly9[1][0] =  	C5x;
 assign Poly9[1][1] =	C5y;	// P2
 assign Poly9[1][2] =	C5z;
 assign Poly9[1][3] =	9'b1;
 
 assign Poly9[2][0] =  	C2x;
 assign Poly9[2][1] =	C2y;	// P3
 assign Poly9[2][2] =	C2z;
 assign Poly9[2][3] =	9'b1;

 /*
 *		Polygon 10	:	C2 -> C5 -> C6
 */
 assign Poly10[0][0] =  C2x;
 assign Poly10[0][1] =	C2y;	// P1
 assign Poly10[0][2] =	C2z;
 assign Poly10[0][3] =	9'b1;

 assign Poly10[1][0] =  	C5x;
 assign Poly10[1][1] =	C5y;	// P2
 assign Poly10[1][2] =	C5z;
 assign Poly10[1][3] =	9'b1;
 
 assign Poly10[2][0] =  C6x;
 assign Poly10[2][1] =	C6y;	// P3
 assign Poly10[2][2] =	C6z;
 assign Poly10[2][3] =	9'b1;
 
/*
 *
 *							BACK
 *
 */
 
/*
 *		Polygon 11	:	C7 -> C6 -> C5
 */
 assign Poly11[0][0] =  C7x;
 assign Poly11[0][1] =	C7y;	// P1
 assign Poly11[0][2] =	C7z;
 assign Poly11[0][3] =	9'b1;

 assign Poly11[1][0] =  C6x;
 assign Poly11[1][1] =	C6y;	// P2
 assign Poly11[1][2] =	C6z;
 assign Poly11[1][3] =	9'b1;
 
 assign Poly11[2][0] = 	C5x;
 assign Poly11[2][1] =	C5y;	// P3
 assign Poly11[2][2] =	C5z;
 assign Poly11[2][3] =	9'b1;
 
/*
 *		Polygon 12	:	C7 -> C8 -> C6
 */
 assign Poly12[0][0] =  C7x;
 assign Poly12[0][1] =	C7y;	// P1
 assign Poly12[0][2] =	C7z;
 assign Poly12[0][3] =	9'b1;
 
 assign Poly12[1][0] =  C8x;
 assign Poly12[1][1] =	C8y;	// P2
 assign Poly12[1][2] =	C8z;
 assign Poly12[1][3] =	9'b1;
 
 assign Poly12[2][0] = 	C6x;
 assign Poly12[2][1] =	C6y;	// P3
 assign Poly12[2][2] =	C6z;
 assign Poly12[2][3] =	9'b1;
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
endmodule
