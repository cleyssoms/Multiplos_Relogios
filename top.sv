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
  logic [7:0] cnt_10khz;
  logic [4:0] cnt_100khz;
  logic       clk_10khz;
  logic       clk_100khz;

  // Iniciando deserializer
  deserializer u_deserializer (
      .clk_100khz (clk_100khz),           // Clock de 100KHz
      .reset      (deserializer_rst),     // Reset assíncrono
      .data_in    (data_in),              // Bit serial de entrada
      .write_in   (write_in),             // Bit válido para escrita
      .ack_in     (ack_in),               // Confirmação de consumo
      .data_out   (deserialized_data),    // Byte paralelo de saída
      .data_ready (enqueue_in),           // Dado pronto para consumo
      .status_out (status_out)            // Status: 1 = disponível, 0 = ocupado
  );

  // Iniciando queue
  queue u_queue (
      .clk_10khz  (clk_10khz),              // Clock de 10KHz
      .reset      (queue_rst),              // Reset assíncrono
      .data_in    (deserialized_data),      // Dado de entrada
      .enqueue_in (enqueue_in),             // Sinal para inserir
      .dequeue_in (dequeue_in),             // Sinal para remover
      .len        (len),                    // Número de elementos (0-8)
      .data_out   (queue_data_out)          // Dado removido
  );

  // 1MHz / 10 = 100kHz
  always @(posedge clk) begin
    if (cnt_100khz == 4'd10) begin
        cnt_100khz <= 0;
        clk_100khz <= ~clk_100khz;
    end else begin
        cnt_100khz <= cnt_100khz + 1;
    end
  end

  // 1MHz / 100 = 10kHz
  always @(posedge clk) begin
    if (cnt_10khz == 7'd100) begin
        cnt_10khz <= 0;
        clk_10khz <= ~clk_10khz;
    end else begin
        cnt_10khz <= cnt_10khz + 1;
    end
  end
endmodule
