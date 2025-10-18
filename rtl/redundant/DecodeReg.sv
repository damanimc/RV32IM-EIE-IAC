module DecodeReg #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12, RF_WIDTH=5
)(
    input logic clk, 
    input logic regWriteD,
    input logic [1:0] resultSelD,
    input logic memWriteD,
    input logic [1:0] _pcSelD,
    input logic [3:0] aluCtrlD,
    input logic aluSelD,
    input logic [2:0] memCtrlD,

    input logic [DATA_WIDTH-1:0] dout1D,
    input logic [DATA_WIDTH-1:0] dout2D,
    input logic [ROM_WIDTH-1:0] pcD,
    input logic [RF_WIDTH-1:0] regAddr3D,
    input logic branchD,
    input logic [DATA_WIDTH-1:0] immExtD,
    input logic flushE,

    output logic regWriteE,
    output logic [1:0] resultSelE,
    output logic memWriteE,
    output logic [1:0] _pcSelE,
    output logic [3:0] aluCtrlE,
    output logic aluSelE,
    output logic [2:0] memCtrlE,

    output logic [DATA_WIDTH-1:0] dout1E,
    output logic [DATA_WIDTH-1:0] dout2E,
    output logic [ROM_WIDTH-1:0] pcE,
    output logic [RF_WIDTH-1:0] regAddr3E,
    output logic [DATA_WIDTH-1:0] immExtE,
    output logic branchE);

always_ff @(posedge clk) begin
    if(flushE)begin
        regWriteE<=0;
        resultSelE<=0;
        memWriteE<=0;
        _pcSelE<=0;
        aluCtrlE<=0;
        aluSelE<=0;
        dout1E<=0;
        dout2E<=0;
        pcE<=0;
        regAddr3E<=0;
        branchE<=0;
        immExtE<=0;
        memCtrlE<=0;
    end
    else begin
        regWriteE<=regWriteD;
        resultSelE<=resultSelD;
        memWriteE<=memWriteD;
        _pcSelE<=_pcSelD;
        aluCtrlE<=aluCtrlD;
        aluSelE<=aluSelD;
        dout1E<=dout1D;
        dout2E<=dout2D;
        pcE<=pcD;
        regAddr3E<=regAddr3D;
        branchE<=branchD;
        immExtE<=immExtD;
        memCtrlE<=memCtrlD;
    end
end

endmodule

