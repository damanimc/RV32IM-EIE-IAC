RV32IM Pipelined CPU with Cache Memory

This repository contains a implementation of a pipelined RV32IM CPU, developed as part of the Instruction Architectures & Compilers course at Imperial College London.

CPU is demonstrated by the following gifs.![Alt text](images/Pipelined%20F1.gif)
![Alt text](images/Pipelined%20Ref.gif)

The project involved evolving a basic single-cycle processor into a functional 5-stage pipeline, requiring custom hardware solutions for data hazards and multi-cycle arithmetic operations.

Technical Features & Updates

1. Hazard Detection & Resolution

Initially, the pipeline relied on software-level nop padding in assembly to prevent data hazards. I later implemented a hardware Hazard Unit to automate this process.

* Forwarding: Minimizes stalls by passing data directly between pipeline stages.
* Stalling & Flushing: Handles branch mispredictions and load-use dependencies.
* Result: This allowed the pipelined CPU to execute the same reference binaries as the single-cycle version without manual modification.

2. Expanded Instruction Support

I extended the [Control Unit] and [ALU] to support the full RV32IM base set plus extensions:

* Control Flow: Implemented jalr, lui, auipc, and branch comparisons (blt, bge, bltu, bgeu).
* Encoding: Re-engineered the aluCtrl encoding to accommodate the expanded instruction set and verified via logic simulation.

3. Multi-Cycle Arithmetic

While my previous designs used single-cycle multipliers, I recognized that this significantly caps the maximum clock frequency (Fmax​) due to long critical paths.

* Implemented multi-cycle mul, div, and rem instructions.
* This trade-off ensures that the CPU can maintain a higher overall clock speed while still handling complex arithmetic.

Verification & Testing

The CPU was verified using two primary methods:

1. Reference Program: A standard benchmark to ensure ISA compliance.
2. F1 Light Sequence: A custom assembly program written to test real-time logic and timing.

