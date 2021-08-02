initial begin
      // testcase-1 a,b,c
      data_mem[0] = 8'b00010100;	// a = 20
      data_mem[1] = 8'b00001010;	// b = 10
      data_mem[2] = 8'b00000010;	// c = 2
      // sum (2's complement): 00000000 //0


      // testcase-2 a,b,c
      data_mem[0] = 8'b00101000; 	//a = 40
      data_mem[1] = 8'b01011010; 	//b = 90
      data_mem[2] = 8'b00011001; 	//c = 25
      // sum (2's complement): 01101001   //105


      // testcase-3 a,b,c
      data_mem[0] = 8'b10110111; 	// -73
      data_mem[1] = 8'b01010010; 	// 82
      data_mem[2] = 8'b00110100; 	// 52
      // sum (2's complement):  11000001  //-63


      // testcase-4 a,b,c
      data_mem[0] = 8'b000001; 		// 1
      data_mem[1] = 8'b01111111; 	// 127
      data_mem[2] = 8'b01111110; 	// 126
      // sum (2's complement): 00000001 //1


      // testcase-5 a,b,c
      data_mem[0] = 8'b10000010; 	// -126
      data_mem[1] = 8'b11111111; 	// -1
      data_mem[2] = 8'b01111100; 	// 124
      // sum (2's complement): 10000000  //-128

end
