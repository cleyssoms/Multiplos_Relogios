module queue (
  input  logic        clk_10khz,
  input  logic        reset,
  input  logic [7:0]  data_in,
  input  logic        enqeue_in,
  input  logic        dequeue_in,
  output logic [3:0]  len_out,
  output logic [7:0]  data_out
);

  logic [63:0] shift_reg;
  logic [7:0] data_out_reg;
  logic [3:0] count = 0;


always_ff @(posedge clk_10khz or posedge reset) begin
  if (reset) begin
    count <= 0;
    shift_reg <= 64'b0;
    data_out_reg <= 8'b0;
  end else begin
    if (enqeue_in && (count < 8)) begin
      // Insere novo dado nos bits superiores
      shift_reg <= {data_in, shift_reg[63:8]};
      count <= count + 1;
    end

    else if (dequeue_in && (count > 0)) begin
      // Captura dado mais antigo
      data_out_reg <= shift_reg[7:0];

      // Desloca todos os dados para direita
      shift_reg <= {8'b0, shift_reg[63:8]}
      count <= count - 1;
    end
  end
end

assign len_out  = count;
assign data_out = data_out_reg;
endmodule
