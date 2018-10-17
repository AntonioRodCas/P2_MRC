/******************************************************************
* Description
*	This is a  an 3to1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Inputs:
*	Selector: Selection input signal
*  Mux_Data0: Mux input data 0
*  Mux_Data1: Mux input data 1
*  Mux_Data2: Mux input data 2
* Outputs:
* 	Data_Output: Data to provide lached data
* Author:
*	José Antonio Rodríguez Castañeda
* email:
*	md193781@iteso.mx
* Date:
*	11/10/2018
******************************************************************/
module Mux3to1
#(
	parameter WORD_LENGTH = 32
)
(
	input [1:0] Selector,
	input [WORD_LENGTH - 1 : 0] MUX_Data0,
	input [WORD_LENGTH - 1 : 0] MUX_Data1,
	input [WORD_LENGTH - 1 : 0] MUX_Data2,
	
	output [WORD_LENGTH - 1 : 0] MUX_Output

);

reg [WORD_LENGTH - 1 : 0] MUX_Output_reg;

	always@(Selector,MUX_Data1,MUX_Data0,MUX_Data2) begin
		case (Selector)
					0 : MUX_Output_reg=MUX_Data0;
					1 : MUX_Output_reg=MUX_Data1;
					2 : MUX_Output_reg=MUX_Data2;
					default : MUX_Output_reg=MUX_Data0;
		endcase
	end
	
assign MUX_Output = MUX_Output_reg;

endmodule