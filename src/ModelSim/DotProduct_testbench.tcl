# stop any simulation that is currently running
quit -sim

# create the default "work" library
vlib work;

# compile the Verilog source code in the parent folder
vlog ../*.sv
# compile the Verilog code of the testbench
vlog DotProduct_testbench.sv
# start the Simulator, including some libraries that may be needed
vsim work.testbench -Lf 220model -Lf altera_mf_ver -Lf verilog

# Show state and hsTimer

# show waveforms specified in wave.do
do DotProduct_wave.do
# advance the simulation the desired amount of time
run 800 ns