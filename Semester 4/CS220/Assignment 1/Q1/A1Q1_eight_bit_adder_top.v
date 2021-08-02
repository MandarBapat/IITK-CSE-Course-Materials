`include "A1Q1_eight_bit_adder.v"

module eight_bit_adder_top;

   reg [7:0] A;
   reg [7:0] B;
   reg Cin;

   wire [7:0] Sum;
   wire Carry;

   eight_bit_adder ADDER (A, B, Cin, Sum, Carry);

   always @(A or B or Cin or Sum or Carry) begin
         $display("time = %d,  A = %d , B = %d  ,  Cin = %d  ,  Sum = %d and Carry = %b", $time, A, B, Cin, Sum, Carry);
   end

   initial begin
      A = 100; B = 100; Cin = 1;
      #1
      $display("\n");
      A = 59; B = 48; Cin = 0;
      #1
      $display("\n");
      A = 20; B = 67; Cin = 0;
      #1
      $display("\n");
      A = 100; B = 40; Cin = 1;
      #1
      $display("\n");
      A = 60; B = 100; Cin = 1;
      #1
      $display("\n");
      A = 50; B = 100; Cin = 0;
      #1
      $display("\n");
      A = 70; B = 60; Cin = 1;
      #1
      $display("\n");
      A = 40; B = 90; Cin = 0;
      #1
      $display("\n");
      A = 55; B = 66; Cin = 1;
      #1
      $display("\n");
      A = 89; B = 67; Cin = 1;
      #1
      $display("\n");

   end

endmodule