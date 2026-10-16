`timescale 1ns/1ps

module tb_digital_tube;
    reg clk = 1'b0;
    reg rstn;
    reg en;
    reg [3:0] sing_digit, ten_digit, hund_digit, kilo_digit;
    wire [6:0] seg;
    wire [3:0] csn;

    reg [6:0] segment_lut [0:15];
    reg [6:0] expected_seg = 7'b0000000;
    reg [3:0] expected_csn = 4'b1111;
    integer scan_index = 0;
    integer checks = 0;
    integer errors = 0;
    integer i;

    digital_tube uut (
        .clk(clk), .rstn(rstn), .en(en),
        .sing_digit(sing_digit), .ten_digit(ten_digit),
        .hund_digit(hund_digit), .kilo_digit(kilo_digit),
        .seg(seg), .csn(csn)
    );

    // 10 ns clock period.
    always #5 clk = ~clk;

    // Check after nonblocking assignments have updated the DUT outputs.
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            scan_index = 0;
            expected_seg = 7'b0000000;
            expected_csn = 4'b1111;
        end else if (en) begin
            case (scan_index)
                0: begin
                    expected_seg = segment_lut[sing_digit];
                    expected_csn = 4'b0111;
                end
                1: begin
                    expected_seg = segment_lut[ten_digit];
                    expected_csn = 4'b1011;
                end
                2: begin
                    expected_seg = segment_lut[hund_digit];
                    expected_csn = 4'b1101;
                end
                3: begin
                    expected_seg = segment_lut[kilo_digit];
                    expected_csn = 4'b1110;
                end
            endcase
            scan_index = (scan_index + 1) % 4;
        end
        // When disabled, both outputs and the scan position must hold.
        #1;
        checks = checks + 1;
        if (seg !== expected_seg || csn !== expected_csn) begin
            errors = errors + 1;
            $display("FAIL t=%0t: seg=%b expected=%b, csn=%b expected=%b",
                     $time, seg, expected_seg, csn, expected_csn);
        end
    end

    initial begin
        $dumpfile("tb_digital_tube.vcd");
        $dumpvars(0, tb_digital_tube);

        segment_lut[0] = 7'b1000000;
        segment_lut[1] = 7'b1111001;
        segment_lut[2] = 7'b0100100;
        segment_lut[3] = 7'b0110000;
        segment_lut[4] = 7'b0011001;
        segment_lut[5] = 7'b0010010;
        segment_lut[6] = 7'b0000010;
        segment_lut[7] = 7'b1111000;
        segment_lut[8] = 7'b0000000;
        segment_lut[9] = 7'b0010000;
        for (i = 10; i < 16; i = i + 1)
            segment_lut[i] = 7'b1111111;

        rstn = 1'b0;
        en = 1'b0;
        {kilo_digit, hund_digit, ten_digit, sing_digit} = 16'h3210;
        repeat (2) @(negedge clk);
        rstn = 1'b1;
        repeat (2) @(negedge clk);
        en = 1'b1;

        // Distinct digits verify ordering; every position sees all 16 codes.
        for (i = 0; i < 16; i = i + 1) begin
            sing_digit = i;
            ten_digit = (i + 1) % 16;
            hund_digit = (i + 2) % 16;
            kilo_digit = (i + 3) % 16;
            repeat (4) @(negedge clk);
        end

        // Pause partway through a scan, change inputs, then resume.
        repeat (2) @(negedge clk);
        en = 1'b0;
        {kilo_digit, hund_digit, ten_digit, sing_digit} = 16'h9876;
        repeat (3) @(negedge clk);
        en = 1'b1;
        repeat (5) @(negedge clk);

        // Assert reset between clock edges while scanning is enabled.
        #2 rstn = 1'b0;
        #2;
        @(negedge clk);
        rstn = 1'b1;
        repeat (8) @(negedge clk);

        if (errors == 0)
            $display("PASS: %0d output checks", checks);
        else
            $fatal(1, "FAIL: %0d errors in %0d checks", errors, checks);
        $finish;
    end

    initial begin
        #5000;
        $fatal(1, "Simulation timed out");
    end
endmodule