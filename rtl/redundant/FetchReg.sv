module FetchReg #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12, RF_WIDTH=5
)(
    input logic clk, 
    input logic [DATA_WIDTH-1:0] instrF,
    input logic [ROM_WIDTH-1:0] pcF,
    input logic flushD,
    output logic [DATA_WIDTH-1:0] instrD,
    output logic [ROM_WIDTH-1:0] pcD

);

always_ff @(posedge clk) begin
    if (flushD)begin
        instrD<=0;
        pcD<=0;
    end
    else begin
        instrD<=instrF;
        pcD<=pcF;
    end
end

endmodule

