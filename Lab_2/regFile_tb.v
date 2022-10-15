
module regFileTB ();
  localparam period = 8;
  localparam width = 16;
  reg  read_enable, write_enable, clk, rst;
  reg  [width - 1 : 0] write_data;
  reg  [2 : 0] read_addr, write_addr;
  wire [width - 1 : 0] read_data_mem, read_data_gen;
  regFileMem #(width)
             regFileMem_dut (
               .read_enable (read_enable ),
               . write_enable ( write_enable ),
               . clk ( clk ),
               . rst ( rst ),
               .write_data (write_data ),
               .read_addr (read_addr ),
               . write_addr ( write_addr ),
               .read_data  ( read_data_mem)
             );

  regFileGen #(width)
             regFileGen_dut (
               .read_enable (read_enable ),
               . write_enable ( write_enable ),
               . clk ( clk ),
               . rst ( rst ),
               .write_data (write_data ),
               .read_addr (read_addr ),
               . write_addr ( write_addr ),
               .read_data  ( read_data_gen)
             );

  /////////////////////create clock pulses///////////////////////////////////////////
  always
  begin
    #(period / 2);
    clk = ~clk;
  end
  ////////////////////////////assertion to check for equal outputs//////////////////////////////////////////////////////
  always @(negedge clk)
  begin
    #(1);
    if (read_data_gen != read_data_mem)
    begin
      $display("ASSERTION FAILED in %g, output from memory file: %h\t, and output from hard-wired registers file: %h\n", $time, $read_data_mem, $read_data_gen);
    end
  end

  always
  begin
    $display("Starting simulation:\nclock period = 8, writing is positive-edge trigger and reading is negative-edge trigger, with asynchronous reset***************************\n");
    $monitor ("at time: %g ==>\n\trst: %h,\n\tread_enable: %h,\n\twrite_enable: %h,\n\twrite_data:%h,\n\tread_addr: %h,\n\twrite_addr: %h,\n\tread_data_mem: %h,\n\tread_data_gen: %h\n", $time, rst, read_enable, write_enable, write_data, read_addr, write_addr, read_data_mem, read_data_gen);

    //reset
    clk = 1'b0;
    rst = 1'b1;
    read_enable = 1'b0;
    write_enable = 1'b1;
    write_data = 16'h123f;
    read_addr = 3'h0;
    write_addr = 3'h2;
    #(period * 1.2);
    assert_result('bz);

    //write 123f to reg 3
    rst = 1'b0;
    write_data = 16'h123f;
    write_addr = 3'h2;
    write_enable = 1'b1;
    #(period);
    assert_result('bz);
    
    //reset again
    rst = 1'b1;
    #(period * 0.1);

    //read from reg 3 and write 78da to reg 8
    rst = 1'b0;
    write_data = 16'h78da;
    write_addr = 3'h7;
    read_addr = 3'h2;
    read_enable = 1'b1;
    #(period);
    assert_result('b0);

    //check output when read_enable = 0 ----> must be high impedance
    read_enable = 1'b0;
    #(period);
    assert_result('bz);

    //read from reg 8
    write_enable = 1'b0;
    write_data = 16'h4532;
    read_addr = 3'h7;
    read_enable = 1'b1;
    #(period);
    assert_result(16'h78da);

    //read from reg 8 and write to it at same time
    write_enable = 1'b1;
    #(period);
    assert_result(16'h4532);

    //write to reg 0
    write_addr = 3'h0;
    #(period);
    //try reset with write_enable, read_enable => 1 for large period
    rst=1'b1;
    #(period * 2);
    assert_result('b0);

    //disabling reset signal
    rst=1'b0;
    #(period);
    assert_result('b0);

    //read from first register
    write_enable = 1'b0;
    read_addr = 3'h0;
    #(period);
    assert_result(16'h4532);

    wait(0);
  end

  task assert_result;
    input [width - 1 : 0] expected;
    begin
      if (expected != read_data_gen)
      begin
        $display ("at time: %g read_data_gen is NOT as it is expected ==>\n\tread_addr: %h,\n\tread_data_gen: %h, expected read_data: %h\n", $time, read_addr, read_data_gen, expected);
      end
      if (expected != read_data_mem)
      begin
        $display ("at time: %g read_data_mem is NOT as it is expected ==>\n\tread_addr: %h,\n\tread_data_mem: %h, expected read_data: %h\n", $time, read_addr, read_data_mem, expected);
      end
    end

  endtask


endmodule

