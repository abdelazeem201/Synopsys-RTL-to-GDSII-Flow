// Description: N Bit Carry Save Adder
// Details:
//
//   N Bit Slice of 4 to 2 Carry Save Adder
//
//      S1[i]   = W[i] xor X[i] xor Y[i]
//      C1[i+1] = W[i]X[i] or W[i]Y[i] or X[i]Y[i]
//      S[i]    = S1[i] xor C1[i] xor Z[i]
//      Cout    = S1[i]C1[i] or S1[i]Z[i] or C1[i]Z[i]
//
module CSA_nBits(S,C,Ovfl,W,X,Y,Z,Cin);

  parameter width = 16 ;                        // Bit Width

  output [width-1:0]   S,C;                     // Sum, Carry
  output               Ovfl;                    // Carry Out
  input  [width-1:0]   W,X,Y,Z;                 // Adder Inputs
  input                Cin;                     // Carry In

  wire [width:0]    S1 = {1'b0, W ^ X ^ Y };
  wire [width:0]    C1 = { W&X | W&Y | X&Y, Cin } ;
  wire [width:0]    Z1 = { 1'b0, Z };

  wire [width:0]    S2 = S1 ^ C1 ^ Z;
  wire [width+1:0]  C2 = { S1&C1 | S1&Z | C1&Z , 1'b0 } ;

  assign S[width-1:0]  = S2[width-1:0];
  assign C[width-1:0]  = C2[width-1:0];
  assign Ovfl          = C2[width+1] | C2[width] | S2[width] ;

endmodule
