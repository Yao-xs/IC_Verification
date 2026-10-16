module mux4to1 (
    input [1:0] sel,
    input [1:0] p0,
    input [1:0] p1,
    input [1:0] p2,
    input [1:0] p3,
    output [1:0] sout
);

    reg [1:0] sout_t;

    always @(*) begin
        if(sel == 2'b00) begin
            sout_t = p0;
        end else if(sel == 2'b01) begin
            sout_t = p1;
        end else if(sel == 2'b10) begin
            sout_t = p2;
        end else begin
            sout_t = p3;
        end
    end

    assign sout = sout_t;

endmodule