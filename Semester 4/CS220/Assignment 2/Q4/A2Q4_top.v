`include "A2Q4_rotate.v"
module top_module();
    reg clk;
    wire [3:0] d_out;
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    blinker E1(.clk(clk), .d_out(d_out));

endmodule