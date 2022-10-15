module regCell #(parameter width = 16) (
    clk, rst, data_in, Q, enable
  );
  input clk, rst, enable;
  input [width - 1 : 0] data_in;
  output reg [width - 1 : 0] Q;
  always @ (posedge clk, posedge rst)
    if (rst == 1'b1)
    begin
      Q <= 'b0;
    end
    else if (enable == 1'b1)
    begin
      Q <= data_in;
    end

endmodule

module x38Decoder (
    data_in, data_out
  );
  input [2 : 0] data_in;
  output [0 : 7] data_out;
  assign data_out  =
         (data_in == 3'b000 ) ? 8'b10000000 :
         (data_in == 3'b001 ) ? 8'b01000000 :
         (data_in == 3'b010 ) ? 8'b00100000 :
         (data_in == 3'b011 ) ? 8'b00010000 :
         (data_in == 3'b100 ) ? 8'b00001000 :
         (data_in == 3'b101 ) ? 8'b00000100 :
         (data_in == 3'b110 ) ? 8'b00000010 :
         (data_in == 3'b111 ) ? 8'b00000001 : 8'h00;
endmodule

module regFileGen #( parameter
                       width = 16
                     ) (
                       read_enable,write_enable, read_data,write_data, clk,rst,
                       read_addr,write_addr
                     );
  input read_enable, write_enable, clk, rst;
  input [width - 1 : 0] write_data;
  input [2 : 0] read_addr, write_addr;
  output reg [width - 1 : 0] read_data;
  wire [0 : 7] write_addr_enable;
  wire [width - 1 : 0] registersOutput [0 : 7];
  x38Decoder
    x38Decoder_dut_wr (
      .data_in (write_addr ),
      .data_out  ( write_addr_enable)
    );

  genvar i;
  generate
    for(i = 0; i < 8; i = i + 1)
	 begin:genloop
      regCell #(width)
        regCell_dut (
          .clk (clk ),
          . rst ( rst ),
          . enable ( write_addr_enable[i] & write_enable),
          .data_in (write_data ),
          .Q  ( registersOutput[i])
        );
		  end
  endgenerate

  
  always @(negedge clk) begin
    if (read_enable == 1'b1) begin
        read_data <= registersOutput[read_addr];
    end
    else
      begin
        read_data <= 'bz;
      end
  end
endmodule
