module encoder(b_in, b_out);
    input [7:0] b_in;
    output [2:0] b_out;
    reg b_out;
    
    always @(*) begin
        case(b_in)
            1 : b_out = 3'd0;
            2 : b_out = 3'd1;
            4 : b_out = 3'd2;
            8 : b_out = 3'd3;
            16 : b_out = 3'd4;
            32 : b_out = 3'd5;
            64 : b_out = 3'd6;
            128 : b_out = 3'd7;
        endcase
    end
endmodule