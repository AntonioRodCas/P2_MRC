 /******************************************************************* 
* Name:
*	FlagCounter.v
* Description:
* 	This module is parameterizable counter with flag
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	enable: Enable input
* Outputs:
* 	flag: Count reached output flag
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       27/09/2018
* 
*********************************************************************/
module FlagCounter
#(
	// Parameter Declarations
	parameter NBITS = 4,
	parameter VALUE =8
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	
	// Output Ports
	output flag

);


reg [NBITS-1 : 0] counter_reg;

	always@(posedge clk or negedge reset) begin
		if (reset == 1'b0)
			counter_reg <= {NBITS{1'b0}};
		else
			if(enable == 1'b1)
				counter_reg <= counter_reg + 1'b1;
			else
				counter_reg <= {NBITS{1'b0}};
	end

//----------------------------------------------------
assign flag = (counter_reg>=VALUE)?1'b1:1'b0;
//----------------------------------------------------

endmodule