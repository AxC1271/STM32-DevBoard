module uart_controller (
    input  wire        clk,
    input  wire        rst,
    input  wire        rx,
    output wire [7:0]  data,
    output wire [6:0]  seg,
    output wire [3:0]  ade
);

    // internal signals
    wire [7:0] data_i;
    wire [6:0] seg_i;
    wire       write_i;
    
    // instantiate modules
    uart_rx rx_receiver (
        .clk   (clk),
        .rst   (rst),
        .rx    (rx),
        .byte  (data_i),    // needs to be propagated to the decoder
        .write (write_i)    // needs to be passed to ssd_fifo module
    );
    
    ascii_ssd_decoder decoder (
        .ascii   (data_i),  // data is originally in ascii, we need to convert
        .seg_ssd (seg_i)
    );
    
    ssd_fifo mem (
        .clk    (clk),
        .rst    (rst),
        .wr_val (seg_i),
        .write  (write_i),
        .seg    (seg),
        .an     (ade)
    );
    
    // final output assignment
    assign data = data_i;
    
endmodule
