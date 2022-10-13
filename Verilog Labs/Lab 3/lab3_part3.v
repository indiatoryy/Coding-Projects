module full_adder(A, B, Ci, S, Co);
  input A, B, Ci;
  output S, Co;
  wire w1,w2,w3;

  xor H1(w1, A, B);
  xor H2(S, w1, Ci);
  and H3(w2, w1, Ci);
  and H4(w3, A, B);
  or H5(Co, w2, w3);
endmodule
	
module RIPPLE_ADDER(A, B,Cin, S, Co);
 input [3:0] A, B;
 input Cin; 
 output [3:0] S;
 output Co;
 wire w1, w2, w3;
 
 full_adder u1(A[0], B[0], Cin,S[0], w1);
 full_adder u2(A[1], B[1], w1, S[1], w2);
 full_adder u3(A[2], B[2], w2, S[2], w3);
 full_adder u4(A[3], B[3], w3, S[3], Co);
endmodule

module part3(A, B, Function, ALUout);
	input [3:0] A, B;
	input [2:0]Function;
	output reg [7:0]ALUout;
	wire [3:0] w1;
	wire w2;
	RIPPLE_ADDER adder(.A(A), .B(B), .Cin(1'b0), .S(w1[3:0]), .Co(w2));
	always @(*)
	begin
		case(Function[2:0])
			3'b000: begin
				ALUout[3:0]=w1[3:0];
				ALUout[4] = w2;
				ALUout[7:5] = 1'b0;
			end
			3'b001: ALUout = A+B;
			3'b010: ALUout[7:0] = { {4{B[3]}}, B[3:0] };
			3'b011: begin
				ALUout[7:1] = 1'b0;
				ALUout[0] = |{A, B};
			end
			3'b100: begin
				ALUout[7:1] = 1'b0;
				ALUout[0] = &{A, B};
			end
				
			3'b101: ALUout[7:0] = {A, B};
			default: ALUout[7:0]=1'b0;
		endcase
	end
endmodule
