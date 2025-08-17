`timescale 1ns/1ps

module uart_rx_tb;

    // parameters
    parameter CLK_FREQ = 100_000_000; // 100 MHz
    parameter BAUD    = 115200;
    parameter CLK_TICKS = CLK_FREQ / (BAUD * 16);

    // internal signals
    reg clk;
    reg rst;
    reg rx;
    wire [7:0] data;

    // instantiate design under test
    uart_rx #(
        .CLK_TICKS(CLK_TICKS)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data(data)
    );

    // clock generation: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk; // period = 10 ns

    // task: send one byte over UART (8N1)
    task uart_send_byte(input [7:0] byte);
        integer i;
        begin
            // Start bit
            rx = 0;
            #(16*CLK_TICKS*10); // one oversample cycle

            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #(16*CLK_TICKS*10);
            end

            // Stop bit
            rx = 1;
            #(16*CLK_TICKS*10);
        end
    endtask

    initial begin
        // initialize signals
        rst = 1;
        rx  = 1; // idle high
        #100;
        rst = 0;

        reg [7:0] test_string [0:4];
        integer j;
        test_string[0] = "H";
        test_string[1] = "E";
        test_string[2] = "L";
        test_string[3] = "L";
        test_string[4] = "O";

        // Send each character
        for (j = 0; j < 5; j = j + 1) begin
            uart_send_byte(test_string[j]);
            #(200_000); // wait some time for receiver to process
        end

        $finish;
    end

    // monitor data output
    initial begin
        $display("Time\tData");
        $monitor("%0t\t%h (%c)", $time, data, data);
    end

endmodule
