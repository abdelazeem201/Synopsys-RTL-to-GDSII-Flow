// Description: Test Part Top
// Details:
//
//    Instructions:
//
//           31:24   23:20 19:16 15:12 11:8     7:0            Description
//         --------- ----- ----- ----- ----- ----------    --------------------
//  NOOP  |   30    | RT  |     |     |     |          |    Do Nothing
//  LOAD  |   31    | RT  |     |     |     |          |    Load GPR RT with
//                                                          next word
//  STORE |   32    | RT  |     |     |     |          |    Store GPR RT onto
//                                                          write bus
//  MULT  |   33    | RT  | RA  | RB  |  0  |          |    Load GPR RT with
//                                                          GPR RA * RB
//  ADD   |   34    | RT  | RA  |  0  | RC  |          |    Load GPR RT with
//                                                          GPR RA + RC
//  MULTX |   35    | RT  | RA  | RB  | RC  |          |    Load GPR RT with
//                                                          GPR RA * RB + RC
//  
module InstructionDecoder(InstBus,RdAdrA,RdAdrB,RdAdrC,
                          WrtAdrX,WrtEnbX,WrtAdrY,WrtEnbY,
                          MemWriteValid,clock,reset);
   
   input  [31:0]     InstBus;                // Memory Read Bus
   input             clock;                  // System Clock
   input             reset; 
   
   output   [3:0]    RdAdrA, RdAdrB, RdAdrC; // Read Addresses
   output   [3:0]    WrtAdrX, WrtAdrY;       // Write Address
   output            WrtEnbX, WrtEnbY;       // Write Enables
   output 	     MemWriteValid;          // Memory Write Bus contains Data 

   reg      [31:0]   InstReg;                // Instruction Register    
   reg      [3:0]    DestReg_Dly1;           // Destination Reg Delayed 1
   reg      [3:0]    DestReg_Dly2;           // Destination Reg Delayed 2
   reg               WE_Y_Dly1;              // Write Enable Y Delayed 1
   reg               WE_Y_Dly2;              // Write Enable Y Delayed 2
   reg               WE_X_Dly1;              // Write Enable X Delayed 1
   reg               MemWriteValid;          // Memory Write Bus Contains Data


   // Decode Instruction
   //
   parameter 	     NOOP=8'h30, LOAD=8'h31, STORE=8'h32, MULT=8'h33,
                     ADD=8'h34, MULTX=8'h35;

     wire 	     writeX =   (InstReg[31:24] == LOAD);
     wire 	     writeMem = (InstReg[31:24] == STORE);
     wire 	     writeY =   (InstReg[31:24] == MULT) ||
                                (InstReg[31:24] == ADD)  ||
                                (InstReg[31:24] == MULTX);
   
   
   // Drive registers to the module outputs
   //
   assign WrtAdrY = DestReg_Dly2;
   assign WrtEnbY = WE_Y_Dly2;
   
   assign WrtAdrX = DestReg_Dly1;
   assign WrtEnbX = WE_X_Dly1;
   
   assign RdAdrA = InstReg[19:16];
   assign RdAdrB = InstReg[15:12];
   assign RdAdrC = InstReg[11:8];
   
  always #10 $display ($time,,, "  INSTR : Instruction=%h, RdAdrA=%h, RdAdrB=%h,RdAdrC=%h",InstReg[31:24],RdAdrA,RdAdrB,RdAdrC);
  always #10 $display ($time,,, "  INSTR : Instruction=%h, WrtAdrX=%h, WrtAdrY=%h,WrtEnbX=%b,WrtEnbY=%b",InstReg[31:24],WrtAdrX,WrtAdrY,WrtEnbX,WrtEnbY);

   // CLOCKED:  Load Registers
   //
 
   // synopsys sync_set_reset "reset"
   always @ (posedge clock)
     begin
       if (reset) 
         begin
         InstReg       <= 32'h00000000;
	 DestReg_Dly1  <= 4'h0;
	 DestReg_Dly2  <= 4'h0;
	 WE_Y_Dly1     <= 1'b0;
	 WE_Y_Dly2     <= 1'b0;
	 WE_X_Dly1     <= 1'b0;
	 MemWriteValid <= 1'b0;
         end
       else
         begin
	 InstReg       <= InstBus;
	 DestReg_Dly1  <= InstReg[23:20];
	 DestReg_Dly2  <= DestReg_Dly1;
	 WE_Y_Dly1     <= writeY ;
	 WE_Y_Dly2     <= WE_Y_Dly1;
	 WE_X_Dly1     <= writeX;
	 MemWriteValid <= writeMem;
         end
    end // always @ (posedge clock)
   

   // Turn off signal for multiplier
   //
   wire 	WrtEnbX, WrtEnbY;

endmodule
