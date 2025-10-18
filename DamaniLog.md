

# **Damani Log**

### Single Cycle
##### Control Unit
##### **ALU**

To implement all of the logic and arithemtic instructions I changed the ALUCtrl to 4-bits funct7[5]:funct3.

I also changed the encoding of the ALU. Now the zero flag is essentially used to check whether conditions are satisfied in the alu or not and no longer just flags wether the output is zero.

```verilog
    always_comb begin
        case (ctrl[2:0])
            3'b000: sum = !ctrl[3] ?  (op1 + op2) : (op1 - op2);
            3'b001: sum = op1 << op2[4:0];
            3'b010: sum = {{31'b0}, {($signed(op1) < $signed(op2))}}; 
            3'b011: sum =  {{31'b0}, {(op1 < op2)}}; // need to be unsigned
            3'b100: sum = op1 ^ op2;
            3'b101: sum = !ctrl[3] ? (op1 >> op2[4:0]) : (op1 >>> op2[4:0]);
            3'b110: sum = op1 | op2;
            3'b111: sum = !ctrl[3] ? (op1 & op2) : op2; //(1111 for load instructions)
        
        endcase

        case (ctrl[2:0])
            3'b000: Zero = (op1 == op2);
            3'b001: Zero = (op1 != op2);
            3'b100: Zero = ($signed(op1) < $signed(op2));
            3'b101: Zero = ($signed(op1) >= $signed(op2));
            3'b110: Zero = (op1 < op2);
            3'b111: Zero = (op1 >= op2);
            default: Zero = 0;
        
        endcase
    end
```

##### Paramatisable MUX

To reduce the need for multiple mux instances I decided to implement a paramerisable mux to replace MUX2 and MUX4 called MUXN.sv Now there is an array called bus which can be set to a custom width dependant on the number of bits you would like to use for your select.

```verilog
    module MUXN
        #(parameter MUX_WIDTH,DATA_WIDTH)
        (
            input [MUX_WIDTH-1:0] bus [DATA_WIDTH-1:0],
            input  logic [MUX_WIDTH-1:0] sel,
            output logic [DATA_WIDTH-1:0] out
        );
    assign out=bus[sel];
    endmodule
```
---

### Pipelining


##### Diagram
I created this design to follow for the top level module.
![Alt text](images/pipeline-blockdiagram.png)

##### Register File
The data to be written to the register file must arrive at the same time as the result to ensure this happens the regsiter file needs to be triggered by the falling edge.

