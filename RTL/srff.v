// Description : Set Reset Flip Flop
// Author       : Godwin Maben
// Details      : Sets or Resets the register
// Created on   : 01/01/2006
// ---------------------------------------------------------------

module srff(clk,rst_n,set,reset,q);

input clk,rst_n,set,reset;

output q;
reg q;


// synopsys sync_set_reset "rst_n"
  always @ (posedge clk)
    begin
      if (rst_n)
        begin
                q<=0;
        end
      else
        begin
                if(set) q<=1;
		if(reset) q<=0;
        end
    end

endmodule
