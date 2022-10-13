module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock, reset,ParallelLoadn, RotateRight, ASRight;
	input [7:0] Data_IN;
	output reg [7:0]Q;
	always @(posedge clock) begin
		if (reset == 1'b1)
			Q  <= 8'b00000000;
		else begin
			if (ParallelLoadn == 0'b0)
				Q <= Data_IN;
			else begin 
				if (RotateRight == 1'b0)  begin
					Q <= (Q << 1) | {7'b0000000, Q[7]};
				end
				else begin
					if (ASRight == 1'b0) begin
						Q <= (Q >> 1) | {Q[0], 7'b0000000}; 
					end
					else
						Q <= (Q >> 1) | {Q[7], 7'b0000000}; 
				end
			end
		end
	end
endmodule