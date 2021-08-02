`include "A3Q1_read.v"

module DRAM();
	
	reg clk, clk2, clk3, input_valid;
	wire output_valid;
	reg [31:0]row;
	wire d_out;
	integer count=0;
	initial begin
		clk <= 0;
		clk2<= 0;
		clk3<= 0;
		row<=32'b0;
		input_valid<=0;
	end
	always #5 clk = ~clk;
	initial begin
		#3
		forever begin
			clk2=1;
			#15
			clk2=0;
			#15
			clk2=0;
			
		end
	end
	initial begin
		#3
		forever begin
			clk3=1;
			#5
			clk3=0;
			#5
			clk3=0;
			
		end
	end
	
	read d1 (.clk(clk), .row(row), .input_valid(input_valid), .output_valid(output_valid));
	
	//always@(posedge clk or clk2 or clk3)$display("Time =%d  output_valid=%d \n", $time, output_valid);
	
	always@(posedge clk2 )  begin
		if(count%2==0)begin
			row<=row + 32'b1;
			if(row > 15) row<=32'b0;
		end;
		count=count+1;
	end
	always@(posedge clk2 or clk3) begin
		if(clk2==1 && $time%3==0 && $time>0) begin 
			input_valid<=1;
		end
		else if(clk3==1)begin
			input_valid<=0;
		end
		
	end
endmodule