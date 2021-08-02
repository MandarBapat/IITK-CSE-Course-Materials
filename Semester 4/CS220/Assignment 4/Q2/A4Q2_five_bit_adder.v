`include "A4Q2_one_bit_adder.v"

module five_bit_adder (x, y, opcode, sum, carry_out, overflow);
	input [4:0] x;
	input [4:0] y;
	input opcode;

	output [4:0] sum;
	wire [4:0] sum;
	output carry_out;
	wire carry_out;
	output overflow;
	reg overflow;


	wire [3:0] intermediate_carry;
 
	one_bit_adder FA0 (x[0], y[0], opcode, opcode, sum[0], intermediate_carry[0]);
	one_bit_adder FA1 (x[1], y[1], intermediate_carry[0], opcode, sum[1], intermediate_carry[1]);
	one_bit_adder FA2 (x[2], y[2], intermediate_carry[1], opcode, sum[2], intermediate_carry[2]);
	one_bit_adder FA3 (x[3], y[3], intermediate_carry[2], opcode, sum[3], intermediate_carry[3]);
	one_bit_adder FA4 (x[4], y[4], intermediate_carry[3], opcode, sum[4], carry_out);
   
	always@(*) begin
		if(carry_out==intermediate_carry[3])
            			overflow = 1'b0;
		else
            			overflow = 1'b1;
	end

endmodule