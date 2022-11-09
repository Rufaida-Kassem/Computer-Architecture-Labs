module RegFile #( parameter
                    width = 32, count = 32
                  ) (
                    read_enable,write_enable, read_addr1, read_addr2, read_data1, read_data2 ,write_data, clk, rst
                    ,write_addr
                  );
  input read_enable, write_enable, clk, rst;
  input [width - 1 : 0] write_data;
  input [2 : 0] read_addr, write_addr;
  output reg [width - 1 : 0] read_data;
  integer i;
  reg [width - 1 : 0] regFile [0 : count - 1];

  always @(posedge clk, posedge rst)
  begin
    if (rst == 1'b1)
    begin
      for (i = 0; i < count; i = i + 1)
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
      read_data1 <= regFile[read_addr1]
                 ;
      read_data2 <= regFile[read_addr2]
                 ;

    end
    else
    begin
      read_data1 <= 'bz;
      read_data2 <= 'bz;
    end
  end

endmodule
