module fsm(p, clk, out);
    input p, clk;
    output out;
    reg out;
    
    reg a, b, c;
    
    initial begin
        a=0;
        b=0;
        c=0;
    end
    

    always @(posedge clk) begin
        a <=  (~p & (c | a)) | (a & (b | c)) | (b & p);
        b <=  (a & b) | (~a & ~b & p) | (a & ~c & p);
        c <= ~c | a | (b & p) | (~b & c & ~p);
        #1
        out = ~a | b | ~c;
    end
endmodule