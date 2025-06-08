// Description : Power Controller 
// Author       : Godwin Maben
// Details      : Power Controller is the block, which reads the instruction 
//                and generate appropriate power down signals to various blocks  
//		  This block needs to be Always on, it generates 
//		  sd - shut_down for Switches
//		  save - save for RFF
//		  restore - restore for RFF
//		  iso  - isolation_enable signals for Isolation cell
//		  reset - Reset signal to reset the block after wake-up
// Created on   : 12/11/2007
// ---------------------------------------------------------------


module power_controller(clock,reset,MemReadBus,gprs_iso,mult_iso,memx_iso,memy_iso,inst_iso,
			gprs_save,gprs_restore,gprs_reset,inst_save,inst_restore,inst_reset,mult_reset,
			gprs_sd,mult_sd,inst_sd, memx_sd,memy_sd,power_ack);

`define IDLE 0
`define ASSERT_ISO_ST 1
`define RESTORE_ST 2
`define WAIT_FOR_RESTORE_INST 3
`define RESET 4

parameter      NOOP=8'h30, LOAD=8'h31, STORE=8'h32, MULT=8'h33,
               ADD=8'h34, MULTX=8'h35, WRITE_MEM=8'h36, READ_MEM=8'h37,
               INST_SD=8'h38,GPRS_SD=8'h39, MULT_SD=8'h3A,MEMX_SD=8'h3B, MEMY_SD=8'h3C,RESTORE=8'h3D;

parameter      BIT4=5'b10000, BIT3=5'b01000,BIT2=5'b00100,BIT1=5'b00010,BIT0=5'b00001;



input clock,reset;

input [7:0] MemReadBus;


output gprs_iso,mult_iso,memx_iso,memy_iso,inst_iso,
       gprs_save,gprs_restore,gprs_reset,inst_save,
       inst_restore,inst_reset,gprs_sd,mult_sd,inst_sd,
       memx_sd,memy_sd,power_ack,mult_reset;



reg [2:0] present_state,next_state;

// ------------------------------------------
// BIT4	BIT3	BIT2	BIT1	BIT0
// SAVE	ISO	RESTORE	SD	RESET
// ------------------------------------------
reg [4:0] mult_stat_reg,inst_stat_reg,
	  gprs_stat_reg,memx_stat_reg,
	  memy_stat_reg;
reg [4:0] mult_stat_reg_next,inst_stat_reg_next,
	  gprs_stat_reg_next,memx_stat_reg_next,
	  memy_stat_reg_next;

wire gprs_iso,mult_iso,memx_iso,memy_iso,inst_iso,
    gprs_save,gprs_restore,gprs_reset,inst_save,
    mult_save,mult_restore,mult_reset,
    inst_restore,inst_reset,gprs_sd_inv,gprs_sd,mult_sd,inst_sd,
    memx_sd,memy_sd,memx_restore,memy_restore;

reg power_ack;
reg reset_sd_next;

wire go_to_restore_state;

reg gprs_iso_next_next,mult_iso_next,memx_iso_next,memy_iso_next,inst_iso_next,
    gprs_save_next,gprs_restore_next,gprs_reset_next,inst_save_next,
    inst_restore_next,inst_reset_next,power_ack_next;

wire gprs_iso_inv,mult_sd_inv,memx_sd_inv,memy_sd_inv;

assign gprs_iso = ~gprs_iso_inv;
assign gprs_sd = ~gprs_sd_inv;
assign mult_sd = ~mult_sd_inv;
assign memx_sd = ~memx_sd_inv;
assign memy_sd = ~memy_sd_inv;


// Isolation Set Reset Registers 
srff inst_iso_reg(clock,reset,inst_stat_reg_next[3],inst_stat_reg[2],inst_iso);
srff mult_iso_reg(clock,reset,mult_stat_reg_next[3],mult_stat_reg[2],mult_iso);
srff gprs_iso_reg(clock,reset,gprs_stat_reg_next[3],gprs_stat_reg[2],gprs_iso_inv);
srff memx_iso_reg(clock,reset,memx_stat_reg_next[3],memx_stat_reg[2],memx_iso);
srff memy_iso_reg(clock,reset,memy_stat_reg_next[3],memy_stat_reg[2],memy_iso);

srff inst_save_reg(clock,reset,inst_stat_reg_next[4],inst_stat_reg[3],inst_save);
srff mult_save_reg(clock,reset,mult_stat_reg_next[4],mult_stat_reg[3],mult_save);
srff gprs_save_reg(clock,reset,gprs_stat_reg_next[4],gprs_stat_reg[3],gprs_save);

srff inst_sd_reg(clock,reset,inst_stat_reg_next[1],reset_sd_next,inst_sd);
srff mult_sd_reg(clock,reset,mult_stat_reg_next[1],reset_sd_next,mult_sd_inv);
srff gprs_sd_reg(clock,reset,gprs_stat_reg_next[1],reset_sd_next,gprs_sd_inv);
srff memx_sd_reg(clock,reset,memx_stat_reg_next[1],reset_sd_next,memx_sd_inv);
srff memy_sd_reg(clock,reset,memy_stat_reg_next[1],reset_sd_next,memy_sd_inv);


assign inst_restore = inst_stat_reg[2];
assign gprs_restore = gprs_stat_reg[2];
assign mult_restore = mult_stat_reg[2];
assign memx_restore = memx_stat_reg[2];
assign memy_restore = memy_stat_reg[2];

assign inst_reset = inst_stat_reg[0];
assign gprs_reset = gprs_stat_reg[0];
assign mult_reset = mult_stat_reg[0];

assign go_to_restore_state = (inst_iso | mult_iso | ~gprs_iso_inv | memx_iso | memy_iso);

// synopsys sync_set_reset "reset"
  always @ (posedge clock)
    begin
      //$display("          PWM USER MESSAGE ---->inst_stat_reg_next[1] %b at time ",inst_stat_reg_next[1] ,$time);
      //$display("          PWM USER MESSAGE ---->reset_sd_next %b at time ",reset_sd_next ,$time);
      //$display("          PWM USER MESSAGE ---->inst_sd %b at time ",inst_sd ,$time);
      //$display("          PWM USER MESSAGE ---->inst_stat_reg %b at time ",inst_stat_reg ,$time);
      if (reset)
	begin
		present_state <= 0;
		inst_stat_reg <= 0;
		mult_stat_reg <= 0;
		gprs_stat_reg <= 0;
		memx_stat_reg <= 0;
		memy_stat_reg <= 0;
	end
      else
	begin
      $display("          PWM USER MESSAGE ---->FSM1 gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
		present_state <= next_state;
		inst_stat_reg <= inst_stat_reg_next;
		mult_stat_reg <= mult_stat_reg_next;
		gprs_stat_reg <= gprs_stat_reg_next;
		memx_stat_reg <= memx_stat_reg_next;
		memy_stat_reg <= memy_stat_reg_next;
      $display("          PWM USER MESSAGE ---->FSM1 gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
      $display("          PWM USER MESSAGE ---->FSM1 gprs_stat_reg blocking assign to %b at time ",gprs_stat_reg_next ,$time);

                inst_stat_reg[0] <= inst_stat_reg[2];
                mult_stat_reg[0] <= mult_stat_reg[2];
                gprs_stat_reg[0] <= gprs_stat_reg[2];
                memx_stat_reg[0] <= memx_stat_reg[2];
                memy_stat_reg[0] <= memy_stat_reg[2];

      $display("          PWM USER MESSAGE ---->FSM1 gprs_stat_reg blocking assign to %b at time ",gprs_stat_reg_next ,$time);
		power_ack <= inst_restore|mult_restore|gprs_restore|memx_restore|memy_restore;
                             //$display("          PWM USER MESSAGE ---->present_state %h at time ",present_state ,$time);
                             //$display("          PWM USER MESSAGE ---->inst_stat_reg %b at time ",inst_stat_reg ,$time);
                             //$display("          PWM USER MESSAGE ---->gprs_stat_reg %b at time ",gprs_stat_reg ,$time);
                             //$display("          PWM USER MESSAGE ---->mult_stat_reg %b at time ",mult_stat_reg ,$time);
                             //$display("          PWM USER MESSAGE ---->memx_stat_reg %b at time ",memx_stat_reg ,$time);
                             //$display("          PWM USER MESSAGE ---->memy_stat_reg %b at time ",memy_stat_reg ,$time);
	end
   end
  always @(present_state or MemReadBus or inst_stat_reg or 
           mult_stat_reg or gprs_stat_reg or
           memx_stat_reg or memy_stat_reg or 
           inst_iso or mult_iso or gprs_iso_inv or 
           memx_iso or memy_iso or go_to_restore_state)
        begin
	  next_state = `IDLE;
	  inst_stat_reg_next = 0;
	  mult_stat_reg_next = 0;
	  gprs_stat_reg_next = 0; 
	  memx_stat_reg_next = 0;
	  memy_stat_reg_next = 0;
	  reset_sd_next = 0;
      $display("          PWM USER MESSAGE ---->ENTERING FSM2 gprs_stat_reg_next  assign to %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->Entering FSM2 gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);

	  case(present_state)
                `IDLE:  begin //0
                          if(|MemReadBus == 0)
                                next_state = `IDLE;
                          else
                             begin
                                        //$display("          PWM FSM USER MESSAGE ---->In IDLE state");
                                if(MemReadBus == INST_SD)
                                   begin
                                        //$display("          PWM FSM USER MESSAGE ---->Going to Shutdown INST");
                                        next_state = `ASSERT_ISO_ST;
                                        inst_stat_reg_next[4] = 1'b1;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
                                   end
                                else if(MemReadBus == GPRS_SD)
                                   begin
                                        next_state = `ASSERT_ISO_ST;
                                        gprs_stat_reg_next[4] = 1'b1;
      $display("          PWM USER MESSAGE ---->FSM2 in IDLE GPRS_SD detected , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in IDLE GPRS_SD detected , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
                                   end
                                else if(MemReadBus == MULT_SD)
                                   begin
                                        next_state = `ASSERT_ISO_ST;
                                        mult_stat_reg_next[4] = 1'b1;
                                   end
                                else if(MemReadBus == MEMX_SD)
                                   begin
                                        next_state = `ASSERT_ISO_ST;
                                        memx_stat_reg_next[4] = 1'b1;
                                   end
                                else if(MemReadBus == MEMY_SD)
                                   begin
                                        next_state = `ASSERT_ISO_ST;
                                        memy_stat_reg_next[4] = 1'b1;
                                   end
                                else 
                                   begin
                                     next_state = `IDLE;
                                   end
                             end
                        end
		`ASSERT_ISO_ST:	begin //1
                                        //$display("          PWM FSM USER MESSAGE ---->In ASSERT_ISO_ST state");
				  if(inst_stat_reg == BIT4)
				     begin
					inst_stat_reg_next[3] = 1'b1;
					next_state = `WAIT_FOR_RESTORE_INST;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
				     end
				  if(mult_stat_reg == BIT4)
				     begin
					mult_stat_reg_next[3] = 1'b1;
					next_state = `WAIT_FOR_RESTORE_INST;
				     end
				  if(gprs_stat_reg == BIT4)
				     begin
					gprs_stat_reg_next[3] = 1'b1;
					next_state = `WAIT_FOR_RESTORE_INST;
      $display("          PWM USER MESSAGE ---->FSM2 in ASSERT_ISO_ST ISO asserted , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in ASSERT_ISO_ST ISO asserted , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
				     end
				  if(memx_stat_reg == BIT4)
				     begin
					memx_stat_reg_next[3] = 1'b1;
					next_state = `WAIT_FOR_RESTORE_INST;
				     end
				  if(memy_stat_reg == BIT4)
				     begin
					memy_stat_reg_next[3] = 1'b1;
					next_state = `WAIT_FOR_RESTORE_INST;
				     end
				end
		`WAIT_FOR_RESTORE_INST:begin //3
                                        //$display("          PWM FSM USER MESSAGE ---->In WAIT_FOR_RESTORE_INST state");
                       if(MemReadBus == RESTORE)
                          begin
                                        //$display("          PWM FSM USER MESSAGE ---->changing to RESTORE_ST state");
                                 next_state = `RESTORE_ST;
				 reset_sd_next = 1;
			         gprs_stat_reg_next[1] = 1'b0;
			         inst_stat_reg_next[1] = 1'b0;
			         mult_stat_reg_next[1] = 1'b0;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in WAIT_FOR_RESTORE_INST jumping to RESTORE , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in WAIT_FOR_RESTORE_INST jumping to RESTORE , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);

                          end
                       else
                          begin
			    next_state = `WAIT_FOR_RESTORE_INST;
			    if(gprs_stat_reg[3])gprs_stat_reg_next[1] = 1'b1;
			    if(mult_stat_reg[3])mult_stat_reg_next[1] = 1'b1;
			    if(inst_stat_reg[3])inst_stat_reg_next[1] = 1'b1;
			    if(memx_stat_reg[3])memx_stat_reg_next[1] = 1'b1;
			    if(memy_stat_reg[3])memy_stat_reg_next[1] = 1'b1;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in WAIT_FOR_RESTORE_INST waiting , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in WAIT_FOR_RESTORE_INST waiting , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);

                          end
                   end
		`RESTORE_ST:	begin //2
                                        //$display("          PWM FSM USER MESSAGE ---->In RESTORE_ST state");
				  if(inst_iso) 
				     begin
					inst_stat_reg_next[2]=1'b1;
					next_state=`RESET;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
                                        //$display("          PWM FSM USER MESSAGE ---->changing to RESET state");
				     end
				  if(mult_iso) 
				     begin
					mult_stat_reg_next[2]=1'b1;
					next_state=`RESET;
				     end
				  if(gprs_iso_inv) 
				     begin
					gprs_stat_reg_next[2]=1'b1;
					next_state=`RESET;
      $display("          PWM USER MESSAGE ---->FSM2 in RESTORE going to RESET , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in RESTORE going to RESET , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
				     end
				  if(memx_iso) 
				     begin
					memx_stat_reg_next[2]=1'b1;
					next_state=`RESET;
				     end
				  if(memy_iso) 
				     begin
					memy_stat_reg_next[2]=1'b1;
					next_state=`RESET;
				     end
				end
		`RESET:begin //4
                                        //$display("          PWM FSM USER MESSAGE ---->In RESET state");

                      inst_stat_reg_next[2]=1'b0;
                      mult_stat_reg_next[2]=1'b0;
                      gprs_stat_reg_next[2]=1'b0;
                      memx_stat_reg_next[2]=1'b0;
                      memy_stat_reg_next[2]=1'b0;
		      next_state=`IDLE;
					//$display("          PWM FSM USER MESSAGE ---->inst_stat_reg_next %b at time ",inst_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in RESET  going to IDLE , gprs_stat_reg_next is %b at time ",gprs_stat_reg_next ,$time);
      $display("          PWM USER MESSAGE ---->FSM2 in RESET  going to IDLE , gprs_stat_reg is %b at time ",gprs_stat_reg ,$time);
		   end
		default:	begin
				  next_state=`IDLE;
                                        //$display("          PWM FSM USER MESSAGE ---->changing to IDLE state");
				end
	  endcase
	end
endmodule
