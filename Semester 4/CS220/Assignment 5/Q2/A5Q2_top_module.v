`include "A5Q2_comparator.v"

module top_module();
    reg [2:0] a[0:3];
    wire [1:0] out;
    
	
    comparator C(a[0], a[1], a[2], a[3], out);
    
    always @(a[0] or a[1] or a[2] or a[3] or out) begin
        $display("Time = %d  a=%d b=%d c=%d d=%d Index value = %d\n", $time, a[0], a[1], a[2], a[3], out);
    end
    
    initial begin
		#1
        a[0] = 3'b110;
        a[1] = 3'b010;
        a[2] = 3'b001;
        a[3] = 3'b111;
        #1
        a[0] = 3'b111;
        a[1] = 3'b000;
        a[2] = 3'b010;
        a[3] = 3'b011;
        #1
        a[0] = 3'b011;
        a[1] = 3'b110;
        a[2] = 3'b101;
        a[3] = 3'b001;
        #1
        a[0] = 3'b001;
        a[1] = 3'b101;
        a[2] = 3'b110;
        a[3] = 3'b111;
        #1
        a[0] = 3'b100;
        a[1] = 3'b110;
        a[2] = 3'b011;
        a[3] = 3'b111;
        #1
        a[0] = 3'b100;
        a[1] = 3'b011;
        a[2] = 3'b000;
        a[3] = 3'b110;
        #1
        a[0] = 3'b100;
        a[1] = 3'b010;
        a[2] = 3'b001;
        a[3] = 3'b111;
        #1
        a[0] = 3'b011;
        a[1] = 3'b001;
        a[2] = 3'b000;
        a[3] = 3'b111;
        #1
        a[0] = 3'b011;
        a[1] = 3'b101;
        a[2] = 3'b110;
        a[3] = 3'b010;
        #1
        a[0] = 3'b110;
        a[1] = 3'b101;
        a[2] = 3'b111;
        a[3] = 3'b011;
    end
    
endmodule