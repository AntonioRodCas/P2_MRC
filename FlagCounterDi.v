 /******************************************************************* 
* Name:
*	FlagCounterDi.v
* Description:
* 	This module is parameterizable counter with count as output with Sync_Reset
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	enable: Enable input
*	Sync_Reset: Synchronous reset input
* Outputs:
* 	count: Count value output 
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       14/10/2018
* 
*********************************************************************/
module FlagCounterDi
#(
	// Parameter Declarations
	parameter NBITS = 8,
	parameter VALUE =8
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input Sync_Reset,
	
	// Output Ports
	output [NBITS-1:0] count

);


reg [NBITS-1 : 0] counter_reg;

	always@(posedge clk or negedge reset) begin
		if (reset == 1'b0)
			counter_reg <= VALUE;
		else
			if(enable == 1'b1)
				if(Sync_Reset)
					counter_reg <= VALUE;
				else
					counter_reg <= counter_reg - 2'b10;
			else
				counter_reg <= counter_reg;
	end

//----------------------------------------------------
assign count = counter_reg;
//----------------------------------------------------

endmodule