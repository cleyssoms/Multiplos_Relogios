module top (
    input  logic        clk,
    input  logic        deserializer_rst,
    input  logic        queue_rst,
    input  logic        data_in,
    input  logic        write_in,
    input  logic        dequeue_in,
    output logic [7:0]  queue_data_out
);

  // Wires to connect deserializer and queue
  logic [7:0] deserialized_data;
  logic       deserialized_valid;
  logic       queue_wr_en;

  // Iniciando deserializer
  deserializer u_deserializer (
      .clk_100mhz (clk),                  // Clock de 100KHz
      .reset      (deserializer_rst),     // Reset assíncrono
      .data_in    (data_in),              // Bit serial de entrada
      .write_in   (write_in),             // Bit válido para escrita
      .ack_in     (ack_in),               // Confirmação de consumo
      .data_out   (deserialized_data),    // Byte paralelo de saída
      .data_ready (enqueue_in),           // Dado pronto para consumo
      .status_out (status_out)            // Status: 1 = disponível, 0 = ocupado
  );

  // Write enable for queue is valid from deserializer
  // assign queue_wr_en = deserialized_valid;

  // Iniciando queue
  queue u_queue (
      .clk_10khz  (clk),                  // Clock de 10KHz
      .reset      (queue_rst),            // Reset assíncrono
      .data_in    (deserialized_data),    // Dado de entrada
      .enqueue_in (enqueue_in),           // Sinal para inserir
      .dequeue_in (dequeue_in),           // Sinal para remover
      .len        (len),                  // Número de elementos (0-8)
      .data_out   (queue_data_out)        // Dado removido
  );

endmodule
