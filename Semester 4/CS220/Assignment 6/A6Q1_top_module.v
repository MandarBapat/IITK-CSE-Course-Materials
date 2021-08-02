`include "A6Q1_interface_module.v"

module top_module();
    reg [4:0] readIn1, readIn2, writeIn;
    reg [2:0] threeBits;
    reg [15:0] writeData;
    wire [15:0] readOut1, readOut2;
    wire done;
    reg ins;
    
    inface I(readIn1, readIn2, writeIn, writeData, threeBits, readOut1, readOut2, done);
   
    always @(done) begin
        if(threeBits==3'b001 && done==1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn1, readOut1);
            $display("Done");
            ins = ins + 1;
        end
        
        if(threeBits == 3'b010 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn1, readOut1);
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn2, readOut2);
            $display("Done");
            ins = ins + 1;
        end
        
        if(threeBits == 3'b011 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn1, readOut1);
            $display("Done");
            ins = ins + 1;
        end
        
        if(threeBits == 3'b100 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn1, readOut1);
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, readIn2, readOut2);
            $display("Done");
            ins = ins + 1;
        end
        
        if(threeBits == 3'b101 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, writeIn, readOut1);
            $display("Done");
            ins = ins + 1;
        end
        
        if(threeBits == 3'b110 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, writeIn, readOut1);
            $display("Done");
            ins = ins + 1;
        end

        if(threeBits == 3'b111 && done == 1'b1) begin
            $display("Time = %d  Address of register = %d  Data in the register = %b",$time, writeIn, readOut1);
            $display("Done");
            ins = ins + 1;
        end
    end
    
    initial begin
        ins = 0;
        ins = ins + 1;
    end
        
        always @(ins) begin
            if(ins == 4'd10) begin
                $finish;
            end
            
            if(ins == 4'd1) begin
        		threeBits = 3'b000;
                writeData = 16'd17;
                writeIn = 5'd1;
            end
            
            if(ins == 4'd2) begin
                threeBits = 3'b011;
                readIn1 = 5'd1;
                writeIn = 5'd2;
                writeData = -16'd9;
            end
            
            if(ins == 4'd3) begin
                threeBits = 3'b100;
                readIn1 = 5'd1;
                readIn2 = 5'd2;
                writeIn = 5'd3;
                writeData = 16'd65;
            end
            
            if(ins == 4'd4) begin
                threeBits = 3'b010;
                readIn1 = 5'd2;
                readIn2 = 5'd3;
            end
            
            if(ins == 4'd5) begin
                threeBits = 3'b111;
                readIn1 = 5'd5;
                writeData = 16'd3;
                writeIn = 5'd3;
            end
            
            if(ins == 4'd6) begin
                threeBits = 3'b101;
                readIn1 = 5'd1;
                readIn2 = 5'd2;
                writeIn = 5'd4;
            end
            
            if(ins == 4'd7) begin
                threeBits = 3'b111;
                writeIn = 5'd9;
                writeData = 16'd9;
            end
            
            if(ins == 4'd8) begin
                threeBits = 3'b110;
                readIn1 = 5'd5;
                readIn2 = 5'd4;
                writeIn = 5'd6;
            end
            
            if(ins == 4'd9) begin
                threeBits = 3'b001;
                readIn1 = 5'd6;
            end
        end 
endmodule