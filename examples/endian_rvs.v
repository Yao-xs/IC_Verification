module endian_rvs

    #(parameter N = 4)
    (
        input en,
        input [N-1:0] a,
        output [N-1:0] b
    );

    reg [N-1:0] b_reg;
    always @(*) begin
        if (en) begin
            b_reg = data_rvs(a);
        end else begin
            b_reg = 0;
        end
    end

    assign b = b_reg;

    function [N-1:0] data_rvs;
        input [N-1:0] data_in;
        parameter MASK = 32'h3;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1) begin
                data_rvs[i] = data_in[N-1-i];
            end
        end
    endfunction

    initial begin
        $display("Endian Reverse Module Initialized with N = %d", N);
    end

endmodule