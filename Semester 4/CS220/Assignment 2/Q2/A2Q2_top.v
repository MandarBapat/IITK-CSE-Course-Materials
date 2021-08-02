`include "A2Q2_priority_encoder8to3.v"

module top_module();
    reg [7:0] c_in;
    wire [2:0] c_out;
    
    encoder E1(.b_in(c_in), .b_out(c_out));
    
    always @(*) begin
        $display("Time = %d  Input = %b  Output = %b\n", $time, c_in, c_out);
    end
    
    initial begin
        c_in = 8'b11001000;
        #1
        c_in = 8'b00100000;
        #1
        c_in = 8'b00010000;
        #1
        c_in = 8'b00101111;
        #1
        c_in = 8'b11111110;
        #1
        c_in = 8'b10000100;
        #1
        c_in = 8'b00110000;
        #1
        c_in = 8'b11100001;
        #1
        c_in = 8'b11000000;
        #1
        c_in = 8'b10000000;
    end
endmodule