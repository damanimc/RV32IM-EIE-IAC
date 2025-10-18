

Personal work for pipelined RV32IM CPU with Cache Memory for Instruction Architectures & Compiler's course @ Imperial College which received an A*. 

Tested the CPU with the provided reference program and created own version of the f1 light sequence program. Both programs have been verified to work on both the single cyles and pipelined version of the CPU. Also tested `mul`,`div` and `rem`instructions with a multi-cycle implementation.

CPU is demonstrated by the following gifs.![Alt text](images/Pipelined%20F1.gif)
![Alt text](images/Pipelined%20Ref.gif)

Updates:
- Added logic to the [Control Unit] and [ALU] for `jalr`, `lui`, `auipc`, `blt`, `bge`, `bltu`, `bgeu`, changed `aluCtrl` encoding and tested the instructions.
- Created, modified and tested the modules for the pipelined CPU.
- Wrote a version of the light sequence assembly code to work with `nop` instructions on the pipelined cpu without data hazard detection hardware.
- Implemented hazard detection in hardware by adding a hazard unit for data [forwarding], [stalling] and [flushing], which allowed the same programs from the single cycle CPU to work on the pipelined.
- Implemented multi-cycle `mul` ,`div` and `rem` instructions

What have I learned?

- I've learned how to write system verilog code. I've also learned more about control and data hazards. 
- Last year I made a multiplier on the single-cycle cpu. I know recognise that in real world scenarios this would be a bad idea because it would significantly limit the clock speed. 
