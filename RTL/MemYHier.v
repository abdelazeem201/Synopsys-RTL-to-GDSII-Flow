
//`define testing_only 

module MemYHier ( memY_dataout, common_address, B, A, clock, notWrtEnbY, WrtEnbY );
  output [63:0] memY_dataout;
  wire [31:0] a;
  wire [31:0] b;
  input [7:0] common_address;
  input [31:0] B;
  input [31:0] A;
  input clock, notWrtEnbY, WrtEnbY;


  wire [7:0] common_address_int;
  wire [31:0] A_int;
  wire [31:0] B_int;
  wire clock_int, notWrtEnbY_int, WrtEnbY_int;

  SAEDRVT14_BUF_4 clock_cell (.A(clock), .X(clock_int) );
  SAEDRVT14_BUF_4 notWrtEnbY_cell (.A(notWrtEnbY), .X(notWrtEnbY_int) );
  SAEDRVT14_BUF_4 WrtEnbY_cell (.A(WrtEnbY), .X(WrtEnbY_int) );

  SAEDRVT14_BUF_4 common_address0  (.A(common_address[0]), .X(common_address_int[0]) );
  SAEDRVT14_BUF_4 common_address1  (.A(common_address[1]), .X(common_address_int[1]) );
  SAEDRVT14_BUF_4 common_address2  (.A(common_address[2]), .X(common_address_int[2]) );
  SAEDRVT14_BUF_4 common_address3  (.A(common_address[3]), .X(common_address_int[3]) );
  SAEDRVT14_BUF_4 common_address4  (.A(common_address[4]), .X(common_address_int[4]) );
  SAEDRVT14_BUF_4 common_address5  (.A(common_address[5]), .X(common_address_int[5]) );
  SAEDRVT14_BUF_4 common_address6  (.A(common_address[6]), .X(common_address_int[6]) );
  SAEDRVT14_BUF_4 common_address7  (.A(common_address[7]), .X(common_address_int[7]) );

  SAEDRVT14_BUF_4 A0  (.A(A[0]), .X(A_int[0]) );
  SAEDRVT14_BUF_4 A1  (.A(A[1]), .X(A_int[1]) );
  SAEDRVT14_BUF_4 A2  (.A(A[2]), .X(A_int[2]) );
  SAEDRVT14_BUF_4 A3  (.A(A[3]), .X(A_int[3]) );
  SAEDRVT14_BUF_4 A4  (.A(A[4]), .X(A_int[4]) );
  SAEDRVT14_BUF_4 A5  (.A(A[5]), .X(A_int[5]) );
  SAEDRVT14_BUF_4 A6  (.A(A[6]), .X(A_int[6]) );
  SAEDRVT14_BUF_4 A7  (.A(A[7]), .X(A_int[7]) );
  SAEDRVT14_BUF_4 A8  (.A(A[8]), .X(A_int[8]) );
  SAEDRVT14_BUF_4 A9  (.A(A[9]), .X(A_int[9]) );
  SAEDRVT14_BUF_4 A10  (.A(A[10]), .X(A_int[10]) );
  SAEDRVT14_BUF_4 A11  (.A(A[11]), .X(A_int[11]) );
  SAEDRVT14_BUF_4 A12  (.A(A[12]), .X(A_int[12]) );
  SAEDRVT14_BUF_4 A13  (.A(A[13]), .X(A_int[13]) );
  SAEDRVT14_BUF_4 A14  (.A(A[14]), .X(A_int[14]) );
  SAEDRVT14_BUF_4 A15  (.A(A[15]), .X(A_int[15]) );
  SAEDRVT14_BUF_4 A16  (.A(A[16]), .X(A_int[16]) );
  SAEDRVT14_BUF_4 A17  (.A(A[17]), .X(A_int[17]) );
  SAEDRVT14_BUF_4 A18  (.A(A[18]), .X(A_int[18]) );
  SAEDRVT14_BUF_4 A19  (.A(A[19]), .X(A_int[19]) );
  SAEDRVT14_BUF_4 A20  (.A(A[20]), .X(A_int[20]) );
  SAEDRVT14_BUF_4 A21  (.A(A[21]), .X(A_int[21]) );
  SAEDRVT14_BUF_4 A22  (.A(A[22]), .X(A_int[22]) );
  SAEDRVT14_BUF_4 A23  (.A(A[23]), .X(A_int[23]) );
  SAEDRVT14_BUF_4 A24  (.A(A[24]), .X(A_int[24]) );
  SAEDRVT14_BUF_4 A25  (.A(A[25]), .X(A_int[25]) );
  SAEDRVT14_BUF_4 A26  (.A(A[26]), .X(A_int[26]) );
  SAEDRVT14_BUF_4 A27  (.A(A[27]), .X(A_int[27]) );
  SAEDRVT14_BUF_4 A28  (.A(A[28]), .X(A_int[28]) );
  SAEDRVT14_BUF_4 A29  (.A(A[29]), .X(A_int[29]) );
  SAEDRVT14_BUF_4 A30  (.A(A[30]), .X(A_int[30]) );
  SAEDRVT14_BUF_4 A31  (.A(A[31]), .X(A_int[31]) );

  SAEDRVT14_BUF_4 B0  (.A(B[0]), .X(B_int[0]) );
  SAEDRVT14_BUF_4 B1  (.A(B[1]), .X(B_int[1]) );
  SAEDRVT14_BUF_4 B2  (.A(B[2]), .X(B_int[2]) );
  SAEDRVT14_BUF_4 B3  (.A(B[3]), .X(B_int[3]) );
  SAEDRVT14_BUF_4 B4  (.A(B[4]), .X(B_int[4]) );
  SAEDRVT14_BUF_4 B5  (.A(B[5]), .X(B_int[5]) );
  SAEDRVT14_BUF_4 B6  (.A(B[6]), .X(B_int[6]) );
  SAEDRVT14_BUF_4 B7  (.A(B[7]), .X(B_int[7]) );
  SAEDRVT14_BUF_4 B8  (.A(B[8]), .X(B_int[8]) );
  SAEDRVT14_BUF_4 B9  (.A(B[9]), .X(B_int[9]) );
  SAEDRVT14_BUF_4 B10  (.A(B[10]), .X(B_int[10]) );
  SAEDRVT14_BUF_4 B11  (.A(B[11]), .X(B_int[11]) );
  SAEDRVT14_BUF_4 B12  (.A(B[12]), .X(B_int[12]) );
  SAEDRVT14_BUF_4 B13  (.A(B[13]), .X(B_int[13]) );
  SAEDRVT14_BUF_4 B14  (.A(B[14]), .X(B_int[14]) );
  SAEDRVT14_BUF_4 B15  (.A(B[15]), .X(B_int[15]) );
  SAEDRVT14_BUF_4 B16  (.A(B[16]), .X(B_int[16]) );
  SAEDRVT14_BUF_4 B17  (.A(B[17]), .X(B_int[17]) );
  SAEDRVT14_BUF_4 B18  (.A(B[18]), .X(B_int[18]) );
  SAEDRVT14_BUF_4 B19  (.A(B[19]), .X(B_int[19]) );
  SAEDRVT14_BUF_4 B20  (.A(B[20]), .X(B_int[20]) );
  SAEDRVT14_BUF_4 B21  (.A(B[21]), .X(B_int[21]) );
  SAEDRVT14_BUF_4 B22  (.A(B[22]), .X(B_int[22]) );
  SAEDRVT14_BUF_4 B23  (.A(B[23]), .X(B_int[23]) );
  SAEDRVT14_BUF_4 B24  (.A(B[24]), .X(B_int[24]) );
  SAEDRVT14_BUF_4 B25  (.A(B[25]), .X(B_int[25]) );
  SAEDRVT14_BUF_4 B26  (.A(B[26]), .X(B_int[26]) );
  SAEDRVT14_BUF_4 B27  (.A(B[27]), .X(B_int[27]) );
  SAEDRVT14_BUF_4 B28  (.A(B[28]), .X(B_int[28]) );
  SAEDRVT14_BUF_4 B29  (.A(B[29]), .X(B_int[29]) );
  SAEDRVT14_BUF_4 B30  (.A(B[30]), .X(B_int[30]) );
  SAEDRVT14_BUF_4 B31  (.A(B[31]), .X(B_int[31]) );

`ifdef testing_only
  always @(  posedge clock) begin
//$display ($time,,, "  MEMY : read=%b,write=%b, Address=%h, data_in=%h,data_out=%h",notWrtEnbY,WrtEnbY,common_address,{A,B},memY_dataout);
      if (WrtEnbY== 1'b1) begin
//$display ("                      ",$time ,,,"     Wrote MEMY at %h , the data %h", common_address,{A,B});
      end
      if (notWrtEnbY== 1'b1) begin
//$display ("                      ",$time ,,,"        Read MEMY at %h , the data %h", common_address,memY_dataout);
      end
   end
`endif

assign memY_dataout = {a,b};

SRAMLP1RW256x32 MemXa (
         .A(common_address_int),
         .I(A),
         .WEB(WrtEnbY_int),
         .CSB(1'b1),
         .OEB(1'b1),
         .CE(clock_int),
         .O(a)) ;

SRAMLP1RW256x32 MemXb (
         .A(common_address_int),
         .I(B),
         .WEB(WrtEnbY_int),
         .CSB(1'b1),
         .OEB(1'b1),
         .CE(clock_int),
         .O(b)) ;
endmodule
