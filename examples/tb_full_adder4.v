`timescale 1ns/1ns;

module tb_full_adder4;
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] So;
    wire Co;
    integer a_value, b_value, cin_value;
    integer errors;
    reg [4:0] expected;

    initial begin
        $dumpfile("tb_full_adder4.vcd");
        $dumpvars(0, tb_full_adder4);
    end

    initial begin
        errors = 0;
        Cin = 1'b0;
        A = 4'd5;
        B = 4'd2;
        #10;
        A = 4'd10;
        B = 4'd8;
        #10;

        for (a_value = 0; a_value < 16; a_value = a_value + 1) begin
            for (b_value = 0; b_value < 16; b_value = b_value + 1) begin
                for (cin_value = 0; cin_value < 2; cin_value = cin_value + 1) begin
                    A = a_value;
                    B = b_value;
                    Cin = cin_value;
                    expected = a_value + b_value + cin_value;
                    #1;
                    if ({Co, So} !== expected) begin
                        errors = errors + 1;
                        $display("FAIL: A=%d B=%d Cin=%b result=%b expected=%b",
                                 A, B, Cin, {Co, So}, expected);
                    end
                end
            end
        end

        if (errors == 0)
            $display("PASS: all 512 input combinations passed.");
        else
            $fatal(1, "FAIL: %0d input combinations failed.", errors);
        $finish;
    end

    full_adder4 FA4 (
        .A(A),
        .B(B),
        .Cin(Cin),
        .So(So),
        .Co(Co)
    );

    initial begin
        #1000;
        $fatal(1, "Simulation timed out.");
    end

endmodule
