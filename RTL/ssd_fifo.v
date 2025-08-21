module ssd_fifo (
    input  wire       clk,
    input  wire       rst,
    input  wire [6:0] wr_val,
    input  wire       write,
    output reg  [6:0] seg,
    output reg  [3:0] an
);

    reg [6:0] values [0:3];
    
    reg scan_clk;
    reg [1:0] scan_idx;
    
    reg write_d;
    wire write_pulse;
    
    reg [16:0] cnt;
    
    integer i;
    initial begin
        scan_clk = 1'b0;
        scan_idx = 2'b00;
        write_d = 1'b0;
        cnt = 17'd0;
        for (i = 0; i < 4; i = i + 1) begin
            values[i] = 7'b1111111;  // blank digits (all segments off)
        end
        an = 4'b1111;
        seg = 7'b1111111;
    end
    
    assign write_pulse = write & ~write_d;
    
    always @(posedge clk) begin
        write_d <= write;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                values[i] <= 7'b1111111;
            end
        end else if (write_pulse) begin
            values[3] <= values[2];
            values[2] <= values[1];
            values[1] <= values[0];
            values[0] <= wr_val;  
        end
    end
    
    always @(posedge clk) begin
        if (cnt == 17'd99999) begin
            cnt <= 17'd0;
            scan_clk <= ~scan_clk;
        end else begin
            cnt <= cnt + 1;
        end
    end
    
    always @(posedge scan_clk) begin
        if (rst) begin
            scan_idx <= 2'b00;
        end else begin
            scan_idx <= scan_idx + 1; 
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            an <= 4'b1111;
        end else begin
            case (scan_idx)
                2'b00: an <= 4'b1110;  // rightmost
                2'b01: an <= 4'b1101;
                2'b10: an <= 4'b1011;
                2'b11: an <= 4'b0111;  // leftmost
                default: an <= 4'b1111;
            endcase
        end
    end
    
    always @(*) begin
        seg = values[scan_idx];
    end

endmodule
