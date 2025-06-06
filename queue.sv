module queue (
  input  logic        clk_10khz,  // Clock de 10KHz
  input  logic        reset,      // Reset assíncrono
  input  logic [7:0]  data_in,    // Dado de entrada
  input  logic        enqueue_in, // Sinal para inserir
  input  logic        dequeue_in, // Sinal para remover
  output logic        ack_in,     // Sinal que recebeu
  output logic [3:0]  len_out,    // Número de elementos (0-8)
  output logic [7:0]  data_out    // Dado removido
);

  // Registrador de 64 bits para armazenar 8 elementos de 8 bits
  logic [63:0] shift_reg;

  // Registrador para o dado removido
  logic [7:0] data_out_reg;

  // Registrador para o comprimento
  logic [3:0] count = 0;


  always_ff @(posedge clk_10khz or posedge reset) begin
    // Limpa e reinicia registradores
    if (reset) begin
      ack_in <= 0;
      count <= 0;
      shift_reg <= 64'b0;
      data_out_reg <= 8'b0;
    end else begin
      // Operação de inserção
      if (enqueue_in && (count < 8)) begin
        // Insere novo dado nos bits superiores
        shift_reg <= {shift_reg[63:8], data_in };
        count <= count + 1;
        ack_in <= 1;
      end else begin 
        // Avisa que nao foi recebido
        ack_in <= 0;
      end


      // Operação de remoção
      if (dequeue_in && (count > 0)) begin
        // Envia o mais antigo para out e o zera
        case (count)
          4'b0001: begin
            data_out_reg <= shift_reg[7:0];
            shift_reg[7:0] <= 8'b0;
          end
          4'b0010:begin
            data_out_reg <= shift_reg[15:8];
            shift_reg[15:8] <= 8'b0;
          end
          4'b0011:begin
            data_out_reg <= shift_reg[23:16];
            shift_reg[23:16] <= 8'b0;
          end
          4'b0100:begin
            data_out_reg <= shift_reg[31:24];
            shift_reg[31:24] <= 8'b0;
          end
          4'b0101:begin
            data_out_reg <= shift_reg[39:32];
            shift_reg[39:32] <= 8'b0;
          end
          4'b0110:begin
            data_out_reg <= shift_reg[47:40];
            shift_reg[47:40] <= 8'b0;
          end
          4'b0111:begin
            data_out_reg <= shift_reg[55:48];
            shift_reg[55:48] <= 8'b0;
          end
          4'b1000:begin
            data_out_reg <= shift_reg[63:56];
            shift_reg[63:56] <= 8'b0;
          end
        endcase

        // Atualiza o count
        count <= count - 1;
      end

      // Enqueue e Dequeue simultâneos com a fila cheia precisará inserir após retirar o dado
      // Dessa forma não haverá mais prevalência do enqueue sobre o dequeue
      if (enqueue_in && dequeue_in && (count == 7)) begin
        // Insere novo dado nos bits superiores
        shift_reg <= {data_in, shift_reg[63:8]};
        count <= count;
      end
    end
  end

  // Atribuições de saída
  assign len_out  = count;
  assign data_out = data_out_reg;
  
endmodule
