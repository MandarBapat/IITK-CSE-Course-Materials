module comparator(a, b, c, d, out);
    input [2:0] a, b, c, d;
    output [1:0] out;
    reg [1:0] out;
    integer index;
    reg [2:0] imd;
    
    always @(a or b or c or d or out) begin
        index = a < b ? 0 : 1;
        imd = a < b ? a : b;
        
        index = imd < c ? index : 2;
        imd = imd < c ? imd : c; 
        
        index = imd < d ? index : 3;
        
        out = index;
    end
endmodule