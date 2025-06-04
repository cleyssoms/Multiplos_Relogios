// top_tb.sv
// Testbench for top.sv

`timescale 1us/1ns

module top_tb;
  // Testbench signals
  logic clk;
  logic deserializer_rst;
  logic queue_rst;
  logic data_in;
  logic write_in;
  logic dequeue_in;
  logic [7:0] queue_data_out;

  // Instantiate the DUT
  top dut (
    .clk(clk),
    .deserializer_rst(deserializer_rst),
    .queue_rst(queue_rst),
    .data_in(data_in),
    .write_in(write_in),
    .dequeue_in(dequeue_in),
    .queue_data_out(queue_data_out)
  );

  // Clock generation: 1MHz (period = 1us)
  initial clk = 0;
  always #0.5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    deserializer_rst = 1;
    queue_rst = 1;
    data_in = 0;
    write_in = 0;
    dequeue_in = 0;
    #2;
    deserializer_rst = 0;
    queue_rst = 0;
    #2;

    // Send a byte: 8 bits serially with write_in
    repeat (8) begin
      data_in = $random;
      write_in = 1;
      #1;
      write_in = 0;
      #1;
    end

    // Wait and dequeue
    #20;
    dequeue_in = 1;
    #1;
    dequeue_in = 0;
    #10;

    // Send another byte
    repeat (8) begin
      data_in = $random;
      write_in = 1;
      #1;
      write_in = 0;
      #1;
    end

    // Dequeue again
    #20;
    dequeue_in = 1;
    #1;
    dequeue_in = 0;
    #10;

    $finish;
  end

  // Monitor
  initial begin
    $monitor("%t | queue_data_out = %h", $time, queue_data_out);
  end
endmodule
