onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label POS -radix decimal /testbench/position
add wave -noupdate -label ORI -radix decimal /testbench/orientation
add wave -noupdate -label PROJ -radix decimal /U1/Proj
add wave -noupdate -label P -radix decimal /testbench/poly
add wave -noupdate -label P' -radix decimal /testbench/poly_proj
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
