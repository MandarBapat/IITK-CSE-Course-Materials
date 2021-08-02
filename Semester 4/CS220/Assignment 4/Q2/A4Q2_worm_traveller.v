`include "A4Q2_five_bit_adder.v"

module worm_traveller(clk, direction, steps ,out1, out2);
    input [1:0] direction;
    input [1:0] steps;
    input clk;
    output [4:0] out1, out2;
    reg [4:0] out1;
    reg [4:0] out2;
    
    initial begin
        out1 = 5'b0;
        out2 = 5'b0;
    end
    
    reg [4:0] num1;
    reg [4:0] num2;
    wire carry_out;
    wire overflow;
    reg opcode;
    wire [4:0] sum;
    reg iter1;
    
    five_bit_adder F(num1, num2, opcode, sum, carry_out, overflow);
    
    always @(posedge clk) begin
        if(direction == 2'b00) begin
            num1 = 15;
            opcode = 1;
            num2 = out2;
            #1
            iter1 = ~sum + 1;
            num1 = out2;
            opcode = 0;
            num2 = (iter1 >= steps) ? steps : iter1;
            #1
            out2 = sum;
        end
        else if(direction == 2'b01) begin
            num1 = 15;
            opcode = 1;
            num2 = out1;
            #1
            iter1 = ~sum + 1;
            num1 = out1;
            opcode = 0;
            num2 = (iter1 >= steps) ? steps : iter1;
            #1
            out1 = sum;
        end
        else if(direction == 2'b10) begin
            opcode = 1;
            num1 = out2;
            num2 = (out2 >= steps)? steps : out2;
            #1
            out2 = ~sum + 1;
        end
        else begin
            opcode = 1;
            num1 = out1;
            num2 = (out1 >= steps)? steps : out1;
            #1
            out1 = ~sum + 1;
        end
    end
endmodule