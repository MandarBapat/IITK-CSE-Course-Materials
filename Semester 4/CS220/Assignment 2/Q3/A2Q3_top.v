`include "A2Q3_blink.v"

module top_module();
    reg clk;
    wire d_out;
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    blinker E1(.clk(clk), .d_out(d_out));

endmodule