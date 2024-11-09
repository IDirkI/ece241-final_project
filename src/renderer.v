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
	wire 	[7:0]		ps2_key_data;
	wire				ps2_key_pressed;
	wire				send_command;
	wire				command_was_sent;
	wire				error_communication;
	
	wire	[24:0] 	pos;
	wire	[24:0]	ori;
	
	// Registers
	reg	[7:0]		ps2_data_received;
	reg	[7:0]		the_command;
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 /*
  *		Recieve Data
  */
	always @ (posedge CLOCK_50) begin
		if(KEY[0] == 1'b0) begin// Reset condition: last data -> NONE
			ps2_data_received <= 8'h00;
		end
		else if (ps2_key_pressed == 1'b1) begin
			if(ps2_data_received == 8'hF0) // Break condition
				ps2_data_received <= 8'h00;
			else
				ps2_data_received <= ps2_key_data;
		end
			
	end
 
 
 /*
  *		Send Data
  */
	always @ (posedge CLOCK_50) begin
		if(KEY[0] == 1'b0) // Reset condition: command -> NONE
			the_command <= 0;
		else
			the_command <= SW[7:0];
	end
	
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
assign send_command = ~KEY[1];
assign LEDR[9] = ~KEY[0];
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
	Pose_Tracker	PT	(
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(~KEY[0]),
		.keycode				(ps2_data_received),
		
		// Outputs
		.position			(pos),
		.orientation		(ori)
	);
 
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(~KEY[0]),
		.the_command		(the_command),
		.send_command		(send_command),
		
		// Bidirectional
		.PS2_CLK				(PS2_CLK),
		.PS2_DAT				(PS2_DAT),
		
		// Outputs
		.command_was_sent	(command_was_sent),
		.error_communication_timed_out (error_communication),
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);
	
	Hexadecimal_To_Seven_Segment Segment0 (
		// Inputs
		.hex_number			(pos[23:20]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX0)
	);

	Hexadecimal_To_Seven_Segment Segment1 (
		// Inputs
		.hex_number			(pos[19:16]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX1)
	);
	
	Hexadecimal_To_Seven_Segment Segment2 (
		// Inputs
		.hex_number			(pos[11:8]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX2)
	);
	
	Hexadecimal_To_Seven_Segment Segment3 (
		// Inputs
		.hex_number			(pos[15:12]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX3)
	);
	
	Hexadecimal_To_Seven_Segment Segment4 (
		// Inputs
		.hex_number			(pos[3:0]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX4)
	);
	
	Hexadecimal_To_Seven_Segment Segment5 (
		// Inputs
		.hex_number			(pos[7:4]),

		// Bidirectional

		// Outputs
		.seven_seg_display	(HEX5)
	);
	

endmodule