module uart_rx #(
    parameter CLK_TICKS = 54
)(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output reg  [7:0] data
);

    typedef enum reg [1:0] {IDLE, START, DATA, STOP} rx_state_t;
    rx_state_t curr_state;

    reg baud_clk;
    reg [7:0] data_i;

    // clock generator process
    reg [6:0] clk_count; // enough to hold 0..CLK_TICKS
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            baud_clk <= 0;
        end else begin
            if (clk_count == CLK_TICKS) begin
                clk_count <= 0;
                baud_clk <= 1'b1;
            end else begin
                clk_count <= clk_count + 1;
                baud_clk <= 1'b0;
            end
        end
    end

    // process to handle uart_rx fsm
    integer bit_count;
    integer bit_duration;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_i <= 8'b0;
            curr_state <= IDLE;
            bit_count <= 0;
            bit_duration <= 0;
            data <= 8'b0;
        end else if (baud_clk) begin
            case (curr_state)
                IDLE: begin
                    data_i <= 8'b0;
                    bit_count <= 0;
                    bit_duration <= 0;
                    if (rx == 1'b0)
                        curr_state <= START;
                end

                START: begin
                    if (rx == 1'b0) begin
                        if (bit_duration == 7) begin
                            curr_state <= DATA;
                            bit_duration <= 0;
                        end else begin
                            bit_duration <= bit_duration + 1;
                        end
                    end else begin
                        curr_state <= IDLE;
                    end
                end

                DATA: begin
                    if (bit_duration == 15) begin
                        data_i[bit_count] <= rx;
                        bit_duration <= 0;
                        if (bit_count == 7) begin
                            curr_state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        bit_duration <= bit_duration + 1;
                    end
                end

                STOP: begin
                    if (bit_duration == 15) begin
                        data <= data_i;
                        curr_state <= IDLE;
                    end else begin
                        bit_duration <= bit_duration + 1;
                    end
                end

                default: curr_state <= IDLE;
            endcase
        end
    end

endmodule
