module IF #(parameter addressWidth = 32) (
    clk, rst, programStartAdd, instruction, programCounter
);
    input clk, rst;
    input [addressWidth - 1 : 0] programStartAdd;
    output [32 - 1 : 0] instruction;
    output [addressWidth - 1 : 0] programCounter;
    reg [addressWidth - 1 : 0] pc;

    always @(posedge clk , posedge rst) begin
        if(rst)
        begin
            pc <= programStartAdd;
        end
    end
endmodule