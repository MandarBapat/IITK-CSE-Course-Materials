module counter(clk,r_counter, i_counter, j_counter, reg3_counter, reg4_counter, reg5_counter, reg6_counter, done);
    input clk;
    output reg [3:0] r_counter, i_counter, j_counter;
    output reg[3:0] reg3_counter, reg4_counter, reg5_counter, reg6_counter;
    output reg done;
    integer pc;
    reg [31:0] mem[0:7]; 
    reg [31:0] temp;
    
    initial begin
        mem[0] = {6'h8 , 5'd0 , 5'd4 , 16'h3456};
        mem[1] = {6'h8 , 5'd0 , 5'd5 , 16'hffff};
        mem[2] = {6'd0 , 5'd5 , 5'd4 , 5'd6 , 5'd0 , 6'h20};
        mem[3] = {6'h8 , 5'd0 , 5'd3 , 16'h7};
        mem[4] = {6'd0 , 5'd0 , 5'd6 , 5'd6 , 5'd3 , 6'h4};
        mem[5] = {6'd0 , 5'd0 , 5'd3 , 5'd3 , 5'd1 , 6'h2};
        mem[6] = {6'h23 , 5'd0 , 5'd5 , 16'h9abc};
        mem[7] = {6'h2 , 26'h123456};
    end
    
    initial begin
        pc = 0;
        done = 0;
        r_counter = 0;
        i_counter = 0;
        j_counter = 0;
        reg4_counter = 0;
        reg5_counter = 0;
        reg3_counter = 0;
        reg6_counter = 0;
    end
    
    always @(posedge clk) begin
        temp = mem[pc];
        if(temp[31:26] == 6'b000000) begin
            r_counter = r_counter + 1;
            if(temp[15:11] == 5'd3) begin
                reg3_counter += 1;
            end
            if(temp[15:11] == 5'd4) begin
                reg4_counter += 1;
            end
            if(temp[15:11] == 5'd5) begin
                reg5_counter += 1;
            end
            if(temp[15:11] == 5'd6) begin
                reg6_counter += 1;
            end
            pc = pc + 1;
        end
        
        else if((temp[31:26] == 6'h2) || (temp[31:26] == 6'h3)) begin
            j_counter = j_counter + 1;
            pc = pc + 1;
        end
        
        else begin
            i_counter = i_counter + 1;
            if(temp[20:16] == 5'd3) begin
                reg3_counter += 1;
            end
            if(temp[20:16] == 5'd4) begin
                reg4_counter += 1;
            end
            if(temp[20:16] == 5'd5) begin
                reg5_counter += 1;
            end
            if(temp[20:16] == 5'd6) begin
                reg6_counter += 1;
            end
            pc = pc + 1;
        end
        if(pc == 4'd8) begin
            done = 1;
        end
    end
endmodule