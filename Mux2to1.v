/******************************************************************
* Description
*	This is a  an 2to1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Mux2to1
#(
	parameter WORD_LENGTH = 32
)
(
	input Selector,
	input [WORD_LENGTH - 1 : 0] MUX_Data0,
	input [WORD_LENGTH - 1 : 0] MUX_Data1,
	
	output [WORD_LENGTH - 1 : 0] MUX_Output

);

reg [WORD_LENGTH - 1 : 0] MUX_Output_reg;

	always@(Selector,MUX_Data1,MUX_Data0) begin
	
		if(Selector)
			MUX_Output_reg = MUX_Data1;
		else
			MUX_Output_reg = MUX_Data0;
	end
	
assign MUX_Output = MUX_Output_reg;

endmodule