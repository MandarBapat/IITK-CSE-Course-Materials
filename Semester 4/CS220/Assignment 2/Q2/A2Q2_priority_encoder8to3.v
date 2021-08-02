module encoder(b_in, b_out);
    input [7:0] b_in;
    output [2:0] b_out;
    reg b_out;
    
    always @(b_in) begin
        if(b_in[0] == 1'b1)
            b_out = 3'd0;
        else if(b_in[1] == 1'b1)
            b_out = 3'd1;
        else if(b_in[2] == 1'b1)
            b_out = 3'd2;
        else if(b_in[3] == 1'b1)
            b_out = 3'd3;
        else if(b_in[4] == 1'b1)
            b_out = 3'd4;
        else if(b_in[5] == 1'b1)
            b_out = 3'd5;
        else if(b_in[6] == 1'b1)
            b_out = 3'd6;
        else
            b_out = 3'd7;
    end
endmodule

            
