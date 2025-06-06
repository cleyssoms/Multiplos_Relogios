module deserializer (
  input  logic       clk_100khz,   // Clock de 100KHz
  input  logic       reset,        // Reset assíncrono
  input  logic       data_in,      // Bit serial de entrada
  input  logic       write_in,     // Bit válido para escrita
  input  logic       ack_in,       // Confirmação de consumo
  output logic [7:0] data_out,     // Byte paralelo de saída
  output logic       data_ready,   // Dado pronto para consumo
  output logic       status_out    // Status: 1 = disponível, 0 = ocupado
);

  // Registro de deslocamento para armazenar os bits recebidos
  logic [7:0] shift_reg;

  // Contador de bits recebidos (0 a 7)
  logic [2:0] bit_counter;

  // Lógica principal do desserializador
  always_ff @(posedge clk_100khz or posedge reset) begin
    if (reset) begin
      shift_reg     <= 8'b0;       // Reinicia registrador
      bit_counter   <= 3'b0;       // Reinicia contador
      data_ready    <= 1'b0;       // Dado não está pronto
      status_out    <= 1'b1;       // Módulo disponível
    end else begin
      if (data_ready) begin        // Dado está pronto para consumo
        if (ack_in) begin          // Confirmação recebida
          data_ready  <= 1'b0;     // Libera o sinal data_ready
          status_out  <= 1'b1;     // Módulo volta a ficar disponível
          bit_counter <= 3'b0;     // Reinicia o contador
          shift_reg   <= 8'b0;     // Reinicia registrador
        end
      end else begin               // Módulo disponível para receber bits
        if (status_out && write_in) begin // Se pode receber e há dado válido
          shift_reg <= {shift_reg[6:0], data_in}; // Desloca e insere novo bit
          bit_counter <= bit_counter + 1;  // Incrementa contador

          if (bit_counter == 3'd7) begin   // Após 8 bits coletados
            data_ready <= 1'b1;    // Sinaliza dado pronto
            status_out <= 1'b0;    // Módulo fica ocupado
          end
        end
      end
    end
  end

  // Saída sempre reflete o registrador de deslocamento
  assign data_out = shift_reg;

endmodule
