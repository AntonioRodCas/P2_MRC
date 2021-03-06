/******************************************************************
* Description
*	This is a simple adder/substractor with a parameter for the width of the input and output.
* Inputs:
*	op: Operation to be executed 0 -> Add, 1 -> Sub
*  A0: Operand 0 input
*	A1:	Operand 1 input
* Outputs:
* 	Data_Output: Output data
*	1.0
* Author:
*	José Antonio Rodríguez Castañeda
* email:
*	md193781@iteso.mx
* Date:
*	11/10/2018
******************************************************************/
module add_sub
#(
	parameter WORD_LENGTH = 32
)
(
	input op,
	input [WORD_LENGTH - 1 : 0] A0,
	input [WORD_LENGTH - 1 : 0] A1,
	
	output [WORD_LENGTH - 1 : 0] Data_Output

);

reg [WORD_LENGTH - 1 : 0] Data_Output_reg;

	always@(op, A0 or A1) begin
	
		if(op)
			Data_Output_reg = A0 - A1;
		else
			Data_Output_reg = A0 + A1;
	end
	
assign Data_Output = Data_Output_reg;

endmodule