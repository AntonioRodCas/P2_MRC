 /******************************************************************* 
* Name:
*	shift_registerRQ.v
* Description:
* 	This module is a shift register with parameter.
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	Data_Input: Data to register 
*	enable: Enable input
*  shift: Shift enable input
*	Sync_Reset: Synchronus reset
*	snum:  Number of shifting input 0-> 1 shift, 1 -> 2 shift
* Outputs:
* 	Data_Output: Data to provide lached data
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       26/09/2018	  First release
*	V1.1       11/10/2018     snum signal adding
* 
*********************************************************************/

module shift_registerRQ
#(
	parameter WORD_LENGTH = 16,
	parameter SHIFT_LR = 0      //Left=0 Rigth=1
)

(
	input [WORD_LENGTH - 1 : 0] D,
	input clk,
	input reset,
	input load,
	input shift,
	input Sync_Reset,
	input snum,
	
	output reg [WORD_LENGTH - 1 : 0] Q

);

reg [WORD_LENGTH - 1 : 0] Q_int;

always @(posedge clk or negedge reset) 
begin
	if(reset==1'b0) 
	begin
		Q_int<= {(WORD_LENGTH) {1'b0}};
	end
	else if (load)
	begin
		if(Sync_Reset)
			Q_int <= {(WORD_LENGTH) {1'b0}};
		else
			Q_int <= D;
	end
	else
	begin
		Q_int<=Q_int;
	end

end

always @(shift,Q_int,snum) 
begin
	if (shift)
	begin
			if(SHIFT_LR)
				if(snum)
					Q<={2'b0 , Q_int[WORD_LENGTH-3:0]};
				else
					Q<={1'b0 , Q_int[WORD_LENGTH-2:0]};
			else
				if(snum)
					Q<={Q_int[WORD_LENGTH-3:0] , 2'b0};
				else
					Q<={Q_int[WORD_LENGTH-2:0] , 1'b0};
	end	
	else
			Q<=Q_int;
end



endmodule
