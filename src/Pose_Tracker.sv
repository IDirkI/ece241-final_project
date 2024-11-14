module Pose_Tracker # (
		parameter 	WOI = 9,
						WOF = 16
	) (
	// Inputs
	CLOCK_50,
	reset,
	keycode,
	
	// Outputs
	position,
	orientation
	);
	
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
 // Scaling Factor
 parameter SF	=	2.0**WOF;
 
 // Math Constants
 parameter PI = 25'b0_00000011_0010010000111101; // 3.1415557861328125
																 // ~0.000035 percision
																 // Must increment ORI by 0.0001 or closeset equivelent
 
 // Update Constants
 parameter  TIMING_CONST 	= 25'd1;
 parameter  POS_INC_RATE	= 25'd1,									  // INC RATE	:	+ 1
				ORI_INC_RATE	= 25'b0_00000000_0000000000000111; // INC RATE	:	+ 0.0001068115234375 ~ 0.0001
 
 
 
 // Need right handed coordinates so <+x> X <+y> = <+z>
 parameter	W		= 8'h1D,	// -z
				A		= 8'h1C,	// -x
				S		= 8'h1B,	//	+z
				D 		= 8'h23, //	+x
				SHIFT = 8'h12, //	-y
				SPACE = 8'h29; //	+y
				
 parameter 	UP		= 8'h75, // -β
				DOWN	= 8'h72, // +β
				RIGHT	= 8'h74,	// +γ
				LEFT	= 8'h6B, // -γ
				IN		= 8'h73,	// -α
				OUT	= 8'h70;	// +α
 /*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
 // Inputs
 input wire					CLOCK_50;
 input wire					reset;
 input wire		[7:0]		keycode;
 
 // Outputs
 
/*
 *				
 *													| x |
 *													| y |
 *							|   position  |	| z |
 *				Pose	= 	|				  | = |   | ∈ ℝ³ × T³
 *							| orientation |	| α |
 *													| β |
 *													| γ |		
 *
 */
													
 output reg		[2:0][WOI+WOF-1:0]		position; 		// 	-> <x, y, z>	3x25 -> 75 bits   
																		//													
																		//													
 output reg		[2:0][WOI+WOF-1:0]		orientation;	// 	-> <α, β, γ>	3x25 -> 75 bits
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 reg	[25:0]	kbCount;
 
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 /*
  *		Pose Counter
  */
	always @ (posedge CLOCK_50) begin
		if(reset) begin
			kbCount <= 26'b0;
			
			position[0] <= 25'b0;
			position[1] <= 25'b0;
			position[2] <= 25'b0;
			
			orientation[0] <= 25'b0;
			orientation[1] <= 25'b0;
			orientation[2] <= 25'b0;
		end
		else if(keycode != 8'h00) begin
			kbCount <= kbCount + 1'b1;
			
			if(kbCount == TIMING_CONST) begin
				kbCount <= 26'b0;
				
				case	(keycode)
					// Position
					W		:	position[2] 	= 	position[2] - POS_INC_RATE*SF; // -z
					A		:	position[0]		= 	position[0] - POS_INC_RATE*SF; // -x
					S		:	position[2]		= 	position[2] + POS_INC_RATE*SF; // +z
					D		:	position[0]		= 	position[0] + POS_INC_RATE*SF; // +x
					SHIFT	:	position[1]		= 	position[1] - POS_INC_RATE*SF; // -y
					SPACE	:	position[1]		= 	position[1] + POS_INC_RATE*SF; // +y
					
					// Orientation
					UP		:	orientation[1]	=	orientation[1] - ORI_INC_RATE;	
					DOWN	:	orientation[1]	=	orientation[1]	+ ORI_INC_RATE;
					RIGHT	:	orientation[2]	=	orientation[2] + ORI_INC_RATE;	
					LEFT	:	orientation[2]	=	orientation[2]	- ORI_INC_RATE;
					IN		:	orientation[0]	=	orientation[0] - ORI_INC_RATE;	
					OUT	:	orientation[0]	=	orientation[0]	+ ORI_INC_RATE;
				endcase
			end
		 end
	end
	
 /*
  *		Orientation Wrapper
  */
  always @ (orientation) begin
		if(orientation[0] >= 2.0*PI) begin
			orientation[0] <= 25'b0;
		end
		
		if(orientation[1] >= 2.0*PI) begin
			orientation[1] <= 25'b0;
		end
		
		if(orientation[2] >= 2.0*PI) begin
			orientation[2] <= 25'b0;
		end
  end
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule
