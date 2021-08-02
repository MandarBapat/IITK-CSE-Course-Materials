`include "A4Q1_eight_bit_adder.v"
module eight_bit_adder_top;
    
   reg [7:0] A;
   reg [7:0] B;
   reg opcode;
    reg [7:0] C;
    
   wire [7:0] Sum;
   wire Carry;
   wire overflow;
    
    eight_bit_adder ADDER (A, B, opcode, Sum, Carry, overflow);

    always @(*) begin
         $display("time = %d,  A = %d , B = %d  ,  opcode = %d  ,  Sum = %d  Sum = %b and Carry = %b overflow=%b", $time, A, B, opcode, Sum, Sum, Carry, overflow);
   end

   initial begin
      A = 100; B = 100; opcode = 1;
      #1
      $display("\n");
      A = 59; B = 48; opcode = 0;
      #1
      $display("\n");
      A = 20; B = 67; opcode = 0;
      #1
      $display("\n");
      A = 100; B = 40; opcode = 1;
      #1
      $display("\n");
      A = 60; B = 100; opcode = 1;
      #1
      $display("\n");
      A = 50; B = 100; opcode = 0;
      #1
      $display("\n");
      A = 70; B = 60; opcode = 1;
      #1
      $display("\n");
      A = 40; B = 90; opcode = 0;
      #1
      $display("\n");
      A = 55; B = 66; opcode = 1;
      #1
      $display("\n");
      A = 89; B = 67; opcode = 1;
      #1
      $display("\n");

   end

endmodule