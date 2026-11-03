module loopback_tb;
    reg clk = 0;
    reg reset_n = 1;
    reg send = 0;
    reg [6:0] data = 0;
    wire serial_out, sent, received, parity_ok;
    wire [6:0] result;

    uart dut(reset_n, clk, send, data, serial_out, sent, received, result, parity_ok);
    always #5 clk = ~clk;

    task check_transfer;
        input [6:0] value;
        begin
            @(negedge clk);
            data = value;
            send = 1;
            @(negedge clk);
            send = 0;
            repeat (12) @(negedge clk);
            if (sent !== 1'b1 || received !== 1'b1 ||
                result !== value || parity_ok !== 1'b1)
                $fatal(1, "Loopback failed for %h", value);
        end
    endtask

    initial begin
        #1 reset_n = 0;
        repeat (2) @(negedge clk);
        reset_n = 1;
        check_transfer(7'h41);
        check_transfer(7'h7f);
        $display("Loopback passed");
        $finish;
    end
endmodule
