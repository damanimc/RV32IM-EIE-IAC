rm -rf obj_dir
rm -f CPU.vcd

verilator -Wall -cc -trace CPU.sv --exe mul_tb.cpp

make -j -C obj_dir/ -f VCPU.mk VCPU

obj_dir/VCPU