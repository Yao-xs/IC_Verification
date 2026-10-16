module pad(
    input DIN, OEN,
    input [1:0] PULL,
    inout PAD,
    output reg DOUT
);

    assign PAD = OEN ? 1'bz : DIN;

    always @(*) begin
        if(OEN == 1) begin
            DOUT = PAD;
        end else begin
            DOUT = 1'bz;
        end
    end

    bufif1 puller (PAD, PULL[0], PULL[1]);

endmodule