##### Control Unit
- Program Counter Controls
    - The logic for for the program counter for the single-cycle CPU is based on PCSel. The issue with this is that now the control unit no longer has zero provided so PCsel
    - PCSel = 00 for all instructions except the jump and branch instructions. For Jump instructions PC is either 01 or 10. For branch instructions PC will either be 00 or 01 depending on the result of zero from the ALU. PCSel = {0,Zero}, where 0 is a 1-bit signal.
    - For the jump instructions we can used one of the unused ALUCtrl so zero will definitely not be set to one. This is the list of funct3 values that can assign Zero=1. I will use ALUCtrl=4'b0010 to ensure Zero can not be set to 1 in any jump instruction.
      -   3'b000
      -   3'b001
      -   3'b100
      -   3'b101
      -   3'b110
      -   3'b111
    - Now PCSel will be passed on as normal, an additional signal branch will be passed. An additional mux will select from PCSel or {1'b0,Zero}

![Alt text](images/pcSelE%20logic.jpg)

---
### Testing


When running the original program on the pipelined CPU this was the result. This error was the result of 

![Alt text](images/Light%20Sequence%20with%20Original%20Code%20(Pipelined).gif)

Upon  Fruther inspection The error is occuring because the WriteAdress for the register file changes before the data input can be written. 

![Alt text](images/Light%20Sequence%20with%20Original%20Code%20on%20Piplelined%20CPU.jpg)

The potential fixes involved modifying the code to include an nop instruction.
There is a 6 cycle delay between PC changing and the value being written to the regsiter file
before pipelining the delay was only 2 cycles. This might suggest that we need 4 nop statements but because PCSelE is determined 2 cycles after PC we may only need 2.
```s
    main:
    addi a1, zero, 0
    addi a0, zero, 0xFF
    addi t2, zero, 8
    addi t1, zero, 0

    loop: 
    beq a1, t2, delay 
    addi a1, a1, 1
    jal ra, sub 
    beq zero, zero, loop

    sub:
    slli a0, a0, 1
    nop
    jalr ra, ra, 0

    delay:
    addi t1, t1, 1
    bne t1, t2, delay

    end:
    beq zero, zero, main
```
After making just this change the light sequence continues however it does not reset. 

![Alt text](images/Light%20Sequence%20with%20NOPs%20(Pipelined).gif)

When looking at the CPU.vcd file this occurs because the instructions that are fecthed and decoded after the branch instruction are still being processed meaning the branch instruction fails to stop those instructions being executed.

Here addi and jal are the instructions are the instructions that have been fetched after branch.

```s
    beq a1, t2, delay 
    addi a1, a1, 1
    jal ra, sub 
```
For this decided to implement a Hazard unit for flushing the instructions. Flushing in effect means clearing the register values, in this circumstance we want to clear the values stored on the Fetch and Decode Registers. This is better than putting 2 nop instruction after every jump/branch instruction because if the branch does not occur then the processor time that could have been used on the next instructions will be wasted.

The logic driving the flush signals is: $$\text{FlushD=(PCSelE!=2'b00)}$$
$$\text{FlushE=(PCSelE!=2'b00)}$$
![Alt text](images/Ligth%20Sequence%20with%20Flushing%20(Pipelined).gif)

There is also the issue of the value of 8 not being stored at t2 before the beq a1, t2 instruction is executed. As they are both 0 it will cause an unexpected branch no nops must be inserted after the addi/li instructions to allow time for the register values to be set.

```s
    main:
        addi a1, zero, 0
        addi a0, zero, 0xFF
        addi t2, zero, 8
        addi t1, zero, 0
        nop
        nop
        nop
```

Once all of these issues were resolved the program worked correctly.

##### Full Hazard Unit

I later eliminated the need for `nop` in the program by implementing more hazard hardware this time to deal with data hazards. This involved the use of stalling and forwarding.

To stall the data instruction coming out of the PC i added an enable to the program counter. `PCEn` was then driven by `!(stallF)`. I did the same thing for the fetch to decode register and this was controlled by a signal called `stallD`.

Within the hazard unit both stall signals are controlled by this logic `stallX=((addr1D==regAddr3E)|(addr2D==regAddr3E))&(resultSelE==2'b01);`

Fowarding data was beneficial for scenarios where the next instruction is dependant on the result of the previous one. Instead of adding nops so the second instruction would start once the data had been written data forwarding could be used. The logic for data forwarding was very simple,
if the destination register in the memory block matches one of the source registers in the execute block the execute block would pull the data from the memory block before it is written back to memory. The data can be intercepted from either the memory or write back stages of the instructions. Saving either one of two cycles.

```verilog 
always_comb begin
    if ((addr1E == regAddr3M) & regWriteM & (addr1E!=0)) 
        forward1E = 2'b10;
    else if ((addr1E == regAddr3W) & regWriteW  & (addr1E!=0)) 
        forward1E = 2'b01;
    else 
        forward1E = 2'b00 ;
    if ((addr2E == regAddr3M) & regWriteM  & (addr2E!=0))
        forward2E = 2'b10 ;
    else if ((addr2E == regAddr3W) & regWriteW  & (addr2E!=0)) 
        forward2E = 2'b01;
    else 
        forward2E = 2'b00;
end
```


##### Testing Reference Program

The reference program was tested without the need for adding no operation instructions because of the prior work done on the hazard unit.

### Multiplication, Divison and Remainders (Multi-Cycle)

Why on earth do we want multiplication to be multi-cylce if you can implement 32-bit multipliers? The reason is that the clock speed and thus our pipelined CPUs performance is limited by the stage with the longest delay. Adding large combinational logic with proportionally large propogation delay in the execute stage would significantly limit the clock speed. This may speed up multiply instructions but everything else will be negatively impacted.

![Alt text](images/RV32IM.png)
There are two ways to implement the multiplication and divison across multiple cycles that can be implemented. The first would be in-order execution, a multiplication is received by the execute stage the registers of the previous stage would be stalled while the multiplication or division is being carried out and would be enabled when it is finished. The logic implemented in the hazard unit would be
`stall = isMulE & !isDone` (Stall while multiplication instruction is not done). Here `isMulE=funct7[0]&opcode[5]` when the opcode is R type. All of the registers in the CPU should be stalled this time to prevent the instructions and operands from changing but to also stop the intermediary values from being written to registers. **This is the solution that is implemented** but of course not the most efficient process but there is a better solution.

A more complicated yet more efficient approach would be out-of order execution. This would allow other instructions to continue being executed while the mul/div instruction is taking place and write back to the register only when finished. This would mean that initially hardware is not stalled. The hardware would only be stalled once the operation is finished or in the scenario where there is a dependancy in the result. 

The destination register of the operation should be kept stored in the unit until its finished. When it is finished the result should be passed out of the ALU. 

The multiplication and divison algorithms used:
The division algorithm used takes 32 cycles to compute the value each time which is going to be worse than a subtraction algorithm when the quotient is less than 32. 

The multiplication algorith can be sumarised mathematically as: $\text{MUL A, B}=\sum_{n=0}^{32} (A<<n)B[n]$

Long Multiplication algorithm
```python

OUT := 0; # output 
for i := 0 to n-1 #where n is the number of bits
    if(B[i]):
        OUT := OUT + (A<<i);
```
When implementing this in verilog I expected this algorithm to take only 32 cycles however it seems that using 31 bit shift causes significant delay, perhaps because it creates a 32-bit shifter, so I modified the algorithm to shift the same number by a single bit every cycle the single bit shift should be much faster. 

``` verilog
always_ff @(posedge clk)begin
    if(isMulE)begin
        if(J<31)begin
            if(BTEMP[J]==1'b1)begin
                OUT<=OUT+ATEMP;
            end
            J<=J+1;
            ATEMP<=ATEMP<<1;
            isDone<=0;
        end
        else begin
            isDone<=1;
        end
    end
end
```

Long Multiplication algorithm
```python

OUT := 0; # output 
for i := 0 to n-1 #where n is the number of bits
    if(B[i]):
        OUT := OUT + A;
    A := A << 1;
```
The divison algorithm is slightly more complicated 
Long Division Algorithm:
```python
if D = 0 then error(DivisionByZeroException) end
Q := 0                  # Initialize quotient and remainder to zero
R := 0                     
for i := n − 1 .. 0 do  # Where n is number of bits in N
  R := R << 1           # Left-shift R by 1 bit
  R(0) := N(i)          # Set the least-significant bit of R equal to bit i of the numerator
  if R ≥ D then
    R := R − D
    Q(i) := 1
  end
end
```

Testing the `divu` instruction, I perform 24/8 and the result is 3 as expected.
![Alt text](images/Divison%20ASM.png)
![Alt text](images/Divison%20VCD.png)

A potential improvement could be implementing multiple clocks so the multiplication happens faster. Im assuming that the clock speed is limited by the memory stage not the execute stage so an increased clock speed for this component wouldn't be unrealistic.The multiplcation clock should only be limited by the internal hardware of the multiplication block. If we can increase the clock speed of this block to say 2x the main clock then the entire process only take 16 clock cycles instead of 32. I tested this and found it to indeed be the case. 

![Alt text](images/multi-clock%20system.png)

I could be possible to make it take a single cycle by making it 32x the speed of the main clock but this would be very hard to see on the diagram so we wont do that. 
### Reflection

Things i would like to included in the pipelined cpu if I had more time.
- Branch prediction, being able to guess whether a branch will be taken will reduce the amount of times that instructions need to be flushed. Either static or Dynamic branch prediction would be useful.
- Multiple instances of the datapath for a superscalar processor would provided further performance improvements as instructions can be processed simulatneously. This in practice would be difficult to implement where there are instructions that are dependant on previous instructions.
- Out of order processing.
- Single Instruction multiple data
- multi-threading
- multi core system


### Individual Statement
What did I contribute? ( The ["damani"](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-6/commits/damani) branch shows the majority of my contributions as well as the table in this ["README.md"](rtl/README.md) )
- I created and tested the modules for the pipelined cpu.
- Added the hazard detection and hardware for data [forwarding](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-6/commit/23380337c582323c5616fe0aa59c5807eb037b8a), [stalling](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-6/commit/8b1d8daa2041492c9ad4de57f330907a89f44238) and [flushing](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-6/commit/3099f2e0eb609115a3773c484693f188a89619b9)
- Wrote version of the light sequence assembly code to work with nops. The process is explained [label](DamaniLog.md)
- Added logic to the control unit and alu for jalr, lui, auipc, blt, bge, bltu, bgeu (across multiple commits)
- Added branch logic to the ALU for the branch instructions.
- Modified the register file to work for pipelining.

What have I learmed?

- I've learned how to write system verilog code. I've also learned more about control and data hazards. 
- I learned more about using github.

What mistakes have I made?/What might I do differently if I were to do it again.

- Not using .gitignore from the beginning. 
- Not proposing a naming convention to the group from the begining.
- For pipelining i created seperate modules for the registers which was ultimately unnecessary and caused by my lack of comfortability with system verilog. If I were to do it again I would learn more about the language before I start building.