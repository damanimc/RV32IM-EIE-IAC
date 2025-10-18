module MUL#(DATA_WIDTH=32)(
    input logic clk1,
    input logic clk2,
    input logic [DATA_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] B,
    input logic [3:0] aluCtrlE,
    output logic [DATA_WIDTH-1:0] OUT,
    input logic isMulE,
    output logic isDone
);
logic [DATA_WIDTH-1:0] BTEMP; 
logic [DATA_WIDTH-1:0] ATEMP; 
logic [DATA_WIDTH-1:0] R_NEXT; 
int I =31;
int J=0;
logic [DATA_WIDTH-1:0] Q;
logic [DATA_WIDTH-1:0] R;
always_ff @(posedge isMulE)begin
   ATEMP<=A;
   BTEMP<=B;
end
always_comb begin
    if(isMulE)begin
        R_NEXT=R<<1;
        R_NEXT[0]=ATEMP[I];
        if (R_NEXT>=B)begin
            R_NEXT=R_NEXT-B;
            Q[I]=1'b1;
        end

        if(isDone==1)begin
            Q=0;
    
        end
    end
end

always_ff @(posedge clk2)begin
    if(isMulE & !isDone)begin
        case (aluCtrlE[2:0])
            3'b000:begin
                if(J<31)begin
                    if(BTEMP[J]==1'b1)begin
                        OUT<=OUT+ATEMP;
                    end
                    J<=J+1;
                    ATEMP<=ATEMP<<1;
                    isDone<=0;
                end

                else begin
                    isDone<=1;

                end
            end
            3'b100:
                if(I>=0) begin                   
                    R<=R_NEXT;
                    I<=I-1;
                    isDone<=0;
                end
                else begin
                    isDone<=1;
                    OUT<=Q;
                end
            3'b100:
                if(I>=0) begin                   
                    R<=R_NEXT;
                    I<=I-1;
                    isDone<=0;
                end
                else begin
                    isDone<=1;
                    OUT<=R;
                end
        endcase
    end   
    
end
always_ff @(posedge clk1) begin
    if(isDone==1)begin
        isDone<=0; 
        R<=0;
        BTEMP<=0;
        ATEMP<=0;
        I<=31;
    end
end
endmodule
