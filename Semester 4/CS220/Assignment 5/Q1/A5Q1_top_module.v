`include "A5Q1_fsm.v"
module top_module();
    reg clk;
    reg [1:0] in;
    wire [3:0] current;
    
    initial clk=0;
    
    always #5 clk = ~clk;
    
    fsm F(in, clk, current);
    
    always @(posedge clk) begin
        $display("Time = %d  Current state = %d",$time, current);
    end
    
    initial begin
        #3
        in = 2'b01;
        #10
        in = 2'b10;
        #10
        in = 2'b11;
        #10
        in = 2'b00;
        #10
        in = 2'b01;
        #10
        in = 2'b10;
        #10
        in = 2'b11;
        #10
        in = 2'b01;
        #10
        in = 2'b10;
        #10
        in = 2'b00;
    end
    
    initial begin
        #100
        $finish;
    end
    
endmodule