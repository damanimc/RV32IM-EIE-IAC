module MUX#(parameter DATA_WIDTH=32)(
    input logic [DATA_WIDTH-1:0] a, 
    input logic [DATA_WIDTH-1:0]b,
    input logic sel,
    output logic [DATA_WIDTH-1:0] out
);

always_comb begin
    if(sel==0)
        out=a;
    else
        out=b;
end

endmodule

