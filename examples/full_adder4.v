module full_adder4 (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] So,
    output Co
);
    wire [3:0] co_temp;

    full_adder1 FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(So[0]),
        .Cout(co_temp[0])
    );

    genvar i;
    generate
        for(i = 1; i < 4; i = i + 1) begin : gen_adders
            full_adder1 FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(co_temp[i-1]),
                .Sum(So[i]),
                .Cout(co_temp[i])
            );
        end
    endgenerate

    assign Co = co_temp[3];

endmodule

module full_adder1 (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule
