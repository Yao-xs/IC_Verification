`timescale 1ns/1ps
module counter_tb;
    logic clk = 0;
    logic rst_n = 1;
    logic enable = 0;
    wire [3:0] count;
    integer checks = 0;

    counter dut (.clk(clk), .rst_n(rst_n), .enable(enable), .count(count));
    always #5 clk = ~clk;

    task automatic check_count(input logic [3:0] expected);
        if (count !== expected)
            $fatal(1, "FAIL at %0t: expected=%0d actual=%0d", $time, expected, count);
        checks++;
    endtask

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
        #1 rst_n = 0;
        #1 check_count(0);
        @(negedge clk);
        rst_n = 1;
        enable = 1;
        // Check counting and 4-bit wrap-around (15 -> 0).
        for (integer i = 1; i <= 20; i++) begin
            @(posedge clk);
            #1 check_count(i % 16);
        end
        @(negedge clk) enable = 0;
        repeat (3) begin
            @(posedge clk);
            #1 check_count(4);
        end
        // Reset between clock edges to verify asynchronous reset.
        #1 rst_n = 0;
        #1 check_count(0);
        $display("PASS: %0d checks (reset, count, wrap-around, hold)", checks);
        $finish;
    end

    initial begin
        #1000;
        $fatal(1, "FAIL: simulation timeout");
    end
endmodule
