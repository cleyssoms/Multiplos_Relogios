module queue_tb;
    logic clk_10khz = 0;
    logic reset;
    logic [7:0] data_in;
    logic enqueue_in, dequeue_in;
    logic [3:0] len_out;
    logic [7:0] data_out;

    queue dut (.*);

    // Clock de 10KHz (período 100us)
    always #50 clk_10khz = ~clk_10khz;

    initial begin
        // Reset inicial
        reset = 1;
        data_in = 0;
        enqueue_in = 0;
        dequeue_in = 0;
        #100;
        reset = 0;

        // Teste 1: Inserção simples
        data_in = 8'hA5;
        enqueue_in = 1;
        #100;
        enqueue_in = 0;
        $display("Inserção 1: len_out=%0d, data_out=%h", len_out, data_out);
        
        // Teste 2: Inserção múltipla
        for (int i = 1; i <= 8; i++) begin
            data_in = i;
            enqueue_in = 1;
            #100;
        end
        enqueue_in = 0;
        $display("Inserção 8: len_out=%0d", len_out);
        
        // Teste 3: Tentativa de overflow
        data_in = 8'hFF;
        enqueue_in = 1;
        #100;
        enqueue_in = 0;
        $display("Overflow: len_out=%0d (deve ser 8)", len_out);
        
        // Teste 4: Remoção simples
        dequeue_in = 1;
        #100;
        dequeue_in = 0;
        $display("Remoção 1: data_out=%h (deve ser A5)", data_out);
        
        // Teste 5: Operação simultânea
        data_in = 8'h77;
        enqueue_in = 1;
        dequeue_in = 1;
        #100;
        enqueue_in = 0;
        dequeue_in = 0;
        $display("Simultâneo: len_out=%0d, data_out=%h", len_out, data_out);
        
        $finish;
    end
endmodule