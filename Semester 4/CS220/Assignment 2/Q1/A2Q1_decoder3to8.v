module decoder(a_in , a_out);

    input [2:0] a_in;
    output [7:0] a_out;
    reg a_out;

    always @(*) begin
        case(a_in)
            3'd0:  a_out = 8'b00000001;
            3'd1:  a_out = 8'b00000010;
            3'd2:  a_out = 8'b00000100;
            3'd3:  a_out = 8'b00001000;
            3'd4:  a_out = 8'b00010000;
            3'd5:  a_out = 8'b00100000;
            3'd6:  a_out = 8'b01000000;
            3'd7:  a_out = 8'b10000000;
        endcase
    end
endmodule