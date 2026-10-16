module digital_tube(
        input clk,
        input rstn,
        input en,

        input[3: 0] sing_digit,
        input[3: 0] ten_digit,
        input[3: 0] hund_digit,
        input[3: 0] kilo_digit,

        output reg[6: 0] seg,
        output reg[3: 0] csn
    );

    reg[1: 0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 'd0;
            seg <= 'd0;
            csn <= 4'b1111;
        end else if (en) begin
            case(cnt)
                2'd0: begin
                    seg <= dt_translate(sing_digit);
                    csn <= 4'b0111;
                    cnt <= 3'd1;
                end
                2'd1: begin
                    seg <= dt_translate(ten_digit);
                    csn <= 4'b1011;
                    cnt <= 3'd2;
                end
                2'd2: begin
                    seg <= dt_translate(hund_digit);
                    csn <= 4'b1101;
                    cnt <= 3'd3;
                end
                2'd3: begin
                    seg <= dt_translate(kilo_digit);
                    csn <= 4'b1110;
                    cnt <= 3'd0;
                end
            endcase
        end
    end

    function [6: 0] dt_translate;
        input[3: 0] digit;
        begin
            case(digit)
                4'd0: dt_translate = 7'b1000000;
                4'd1: dt_translate = 7'b1111001;
                4'd2: dt_translate = 7'b0100100;
                4'd3: dt_translate = 7'b0110000;
                4'd4: dt_translate = 7'b0011001;
                4'd5: dt_translate = 7'b0010010;
                4'd6: dt_translate = 7'b0000010;
                4'd7: dt_translate = 7'b1111000;
                4'd8: dt_translate = 7'b0000000;
                4'd9: dt_translate = 7'b0010000;
                default: dt_translate = 7'b1111111; // off
            endcase
        end
    endfunction

endmodule
