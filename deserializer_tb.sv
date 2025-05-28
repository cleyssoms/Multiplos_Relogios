module deserializer_tb;

  // Sinais de entrada/saída
  logic       clk_100mhz;
  logic       reset;
  logic       data_in;
  logic       write_in;
  logic       ack_in;
  logic [7:0] data_out;
  logic       data_ready;
  logic       status_out;

  // Instância do desserializador
  deserializer dut (
    .clk_100mhz(clk_100mhz),
    .reset(reset),
    .data_in(data_in),
    .write_in(write_in),
    .ack_in(ack_in),
    .data_out(data_out),
    .data_ready(data_ready),
    .status_out(status_out)
  );

  // Geração do clock de 100KHz (período = 10us)
  initial begin
    clk_100mhz = 0;
    forever #5 clk_100mhz = ~clk_100mhz; // Inverte a cada 5us (metade do período)
  end

  // Procedimento de teste
  initial begin
    // Inicialização
    reset = 1;
    data_in = 0;
    write_in = 0;
    ack_in = 0;
    #10; // Aguarda estabilização
    reset = 0;

    // Teste 1: Recepção de 8 bits válidos
    $display("\n=== Teste 1: Recepção normal de 8 bits ===");
    for (int i = 0; i < 8; i++) begin
      data_in = i[0]; // Envia 0,1,0,1,0,1,0,1 (LSB alternado)
      write_in = 1;
      @(posedge clk_100mhz); // Aguarda borda de subida
    end
    write_in = 0;

    // Verifica se o byte está pronto (0x55 = 01010101)
    @(posedge clk_100mhz);
    if (data_ready !== 1'b1 || data_out !== 8'h55) begin
      $error("ERRO: data_ready=%b, data_out=0x%h (esperado 0x55)", data_ready, data_out);
    end else begin
      $display("OK: Byte 0x55 recebido corretamente!");
    end

    // Teste 2: Confirmação (ACK)
    $display("\n=== Teste 2: Confirmação com ack_in ===");
    ack_in = 1;           // Confirma o dado
    @(posedge clk_100mhz);
    ack_in = 0;

    // Verifica se o deserializador está disponível novamente
    @(posedge clk_100mhz);
    if (status_out !== 1'b1 || data_ready !== 1'b0) begin
      $error("ERRO: status_out=%b (deveria ser 1), data_ready=%b (deveria ser 0)", status_out, data_ready);
    end else begin
      $display("OK: Desserializador liberado após ACK!");
    end

    // Teste 3: Reset durante operação
    $display("\n=== Teste 3: Reset durante recepção ===");
    for (int i = 0; i < 4; i++) begin
      data_in = 1;
      write_in = 1;
      @(posedge clk_100mhz);
    end
    reset = 1;             // Força reset no meio da operação
    @(posedge clk_100mhz);
    reset = 0;

    // Verifica se tudo foi reiniciado
    @(posedge clk_100mhz);
    if (data_ready !== 1'b0 || status_out !== 1'b1 || data_out !== 8'h00) begin
      $error("ERRO: Reset não funcionou (data_ready=%b, status_out=%b, data_out=0x%h)", data_ready, status_out, data_out);
    end else begin
      $display("OK: Reset concluído com sucesso!");
    end

    // Finalização
    $display("\n=== Todos os testes concluídos ===");
  end

endmodule