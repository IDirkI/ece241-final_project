module Pose_Tracker(
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
 // Need right handed coordinates so <+x> X <+y> = <+z>
 parameter	W		= 8'h1D,	// -z
				A		= 8'h1C,	// -x
				S		= 8'h1B,	//	+z
				D 		= 8'h23, //	+x
				SHIFT = 8'h12, //	-y
				SPACE = 8'h29; //	+y
/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
 // Inputs
 input wire					CLOCK_50;
 input wire					reset;
 input wire		[7:0]		keycode;
 
 // Outputs
													//									x		 y			 z
 output reg		[23:0]		position; 		// Positions		-> <[7:0], [15:8], [23:16]> TESTING
 
													//									α		 β			 γ
 output reg		[23:0]		orientation;	// Orientation		-> <[7:0], [15:8], [23:16]> TESTING

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
			position = 24'b0;
			orientation = 24'b0;
		end
		else if(keycode != 8'h00)
			kbCount <= kbCount + 1'b1;
			
			if(kbCount == 26'd10_000_000) begin
				kbCount <= 26'b0;
				
				case	(keycode)
					// Position
					W		:	position[23:16] 	= position[23:16] - 1'b1; // -z
					A		:	position[7:0]		= position[7:0]	- 1'b1; // -x
					S		:	position[23:16]	= position[23:16] + 1'b1; // +z
					D		:	position[7:0]		= position[7:0]	+ 1'b1; // +x
					SHIFT	:	position[15:8]		= position[15:8] 	- 1'b1; // -y
					SPACE	:	position[15:8]		= position[15:8] 	+ 1'b1; // +y
				endcase
			end
			
	end
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule
