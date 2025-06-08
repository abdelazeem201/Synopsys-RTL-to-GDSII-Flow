module MemXHier ( memX_dataout, common_address, Product, C, clock, notWrtEnbX, WrtEnbX );
  output [63:0] memX_dataout;
  wire [31:0] a;
  wire [31:0] b;
  input [7:0] common_address;
  input [31:0] Product;
  input [31:0] C; 
  input clock, notWrtEnbX, WrtEnbX;
	
  wire [7:0] common_address_int;
  wire [31:0] Product_int;
  wire [31:0] C_int;
  wire clock_int, notWrtEnbX_int, WrtEnbX_int;

// Temporary hack to make verification pass
// Add buffers on the input nets of macro
  SAEDRVT14_BUF_4 clock_cell (.A(clock), .X(clock_int) );
  SAEDRVT14_BUF_4 notWrtEnbX_cell (.A(notWrtEnbX), .X(notWrtEnbX_int) );
  SAEDRVT14_BUF_4 WrtEnbX_cell (.A(WrtEnbX), .X(WrtEnbX_int) );


  SAEDRVT14_BUF_4 common_address0  (.A(common_address[0]), .X(common_address_int[0]) );
  SAEDRVT14_BUF_4 common_address1  (.A(common_address[1]), .X(common_address_int[1]) );
  SAEDRVT14_BUF_4 common_address2  (.A(common_address[2]), .X(common_address_int[2]) );
  SAEDRVT14_BUF_4 common_address3  (.A(common_address[3]), .X(common_address_int[3]) );
  SAEDRVT14_BUF_4 common_address4  (.A(common_address[4]), .X(common_address_int[4]) );
  SAEDRVT14_BUF_4 common_address5  (.A(common_address[5]), .X(common_address_int[5]) );
  SAEDRVT14_BUF_4 common_address6  (.A(common_address[6]), .X(common_address_int[6]) );
  SAEDRVT14_BUF_4 common_address7  (.A(common_address[7]), .X(common_address_int[7]) );

  SAEDRVT14_BUF_4 Prod0  (.A(Product[0]), .X(Product_int[0]) );
  SAEDRVT14_BUF_4 Prod1  (.A(Product[1]), .X(Product_int[1]) );
  SAEDRVT14_BUF_4 Prod2  (.A(Product[2]), .X(Product_int[2]) );
  SAEDRVT14_BUF_4 Prod3  (.A(Product[3]), .X(Product_int[3]) );
  SAEDRVT14_BUF_4 Prod4  (.A(Product[4]), .X(Product_int[4]) );
  SAEDRVT14_BUF_4 Prod5  (.A(Product[5]), .X(Product_int[5]) );
  SAEDRVT14_BUF_4 Prod6  (.A(Product[6]), .X(Product_int[6]) );
  SAEDRVT14_BUF_4 Prod7  (.A(Product[7]), .X(Product_int[7]) );
  SAEDRVT14_BUF_4 Prod8  (.A(Product[8]), .X(Product_int[8]) );
  SAEDRVT14_BUF_4 Prod9  (.A(Product[9]), .X(Product_int[9]) );
  SAEDRVT14_BUF_4 Prod10  (.A(Product[10]), .X(Product_int[10]) );
  SAEDRVT14_BUF_4 Prod11  (.A(Product[11]), .X(Product_int[11]) );
  SAEDRVT14_BUF_4 Prod12  (.A(Product[12]), .X(Product_int[12]) );
  SAEDRVT14_BUF_4 Prod13  (.A(Product[13]), .X(Product_int[13]) );
  SAEDRVT14_BUF_4 Prod14  (.A(Product[14]), .X(Product_int[14]) );
  SAEDRVT14_BUF_4 Prod15  (.A(Product[15]), .X(Product_int[15]) );
  SAEDRVT14_BUF_4 Prod16  (.A(Product[16]), .X(Product_int[16]) );
  SAEDRVT14_BUF_4 Prod17  (.A(Product[17]), .X(Product_int[17]) );
  SAEDRVT14_BUF_4 Prod18  (.A(Product[18]), .X(Product_int[18]) );
  SAEDRVT14_BUF_4 Prod19  (.A(Product[19]), .X(Product_int[19]) );
  SAEDRVT14_BUF_4 Prod20  (.A(Product[20]), .X(Product_int[20]) );
  SAEDRVT14_BUF_4 Prod21  (.A(Product[21]), .X(Product_int[21]) );
  SAEDRVT14_BUF_4 Prod22  (.A(Product[22]), .X(Product_int[22]) );
  SAEDRVT14_BUF_4 Prod23  (.A(Product[23]), .X(Product_int[23]) );
  SAEDRVT14_BUF_4 Prod24  (.A(Product[24]), .X(Product_int[24]) );
  SAEDRVT14_BUF_4 Prod25  (.A(Product[25]), .X(Product_int[25]) );
  SAEDRVT14_BUF_4 Prod26  (.A(Product[26]), .X(Product_int[26]) );
  SAEDRVT14_BUF_4 Prod27  (.A(Product[27]), .X(Product_int[27]) );
  SAEDRVT14_BUF_4 Prod28  (.A(Product[28]), .X(Product_int[28]) );
  SAEDRVT14_BUF_4 Prod29  (.A(Product[29]), .X(Product_int[29]) );
  SAEDRVT14_BUF_4 Prod30  (.A(Product[30]), .X(Product_int[30]) );
  SAEDRVT14_BUF_4 Prod31  (.A(Product[31]), .X(Product_int[31]) );

  SAEDRVT14_BUF_4 C0  (.A(C[0]), .X(C_int[0]) );
  SAEDRVT14_BUF_4 C1  (.A(C[1]), .X(C_int[1]) );
  SAEDRVT14_BUF_4 C2  (.A(C[2]), .X(C_int[2]) );
  SAEDRVT14_BUF_4 C3  (.A(C[3]), .X(C_int[3]) );
  SAEDRVT14_BUF_4 C4  (.A(C[4]), .X(C_int[4]) );
  SAEDRVT14_BUF_4 C5  (.A(C[5]), .X(C_int[5]) );
  SAEDRVT14_BUF_4 C6  (.A(C[6]), .X(C_int[6]) );
  SAEDRVT14_BUF_4 C7  (.A(C[7]), .X(C_int[7]) );
  SAEDRVT14_BUF_4 C8  (.A(C[8]), .X(C_int[8]) );
  SAEDRVT14_BUF_4 C9  (.A(C[9]), .X(C_int[9]) );
  SAEDRVT14_BUF_4 C10  (.A(C[10]), .X(C_int[10]) );
  SAEDRVT14_BUF_4 C11  (.A(C[11]), .X(C_int[11]) );
  SAEDRVT14_BUF_4 C12  (.A(C[12]), .X(C_int[12]) );
  SAEDRVT14_BUF_4 C13  (.A(C[13]), .X(C_int[13]) );
  SAEDRVT14_BUF_4 C14  (.A(C[14]), .X(C_int[14]) );
  SAEDRVT14_BUF_4 C15  (.A(C[15]), .X(C_int[15]) );
  SAEDRVT14_BUF_4 C16  (.A(C[16]), .X(C_int[16]) );
  SAEDRVT14_BUF_4 C17  (.A(C[17]), .X(C_int[17]) );
  SAEDRVT14_BUF_4 C18  (.A(C[18]), .X(C_int[18]) );
  SAEDRVT14_BUF_4 C19  (.A(C[19]), .X(C_int[19]) );
  SAEDRVT14_BUF_4 C20  (.A(C[20]), .X(C_int[20]) );
  SAEDRVT14_BUF_4 C21  (.A(C[21]), .X(C_int[21]) );
  SAEDRVT14_BUF_4 C22  (.A(C[22]), .X(C_int[22]) );
  SAEDRVT14_BUF_4 C23  (.A(C[23]), .X(C_int[23]) );
  SAEDRVT14_BUF_4 C24  (.A(C[24]), .X(C_int[24]) );
  SAEDRVT14_BUF_4 C25  (.A(C[25]), .X(C_int[25]) );
  SAEDRVT14_BUF_4 C26  (.A(C[26]), .X(C_int[26]) );
  SAEDRVT14_BUF_4 C27  (.A(C[27]), .X(C_int[27]) );
  SAEDRVT14_BUF_4 C28  (.A(C[28]), .X(C_int[28]) );
  SAEDRVT14_BUF_4 C29  (.A(C[29]), .X(C_int[29]) );
  SAEDRVT14_BUF_4 C30  (.A(C[30]), .X(C_int[30]) );
  SAEDRVT14_BUF_4 C31  (.A(C[31]), .X(C_int[31]) );


  always @(  posedge clock ) begin
      //$display ($time,,, "    MEMX : read=%b,write=%b, Address=%h, data_in=%h,data_out=%h",notWrtEnbX,WrtEnbX,common_address,{Product,C},memX_dataout);
      if (WrtEnbX== 1'b1) begin 
        $display ($time ,,," Wrote MEMX at %h , the data %h ", common_address,{Product,C});
      end
      if (notWrtEnbX== 1'b1) begin
          $display ($time ,,,"    Reading MEMX at %h , the data %h ", common_address,memX_dataout);
      end
   end
assign memX_dataout = {a,b};

SRAMLP1RW256x32 MemXa (
         .A(common_address_int),
         .I(Product_int),
         .WEB(WrtEnbX_int),
         .CSB(1'b1),
         .OEB(1'b1),
         .CE(clock_int),
         .O(a)) ;

SRAMLP1RW256x32 MemXb (
         .A(common_address_int),
         .I(C_int),
         .WEB(WrtEnbX_int),
         .CSB(1'b1),
         .OEB(1'b1),
         .CE(clock_int),
         .O(b)) ;


endmodule
