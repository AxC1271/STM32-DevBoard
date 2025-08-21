module ascii_ssd_decoder (
    input  wire [7:0] ascii,
    output reg  [6:0] seg_ssd
);

    // Combinational logic for ASCII to 7-segment decoding
    always @(*) begin
        case (ascii)
            8'h30: seg_ssd = 7'b0000001; // 0
            8'h31: seg_ssd = 7'b1001111; // 1
            8'h32: seg_ssd = 7'b0010010; // 2
            8'h33: seg_ssd = 7'b0000110; // 3
            8'h34: seg_ssd = 7'b1001100; // 4
            8'h35: seg_ssd = 7'b0100100; // 5
            8'h36: seg_ssd = 7'b0100000; // 6
            8'h37: seg_ssd = 7'b0001111; // 7
            8'h38: seg_ssd = 7'b0000000; // 8
            8'h39: seg_ssd = 7'b0000100; // 9
            8'h41, 8'h61: seg_ssd = 7'b0001000; // A/a
            8'h42, 8'h62: seg_ssd = 7'b1100000; // B/b
            8'h43, 8'h63: seg_ssd = 7'b1110010; // C/c
            8'h44, 8'h64: seg_ssd = 7'b1000010; // D/d
            8'h45, 8'h65: seg_ssd = 7'b0110000; // E/e
            8'h46, 8'h66: seg_ssd = 7'b0111000; // F/f
            8'h47, 8'h67: seg_ssd = 7'b0100001; // G/g
            8'h48, 8'h68: seg_ssd = 7'b1001000; // H/h
            8'h49, 8'h69: seg_ssd = 7'b0101111; // I/i
            8'h4A, 8'h6A: seg_ssd = 7'b1000011; // J/j
            8'h4C, 8'h6C: seg_ssd = 7'b1110001; // L/l
            8'h4E, 8'h6E: seg_ssd = 7'b1101010; // N/n
            8'h4F, 8'h6F: seg_ssd = 7'b1100010; // O/o
            8'h50, 8'h70: seg_ssd = 7'b0011000; // P/p
            8'h52, 8'h72: seg_ssd = 7'b1111010; // R/r
            8'h54, 8'h74: seg_ssd = 7'b1110000; // T/t
            8'h55, 8'h75: seg_ssd = 7'b1100011; // U/u
            8'h59, 8'h79: seg_ssd = 7'b1000100; // Y/y
            default: seg_ssd = 7'b1111111;       // blank (spaces or invalid chars)
        endcase
    end

endmodule
