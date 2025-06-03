module queue_tb;
    logic clk_10khz = 0;
    logic reset;
    logic [7:0] data_in;
    logic enqueue_in, dequeue_in;
    logic [3:0] len_out;
    logic [7:0] data_out;

    queue dut (.*);

    // Clock de 10KHz (per√≠odo 100us)
    always #50 clk_10khz = ~clk_10khz;

    initial begin
        // Reset inicial
        reset = 1;
        data_in = 0;
        enqueue_in = 0;
        dequeue_in = 0;
        #100;
        reset = 0;

        // Teste 1: Inser√ß√£o
        data_in = 8'hA5;
        enqueue_in = 1;
        #100;
        enqueue_in = 0;
        $display("InserÁ„o 1: data_in=%h, len_out=%0d", data_in, len_out);
        for (int i = 2; i <= 8; i++) begin
            data_in = i;
            enqueue_in = 1;
            #100;
            $display("InserÁ„o %0d: data_in=%h, len_out=%0d", i, data_in, len_out);
        end
        enqueue_in = 0;
        
        // Teste 3: Tentativa de overflow
        data_in = 8'hFF;
        enqueue_in = 1;
        #100;
        enqueue_in = 0;
        $display("Overflow: data_in=%h, len_out=%0d (deve ser 8)", data_in, len_out);
        
        // Teste 4: Remo√ß√£o
        dequeue_in = 1;
        #100;
        dequeue_in = 0;
        $display("RemoÁ„o 1: data_out=%h (deve ser A5), len_out=%0d (deve ser 7)", data_out, len_out);
        
        // Teste 5: Opera√ß√£o simult√¢nea
        data_in = 8'h77;
        enqueue_in = 1;
        dequeue_in = 1;
        #100;
        enqueue_in = 0;
        dequeue_in = 0;
        $display("Simult‚neo: data_in=%h (deve ser 77), data_out=%h (deve ser 2), len_out=%0d (deve ser 7)", data_in, data_out, len_out);
        
        $stop;
    end
endmodule