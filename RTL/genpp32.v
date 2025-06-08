//   Generate Partial Products for 32 x 32 Multiplier using  Radix 4 Booth
//   Recoding (8 Bit Signed Operands) & Partial Product Generation
//
module GenPP_32Bits(PP15,PP14,PP13,PP12,PP11,PP10,PP9,PP8,
                    PP7,PP6,PP5,PP4,PP3,PP2,PP1,PP0,iso_X,iso_Y,iso_in);
  `define nBits 32

  output [`nBits:0]      PP15;                   // Partial Product 15
  output [`nBits:0]      PP14;                   // Partial Product 14
  output [`nBits:0]      PP13;                   // Partial Product 13
  output [`nBits:0]      PP12;                   // Partial Product 12
  output [`nBits:0]      PP11;                   // Partial Product 11
  output [`nBits:0]      PP10;                   // Partial Product 10
  output [`nBits:0]      PP9;                    // Partial Product 9
  output [`nBits:0]      PP8;                    // Partial Product 8
  output [`nBits:0]      PP7;                    // Partial Product 7
  output [`nBits:0]      PP6;                    // Partial Product 6
  output [`nBits:0]      PP5;                    // Partial Product 5
  output [`nBits:0]      PP4;                    // Partial Product 4
  output [`nBits:0]      PP3;                    // Partial Product 3
  output [`nBits:0]      PP2;                    // Partial Product 2
  output [`nBits:0]      PP1;                    // Partial Product 1
  output [`nBits:0]      PP0;                    // Partial Product 0
  input  [`nBits-1:0]    iso_X;                      // Mulitiplicand, X
  input  [`nBits-1:0]    iso_Y;                      // Mulitiplier, Y

  input                iso_in;
  wire                 iso_in_N;
  wire [`nBits-1:0]    X;
  wire [`nBits-1:0]    Y;

  // Booth recoding requires dividing the multiplier into overlapping segments
  // which are 3 bits in lenth. The segments are defined using the rules below:
  //
  //     Multiplier Y = Yn-1 Yn-2 .... Y2 Y1 Y0 , where n = Mulitplier width
  //
  //     Signed Multiplier (2's complement form):
  //
  //       Seg 0       = Y1, Y0, 0
  //       Seg j       = Yi+1, Yi, Yi-1         For j = 1 to (n/2)-1, i=2*j
  //       Seg n/2     = Yn-1, Yn-1, Yn-2  -->  For Odd n
  //       Seg n/2     = Yn-1, Yn-2, Yn-3  -->  For Even n
  //
  //     Unsigned Multiplier:
  //
  //       Seg 0       = Y1, Y0, 0
  //       Seg j       = Yi+1, Yi, Yi-1         For j = 1 to (n/2)-1, i=2*j
  //       Seg n/2     = 0, Yn-1, Yn-2     -->  For Odd n
  //       Seg n/2     = Yn-1, Yn-2, Yn-3  -->  For Even n
  //       Seg (n/2)+1 = 0, 0, Yn-1        -->  For Even n
  //
  wire [2:0] Seg15 = Y[31:29];           // Segment 15
  wire [2:0] Seg14 = Y[29:27];           // Segment 14
  wire [2:0] Seg13 = Y[27:25];           // Segment 13
  wire [2:0] Seg12 = Y[25:23];           // Segment 12
  wire [2:0] Seg11 = Y[23:21];           // Segment 11
  wire [2:0] Seg10 = Y[21:19];           // Segment 10
  wire [2:0] Seg9  = Y[19:17];           // Segment 9
  wire [2:0] Seg8  = Y[17:15];           // Segment 8
  wire [2:0] Seg7  = Y[15:13];           // Segment 7
  wire [2:0] Seg6  = Y[13:11];           // Segment 6
  wire [2:0] Seg5  = Y[11:9];            // Segment 5
  wire [2:0] Seg4  = Y[9:7];             // Segment 4
  wire [2:0] Seg3  = Y[7:5];             // Segment 3
  wire [2:0] Seg2  = Y[5:3];             // Segment 2
  wire [2:0] Seg1  = Y[3:1];             // Segment 1
  wire [2:0] Seg0  = {Y[1:0], 1'b0};     // Segment 0

  assign X = iso_X;
  assign Y = iso_Y;

  assign PP15[`nBits:0] = BoothDecode(Seg15[2:0],X[`nBits-1:0]);
  assign PP14[`nBits:0] = BoothDecode(Seg14[2:0],X[`nBits-1:0]);
  assign PP13[`nBits:0] = BoothDecode(Seg13[2:0],X[`nBits-1:0]);
  assign PP12[`nBits:0] = BoothDecode(Seg12[2:0],X[`nBits-1:0]);
  assign PP11[`nBits:0] = BoothDecode(Seg11[2:0],X[`nBits-1:0]);
  assign PP10[`nBits:0] = BoothDecode(Seg10[2:0],X[`nBits-1:0]);
  assign PP9[`nBits:0] = BoothDecode(Seg9[2:0],X[`nBits-1:0]);
  assign PP8[`nBits:0] = BoothDecode(Seg8[2:0],X[`nBits-1:0]);
  assign PP7[`nBits:0] = BoothDecode(Seg7[2:0],X[`nBits-1:0]);
  assign PP6[`nBits:0] = BoothDecode(Seg6[2:0],X[`nBits-1:0]);
  assign PP5[`nBits:0] = BoothDecode(Seg5[2:0],X[`nBits-1:0]);
  assign PP4[`nBits:0] = BoothDecode(Seg4[2:0],X[`nBits-1:0]);
  assign PP3[`nBits:0] = BoothDecode(Seg3[2:0],X[`nBits-1:0]);
  assign PP2[`nBits:0] = BoothDecode(Seg2[2:0],X[`nBits-1:0]);
  assign PP1[`nBits:0] = BoothDecode(Seg1[2:0],X[`nBits-1:0]);
  assign PP0[`nBits:0] = BoothDecode(Seg0[2:0],X[`nBits-1:0]);

  // FUNCTION: BoothDecode - Use Booth Encoding to generate partial products.
  //
  // Yi+1| Yi |Yi-1|          Description                             |Action
  // ----+----+----+--------------------------------------------------+--------
  //   0 |  0 |  0 |Add Zero (No String)                              |  +0
  //   0 |  0 |  1 |Add Multiplicand (End of String)                  |  +X
  //   0 |  1 |  0 |Add Multiplicand (String of one)                  |  +X
  //   0 |  1 |  1 |Add Twice the Multiplicand (End of String)        | +2X
  //   1 |  0 |  0 |Substract Twice the Multiplicand (Start of string)| -2X
  //   1 |  0 |  1 |Substract the Multiplicand (-2X +X)               |  -X
  //   1 |  1 |  0 |Substract the Multiplicand (Start of string)      |  -X
  //   1 |  1 |  1 |Substract Zero (Center of String)                 |  -0
  //
  function [`nBits:0] BoothDecode;
    input [2:0] Segment;
    input [`nBits:0] X;
    case ( Segment[2:0] )
         3'b000  :  BoothDecode = 33'h000000000;                    // + Zero
         3'b001,
         3'b010  :  BoothDecode = { X[`nBits-1], X[`nBits-1:0] }  ; // +X
         3'b011  :  BoothDecode = { X[`nBits-1:0], 1'b0  }  ;       // +2X
         3'b100  :  BoothDecode = { ~X[`nBits-1:0], 1'b1  }  ;      // -2X
         3'b101,
         3'b110  :  BoothDecode = { ~X[`nBits-1], ~X[`nBits-1:0] } ;// -X
         3'b111  :  BoothDecode = 33'h1FFFFFFFF;                    // - Zero
    endcase
  endfunction
endmodule
