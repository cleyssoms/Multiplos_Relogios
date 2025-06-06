`timescale 1us/100ns

module top_tb;
  // Testbench signals
  logic clk;
  logic deserializer_rst;
  logic queue_rst;
  logic data_in;
  logic write_in;
  logic dequeue_in;
  logic [7:0] queue_data_out;

  top top (
    .clk(clk),
    .deserializer_rst(deserializer_rst),
    .queue_rst(queue_rst),
    .data_in(data_in),
    .write_in(write_in),
    .dequeue_in(dequeue_in),
    .queue_data_out(queue_data_out)
  );

  // Clock generation: 1MHz (period = 1us)
  always #0.5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    clk = 0;
    deserializer_rst = 1;
    queue_rst = 1;
    data_in = 0;
    write_in = 0;
    dequeue_in = 0;
    queue_data_out = 0;
    #20;
    deserializer_rst = 0;
    queue_rst = 0;
    #20;

    // Envia um byte para o deserializador
    repeat (8) begin
      data_in = 1;
      write_in = 1;
      #50;
      write_in = 0;
      #50;
    end
    write_in = 0;

    // Wait and dequeue
    dequeue_in = 1;
    #100;
    dequeue_in = 0;

    #1000;
    // a partir daqui fds
    // Send another byte
    repeat (8) begin
      data_in = 1;
      write_in = 1;
      #50;
      write_in = 0;
      #50;
    end

    // Dequeue again
    #200;
    dequeue_in = 1;
    #10;
    dequeue_in = 0;
    #100;

    $stop;
  end

  // Monitor
  initial begin
    $monitor("%t | queue_data_out = %h", $time, queue_data_out);
  end
endmodule
