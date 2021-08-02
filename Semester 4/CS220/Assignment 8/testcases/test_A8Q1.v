initial begin

      //testcase-1
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000010;	// 2
      //sum (2's complement): 00000011

     //testcase-2
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000011;	// 3
      //sum (2's complement): 00100001

      //testcase-3
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000100;	// 4
      //sum (2's complement): 11111001

      //testcase-4
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000101;	// 5
      //sum (2's complement): 11110100

      //testcase-5
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00001010;	// 10
      //sum (2's complement): 00011100


     //testcase-6
      data_mem[0] = 8'b00000001;	// 1
      data_mem[1] = 8'b00000010;	// 2
      data_mem[2] = 8'b00011110;	// 30
      data_mem[3] = 8'b11011000;	// -40
      data_mem[4] = 8'b11111011;	// -5
      data_mem[5] = 8'b00000110;	// 6
      data_mem[6] = 8'b00000111;	// 7
      data_mem[7] = 8'b00001000;	// 8
      data_mem[8] = 8'b00001001;	// 9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00001011;	// 11
      //sum (2's complement): 00011100


      //testcase-7
      data_mem[0] = 8'b10000010;	// -126
      data_mem[1] = 8'b11111110;	// -2
      data_mem[2] = 8'b01111110;	// 126
      data_mem[3] = 8'b00000010;	// 2
      data_mem[4] = 8'b01111110;	// 126
      data_mem[5] = 8'b00000001;	// 1
      data_mem[6] = 8'b10000001;	// -127
      data_mem[7] = 8'b00001000;	// 126
      data_mem[8] = 8'b11110110;	// -9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000010;	// 2
      //sum (2's complement): 10000000

      //testcase-8
      data_mem[0] = 8'b10000010;	// -126
      data_mem[1] = 8'b11111110;	// -2
      data_mem[2] = 8'b01111110;	// 126
      data_mem[3] = 8'b00000010;	// 2
      data_mem[4] = 8'b01111110;	// 126
      data_mem[5] = 8'b00000001;	// 1
      data_mem[6] = 8'b10000001;	// -127
      data_mem[7] = 8'b00001000;	// 126
      data_mem[8] = 8'b11110110;	// -9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000100;	// 4
      //sum (2's complement): 00000000

      //testcase-9
      data_mem[0] = 8'b10000010;	// -126
      data_mem[1] = 8'b11111110;	// -2
      data_mem[2] = 8'b01111110;	// 126
      data_mem[3] = 8'b00000010;	// 2
      data_mem[4] = 8'b01111110;	// 126
      data_mem[5] = 8'b00000001;	// 1
      data_mem[6] = 8'b10000001;	// -127
      data_mem[7] = 8'b00001000;	// 126
      data_mem[8] = 8'b11110110;	// -9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000110;	// 6
      //sum (2's complement): 01111111


      //testcase-10
      data_mem[0] = 8'b10000010;	// -126
      data_mem[1] = 8'b11111111;	// -1
      data_mem[2] = 8'b01111110;	// 126
      data_mem[3] = 8'b00000001;	// 1
      data_mem[4] = 8'b01111110;	// 126
      data_mem[5] = 8'b00000001;	// 1
      data_mem[6] = 8'b10000001;	// -127
      data_mem[7] = 8'b00001000;	// 126
      data_mem[8] = 8'b11110110;	// -9
      data_mem[9] = 8'b00001010;	// 10
      data_mem[10] = 8'b00000101;	// 5
      //sum (2's complement): 01111110

end
