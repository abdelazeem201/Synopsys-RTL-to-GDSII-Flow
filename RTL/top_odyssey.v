// Modified By Godwin on 12/11/2007 
// Added 2 macros
// Added Power Controller
// Added Address Mux
// Added Extra Multiplier

module ChipTop (MemWriteBus, MemWriteValid, MemReadBus, clock, reset,power_ack,MemOverflow);

   input  [31:0]     MemReadBus;             // Memory Read Bus
   output [63:0]     MemWriteBus;            // Memory Write Bus
   output 	     MemWriteValid,power_ack,MemOverflow;      // Memory Write Bus Contains Data
   input             clock,reset;                  // System Clock

   wire 	     inst_sd;                // switch 
   wire 	     inst_iso;            // iso
   wire 	     inst_reset;
   wire 	     inst_save;
   wire 	     inst_restore;

   wire 	     gprs_sd;                // switch 
   wire 	     gprs_iso;            // iso
   wire 	     gprs_reset;
   wire 	     gprs_save;
   wire 	     gprs_restore;
  
   wire 	     mult_iso;            // iso
   wire 	     mult_sd;                // switch 

   wire 	     memx_iso;            // iso
   wire 	     memx_sd;                // switch 

   wire 	     memy_iso;            // iso
   wire 	     memy_sd;                // switch 
   wire		     power_ack;

   wire genpp_on;
   wire genpp_ack;

   wire   [31:0]     MemReadBus;             // Memory Read Bus
   wire   [63:0]     MemWriteBus;            // Memory Write Bus
   wire 	     MemWriteValid;          // Memory Write Bus Contains Data
   wire   [31:0]     A, B, C;                // Data Buses
   wire   [3:0]      RdAdrA, RdAdrB, RdAdrC; // Read Addresses
   wire   [3:0]      WrtAdrX, WrtAdrY;       // Write Address
   wire              WrtEnbX, WrtEnbY;       // Write Enables
   wire   [31:0]     Product;                // Multiplier output
   wire 	     Ovfl;                   // Multiplier Overflow

   
   wire mult_reset;
//   assign mult_reset = 1'b0;
             
   wire    GENPP_ao = 1'b1;

// Wires added for the new modules /////////////////////////


wire [63:0] memX_dataout,memY_dataout;
wire [7:0] common_address;


//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Instruction Decoder 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
InstructionDecoder InstDecode(
                    .InstBus(MemReadBus),
                    .RdAdrA(RdAdrA),
                    .RdAdrB(RdAdrB),
                    .RdAdrC(RdAdrC),
                    .WrtAdrX(WrtAdrX),
                    .WrtEnbX(WrtEnbX),
                    .WrtAdrY(WrtAdrY),
                    .WrtEnbY(WrtEnbY),
                    .MemWriteValid(MemWriteValid), 
                    .clock(clock), 
                    .reset(reset|inst_reset));
   
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 16 General Purpose Registers
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GeneralPurposeRegisters  GPRs(
                          .A(A),
                          .B(B),
                          .C(C),
                          .RdAdrA(RdAdrA),
                          .RdAdrB(RdAdrB),
                          .RdAdrC(RdAdrC),
                          .WrtAdrX(WrtAdrX),
                          .WrtEnbX(WrtEnbX),
                          .WrtAdrY(WrtAdrY),
                          .WrtEnbY(WrtEnbY),
                          .X(MemReadBus),
                          .Y(Product),
                          .clock(clock), 
                          .reset(reset)); 
   

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 32 x 32 Signed Multiplier
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Mult_32x32 Multiplier(
            .Ovfl(Ovfl),
	    .Product(Product),
	    .X(A),
	    .Y(B),
	    .Z(C),
	    .clock(clock),
	    .iso(mult_iso), 
	    .reset(reset|mult_reset));


//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Power Controller
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


power_controller PwrCtrl (
	         .clock(clock),
                 .reset(reset),
                 .MemReadBus(MemReadBus[31:24]),
                 .gprs_iso(gprs_iso),
                 .mult_iso(mult_iso),
                 .memx_iso(memx_iso),
                 .memy_iso(memy_iso),
                 .inst_iso(inst_iso),
                 .gprs_save(gprs_save),
                 .gprs_restore(gprs_restore),
                 .gprs_reset(gprs_reset),
                 .inst_save(inst_save),
                 .inst_restore(inst_restore),
                 .inst_reset(inst_reset),
                 .mult_reset(mult_reset),
                 .gprs_sd(gprs_sd),
                 .mult_sd(mult_sd),
                 .inst_sd(inst_sd),
                 .memx_sd(memx_sd),
                 .memy_sd(memy_sd),
                 .power_ack(power_ack));

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Address generator for X and Y RAM's
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

address_gen_add AddressGen (
             .read_addressX(RdAdrA),
             .read_addressY(RdAdrB),
             .write_addressX(WrtAdrX),
             .write_addressY(WrtAdrY),
             .write_X_enable(WrtEnbX), 
             .write_Y_enable(WrtEnbY),
	     .memX_datain(memX_dataout),
	     .memY_datain(memY_dataout),
             .common_address(common_address),
	     .MemWriteBus(MemWriteBus),
             .MemOverflow(MemOverflow));

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Memory X
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


wire notWrtEnbX = ~WrtEnbX;

MemXHier MemXHier ( .memX_dataout(memX_dataout), .common_address(common_address),
	.Product(Product), .C(C), .clock(clock), .notWrtEnbX(notWrtEnbX),
	.WrtEnbX(WrtEnbX) );

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Memory Y
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wire notWrtEnbY = ~WrtEnbY;

MemYHier MemYHier ( .memY_dataout(memY_dataout), .common_address(common_address),
	.B(B), .A(A), .clock(clock), .notWrtEnbY(notWrtEnbY), .WrtEnbY(WrtEnbY) );

endmodule

