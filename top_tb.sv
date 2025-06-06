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

  // clock : 1MHz
  always #0.5 clk = ~clk;

  initial begin
    // Inicializacao
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
    // esta desincronizado com o clock e
    // portanto enche o deserializador mais rapido,
    // assim jogando alguns dados fora.
    repeat (8) begin
      data_in = $random;
      write_in = 1;
      #50;
      write_in = 0;
      #50;
    end
    write_in = 0;

    // espera e faz o dequeue
    dequeue_in = 1;
    #100;
    dequeue_in = 0;

    #200;
    deserializer_rst = 1;
    #10 // Zerando deserializador por conveniencia
    deserializer_rst = 0;
    #200;

    repeat (8) begin
      data_in = 1;
      write_in = 1;
      #11;
      write_in = 0;
      #11;
    end
    write_in = 0;

    // espera e faz o dequeue
    dequeue_in = 1;

    #500

    $stop;
  end

  // Monitor
  initial begin
    $monitor("%t | queue_data_out = %h", $time, queue_data_out);
  end
endmodule
