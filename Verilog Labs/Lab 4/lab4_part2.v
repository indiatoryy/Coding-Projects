module part2(Clock, Reset_b, Data, Function, ALUout);
	input Clock, Reset_b;
	input [3:0] Data;
	input [2:0] Function;
	output [7:0] ALUout;

	wire [7:0] wOut;

	reg [7:0] wReg = 'd0;

	// cases 0 through 6
	lab3ALU u0 (Data[3:0], wReg[3:0], Function[2:0], wOut[7:0]);
	
	// case 7
	always @(posedge Clock)     // triggered every time clock rises
	begin 
		if (Reset_b == 1'b0)    // when reset_b is 0
			
			wReg <= wReg;             // q set to 0
		else                    // when not 0
			wReg <= wOut;             // value of d passes through to output q
	end	
	
	assign ALUout = wReg;

endmodule

// ALU
module lab3ALU(A, B, Function, ALUout);
    	input [3:0] A, B;
	input [2:0] Function;
	
	output reg [7:0]ALUout = 'd0;
	
	wire [3:0] w1;
	wire w2;
	
	RIPPLE_ADDER adder(.A(A), .B(B), .Cin(1'b0), .S(w1[3:0]), .Co(w2));
	
	always @(*)
	begin
		case(Function[2:0])
			
			// 0: A+B with adder
			3'b000: begin
				ALUout[3:0]=w1[3:0];
				ALUout[4] = w2;
				ALUout[7:5] = 1'b0;
			end
			
			// 1: A+B using "+"
			3'b001: ALUout = A+B;
			
			// 2: Sign Extension
			3'b010: ALUout[7:0] = { {4{B[3]}}, B[3:0] };
			
			// 3: Output if...
			3'b011: begin
				ALUout[7:1] = 1'b0;
				ALUout[0] = |{A, B};
			end
			
			// 4: Output if...
			3'b100: begin
				ALUout[7:1] = 1'b0;
				ALUout[0] = &{A, B};
			end
				
			// 5: Left shift B by A bits
			3'b101: ALUout = B * (2**A);
			
			// 6: AXB using "*"
			3'b110: ALUout = A*B;
			
			// 7: Hold current value in the Register
			3'b111: ALUout[7:0] = ALUout[7:0];
			
			default: ALUout[7:0]=1'b0;
			
		endcase
	end
endmodule

// Register
//module register (D, Reset_b, Clock, q);
    //input [7:0] D;
   // input Reset_b, Clock;
  //  output reg [7:0] q;
    
//	always @(posedge Clock)     // triggered every time clock rises
	
//	begin 
//		if (Reset_b == 1'b0)    // when reset_b is 0
			
//			q <= 0;             // q set to 0
//		else                    // when not 0
//			q <= D;             // value of d passes through to output q
//	end	
//endmodule

// Full adder
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
	
// Ripple Adder	
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