module MemoryReg #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12, RF_WIDTH=5
)(
    input logic clk,
    input logic regWriteM,
    input logic [RF_WIDTH-1:0] regAddr3M,
    input logic [DATA_WIDTH-1:0] regDin3M,
    output logic regWriteW,
    output logic [RF_WIDTH-1:0] regAddr3W,
    output logic [DATA_WIDTH-1:0] regDin3W);

always_ff @(posedge clk) begin
    regWriteW<=regWriteM;
    regAddr3W<=regAddr3M;
    regDin3W<=regDin3M;
end
endmodule
