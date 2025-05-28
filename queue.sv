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
logic [3:0] count;


always_ff @(posedge clk_10mhz or posedge reset) begin
  if (reset) begin
    top_ptr <= 0;
    tail_ptr <= 0;
    count <= 0;
    for (int i = 0; i < 8; i++) begin
      buffer[i] <= 8'd0;
    end

  end else begin
    if (enqeue_in && count < 4'd8) begin
      enfila;
    end






assign len_out  = len;
assign data_out = stack[len];
