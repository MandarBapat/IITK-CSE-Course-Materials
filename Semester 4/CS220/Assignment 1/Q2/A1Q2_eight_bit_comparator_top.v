`include "A1Q2_eight_bit_comparator.v"

module eight_bit_adder_top;

    reg [7:0] A;
    reg [7:0] B;
    reg lin, ein, gin;
    wire lout, eout, gout;

   eight_bit_comparator COMPARATOR (A, B, lin, ein, gin, lout, eout, gout);

    always @ (*) begin
        if(eout==1) begin
            $display("Time = %d , A = %d , B = %d ,  A is equal to B" , $time, A , B);
        end
        else if(lout==1) begin
            $display("Time = %d , A = %d , B = %d ,  A is less than B" , $time, A , B);
        end
        else begin
            $display("Time = %d , A = %d , B = %d ,  A is greater than B" , $time, A , B);
        end
   end

   initial begin
      A = 100; B = 100;
      #1
      $display("\n");
      A = 133; B = 23;
      #1
      $display("\n");
      A = 20; B = 200; 
      #1
      $display("\n");
      A = 240; B = 189;
      #1
      $display("\n");
      A = 79; B = 156; 
      #1
      $display("\n");
      A = 27; B = 28;
      #1
      $display("\n");
      A = 88; B = 65; 
      #1
      $display("\n");
      A = 4; B = 100; 
      #1
      $display("\n");
      A = 89; B = 86; 
      #1
      $display("\n");   
      A = 45; B = 45; 
      #1
      $display("\n");

end

endmodule