 /******************************************************************* 
* Name:
*	shift_registerD.v
* Description:
* 	This module is a shift register with parameter special for Root Square solving.
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	Data_Input: Data to register 
*	enable: Enable input
*  shift: Shift enable input
*	snum:  Number of shifting input
*  op: 	 Operation selector    0 -> Mult,  1 -> RS 
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

module shift_registerD
#(
	parameter WORD_LENGTH = 16
)

(
	input [WORD_LENGTH - 1 : 0] D,
	input clk,
	input reset,
	input load,
	input shift,
	input op,
	input [7:0] snum,
	
	output reg [WORD_LENGTH - 1 : 0] Q

);

wire [((WORD_LENGTH*2)+2) - 1 : 0] D_buf;

assign D_buf = {{(WORD_LENGTH+2){1'b0}}, D};


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
			if(op)
			begin
				case (snum)
					0 : Q<=D_buf[1:0];
					1 : Q<=D_buf[2:1];
					2 : Q<=D_buf[3:2];
					3 : Q<=D_buf[4:3];
					4 : Q<=D_buf[5:4];
					5 : Q<=D_buf[6:4];
					6 : Q<=D_buf[7:6];
					7 : Q<=D_buf[8:7];
					8 : Q<=D_buf[9:8];
					9 : Q<=D_buf[10:9];
					10 : Q<=D_buf[11:10];
					11 : Q<=D_buf[12:11];
					12 : Q<=D_buf[13:12];
					13 : Q<=D_buf[14:13];
					14 : Q<=D_buf[15:14];
					15 : Q<=D_buf[16:15];
					16 : Q<=D_buf[17:16];
					17 : Q<=D_buf[18:17];
					18 : Q<=D_buf[19:18];
					19 : Q<=D_buf[20:19];
					20 : Q<=D_buf[21:20];
					21 : Q<=D_buf[22:21];
					22 : Q<=D_buf[23:22];
					23 : Q<=D_buf[24:23];
					24 : Q<=D_buf[25:24];
					25 : Q<=D_buf[26:25];
					26 : Q<=D_buf[27:26];
					27 : Q<=D_buf[28:27];
					28 : Q<=D_buf[29:28];
					29 : Q<=D_buf[30:29];
					30 : Q<=D_buf[31:30];
					31 : Q<=D_buf[32:31];
					32 : Q<=D_buf[33:32];
					default: Q<=D_buf[1:0];
				endcase
			end
			else
				Q<=Q<<1;
		else
			Q<=Q;
	end

end


endmodule
