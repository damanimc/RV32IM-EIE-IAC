module CPU #(
    parameter DATA_WIDTH=32,
    parameter ROM_WIDTH=12,
    parameter REG_RF_WIDTH=5
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0
);
logic [ROM_WIDTH-1:0] PC;
logic Zero;
logic [DATA_WIDTH-1:0] ImmExt;
logic ALUSel;
logic [3:0] ALUCtrl;
logic RegWrite;
logic [REG_RF_WIDTH-1:0] addr2;
logic [REG_RF_WIDTH-1:0] addr1;
logic [REG_RF_WIDTH-1:0] addr3;
logic [1:0] PCSel;
logic MemWrite;
logic [1:0] ResultSel;


DataPath dataPath(
//Inputs:
    .clk(clk),
    .rst(rst),
    //reg addreses
    .addr2(addr2),
    .addr1(addr1),
    .addr3(addr3),
    //control signals
    .PCSel(PCSel),
    .ResultSel(ResultSel),
    .MemWrite(MemWrite),

    .ALUCtrl(ALUCtrl),
    .ALUSel(ALUSel),
    .RegWrite(RegWrite),
    //extended immediate operand,
    .ImmExt(ImmExt),
//Outputs:
    .PC(PC),
    .Zero(Zero),
    //for debugging the counter program same as a0 from lab 4
    .a0(a0)
);

ControlPath controlPath(
//Inputs:
    .PC(PC),
    .Zero(Zero),
//Outputs:
    //from Instr Mem to regfile
    .addr2(addr2),
    .addr1(addr1),
    .addr3(addr3),
    //Control signals
    .PCSel(PCSel),
    .ResultSel(ResultSel),
    .MemWrite(MemWrite),

    .ALUCtrl(ALUCtrl),
    .ALUSel(ALUSel),
    .RegWrite(RegWrite),
    //immediate operand from extend unit
    .ImmExt(ImmExt)
);
endmodule

