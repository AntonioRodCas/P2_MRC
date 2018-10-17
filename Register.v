/******************************************************************* 
* Name:
*	Register.v
* Description:
* 	This module is a register with parameter.
*   -Modified to have enable signal. (01/09/18)
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	Data_Input: Data to register 
*	enable: Enable input
* Outputs:
* 	Data_Output: Data to provide lached data
* Versión:  
*	1.1
* Author: 
*	José Luis Pizano Escalante
* Modified:
*	José Antonio Rodríguez Castañeda   md193781
* Date: 
*	V1.0       07/02/2013
*  	V1.1		  01/09/18
* 
*********************************************************************/

 module Register
#(
	parameter WORD_LENGTH = 6									//Input parameter definition
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input [WORD_LENGTH-1 : 0] Data_Input,

	// Output Ports
	output [WORD_LENGTH-1 : 0] Data_Output
);

reg  [WORD_LENGTH-1 : 0] Data_reg;

always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) 											//reset
		Data_reg <= 0;
	else if (enable) begin										//enable 
		
		Data_reg <= Data_Input;
		
		end

end

assign Data_Output = Data_reg;								//Assign data to output

endmodule