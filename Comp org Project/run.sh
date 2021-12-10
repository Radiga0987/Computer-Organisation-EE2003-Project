#!/bin/sh
#
# Compile and run the test bench

[ -x "$(command -v iverilog)" ] || { echo "Install iverilog"; exit 1; }


iverilog -o dut cpu_tb.v cpu.v dmem.v imem.v regfile.v alu.v imm_gen.v control.v cpu_mm.v control_mm.v matrix_ops.v regfile_mm.v

./dut  #vvp dut

cat << EOF 
MaTrIx MuLtIpLiEd!!!
EOF
