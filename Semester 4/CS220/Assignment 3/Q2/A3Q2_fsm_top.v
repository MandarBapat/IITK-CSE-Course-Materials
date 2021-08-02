`include "A3Q2_fsm.v"

module top_module();
    
    reg p, clk, clk2;
    wire out;
    
    fsm F1(.p(p), .clk(clk) , .out(out));
    
    initial begin
        clk=0;
        clk2=0;
    end
    
    always #5 clk = ~clk;
     
    initial begin
        #1000
        $finish;
    end
    
    initial begin
        #3
        forever begin
            clk2=1;
            #5
            clk2=0;
            #5
            clk2=1;
        end
    end
    
    always @(posedge clk2) begin
        p=$random;
    end
    
    always @(*) begin
        $display("Time = %d  Input = %b , Output = %b",$time, p, out);
    end
endmodule
    
    
    