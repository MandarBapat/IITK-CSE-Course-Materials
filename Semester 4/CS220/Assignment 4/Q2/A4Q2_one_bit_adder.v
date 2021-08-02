module one_bit_adder (a, b, cin, opcode, sum, cout);

   input a;
   input b;
   input cin;
   input opcode;

   output sum;
   wire sum;
   output cout;
   wire cout;
   
   wire temp;
   
   assign temp = b^opcode;
   assign sum = a^temp^cin;
   assign cout = (a & temp) | (a & cin) | (cin & temp); 

endmodule