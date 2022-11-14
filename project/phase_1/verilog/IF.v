module pcCircuit #(parameter addressWidth = 32) (
    clk, rst, programStartAdd, addR
  );
  input clk, rst;
  input [addressWidth - 1 : 0] programStartAdd;
  output reg [addressWidth - 1 : 0] addR;
  reg [addressWidth - 1 : 0] pc;

  //pc circuit
  always @(posedge clk , posedge rst)
  begin
    if(rst)
    begin
      pc <= programStartAdd;
    end
    else if (clk)
    begin
      pc <= pc + 1;
      addR <= pc;
    end
  end
endmodule

