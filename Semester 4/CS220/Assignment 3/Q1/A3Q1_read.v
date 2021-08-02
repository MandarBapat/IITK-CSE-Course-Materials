module read(clk, row, input_valid, output_valid);
	input clk, input_valid;
	input [31:0] row;
	output output_valid;
	reg output_valid=0;
	wire [31:0]row;
	reg [31:0]prev;
	reg [31:0] mem[0:15];
	initial begin
		mem[0]=32'b0;
		mem[1]=32'b1;
		mem[2]=32'b10;
		mem[3]=32'b11;
		mem[4]=32'b100;
		mem[5]=32'b101;
		mem[6]=32'b110;
		mem[7]=32'b111;
		mem[8]=32'b1000;
		mem[9]=32'b1001;
		mem[10]=32'b1010;
		mem[11]=32'b1011;
		mem[12]=32'b1100;
		mem[13]=32'b1101;
		mem[14]=32'b1110;
		mem[15]=32'b1111;
	end
	integer count=1;
	always@(prev)begin
		$display("Time = %d  row=%d prev=%d Output = %b output_valid=%d\n", $time, row, prev, mem[prev], output_valid);
	end
	always@(posedge clk) begin
		if(input_valid==1'b1) begin
			output_valid<=0;
			if(count==1) begin
				prev <= #10 row;
				output_valid<=#10 1;
				//$display("Time = %d  row=%d prev=%d Output = %b output_valid=%d\n", $time, row, prev, mem[prev], 0);
			end
			else if(prev != row) begin
				prev <= #20 row;
				output_valid<= #20 1;
				//$display("Time = %d  row=%d prev=%d Output = %b output_valid=%d\n", $time, row, prev, mem[prev], 0);
			end
			else if(prev==row)begin
				output_valid<=1;
				$display("Time = %d  row=%d prev=%d Output = %b output_valid=%d\n", $time, row, prev, mem[prev], output_valid);
			end
		end
		count=count+1;
		if(count == 31)
			$finish;
	
	end	
endmodule