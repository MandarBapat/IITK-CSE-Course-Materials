`include "A7Q2_processor.v"

module top_module();
    reg clk;
    wire [7:0] result1;
    
    initial begin
        clk = 0;
    end
    
    always #5 clk = ~clk;
    
    processor P(clk, result1);
    
    always @(result1) begin
        $display("Time = %d Final content of register $5 = %d", $time, result1);
        $finish;
    end
    
endmodule