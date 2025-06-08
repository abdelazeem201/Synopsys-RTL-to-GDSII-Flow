// Description: General Purpose Registers
//
module GeneralPurposeRegisters(A,B,C,RdAdrA,RdAdrB,RdAdrC,
                               WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,clock,reset);


  output [31:0]     A, B, C;                // A-reg, B-reg, & C-reg outputs

  input  [3:0]      RdAdrA, RdAdrB, RdAdrC; // Read Addresses
  input  [3:0]      WrtAdrX, WrtAdrY;       // Write Address
  input             WrtEnbX, WrtEnbY;       // Write Enables
  input  [31:0]     X, Y;                   // Data Input
  input             clock;
  input             reset;

  wire [31:0]       regIn0, regIn1, regIn2, regIn3;
  wire [31:0]       regIn4, regIn5, regIn6, regIn7;
  wire [31:0]       regIn8, regIn9, regInA, regInB;
  wire [31:0]       regInC, regInD, regInE, regInF;
  wire [31:0]       Data_A, Data_B, Data_C;

  reg  [31:0]       GPR0_reg, GPR1_reg, GPR2_reg, GPR3_reg;
  reg  [31:0]       GPR4_reg, GPR5_reg, GPR6_reg, GPR7_reg;
  reg  [31:0]       GPR8_reg, GPR9_reg, GPRA_reg, GPRB_reg;
  reg  [31:0]       GPRC_reg, GPRD_reg, GPRE_reg, GPRF_reg;
  reg  [31:0]       A_reg, B_reg, C_reg;

  // Write GPRs decode
  //
  assign regIn0 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR0_reg,4'h0);
  assign regIn1 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR1_reg,4'h1);
  assign regIn2 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR2_reg,4'h2);
  assign regIn3 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR3_reg,4'h3);
  assign regIn4 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR4_reg,4'h4);
  assign regIn5 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR5_reg,4'h5);
  assign regIn6 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR6_reg,4'h6);
  assign regIn7 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR7_reg,4'h7);
  assign regIn8 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR8_reg,4'h8);
  assign regIn9 = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPR9_reg,4'h9);
  assign regInA = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRA_reg,4'hA);
  assign regInB = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRB_reg,4'hB);
  assign regInC = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRC_reg,4'hC);
  assign regInD = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRD_reg,4'hD);
  assign regInE = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRE_reg,4'hE);
  assign regInF = GPRdecode(WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,X,Y,GPRF_reg,4'hF);

  // Read GPRs selection
  //
  assign Data_A=Select16(RdAdrA,GPR0_reg,GPR1_reg,GPR2_reg,GPR3_reg,
                                GPR4_reg,GPR5_reg,GPR6_reg,GPR7_reg,
                                GPR8_reg,GPR9_reg,GPRA_reg,GPRB_reg,
                                GPRC_reg,GPRD_reg,GPRE_reg,GPRF_reg);
  assign Data_B=Select16(RdAdrB,GPR0_reg,GPR1_reg,GPR2_reg,GPR3_reg,
                                GPR4_reg,GPR5_reg,GPR6_reg,GPR7_reg,
                                GPR8_reg,GPR9_reg,GPRA_reg,GPRB_reg,
                                GPRC_reg,GPRD_reg,GPRE_reg,GPRF_reg);
  assign Data_C=Select16(RdAdrC,GPR0_reg,GPR1_reg,GPR2_reg,GPR3_reg,
                                GPR4_reg,GPR5_reg,GPR6_reg,GPR7_reg,
                                GPR8_reg,GPR9_reg,GPRA_reg,GPRB_reg,
                                GPRC_reg,GPRD_reg,GPRE_reg,GPRF_reg);

  // Drive the A, B & C registers to the module outputs
  // 
  assign A = A_reg;
  assign B = B_reg;
  assign C = C_reg;

  // CLOCKED:  Load GPR Registers and A, B & C Registers
  //
 
  // synopsys sync_set_reset "reset"
  always @ (posedge clock)
    begin
      if (reset)
        begin
        GPR0_reg = 32'h00000000; GPR1_reg = 32'h00000000;
        GPR2_reg = 32'h00000000; GPR3_reg = 32'h00000000;
        GPR4_reg = 32'h00000000; GPR5_reg = 32'h00000000;
        GPR6_reg = 32'h00000000; GPR7_reg = 32'h00000000;
        GPR8_reg = 32'h00000000; GPR9_reg = 32'h00000000;
        GPRA_reg = 32'h00000000; GPRB_reg = 32'h00000000;
        GPRC_reg = 32'h00000000; GPRD_reg = 32'h00000000;
        GPRE_reg = 32'h00000000; GPRF_reg = 32'h00000000;
        A_reg = 32'h00000000;
        B_reg = 32'h00000000;
        C_reg = 32'h00000000;
        end
      else
        begin
        GPR0_reg = regIn0; GPR1_reg = regIn1;
        GPR2_reg = regIn2; GPR3_reg = regIn3;
        GPR4_reg = regIn4; GPR5_reg = regIn5;
        GPR6_reg = regIn6; GPR7_reg = regIn7;
        GPR8_reg = regIn8; GPR9_reg = regIn9;
        GPRA_reg = regInA; GPRB_reg = regInB;
        GPRC_reg = regInC; GPRD_reg = regInD;
        GPRE_reg = regInE; GPRF_reg = regInF;
        A_reg = Data_A;
        B_reg = Data_B;
        C_reg = Data_C;
        end
    end

  // FUNCTION: Select16 - Generate Data in for GPRs
  //
  function [31:0] Select16;
    input [3:0]  sel;
    input [31:0] d0,d1,d2,d3,d4,d5,d6,d7;
    input [31:0] d8,d9,da,db,dc,dd,de,df;
    case(sel)
      4'h0: Select16=d0;
      4'h1: Select16=d1;
      4'h2: Select16=d2;
      4'h3: Select16=d3;
      4'h4: Select16=d4;
      4'h5: Select16=d5;
      4'h6: Select16=d6;
      4'h7: Select16=d7;
      4'h8: Select16=d8;
      4'h9: Select16=d9;
      4'hA: Select16=da;
      4'hB: Select16=db;
      4'hC: Select16=dc;
      4'hD: Select16=dd;
      4'hE: Select16=de;
      4'hF: Select16=df;
    endcase
  endfunction

  // FUNCTION: GPR Decode - Generate Data in for GPRs
  //
  function [31:0] GPRdecode;
    input [3:0] xaddr;
    input       xenb;
    input [3:0] yaddr;
    input       yenb;
    input [31:0] x;
    input [31:0] y;
    input [31:0] hold;
    input [3:0] gpr;

    if ( (xaddr[3:0] == gpr[3:0]) && (xenb == 1'b1) )
       GPRdecode = x;
    else if ( (yaddr[3:0] == gpr[3:0]) && (yenb == 1'b1) )
       GPRdecode = y;
    else
       GPRdecode = hold;
  endfunction
/* testing only
  always #10 $display ($time,,, "  GPR : X=%h, Adr=%h, E=%b",X,WrtAdrX,WrtEnbX);
  always #10 $display ($time,,, "  GPR : Y=%h, Adr=%h, E=%b",Y,WrtAdrY,WrtEnbY);
  always #10 $display ($time,,, "  GPR : RdA=%h, RdB=%h, RdC=%h",RdAdrA,RdAdrB,RdAdrC);
  always #10 $display ($time,,, "  GPR : in0=%h GPR0=%h",regIn0,GPR0_reg);
  always #10 $display ($time,,, "  GPR : in1=%h GPR1=%h",regIn1,GPR1_reg);
  always #10 $display ($time,,, "  GPR : in2=%h GPR2=%h",regIn2,GPR2_reg);
  always #10 $display ($time,,, "  GPR : in3=%h GPR3=%h",regIn3,GPR3_reg);
  always #10 $display ($time,,, "  GPR : da=%h A=%h",Data_A,A_reg);
  always #10 $display ($time,,, "  GPR : db=%h B=%h",Data_B,B_reg);
  always #10 $display ($time,,, "  GPR : dc=%h C=%h",Data_C,C_reg);
*/
endmodule
