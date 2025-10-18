module ControlPath #(parameter DATA_WIDTH=32, REG_RF_WIDTH=5, ROM_WIDTH=12)(
    input logic [ROM_WIDTH-1:0] PC,
    input logic Zero,
    output logic [DATA_WIDTH-1:0] ImmExt,
    output logic [3:0] ALUCtrl,
    output logic RegWrite,
    output logic MemWrite,
    output logic [REG_RF_WIDTH-1:0] addr1,
    output logic [REG_RF_WIDTH-1:0] addr2,
    output logic [REG_RF_WIDTH-1:0] addr3,
    output logic [1:0] PCSel,
    output logic ALUSel,
    output logic [1:0] ResultSel
    
   
    
);


logic [DATA_WIDTH-1:0] Instr;
logic [2:0] ImmSel;
logic Branch;
InstrMem instrMem(
    .a(PC),
    .rd(Instr)
);
ControlUnit controlUnit(
    //inputs
    .Instr(Instr),
    .Zero(Zero),
    //outputs
    .PCSel(PCSel),
    .ResultSel(ResultSel),
    .MemWrite(MemWrite),
    .ALUCtrl(ALUCtrl),
    .ALUSel(ALUSel),
    .ImmSel(ImmSel),
    .RegWrite(RegWrite),
    .Branch(Branch)
);
Extend Extend(
    //inputs
    .ImmSel(ImmSel),
    .Instr(Instr),
    //output
    .ImmExt(ImmExt)
);

always_comb begin
    //addresses for the register file
    addr1=Instr[24:20];
    addr2=Instr[19:15];
    addr3=Instr[11:7];
end
endmodule

