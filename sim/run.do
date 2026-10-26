# ====================================================================
# ModelSim Simulation Script for 5-Stage Pipelined ARM Processor
# Computer Architecture Lab - University of Tehran
# ====================================================================

# Stop any running simulation
catch {quit -sim}

# Determine project root directory whether script is run from root or sim/
set script_dir [file dirname [info script]]
if {$script_dir == "." || $script_dir == ""} {
    if {[file exists "../src"]} {
        set root_dir ".."
    } else {
        set root_dir "."
    }
} else {
    if {[file exists "$script_dir/../src"]} {
        set root_dir "$script_dir/.."
    } else {
        set root_dir "$script_dir"
    }
}

puts ">>> Project Root: $root_dir"

# Ensure instruction_mem.mem is available in current simulation directory
if {![file exists "instruction_mem.mem"] && [file exists "$root_dir/tb/instruction_mem.mem"]} {
    file copy -force "$root_dir/tb/instruction_mem.mem" "."
    puts ">>> Copied instruction_mem.mem to simulation directory."
}

# Create / clean work library
if {[file exists work]} {
    catch {vdel -lib work -all}
}
vlib work
vmap work work

puts ">>> Compiling RTL and Testbench files..."

# Base / Utility Modules
vlog -work work "$root_dir/src/PC_adder.v"
vlog -work work "$root_dir/src/PC_mux.v"
vlog -work work "$root_dir/src/PC_reg.v"
vlog -work work "$root_dir/src/instruction_mem.v"
vlog -work work "$root_dir/src/RegisterFile.v"
vlog -work work "$root_dir/src/StatusRegister.v"
vlog -work work "$root_dir/src/condition_check.v"
vlog -work work "$root_dir/src/control_unit.v"
vlog -work work "$root_dir/src/shift_operand.v"
vlog -work work "$root_dir/src/Val2Generator.v"
vlog -work work "$root_dir/src/ALU.v"
vlog -work work "$root_dir/src/data_mem.v"
vlog -work work "$root_dir/src/Hazard_Detection_Unit.v"
vlog -work work "$root_dir/src/Forwarding_Unit.v"

# Pipeline Stages and Stage Registers
vlog -work work "$root_dir/src/IF_stage.v"
vlog -work work "$root_dir/src/IF_stage_reg.v"
vlog -work work "$root_dir/src/ID_stage.v"
vlog -work work "$root_dir/src/ID_stage_reg.v"
vlog -work work "$root_dir/src/EXE_stage.v"
vlog -work work "$root_dir/src/EXE_stage_reg.v"
vlog -work work "$root_dir/src/MEM_stage.v"
vlog -work work "$root_dir/src/MEM_stage_reg.v"
vlog -work work "$root_dir/src/WB_stage.v"
vlog -work work "$root_dir/src/WB_stage_reg.v"

# Top and Testbench
vlog -work work "$root_dir/src/Top.v"
vlog -work work "$root_dir/tb/Top_tb.v"

puts ">>> Compilation completed successfully."

# Start simulation
vsim -voptargs=+acc work.Top_tb

# Setup Waveform
if {[file exists "$root_dir/sim/wave.do"]} {
    do "$root_dir/sim/wave.do"
} else {
    add wave -divider "CLOCK & RESET"
    add wave -color "Yellow" /Top_tb/clk
    add wave -color "Red"    /Top_tb/rst
    add wave -color "Cyan"   /Top_tb/Forwarding_EN

    add wave -divider "IF STAGE"
    add wave -radix hexadecimal /Top_tb/uut/PC_IF
    add wave -radix hexadecimal /Top_tb/uut/Instruction_IF

    add wave -divider "ID STAGE"
    add wave -radix hexadecimal /Top_tb/uut/PC_ID
    add wave -radix hexadecimal /Top_tb/uut/Instruction_ID

    add wave -divider "HAZARDS & FORWARDING"
    add wave /Top_tb/uut/true_hazard
    add wave /Top_tb/uut/Hazard_Detected_wire
    add wave /Top_tb/uut/B_EXE
    add wave /Top_tb/uut/sel_src1_wire
    add wave /Top_tb/uut/sel_src2_wire

    add wave -divider "REGISTER FILE"
    add wave -radix decimal /Top_tb/uut/ID_stage_inst/RF/regs
}

# Run simulation
run -all
