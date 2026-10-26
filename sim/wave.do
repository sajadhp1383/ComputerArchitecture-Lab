# Waveform Configuration for ARM 5-Stage Pipeline

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {GLOBAL CONTROL}
add wave -noupdate -color Yellow /Top_tb/clk
add wave -noupdate -color Red    /Top_tb/rst
add wave -noupdate -color Cyan   /Top_tb/Forwarding_EN

add wave -noupdate -divider {FETCH (IF)}
add wave -noupdate -radix hexadecimal /Top_tb/uut/PC_IF
add wave -noupdate -radix hexadecimal /Top_tb/uut/Instruction_IF
add wave -noupdate -color Orange /Top_tb/uut/true_hazard
add wave -noupdate -color Magenta /Top_tb/uut/B_EXE
add wave -noupdate -radix hexadecimal /Top_tb/uut/Branch_Address

add wave -noupdate -divider {DECODE (ID)}
add wave -noupdate -radix hexadecimal /Top_tb/uut/PC_ID
add wave -noupdate -radix hexadecimal /Top_tb/uut/Instruction_ID
add wave -noupdate -radix unsigned /Top_tb/uut/src1_ID
add wave -noupdate -radix unsigned /Top_tb/uut/src2_ID
add wave -noupdate -radix unsigned /Top_tb/uut/Dest_ID
add wave -noupdate -radix hexadecimal /Top_tb/uut/Val_Rn_ID
add wave -noupdate -radix hexadecimal /Top_tb/uut/Val_Rm_ID

add wave -noupdate -divider {EXECUTE (EXE)}
add wave -noupdate -radix hexadecimal /Top_tb/uut/alu_result_exe
add wave -noupdate -radix hexadecimal /Top_tb/uut/val_rm_exe_out
add wave -noupdate /Top_tb/uut/SR
add wave -noupdate /Top_tb/uut/sel_src1_wire
add wave -noupdate /Top_tb/uut/sel_src2_wire

add wave -noupdate -divider {MEMORY (MEM)}
add wave -noupdate /Top_tb/uut/MEM_R_EN_MEM
add wave -noupdate /Top_tb/uut/MEM_W_EN_MEM
add wave -noupdate -radix hexadecimal /Top_tb/uut/ALU_result_MEM
add wave -noupdate -radix hexadecimal /Top_tb/uut/Val_Rm_MEM
add wave -noupdate -radix hexadecimal /Top_tb/uut/data_mem_out_MEM

add wave -noupdate -divider {WRITEBACK (WB)}
add wave -noupdate /Top_tb/uut/WB_EN_WB
add wave -noupdate -radix unsigned /Top_tb/uut/Dest_WB
add wave -noupdate -radix hexadecimal /Top_tb/uut/WB_WB_Value

add wave -noupdate -divider {REGISTER FILE}
add wave -noupdate -radix decimal /Top_tb/uut/ID_stage_inst/RF/regs

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamestyle 1
configure wave -timeline 0
configure wave -timelineunits ns
update
