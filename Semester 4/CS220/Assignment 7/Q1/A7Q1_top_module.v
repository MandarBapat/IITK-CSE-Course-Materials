`include "A7Q1_counter.v"

module top_module();
    reg clk;
    wire [3:0] r_counter, i_counter, j_counter;
    wire [3:0] reg3_counter, reg4_counter, reg5_counter, reg6_counter;
    wire done;
    initial begin
        clk = 0;
    end
    
    always #5 clk = ~clk;
    
    counter C(clk, r_counter, i_counter, j_counter,reg3_counter, reg4_counter, reg5_counter, reg6_counter, done);
    
    always @(done) begin
        if(done == 1'b1) begin
            $display("Time = %d", $time);
            $display("Number of R-format instrcuctions = %d", r_counter);
            $display("Number of I-format instrcuctions = %d", i_counter);
            $display("Number of J-format instrcuctions = %d", j_counter);
            $display("Number of $3 register writes = %d", reg3_counter);
            $display("Number of $4 register writes = %d", reg4_counter);
            $display("Number of $5 register writes = %d", reg5_counter);
            $display("Number of $6 register writes = %d", reg6_counter);
            $finish;
        end
    end
endmodule
    