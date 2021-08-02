module processor(clk, result1);
    input clk;
    output reg [7:0] result1;
    reg [7:0] regFile[0:31];
    reg [31:0] mem[0:6];
    integer pc;
    integer state;
    reg [31:0] temp;
    reg [7:0] temp_rs_1, temp_rt_1, temp_rd_1;
    reg [7:0] temp_rs_2, temp_rt_2;
    reg [15:0] temp_i;
    reg r_format, i_format;
    reg [7:0] add1, add2;
    reg [7:0] result;
 
    initial begin
        mem[0] = {6'h9 , 5'd0 , 5'd1 , 16'd45};
        mem[1] = {6'h9 , 5'd0 , 5'd2 , -16'd20};
        mem[2] = {6'h9 , 5'd0 , 5'd3 , -16'd60};
        mem[3] = {6'h9 , 5'd0 , 5'd4 , 16'd30};
        mem[4] = {6'd0 , 5'd1 , 5'd2 , 5'd5 , 5'd0 , 6'h21};
        mem[5] = {6'd0 , 5'd3 , 5'd4 , 5'd6 , 5'd0 , 6'h21};
        mem[6] = {6'd0 , 5'd5 , 5'd6 , 5'd5 , 5'd0 , 6'h23};
    end
    
    initial begin
        for(integer i=0; i<=31 ; i++) begin
            regFile[i] = 8'd0;
        end
    end
    
    initial begin
        pc = 0;
        state = 0;
        r_format = 0;
        i_format = 0;
    end
    
    always @(posedge clk) begin
        if(state == 3'd0) begin
            temp = mem[pc];
            pc = pc + 1;
            state = state + 1;
            r_format = 0;
            i_format = 0;
        end
        
        else if(state == 3'd1) begin
            if(temp[31:26] == 6'd0) begin
                r_format = 1;
            end
            else begin
                i_format = 1;
            end
            state = state + 1;
        end
        
        else if(state == 3'd2) begin
            if(r_format == 1'b1) begin
                temp_rs_1 = temp[25:21];
                temp_rt_1 = temp[20:16];
                add1 = regFile[temp_rs_1];
                add2 = regFile[temp_rt_1];
            end
            else begin
                temp_rs_2 = temp[25:21];
                add2 = temp[7:0];
                add1 = regFile[temp_rs_2];
            end
            state = state + 1;
        end
        
        else if(state == 3'd3) begin
            if(r_format == 1'b1) begin
                if(temp[5:0] == 6'h21) begin
                    result = add1 + add2;
                end
                else begin
                    result = add1 - add2;
                end
            end
            
            else begin
                result = add1 + add2;
            end
            state = state + 1;
        end
        
        else if(state == 3'd4) begin
            if(r_format == 1) begin
                temp_rd_1 = temp[15:11];
                regFile[temp_rd_1] = result;
            end
            
            else begin
                temp_rt_2 = temp[20:16];
                regFile[temp_rt_2] = result;
            end
            
            if(pc < 7) begin
                state = 0;
            end
            
            else begin
                state = 5;
            end
        end
        
        else begin
            result1 = regFile[5];
        end
    end
    
endmodule