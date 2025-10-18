
## Instructions 
1. Change Directory in terminal to rtl
2. To run the f1 program copy the contents of `test/f1.mem` into `rtl/Instr.mem` and type this command into the terminal `source ./f1.sh` 
3. To run the reference program copy the contents of `test/ref.mem` into `rtl/Instr.mem` and run the command `source ./ref.sh`

## Versions
There are 2 versions of the CPU. The single cycle version of the CPU can be found on the `szinglecycle` branch and the pipelined version of the cpu is found in the `main` and on the `damani` branch. Both version include cache.

## File Credits
These list who contributed to which modules of the CPU in the Pipelined CPU

|                | Damani | Emre | Indira | Pierce |
|----------------|--------|------|--------|--------|
| ALU.sv         | x      |      | x      |        |
| CacheMem.sv    |        | x    |        |        |
| ControlUnit.sv | x      | x    | x      | x      |
| CPU.sv         | x      | x    | x      | x      |
| DataMem.sv     |        | x    | x      |        |
| Decode.sv      | x      |      |        |        |
| Execute.sv     | x      |      |        |        |
| Extend.sv      |        | x    |        | x      |
| Fetch.sv       | x      |      |        |        |
| HazardUnit.sv  | x      |      |        |        |
| InstrMem.sv    |        | x    | x      |        |
| Memory.sv      | x      |      |        |        |
| MUXN.sv        | x      |      |        |        |
| PC.sv          |        | x    |        |        |
| RegFile.sv     | x      | x    |        |        |
| f1_tb.cpp      | x      |      |        |        |
| ref_tb.cpp     | x      |      |        |        |

