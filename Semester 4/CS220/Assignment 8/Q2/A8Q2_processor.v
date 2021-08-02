module processor(clk, result1);
    input clk;
    output reg [7:0] result1;
    
    reg [7:0] regFile[0:31];
    reg [31:0] mem[0:10];
    reg [7:0] pc;
    reg [2:0] state;
    reg [31:0] temp;
    reg [4:0] temp_rs_1, temp_rt_1, temp_rd_1;
    reg [4:0] temp_rs_2, temp_rt_2;
    reg r_format, i_format, j_format;
    reg [7:0] result;
    reg invalid;
    reg [7:0] data[0:2];
    reg [4:0] dest;
    reg [7:0] MAX_PC, OUTPUT_REG;
 
    initial begin
        mem[0] = {6'h23 , 5'd0 , 5'd1 , 16'd0};
        mem[1] = {6'h23 , 5'd0 , 5'd2 , 16'd1};
        mem[2] = {6'h23 , 5'd0 , 5'd3 , 16'd2};
        mem[3] = {6'h9 , 5'd0 , 5'd4 , 16'd0};
        mem[4] = {6'h9 , 5'd1 , 5'd5 , 16'd0};
        mem[5] = {6'h0 , 5'd5 , 5'd2 , 5'd6 , 5'd0, 6'h2a};
        mem[6] = {6'h4 , 5'd6 , 5'd0 , 16'd5};
        mem[7] = {6'h0 , 5'd4 , 5'd5 , 5'd4 , 5'd0 , 6'h21};
        mem[8] = {6'h0 , 5'd5 , 5'd3 , 5'd5 , 5'd0 , 6'h21};
        mem[9] = {6'h0 , 5'd5 , 5'd2 , 5'd6 , 5'd0, 6'h2a};
        mem[10] = {6'h5 , 5'd6 , 5'd0 , -16'd3};
    end
    
    initial begin
        data[0] = 1 + ~(-8'd126);
        data[1] = 1 + ~(-8'd1);
        data[2] = 1 + ~(8'd124);
    end
    
    initial begin
        for(integer i=0; i<=31 ; i++) begin
            regFile[i] = 8'd0;
        end
    end
    
    initial begin
        pc = 8'd0;
        state = 3'd0;
        r_format = 0;
        i_format = 0;
        j_format = 0;
        invalid = 0;
        MAX_PC = 8'd11;
        OUTPUT_REG = 8'd4;
    end
    
    always @(posedge clk) begin
        if(state == 3'd0) begin
            temp = mem[pc];
            state = 3'd1;
            r_format = 0;
            i_format = 0;
            j_format = 0;
        end
        
        else if(state == 3'd1) begin
            if(temp[31:26] == 6'h0) begin
                r_format = 1'b1;
            end
            else if(temp[31:26] == 6'h2 || temp[31:26] == 6'h3) begin
                j_format = 1'b1;
            end
            else begin
                i_format = 1'b1;
            end
            state = 3'd2;
        end
        
        else if(state == 3'd2) begin
            if(r_format == 1'b1) begin
                temp_rs_1 = temp[25:21];
                temp_rt_1 = temp[20:16];
            end
            else if(i_format == 1'b1) begin
                temp_rs_2 = temp[25:21];
            end
            state = 3'd3;
        end
        
        else if(state == 3'd3) begin
            if(r_format == 1'b1) begin
                if(temp[5:0] == 6'h21) begin
                    result = regFile[temp_rs_1] + regFile[temp_rt_1];
                end
                else if (temp[5:0] == 6'h2a) begin
                    result = $signed(regFile[temp_rs_1]) < $signed(regFile[temp_rt_1]);
                end
                else if(temp[5:0] == 6'h8) begin
                    pc = regFile[31];
                end
                else begin
                    invalid = 1'b0;
                end
            end
            
            else if(i_format == 1'b1) begin
                if(temp[31:26] == 6'h9) begin
                    result = regFile[temp_rs_2] + temp[7:0];
                end
                else if(temp[31:26] == 6'h4) begin
                    temp_rt_2 = temp[20:16];
                    if(regFile[temp_rs_2] == regFile[temp_rt_2]) begin
                        pc = pc + temp[7:0];
                    end
                    else begin
                        pc = pc + 8'd1;
                    end
                end
                else if(temp[31:26] == 6'h23) begin
                    result = regFile[temp_rs_2] + temp[7:0];
                end
                else if(temp[31:26] == 6'h5) begin
                    temp_rt_2 = temp[20:16];
                    if(regFile[temp_rs_2] == regFile[temp_rt_2]) begin
                        pc = pc + 8'd1;
                    end
                    else begin
                        pc = pc + temp[7:0];
                    end
                end
                else begin
                    invalid = 1'b1;
                end
            end
            
            else if(j_format == 1'b1) begin
                if(temp[31:26] == 6'h3) begin
                    regFile[31] = pc + 8'b1;
                    pc = temp[7:0];
                end
                else begin
                    invalid = 1'b1;
                end
            end
            
            else begin
                invalid = 1'b1;
            end
            
            state = 3'd4;
        end
        
        else if(state == 3'd4) begin
            if(i_format == 1'b1 && temp[31:26] == 6'h23) begin
                result = 1 + ~(data[result]);
            end
            state = 3'd5;
        end
        
        else if(state == 3'd5) begin
            if(invalid == 1'b0) begin
                if(r_format == 1'b1) begin
                    if(temp[5:0] == 6'h21 || temp[5:0] == 6'h2a) begin
                        temp_rd_1 = temp[15:11];
                        regFile[temp_rd_1] = result;
                        pc = pc + 8'd1;
                    end
                end
                else if(i_format == 1'b1) begin
                    if(temp[31:26] == 6'h9 || temp[31:26] == 6'h23) begin
                        dest = temp[20:16];
                        regFile[dest] = result;
                        pc = pc + 8'd1;
                    end
                end
            end
            
            if(pc < MAX_PC) begin
                state = 3'd0;
            end
            else begin
                state = 3'd6;
            end
        end
        
        else if(state == 3'd6) begin
            result1 = regFile[OUTPUT_REG];
        end
    end
    
endmodule