module one_bit_comparator(a, b, l1, e1, g1, l2, e2, g2);
    input a, b, l1, e1, g1;
    output l2, e2, g2;
    reg l2, e2, g2;
    
    always @(*) begin
        if(e1==0) begin
            l2 <= l1;
            g2 <= g1;
            e2 <= e1;
        end
        else begin
            l2 <= (~a) & (b);
            g2 <= a & (~b);
            e2 <= (a & b) | (~a & ~b);
        end
    end
endmodule