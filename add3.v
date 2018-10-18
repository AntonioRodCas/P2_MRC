 /*********************************************************
 * Description:
 * This module is a 3 adder if the input value is > 5
 * If not, the output is the same as input
 * 	Inputs:
 *			in:		Input to be decoded
 *		Outputs:
 *			out:		Output of the 3 adder
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    08/09/18
 *
 **********************************************************/

module add3

(
	input [3:0] in,						
	
	output [3:0] out

);

wire [3:0] in_w;
reg  [3:0] out_w;



always @(in_w) 
begin
	case (in_w)
		4'b0000: out_w = 4'b0000;   // case for 0 -> 0
		4'b0001: out_w = 4'b0001;   // case for 1 -> 1
		4'b0010: out_w = 4'b0010;   // case for 2 -> 2
		4'b0011: out_w = 4'b0011;   // case for 3 -> 3
		4'b0100: out_w = 4'b0100;   // case for 4 -> 4
		4'b0101: out_w = 4'b1000;   // case for 5 -> 8
		4'b0110: out_w = 4'b1001;   // case for 6 -> 9
		4'b0111: out_w = 4'b1010;   // case for 7 -> 10
		4'b1000: out_w = 4'b1011;   // case for 8 -> 11
		4'b1001: out_w = 4'b1100;   // case for 9 -> 12
		default: out_w = 4'bxxxx;   // case for default -> x ;
		endcase
end

assign in_w = in;
assign out=out_w;

endmodule