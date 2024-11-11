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
	
	wire	[24:0] 	pos;
	wire	[24:0]	ori;
	
	// Registers
	reg	[24:0]	outPose;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 /*
  *	Switch between showing position and orientation
  */
 
 always @ (posedge CLOCK_50) begin
	if(SW[9] == 1'b0)
		outPose <= pos;
	else
		outPose <= ori;
 end
 
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
	
	Hexadecimal_To_Seven_Segment Segment0 (
		// Inputs
		.hex_number			(outPose[19:16]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX0)
	);

	Hexadecimal_To_Seven_Segment Segment1 (
		// Inputs
		.hex_number			(outPose[23:20]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX1)
	);
	
	Hexadecimal_To_Seven_Segment Segment2 (
		// Inputs
		.hex_number			(outPose[11:8]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX2)
	);
	
	Hexadecimal_To_Seven_Segment Segment3 (
		// Inputs
		.hex_number			(outPose[15:12]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX3)
	);
	
	Hexadecimal_To_Seven_Segment Segment4 (
		// Inputs
		.hex_number			(outPose[3:0]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX4)
	);
	
	Hexadecimal_To_Seven_Segment Segment5 (
		// Inputs
		.hex_number			(outPose[7:4]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX5)
	);
	

endmodule