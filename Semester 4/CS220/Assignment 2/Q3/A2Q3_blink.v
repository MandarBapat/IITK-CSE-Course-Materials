module blinker(clk, d_out);
    input clk;
    output d_out;
    reg d_out;
    integer counter = 0;
    
    initial begin
        d_out = 0;
        $display("Time = %d , Output = %b", $time, d_out);
    end
    
    always @(negedge clk) begin
        counter = counter + 1;
        if(counter%25000 == 0) begin
            d_out = ~(d_out);
            $display("Time = %d  Counter = %d  Output = %b", $time, counter,d_out);
        end
        if(counter == 310000)
            $finish;
    end
endmodule