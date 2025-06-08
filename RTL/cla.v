// Description: Carry Look-Ahead Adders
// Details:
//
// Four Bit Slice of Carry Look-Ahead Adder
//
//    SUM[i]       = A[i] xor B[i] xor Carry[i]
//    GENERATE[i]  = A[i] and B[i]
//    PROPAGATE[i] = A[i] or B[i]
//    CARRY[i]     = GENERATE[i-1] or (PROPAGATE[i-1] and CARRY[i-1])
//
module CLA_4Bits(PP,GP,S,A,B,CI);
  output          PP,GP;                  // Carry Propagate & Generate Prime
  output [3:0]    S;                      // Sum
  input  [3:0]    A,B;                    // Adder Inputs
  input           CI;                     // Carry In

  wire [3:0] P =  A | B;
  wire [3:0] G =  A & B;

  wire  C1 =  G[0] | P[0]&CI;
  wire  C2 =  G[1] | P[1]&C1;
  wire  C3 =  G[2] | P[2]&C2;
  wire [3:0] C = { C3, C2, C1, CI };

  assign PP = & P[3:0];
  assign GP = G[3] | P[3]&G[2] | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0];
  assign S  =  A ^ B ^ C ;
  // always  #1 $display ($time,,,"BIT CI=%b, C=%b, A=%b, B=%b, S=%b, P=%b, G=%b", CI, C, A, B, S, P, G);
endmodule

// Four Bit Carry Look-Ahead generator
//
module CLA_Gen_2Bits(PPP,GPP,C4,PP,GP,CI);
  output          PPP, GPP, C4;
  input  [1:0]    PP, GP;
  input           CI;

  assign C4=GP[0] | PP[0]&CI,
         GPP=GP[1] | PP[1]&GP[0],
         PPP=PP[1]&PP[0];

endmodule

// Four Bit Carry Look-Ahead generator
//
module CLA_Gen_4Bits(PPP,GPP,C4,C8,C12,PP,GP,CI);
  output          PPP, GPP, C4, C8, C12;
  input  [3:0]    PP, GP;
  input           CI;

      assign C4=GP[0] | PP[0]&CI,
             C8=GP[1] | PP[1]&GP[0] | PP[1]&PP[0]&CI,
             C12=GP[2] | PP[2]&GP[1] | PP[2]&PP[1]&GP[0] | PP[2]&PP[1]&PP[0]&CI,
             GPP=GP[3] | PP[3]&GP[2] | PP[3]&PP[2]&GP[1] | PP[3]&PP[2]&PP[1]&GP[0],
             PPP = & PP[3:0];

endmodule

// SixTeen Bit Slice Carry Look-Ahead Adder
//
module CLA_16Bits(PPP,GPP,S,A,B,CI);
  output          GPP, PPP;
  output [15:0]   S;
  input  [15:0]   A,B;
  input           CI;
  wire   [3:0]    PP, GP;
  wire            C4, C8, C12;

  CLA_4Bits  BITS30(PP[0],GP[0],S[3:0],A[3:0],B[3:0],CI),
             BITS74(PP[1],GP[1],S[7:4],A[7:4],B[7:4],C4),
             BITS118(PP[2],GP[2],S[11:8],A[11:8],B[11:8],C8),
             BITS1512(PP[3],GP[3],S[15:12],A[15:12],B[15:12],C12);

  CLA_Gen_4Bits GEN150(PPP,GPP,C4,C8,C12,PP[3:0],GP[3:0],CI);

  // always #10 $display ($time,,,"G1  GP=%b, PP=%b, C=%b%b%b%b", GP, PP, C12,C8,C4,CI);
  // always #10 $display ($time,,,"G1  A=%h, B=%h, S=%h", A, B, S);
endmodule

// Sixteen Bit Carry Look-Ahead Adder
//
module CLA_16Bit_Adder(CO,S,A,B,CI);
  output          CO;
  output [15:0]   S;
  input  [15:0]   A,B;
  input           CI;
  wire            PP, GP;

  CLA_16Bits     BITS15_0(PP,GP,S[15:0],A[15:0],B[15:0],CI);
  assign         CO =  GP | PP&CI;

  // always #10 $display ($time,,,"G2  GP=%b, PP=%b, C=%b", GP, PP, CI);
  // always #10 $display ($time,,,"G2  A=%h, B=%h, S=%h", A, B, S);
endmodule

// Thirty Two Bit Carry Look-Ahead Adder
//
module CLA_32Bit_Adder(CO,S,A,B,CI);
  output          CO;
  output [31:0]   S;
  input  [31:0]   A,B;
  input           CI;
  wire            GPP, PPP;
  wire   [1:0]    PP, GP;
  wire            C16, C32, C48;

  CLA_16Bits     BITS15_0(PP[0],GP[0],S[15:0],A[15:0],B[15:0],CI),
                 BITS31_16(PP[1],GP[1],S[31:16],A[31:16],B[31:16],C16);

  CLA_Gen_2Bits  GEN31_0(PPP,GPP,C16,PP[1:0],GP[1:0],CI);
  assign         CO =  GPP | PPP&CI;

// always #10 $display ($time,,,"G2  GP=%b, PP=%b, C=%b%b", GP, PP, C16,CI);
// always #10 $display ($time,,,"G2  A=%h, B=%h, S=%h", A, B, S);
endmodule

// SixtyFour Bit Carry Look-Ahead Adder
//
module CLA_64Bit_Adder(CO,S,A,B,CI);
  output          CO;
  output [63:0]   S;
  input  [63:0]   A,B;
  input           CI;
  wire            GPP, PPP;
  wire   [3:0]    PP, GP;
  wire            C16, C32, C48;

  CLA_16Bits     BITS15_0(PP[0],GP[0],S[15:0],A[15:0],B[15:0],CI),
                 BITS31_16(PP[1],GP[1],S[31:16],A[31:16],B[31:16],C16),
                 BITS47_32(PP[2],GP[2],S[47:32],A[47:32],B[47:32],C32),
                 BITS63_48(PP[3],GP[3],S[63:48],A[63:48],B[63:48],C48);

  CLA_Gen_4Bits  GEN63_0(PPP,GPP,C16,C32,C48,PP[3:0],GP[3:0],CI);
  assign         CO =  GPP | PPP&CI;

  // always #10 $display ($time,,,"G2  GP=%b, PP=%b, C=%b%b%b%b", GP, PP, C48,C32,C16,CI);
  // always #10 $display ($time,,,"G2  A=%h, B=%h, S=%h", A, B, S);
endmodule
