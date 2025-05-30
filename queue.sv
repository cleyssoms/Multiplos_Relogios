module queue (
  input  logic        clock10mhz,
  input  logic        reset,
  input  logic [7:0]  data_in,
  input  logic        enqeue_in,
  input  logic        dequeue_in,
  output logic [3:0]  len_out,
  output logic [7:0]  data_out
);

logic [63:0] shift_reg;
logic [7:0] out_data;
logic [3:0] count;


always_ff @(posedge clk_10mhz or posedge reset) begin
  if (reset) begin
    count <= 0;
    shift_reg <= 0; // TODO n sei se precisa ate

  end else begin
    if (enqeue_in && (count < 4'd8)) begin
      shift_reg <= shift_reg << 8; // TODO rever sintatica
      shift_reg[7:0] <= data_out;
    end

    if (dequeue_in && (count > 4'd0)) begin
      out_data <= shift_reg[(len << 3)]; // multiplica por 8 len(tamanho de cada elemento)
      len--;
    end


assign len_out  = len;
assign data_out = out_data;
