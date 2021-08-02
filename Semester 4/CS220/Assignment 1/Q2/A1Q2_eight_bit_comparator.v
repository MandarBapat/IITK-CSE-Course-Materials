`include "A1Q2_one_bit_comparator.v"

module eight_bit_comparator(a, b, lin, ein, gin, lout, eout, gout);
    input [7:0] a,b;
    input lin, ein, gin;
    output lout, eout, gout;
    wire lout, eout, gout;
    
    wire [20:0] w;
    
    one_bit_comparator C1(.a(a[7]) , .b(b[7]) , .l1(lin) , .e1(ein), .g1(gin) , .l2(w[0]) , .e2(w[1]) , .g2(w[2]));
    one_bit_comparator C2(.a(a[6]) , .b(b[6]) , .l1(w[0]) , .e1(w[1]), .g1(w[2]) , .l2(w[3]) , .e2(w[4]) , .g2(w[5]));
    one_bit_comparator C3(.a(a[5]) , .b(b[5]) , .l1(w[3]) , .e1(w[4]), .g1(w[5]) , .l2(w[6]) , .e2(w[7]) , .g2(w[8]));
    one_bit_comparator C4(.a(a[4]) , .b(b[4]) , .l1(w[6]) , .e1(w[7]), .g1(w[8]) , .l2(w[9]) , .e2(w[10]) , .g2(w[11]));
    one_bit_comparator C5(.a(a[3]) , .b(b[3]) , .l1(w[9]) , .e1(w[10]), .g1(w[11]) , .l2(w[12]) , .e2(w[13]) , .g2(w[14]));
    one_bit_comparator C6(.a(a[2]) , .b(b[2]) , .l1(w[12]) , .e1(w[13]), .g1(w[14]) , .l2(w[15]) , .e2(w[16]) , .g2(w[17]));
    one_bit_comparator C7(.a(a[1]) , .b(b[1]) , .l1(w[15]) , .e1(w[16]), .g1(w[17]) , .l2(w[18]) , .e2(w[19]) , .g2(w[20]));
    one_bit_comparator C8(.a(a[0]) , .b(b[0]) , .l1(w[18]) , .e1(w[19]), .g1(w[20]) , .l2(lout) , .e2(eout) , .g2(gout));
    
endmodule