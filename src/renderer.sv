// Top level module the project enters initially
module renderer(
	// Inputs
	CLOCK_50, 
	KEY, 
	SW,
	
	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
	parameter 	WOI = 9,
					WOF = 16;
/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
	// Inputs
	input wire 			CLOCK_50;
	input wire	[9:0]	SW;
	input wire	[3:0] KEY; // KEY[0] -> reset		KEY[1] -> send command
	
	// Bidirectionals
	inout wire			PS2_CLK;
	inout	wire			PS2_DAT;
	
	// Outputs
	output wire	[6:0] HEX0;
	output wire	[6:0] HEX1;
	output wire	[6:0] HEX2;
	output wire	[6:0] HEX3;
	output wire	[6:0] HEX4;
	output wire	[6:0] HEX5;
	output wire [9:0] LEDR;
	

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
	// Internal Wires
	wire				reset;
	wire	[7:0]		input_command;
	wire				send_command;
	wire				command_was_sent;
	wire				error_communication;
	wire	[7:0]		keycode;
	
	wire	[2:0][WOI+WOF-1:0]	pos;
	wire	[2:0][WOI+WOF-1:0]	ori;
	
	
	wire 	[2:0][WOI+WOF-1:0] Poly1;
	wire 	[2:0][WOI+WOF-1:0] Poly2;
	wire 	[2:0][WOI+WOF-1:0] Poly3;
	wire 	[2:0][WOI+WOF-1:0] Poly4;
	wire 	[2:0][WOI+WOF-1:0] Poly5;
	wire 	[2:0][WOI+WOF-1:0] Poly6;
	wire 	[2:0][WOI+WOF-1:0] Poly7;
	wire 	[2:0][WOI+WOF-1:0] Poly8;
	wire 	[2:0][WOI+WOF-1:0] Poly9;
	wire 	[2:0][WOI+WOF-1:0] Poly10;
	wire 	[2:0][WOI+WOF-1:0] Poly11;
	wire 	[2:0][WOI+WOF-1:0] Poly12;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
assign reset			= ~KEY[0];
assign send_command 	= ~KEY[1];
assign input_command = SW[7:0];

assign LEDR[9] = reset; // Visual Reset
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
	
	Polygon_List # (
		.WOI					(WOI),
		.WOF					(WOF)
	) LIST (
		// Outputs
		.Poly1				(Poly1),
		.Poly2				(Poly2),
		.Poly3				(Poly3),
		.Poly4				(Poly4),
		.Poly5				(Poly5),
		.Poly6				(Poly6),
		.Poly7				(Poly7),
		.Poly8				(Poly8),
		.Poly9				(Poly9),
		.Poly10				(Poly10),
		.Poly11				(Poly11),
		.Poly12				(Poly12)
	);
	
	Pose_Tracker	PT	(
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(reset),
		.keycode				(keycode),
		
		// Outputs
		.position			(pos),
		.orientation		(ori)
	);
 
	Keyboard_Intefracer KB_I (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(reset),
		.input_command		(input_command),
		.send_command		(send_command),
		
		// Bidirectional
		.PS2_CLK				(PS2_CLK),
		.PS2_DAT				(PS2_DAT),
		
		// Outputs
		.command_was_sent	(command_was_sent),
		.error_communication_timed_out (error_communication),
		.keycode				(keycode)
	);
	

endmodule
