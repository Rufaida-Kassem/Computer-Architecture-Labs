module regFileMem #( parameter
                       width = 16
                     ) (
                       read_enable,write_enable, read_data,write_data, clk,rst,
                       read_addr,write_addr
                     );
  input read_enable, write_enable, clk, rst;
  input [width - 1 : 0] write_data;
  input [2 : 0] read_addr, write_addr;
  output reg [width - 1 : 0] read_data;
  integer i;
  reg [width - 1 : 0] regFile [0 : 7];

  always @(posedge clk, posedge rst)
  begin
    if (rst == 1'b1)
    begin
      for (i = 0; i < 8; i = i + 1)
      begin
        regFile[i] <= 'b0;
      end
    end
    else if (write_enable == 1'b1)
    begin
      regFile[write_addr]
             <= write_data;
    end
  end

  always @(negedge clk)
  begin
    if (read_enable == 1'b1)
    begin
      read_data <= regFile[read_addr]
                ;
    end
    else
    begin
      read_data <= 'bz;
    end
  end

endmodule
