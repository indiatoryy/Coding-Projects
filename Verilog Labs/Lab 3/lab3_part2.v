module part2(a,b,c_in, s, c_out);
	input [3:0]a,b;
	input c_in;
	output [3:0]s;
	output [3:0]c_out;
	RIPPLE_ADDER ripple(.A(a), .B(b), .Cin(c_in), .S(s), .Co(c_out[3:0]));
endmodule

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
 output [3:0]Co;
 wire w1, w2, w3;
 assign Co[0] = w1;
 assign Co[1] = w2;
 assign Co[2] = w3;
 full_adder u1(A[0], B[0], Cin,S[0], w1);
 full_adder u2(A[1], B[1], w1, S[1], w2);
 full_adder u3(A[2], B[2], w2, S[2], w3);
 full_adder u4(A[3], B[3], w3, S[3], Co[3]);
endmodule
	 
