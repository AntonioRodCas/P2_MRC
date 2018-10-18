 /*********************************************************
 * Description:
 * This module is a BCD top 7 segment converter
 * 	Inputs:
 *			BCD: 		BCD input data
 *
 *		Outputs:
 *			SSD:     Seven Segment display output
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    08/09/18
 *
 **********************************************************/

module BCDto7seg
(						
	input [3:0] BCD,					
	
	
	output [6:0] SSD
	
);

reg [6:0] SSD_reg;

always@(BCD) begin
		case (BCD)
		4'b0000: SSD_reg = 7'b1000000;   // 0 for 7 segment display
		4'b0001: SSD_reg = 7'b1111001;   // 1 for 7 segment display
		4'b0010: SSD_reg = 7'b0100100;   // 2 for 7 segment display
		4'b0011: SSD_reg = 7'b0110000;   // 3 for 7 segment display
		4'b0100: SSD_reg = 7'b0011001;   // 4 for 7 segment display
		4'b0101: SSD_reg = 7'b0010010;   // 5 for 7 segment display
		4'b0110: SSD_reg = 7'b0000010;   // 6 for 7 segment display
		4'b0111: SSD_reg = 7'b1111000;   // 7 for 7 segment display
		4'b1000: SSD_reg = 7'b0000000;   // 8 for 7 segment display
		4'b1001: SSD_reg = 7'b0011000;   // 9 for 7 segment display
		default: SSD_reg = 7'b1000000;
		endcase
		
end

assign SSD = SSD_reg;

endmodule