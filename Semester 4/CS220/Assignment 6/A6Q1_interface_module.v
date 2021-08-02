module inface(readIn1, readIn2, writeIn, writeData, threeBits, readOut1, readOut2, done);
    input [4:0] readIn1, readIn2, writeIn;
    input [15:0] writeData;
    input [2:0] threeBits;
    output reg [15:0] readOut1, readOut2;
    output reg done;
    
    reg [15:0] a, b, c;
    
    reg [15:0] regFile[0:31];
    
    initial begin
        done = 1'b0;
        regFile[0] = 16'b0;
        regFile[1] = 16'b0;
        regFile[2] = 16'b0;
        regFile[3] = 16'b0;
        regFile[4] = 16'b0;
        regFile[5] = 16'b0;
        regFile[6] = 16'b0;
        regFile[7] = 16'b0;
        regFile[8] = 16'b0;
        regFile[9] = 16'b0;
        regFile[10] = 16'b0;
        regFile[11] = 16'b0;
        regFile[12] = 16'b0;
        regFile[13] = 16'b0;
        regFile[14] = 16'b0;
        regFile[15] = 16'b0;
        regFile[16] = 16'b0;
        regFile[17] = 16'b0;
        regFile[18] = 16'b0;
        regFile[19] = 16'b0;
        regFile[20] = 16'b0;
        regFile[21] = 16'b0;
        regFile[22] = 16'b0;
        regFile[23] = 16'b0;
        regFile[24] = 16'b0;
        regFile[25] = 16'b0;
        regFile[26] = 16'b0;
        regFile[27] = 16'b0;
        regFile[28] = 16'b0;
        regFile[29] = 16'b0;
        regFile[30] = 16'b0;
        regFile[31] = 16'b0;
    end
    
    always @(threeBits) begin
        if(threeBits == 3'b000) begin
            #20
            regFile[writeIn] = writeData;
            done=1'b1;
        end
        
        if(threeBits == 3'b001) begin
            #20
            readOut1 = regFile[readIn1];
            done = 1'b1;
        end
        
        if(threeBits == 3'b010) begin
            #20
            readOut1 = regFile[readIn1];
            readOut2 = regFile[readIn2];
            done = 1'b1;
        end
        
        if(threeBits == 3'b011) begin
            #20
            readOut1 = regFile[readIn1];
            #20
            regFile[writeIn] = writeData;
            done = 1'b1;
        end
        
        if(threeBits == 3'b100) begin
            #20
            readOut1 = regFile[readIn1];
            readOut2 = regFile[readIn2];
            #20
            regFile[writeIn] = writeData;
            done = 1'b1;
        end
        
        if(threeBits == 3'b101) begin
            #20
            a = regFile[readIn1];
            b = regFile[readIn2];
            #160
            c = a + b;
            #20
            regFile[writeIn] = c;
            readOut1 = regFile[writeIn];
            done = 1'b1;
        end
        
        if(threeBits == 3'b110) begin
            #20
            a = regFile[readIn1];
            b = regFile[readIn2];
            #160
            c = a - b;
            #20
            regFile[writeIn] = c;
            readOut1 = regFile[writeIn];
            done = 1'b1;        	
        end
        
        if(threeBits == 3'b111) begin
            #20
            a = regFile[readIn1];
            #160
            c = a << writeData;
            #20
            regFile[writeIn] = c;
            readOut1 = regFile[writeIn];
            done = 1'b1;
        end
    end 
endmodule
        