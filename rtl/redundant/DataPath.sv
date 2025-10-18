module DataPath #(
    parameter ROM_WIDTH=12,
    REG_RF_WIDTH=5,
    DATA_WIDTH=32)
(
    output logic Zero,
    output logic [ROM_WIDTH-1:0] PC,
   
    input logic clk,
    input logic rst,
    input logic [REG_RF_WIDTH-1:0] addr2,
    input logic [REG_RF_WIDTH-1:0] addr1,
    input logic [REG_RF_WIDTH-1:0] addr3,
    input logic [1:0] PCSel,
    input logic [1:0] ResultSel,
    input logic MemWrite,

    input logic RegWrite,
    input logic ALUSel,
    input logic [3:0] ALUCtrl,
    input logic [DATA_WIDTH-1:0] ImmExt,
    output logic [DATA_WIDTH-1:0] a0
 );


logic [DATA_WIDTH-1:0] ScrA;
logic [DATA_WIDTH-1:0] ScrB;
logic [DATA_WIDTH-1:0] regOp2;
logic [ROM_WIDTH-1:0] PCNext;
logic [DATA_WIDTH-1:0] ReadData;
logic [DATA_WIDTH-1:0] ALUResult;
logic [DATA_WIDTH-1:0] Result;


RegFile #(REG_RF_WIDTH,DATA_WIDTH) regFile(
    .clk(clk),
    .addr1(addr2),
    .addr2(addr1),
    .addr3(addr3),
    .we3(RegWrite),
    .din3(Result),
    .dout1(ScrA),
    .dout2(regOp2),
    .a0(a0)
);

MUXN #(1,DATA_WIDTH) aluMux(
    .bus({ImmExt,regOp2}),
    .sel(ALUSel),
    .out(ScrB)
);

ALU #(DATA_WIDTH) alu(
    .op1(ScrA),
    .op2(ScrB),
    .ctrl(ALUCtrl),
    .sum(ALUResult),
    .Zero(Zero)
);


MUXN #(2,ROM_WIDTH) pcMux(
    .sel(PCSel),
    .bus({ScrA[ROM_WIDTH-1:0]+ImmExt[ROM_WIDTH-1:0],
        ScrA[ROM_WIDTH-1:0]+ImmExt[ROM_WIDTH-1:0],
        (PC+ImmExt[ROM_WIDTH-1:0]),
        (PC+12'd4)}),
    .out(PCNext)

);

PC #(ROM_WIDTH) pcReg(
    .clk(clk),
    .rst(rst),
    .PCNext(PCNext),
    .PC(PC)
);

DataMem #(DATA_WIDTH,DATA_WIDTH) dataMemory(
    .A(ALUResult),
    .WD(regOp2),
    .WE(MemWrite),
    .RD(ReadData),
    .clk(clk)
);

MUXN #(2,DATA_WIDTH) regMux(
    .bus({
        ({{DATA_WIDTH-ROM_WIDTH{1'b0}}, PC+12'd4}),
        (ImmExt+{{DATA_WIDTH-ROM_WIDTH{1'b0}},PC}),
        ReadData,
        ALUResult
    }),
    .sel(ResultSel),
    .out(Result)
);



initial begin
    PC=0;
end
endmodule

