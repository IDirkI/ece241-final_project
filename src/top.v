// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

module top (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, PS2_CLK, PS2_DAT);

    input wire CLOCK_50;             // DE-series 50 MHz clock signal
    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [6:0] HEX0;     // DE-series HEX displays
    output wire [6:0] HEX1;
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;
    output wire [6:0] HEX5;

    output wire [9:0] LEDR;     // DE-series LEDs  

	inout wire  PS2_CLK;
    inout wire  PS2_DAT;

    renderer U1 (.CLOCK_50(CLOCK_50),
				 .SW(SW[9:0]),
				 .KEY(KEY[3:0]),
				 .HEX0(HEX0),
				 .HEX1(HEX1),
				 .HEX2(HEX2),
				 .HEX3(HEX3),
				 .HEX4(HEX4),
				 .HEX5(HEX5),
				 .LEDR(LEDR[9:0]),
				 .PS2_CLK(PS2_CLK),
				 .PS2_DAT(PS2_DAT)
				 );

endmodule

