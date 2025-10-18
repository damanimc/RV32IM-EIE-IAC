module ExecuteReg #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12, RF_WIDTH=5
)(
    input logic clk,
    input logic regWriteE,
    input logic [1:0] resultSelE,
    input logic memWriteE,
    input logic [DATA_WIDTH-1:0] aluResultE,
    input logic [DATA_WIDTH-1:0] memDinE,
    input logic [RF_WIDTH-1:0] regAddr3E,
    input logic [ROM_WIDTH-1:0] pcE,
    input logic [DATA_WIDTH-1:0] immExtE,
    input logic [2:0] memCtrlE,
    output logic regWriteM,
    output logic [1:0] resultSelM,
    output logic memWriteM,
    output logic [DATA_WIDTH-1:0] aluResultM,
    output logic [DATA_WIDTH-1:0] memDinM,
    output logic [RF_WIDTH-1:0] regAddr3M,
    output logic [ROM_WIDTH-1:0] pcM,
    output logic [DATA_WIDTH-1:0] immExtM,
    output logic [2:0] memCtrlM);

always_ff @(posedge clk) begin
    regWriteM<= regWriteE;
    resultSelM<= resultSelE;
    memWriteM<= memWriteE;
    aluResultM<= aluResultE;
    memDinM<= memDinE;
    regAddr3M<= regAddr3E;
    pcM<= pcE;
    immExtM<=immExtE;
    memCtrlM<=memCtrlE;
end

endmodule

