`include "A2Q1_decoder3to8.v"
`include "A2Q1_encoder8to3.v"

module top_module();
    reg [2:0] c_in;
    wire [2:0] c_out;
    wire [7:0] intermediate;
    
    decoder D1(.a_in(c_in), .a_out(intermediate));
    encoder E1(.b_in(intermediate), .b_out(c_out));
    
    always @(*) begin
        $display("Time = %d  Input = %b  Output = %b\n", $time, c_in, c_out);
    end
    
    initial begin
        c_in = 3'd0;
        $display("\n");
        #5
        c_in = 3'd1;
        #5
        c_in = 3'd3;
        #5
        c_in = 3'd4;
        #5
        c_in = 3'd5;
        #5
        c_in = 3'd6;
        #5
        c_in = 3'd7;
    end
endmodule