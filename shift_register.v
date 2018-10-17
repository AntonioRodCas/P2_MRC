 /******************************************************************* 
* Name:
*	shift_register.v
* Description:
* 	This module is a shift register with parameter.
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	Data_Input: Data to register 
*	enable: Enable input
*  shift: Shift enable input
* Outputs:
* 	Data_Output: Data to provide lached data
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       26/09/2018
* 
*********************************************************************/

module shift_register
#(
	parameter WORD_LENGTH = 8,
	parameter SHIFT_LR = 0      //Left=0 Rigth=1
)

(
	input [WORD_LENGTH - 1 : 0] D,
	input clk,
	input reset,
	input load,
	input shift,
	
	output reg [WORD_LENGTH - 1 : 0] Q

);

always @(posedge clk or negedge reset) 
begin
	if(reset==1'b0) 
	begin
		Q<= {(WORD_LENGTH-1) {1'b0}};
	end
	else if (load)
	begin
		Q<=D;
	end
	else
	begin
		if (shift)
		begin
			if(SHIFT_LR)
				Q<=Q>>1;
			else
				Q<=Q<<1;
		end
		else
			Q<=Q;
	end

end





endmodule
