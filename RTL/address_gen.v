// Description : Chip Top Address Generator TOP
// Author       : Ahmed Abdelazeem
// Details      : Generates appropriate address to Memx or Memy
// Created on   : 12/11/2024
// ---------------------------------------------------------------

module address_gen_add(read_addressX,read_addressY,write_addressX,write_addressY,write_X_enable, write_Y_enable,memX_datain,memY_datain,common_address,MemWriteBus,MemOverflow);

input write_X_enable,write_Y_enable;
input [3:0] read_addressX,read_addressY,write_addressX,write_addressY;


input [63:0] memX_datain,memY_datain;

output [7:0] common_address;
output [63:0] MemWriteBus;

output MemOverflow;



assign common_address = (write_X_enable|write_Y_enable)?{write_addressX,write_addressY}:{read_addressX,read_addressY};

assign {MemOverflow,MemWriteBus} = memX_datain + memY_datain;


endmodule
