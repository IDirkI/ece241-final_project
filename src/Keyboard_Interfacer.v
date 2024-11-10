module Keyboard_Intefracer(
	// Inputs
		CLOCK_50,
		reset,
		input_command,
		send_command,
		
	// Bidirectionals
		PS2_CLK,
		PS2_DAT,
		
	// Outputs
		command_was_sent,
		error_communication_timed_out,
		keycode
 );
 
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
 
 // Inputs
	input wire				CLOCK_50;
	input wire				reset;
	input wire		[7:0]	input_command;
	input	wire				send_command;
 
 // Bidirectionals
	inout	wire				PS2_CLK;
	inout	wire				PS2_DAT;
	
 // Outputs
	output wire				command_was_sent;
	output wire				error_communication_timed_out;
	output reg		[7:0]	keycode;
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 // Wires
	wire	[7:0]	ps2_key_data;
	wire			ps2_key_pressed;
 
 // Registers
	reg	[7:0]	the_command;
 
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
		if(reset == 1'b1) begin// Reset condition: last data -> NONE
			keycode <= 8'h00;
		end
		else if (ps2_key_pressed == 1'b1) begin
			if(keycode == 8'hF0) // Break condition
				keycode <= 8'h00;
			else
				keycode <= ps2_key_data;
		end
			
	end
 
 
 /*
  *		Send Data
  */
	always @ (posedge CLOCK_50) begin
		if(reset == 1'b1) // Reset condition: command -> NONE
			the_command <= 0;
		else
			the_command <= input_command;
	end
 
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
  
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(reset),
		.the_command		(the_command),
		.send_command		(send_command),
		
		// Bidirectional
		.PS2_CLK				(PS2_CLK),
		.PS2_DAT				(PS2_DAT),
		
		// Outputs
		.command_was_sent	(command_was_sent),
		.error_communication_timed_out (error_communication_timed_out),
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);
		 
endmodule
