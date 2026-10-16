`timescale 1ns/1ns;

module tb_pad;
    reg DIN, OEN;
    reg [1:0] PULL;
    wire PAD;
    wire DOUT;

    reg PAD_REG;
    assign PAD = OEN ? PAD_REG : 1'bz;

    initial begin
        $dumpfile("tb_pad.vcd");
        $dumpvars(0, tb_pad);
    end

    initial begin
        PAD_REG = 1'bz;
        OEN = 1'b1;
        #0; PULL = 2'b10;
        #20; PULL = 2'b11;
        #20; PULL = 2'b00;
        #20; PAD_REG = 1'b0;
        #20; PAD_REG = 1'b1;

        #30; OEN = 1'b0; DIN = 1'bz;

        #15; DIN = 1'b0;
        #15; DIN = 1'b1;
    end

    pad u_pad (
        .DIN(DIN),
        .OEN(OEN),
        .PULL(PULL),
        .PAD(PAD),
        .DOUT(DOUT)
    );

    initial begin
        #1000;
        $finish;
    end

endmodule