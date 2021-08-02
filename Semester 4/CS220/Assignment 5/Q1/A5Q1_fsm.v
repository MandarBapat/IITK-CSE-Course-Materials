module fsm(in, clk, current);
    input [1:0] in;
    input clk;
    output [3:0] current;
    reg current;
    integer index1, index2;
    
    reg [2:0] microROM[0:12];
    reg [3:0] disp1[0:3];
    reg [3:0] disp2[0:3];
    
    initial begin
        microROM[0] = 3'b000;
        microROM[1] = 3'b000;
        microROM[2] = 3'b000;
        microROM[3] = 3'b001;
        microROM[4] = 3'b010;
        microROM[5] = 3'b010;
        microROM[6] = 3'b000;
        microROM[7] = 3'b000;
        microROM[8] = 3'b000;
        microROM[9] = 3'b000;
        microROM[10] = 3'b011;
        microROM[11] = 3'b100;
        microROM[12] = 3'b100;
    end
    
    initial begin
        current = 4'b0000;
    end
    
    initial begin
        disp1[0] = 4'b0100;
        disp1[1] = 4'b0101;
        disp1[2] = 4'b0110;
        disp1[3] = 4'b0110;
    end
    
    initial begin
        disp2[0] = 4'b1011;
        disp2[1] = 4'b1100;
        disp2[2] = 4'b1100;
        disp2[3] = 4'b1100;
    end
    
    always @(posedge clk) begin
        #2
        index1 = current;
        if(microROM[index1] == 3'b000) begin
            current = current + 1;
        end
        
        else if(microROM[index1] == 3'b001) begin
            index2 = in;
            current = disp1[index2];
        end
        
        else if(microROM[index1] == 3'b010) begin
            current = 4'b0111;
        end
        
        else if(microROM[index1] == 3'b011) begin
            index2 = in;
            current = disp2[index2];
        end
        
        else begin
            current = 4'b0000;
        end
    end
   
endmodule