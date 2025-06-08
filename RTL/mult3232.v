//   Multiply Using Radix 4 Booth Recoding, Wallace tree of 4:2 Carry Save
//   Adders and final carry propagating add using a Carry Look-Ahead Adder
//
//                            Xn-1 Xn-2 ... X2 X1 X0 <- Multiplicand
//                         X  Yn-1 Yn-2 ... Y2 Y1 Y0 <- Multiplier
//                         -------------------------
//                           An-1  An-2 ... A2 A1 A0 <- Partial Product 0
//                      Bn-1 Bn-2 ... B2 B1 B0    Y1 <- Partial Product 1
//               Cn-1  Cn-2 ... C2 C1 C0    Y3       <- Partial Product 2
//         Dn-1  Dn-2 ... D2 D1 D0    Y5             <- Partial Product 3
//                    ...                                      ...
//   Mn-1 Mn-2 ...                                   <- Partial Product (n/2)-1
//   -----------------------------------------------
//   S2n-1 S2n-2  ...                       S2 S1 S0
//
module Mult_32x32(Ovfl,Product,X,Y,Z,clock,iso,reset);
  `define nBits   32

  output                 Ovfl;            // Overflow
  output [`nBits-1:0]    Product;         // Product X * Y
  input  [`nBits-1:0]    X;               // Mulitiplicand, X
  input  [`nBits-1:0]    Y;               // Mulitiplier, Y
  input  [`nBits-1:0]    Z;               // Adder, Z
  input                  clock;
  input                  iso;
  input                  reset;

  reg    [31:0]          S_reg; 
  reg  Ovfl_reg; // Result and Overflow registers

  wire   [`nBits:0]      PP15;            // Partial Product 15
  wire   [`nBits:0]      PP14;            // Partial Product 14
  wire   [`nBits:0]      PP13;            // Partial Product 13
  wire   [`nBits:0]      PP12;            // Partial Product 12
  wire   [`nBits:0]      PP11;            // Partial Product 11
  wire   [`nBits:0]      PP10;            // Partial Product 10
  wire   [`nBits:0]      PP9;             // Partial Product 9
  wire   [`nBits:0]      PP8;             // Partial Product 8
  wire   [`nBits:0]      PP7;             // Partial Product 7
  wire   [`nBits:0]      PP6;             // Partial Product 6
  wire   [`nBits:0]      PP5;             // Partial Product 5
  wire   [`nBits:0]      PP4;             // Partial Product 4
  wire   [`nBits:0]      PP3;             // Partial Product 3
  wire   [`nBits:0]      PP2;             // Partial Product 2
  wire   [`nBits:0]      PP1;             // Partial Product 1
  wire   [`nBits:0]      PP0;             // Partial Product 0
 
  // Generate Partial Products
  //
  GenPP_32Bits  GENPP(PP15,PP14,PP13,PP12,PP11,PP10,PP9,PP8,
                      PP7,PP6,PP5,PP4,PP3,PP2,PP1,PP0,X,Y,iso);
  
  // Add Partial Products
  //
  wire                  overflow;         // Overflow
  wire   [`nBits-1:0]   result;           // Product X * Y + Z
  PP_Add_32Bits  ADDPP(overflow,result,PP15,PP14,PP13,PP12,PP11,PP10,PP9,PP8,
                      PP7,PP6,PP5,PP4,PP3,PP2,PP1,PP0,Y,Z);
  
  // Drive the registers to the module outputs
  //
  assign Product = S_reg;
  assign Ovfl = Ovfl_reg;
 
  // CLOCKED:  Load GPR Registers and A, B & C Registers
  //
 
  // synopsys sync_set_reset "reset"
  always @ (posedge clock)
    begin
      if (reset) 
        begin
        S_reg = result;
        Ovfl_reg = overflow;
        end
      else 
        begin
        S_reg = 32'b0;
        Ovfl_reg = 1'b0;
        end
    end
endmodule
