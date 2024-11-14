onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Poly1 -radix decimal /testbench/Poly1
add wave -noupdate -label Poly2 -radix decimal /testbench/Poly2
add wave -noupdate -label Poly3 -radix decimal /testbench/Poly3
add wave -noupdate -label Poly4 -radix decimal /testbench/Poly4
add wave -noupdate -label Poly5 -radix decimal /testbench/Poly5
add wave -noupdate -label Poly6 -radix decimal /testbench/Poly6
add wave -noupdate -label Poly7 -radix decimal /testbench/Poly7
add wave -noupdate -label Poly8 -radix decimal /testbench/Poly8
add wave -noupdate -label Poly9 -radix decimal /testbench/Poly9
add wave -noupdate -label Poly10 -radix decimal /testbench/Poly10
add wave -noupdate -label Poly11 -radix decimal /testbench/Poly11
add wave -noupdate -label Poly12 -radix decimal /testbench/Poly12
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {120 ns}
