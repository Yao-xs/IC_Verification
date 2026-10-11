`timescale 1ns/1ns

module runoob;

    initial begin: runoob
        integer i;
        i = 0;
        forever begin
            #10 i = i + 1;
        end
    end

    initial begin
        $dumpfile("runoob.vcd");
        $dumpvars(0, runoob);
    end

    reg stop_flag;
    initial stop_flag = 1'b0;
    always begin : detect_stop
        if(runoob.i == 100) begin
            $display("i = %d, stop_flag = %b", runoob.i, stop_flag);
            stop_flag = 1'b1;
            $finish;
        end
        #10;
    end

endmodule