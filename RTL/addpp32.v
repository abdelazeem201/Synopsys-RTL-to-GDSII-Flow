// Description:  Wallace Tree for 32 x 32 Multiplier
// Author: Ahmed Abdelazeem
// Wallace Carry Save Adder Tree
//
//   Uses 4 levels of 4 to 2 Carry Save adders to sum the 16 partial products.
//   The final sum is generated using a Carry Look-Ahead adder.
//
//  15  14  13  12     11  10   9   8      7   6   5   4      3   2   1   0
//   |   |   |   |      |   |   |   |      |   |   |   |      |   |   |   |
// +-+---+---+---+-+  +-+---+---+---+-+  +-+---+---+---+-+  +-+---+---+---+-+
// |     CSA13     |  |     CSA12     |  |     CSA11     |  |     CSA10     |
// +---+-------+---+  +---+-------+---+  +---+-------+---+  +---+-------+---+
//     |       +------+   |   +---+          +---+   |   +------+       |
//     +----------+   |   |   |                  |   |   |   +----------+
//              +-+---+---+---+-+              +-+---+---+---+-+
//              |     CSA21     |              |     CSA20     |
//              +---+-------+---+              +---+-------+---+
//                  |       +--------+   +---------+       |
//                  +------------+   |   |   +-------------+
//                             +-+---+---+---+-+
//                             |     CSA30     |
//                             +---+-------+---+
//                                 |       +-+   Z  Y[31]
//                                 +-----+   |   |   |
//                                     +-+---+---+---+-+
//                                     |     CSA40     |
//                                     +---+-------+---+
//                                         |       |
//                                     +---+-------+---+
//                                     |     CLA0      |
//                                     +-------+-------+
//                                             | Sum
//
module PP_Add_32Bits(Ovfl,Sum,PP15,PP14,PP13,PP12,PP11,PP10,PP9,PP8,
                    PP7,PP6,PP5,PP4,PP3,PP2,PP1,PP0,Y,Z);

  output               Ovfl;          // CLA Overflow
  output [31:0]        Sum;           // Sum of Partial Products
  input  [32:0]        PP15;          // Partial Product 15
  input  [32:0]        PP14;          // Partial Product 14
  input  [32:0]        PP13;          // Partial Product 13
  input  [32:0]        PP12;          // Partial Product 12
  input  [32:0]        PP11;          // Partial Product 11
  input  [32:0]        PP10;          // Partial Product 10
  input  [32:0]        PP9;           // Partial Product 9
  input  [32:0]        PP8;           // Partial Product 8
  input  [32:0]        PP7;           // Partial Product 7
  input  [32:0]        PP6;           // Partial Product 6
  input  [32:0]        PP5;           // Partial Product 5
  input  [32:0]        PP4;           // Partial Product 4
  input  [32:0]        PP3;           // Partial Product 3
  input  [32:0]        PP2;           // Partial Product 2
  input  [32:0]        PP1;           // Partial Product 1
  input  [32:0]        PP0;           // Partial Product 0
  input  [31:0]        Y;             // Mulitiplier, Y
  input  [31:0]        Z;             // Adder Z

  wire                 Cin = 1'b0;    // Carry In
  wire                 Zero = 1'b0;   // Carry In

  // Partial Product Alignment and Wallace Tree Addition
  //
  //    Note: Y[x] terms are included to complete Booth encoding.  They are
  //          used for completing 2's complement when substacting the segment
  //          is required.
  // 
  // First Level of Wallace Tree
  // 
  wire [9:0]  aPP15= { PP15[1:0], 1'b0, Y[29], 6'h00 };
  wire [9:0]  aPP14= { PP14[3:0], 1'b0, Y[27], 4'h0 };
  wire [9:0]  aPP13= { PP13[5:0], 1'b0, Y[25], 2'h0 };
  wire [9:0]  aPP12= { PP12[7:0], 1'b0, Y[23] };
  wire [9:0]  S13;                                    // CSA Sum PP15:PP12
  wire [9:0]  C13;                                    // CSA Carry PP15:PP12
  wire        Ovf13;                                  // CSA Overflow
  CSA_nBits   #(10)  CSA13(C13,S13,Ovf13,aPP15,aPP14,aPP13,aPP12,Zero);

  wire [17:0] aPP11= { PP11[9:0],  1'b0, Y[21], 6'h00 };
  wire [17:0] aPP10= { PP10[11:0], 1'b0, Y[19], 4'h0 };
  wire [17:0] aPP9 = { PP9[13:0],  1'b0, Y[17], 2'h0 };
  wire [17:0] aPP8 = { PP8[15:0],  1'b0, Y[15] };
  wire [17:0] S12;                                    // CSA Sum PP11:PP8
  wire [17:0] C12;                                    // CSA Carry PP11:PP8
  wire        Ovf12;                                  // CSA Overflow
  CSA_nBits   #(18)  CSA12(C12,S12,Ovf12,aPP11,aPP10,aPP9,aPP8,Zero);

  wire [25:0] aPP7 = { PP7[17:0], 1'b0, Y[13], 6'h00 };
  wire [25:0] aPP6 = { PP6[19:0], 1'b0, Y[11], 4'h0 };
  wire [25:0] aPP5 = { PP5[21:0], 1'b0, Y[9], 2'h0 };
  wire [25:0] aPP4 = { PP4[23:0], 1'b0, Y[7] };
  wire [25:0] S11;                                    // CSA Sum PP7:PP4
  wire [25:0] C11;                                    // CSA Carry PP7:PP4
  wire        Ovf11;                                  // CSA Overflow
  CSA_nBits   #(26)  CSA11(C11,S11,Ovf11,aPP7,aPP6,aPP5,aPP4,Zero);

  wire [31:0] aPP3 = { PP3[25:0], 1'b0, Y[5], 4'h0 };
  wire [31:0] aPP2 = { PP2[27:0], 1'b0, Y[3], 2'h0 };
  wire [31:0] aPP1 = { PP1[29:0], 1'b0, Y[1] };
  wire [31:0] aPP0 = { PP0[31:0] };
  wire [31:0] S10;                                    // CSA Sum PP3:PP0
  wire [31:0] C10;                                    // CSA Carry PP3:PP0
  wire        Ovf10;                                  // CSA Overflow
  CSA_nBits   #(32)  CSA10(C10,S10,Ovf10,aPP3,aPP2,aPP1,aPP0,Zero);

  // Second Level of Wallace Tree
  //
  wire [17:0] S21;                                    // CSA Sum PP15:PP8
  wire [17:0] C21;                                    // CSA Carry PP15:PP8
  wire        Ovf21;                                  // CSA Overflow
  CSA_nBits   #(18)  CSA21(C21,S21,Ovf21,C12,S12,{C13,8'h00},{S13,8'h00},Zero);

  wire [31:0] S20;                                    // CSA Sum PP7:PP0
  wire [31:0] C20;                                    // CSA Carry PP7:PP0
  wire        Ovf20;                                  // CSA Overflow
  CSA_nBits   #(32)  CSA20(C20,S20,Ovf20,C10,S10,{C11,6'h00},{S11,6'h00},Zero);

  // Third Level of Wallace Tree
  //
  wire [31:0] S30;                                    // CSA Sum PP15:PP0
  wire [31:0] C30;                                    // CSA Carry PP15:PP0
  wire        Ovf30;                                  // CSA Overflow
  CSA_nBits   #(32)  CSA30(C30,S30,Ovf30,C20,S20,{C21,14'h0000},{S21,14'h0000},Zero);

  // Forth Level of Wallace Tree
  // 
  wire [31:0] S40;                         // CSA Sum Z & Final Subtraction Fix
  wire [31:0] C40;                         // CSA Carry Z & Final Sub Fix
  wire        Ovf40;                       // CSA Overflow Z & Final Sub Fix
  CSA_nBits   #(32)  CSA40(C40,S40,Ovf40,C30,S30,Z,{1'b0,Y[31],30'h00000000},Zero);

  // Final Carry Propagating Stage
  //
  wire        ClaOvfl;                     // CLA Overflow
  CLA_32Bit_Adder  CLA1(ClaOvfl,Sum,C40,S40,Cin);

  // Overflow Detection
  // 
  assign Ovfl = Ovf13 | Ovf12 | Ovf11 | Ovf10 | Ovf21 | Ovf20 | Ovf30 | Ovf40 ;
  //  always #10 $display ($time,,,"Overflow %h %h %h %h  %h %h  %h  %h  %h",
  //              Ovf13,Ovf12,Ovf11,Ovf10,Ovf21,Ovf20,Ovf30,Ovf40,ClaOvfl);
endmodule
