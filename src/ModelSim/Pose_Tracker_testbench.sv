`timescale 1ns / 1ps

module Pose_Tracker_testbench ( );

	parameter 	WOI = 9,
				WOF = 16;

	parameter CLOCK_PERIOD = 10;

	reg CLOCK_50;
    reg reset;
	reg [7:0] keycode;
	
	wire [2:0][WOI+WOF-1:0] position;
	wire [2:0][WOI+WOF-1:0] orientation;

	initial begin
        CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
        reset <= 1'b1;
        #10 reset <= 1'b0;
	end // initial

    // In the setup below we assume that the half_sec_enable signal coming
    // from the half-second clock is asserted every 3 cycles of CLOCK_50. Of
    // course, in the real circuit the half-second clock is asserted every
    // 25M cycles. The setup below produces the Morse code for A (.-) followed
    // by the Morse code for B (-...).
	initial begin
        keycode <= 8'h00;
		#10 keycode <= 8'h1C; // Press 'A'
		#30 keycode <= 8'h00;
		#30 keycode <= 8'h23; // Press 'D'
	end // initial
	Pose_Tracker U1 (CLOCK_50, reset, keycode, position, orientation);

endmodule
