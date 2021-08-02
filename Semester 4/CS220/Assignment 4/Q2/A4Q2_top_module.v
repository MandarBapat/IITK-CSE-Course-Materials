`include "A4Q2_worm_traveller.v"
module top_module();
    
    reg clk1;
    reg [1:0] direction;
    reg [1:0] steps;
    wire [4:0] out1;
    wire [4:0] out2;
    
    worm_traveller WT(clk1, direction, steps, out1, out2);
    
    initial begin
        clk1 = 0;
    end
    
    always #5 clk1 = ~clk1;
    
    initial begin
        #100
        $finish;
    end
    
    always @(posedge clk1) begin
        $display("Time = %d Direction = %d Steps = %d Position = (%d , %d)\n",$time, direction, steps, out1,out2);
    end
    
    initial begin
        #3
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
        #10
        direction = 2'b00; steps = 2'b01;
    end
endmodule