`timescale 1ns/1ns

module tb_mux4to1;
    reg [1:0] sel;
    wire [1:0] sout;

    initial begin
        sel = 2'b00;
        #10 sel = 2'b11;
        #10 sel = 2'b01;
        #10 sel = 2'b00;
        #10 sel = 2'b10;
    end

    mux4to1 uut (
        .sel(sel),
        .p0(2'b00),
        .p1(2'b01),
        .p2(2'b10),
        .p3(2'b11),
        .sout(sout)
    );

    initial begin
        $dumpfile("tb_mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);
    end

    initial begin
       rgb(0, 0, 0);
       if($time>=1000)
        $finish;
    end

endmodule