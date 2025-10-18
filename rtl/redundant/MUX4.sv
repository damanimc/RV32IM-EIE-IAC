module MUX4 #(parameter DATA_WIDTH=32)(
    input logic [DATA_WIDTH-1:0] a, 
    input logic [DATA_WIDTH-1:0] b,
    input logic [DATA_WIDTH-1:0] c, 
    input logic [DATA_WIDTH-1:0] d,
    input logic [1:0] sel,
    output logic [DATA_WIDTH-1:0] out
);

always_comb begin
    case (sel)
        0'b00 : out = a;
        0'b01 : out = b;
        0'b10 : out = c;
        0'b11 : out = d;
    endcase
end

endmodule

