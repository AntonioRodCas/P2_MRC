 /*********************************************************
 * Description:
 * This module is test bench file for testing the MRC module
 *
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    14/10/18
 *
 **********************************************************/ 
 
 
 
module MRC_TB;

parameter WORD_LENGTH = 16;


reg clk_tb = 0;
reg reset_tb;
reg start_tb = 0;
reg load_tb = 0;
reg op_tb = 0;

reg [WORD_LENGTH - 1 : 0] Data_tb;


wire ready_tb;
wire [(WORD_LENGTH*2)-1 : 0] Result_tb;

wire x_tb;
wire y_tb;
wire error_tb;


MRC
#(
	.WORD_LENGTH(WORD_LENGTH)
)
SM_1
(
	.start(start_tb),
	.load(load_tb),
	.Data(Data_tb),
	.op(op_tb),
	.clk(clk_tb),
	.reset(reset_tb),
	
	
	.ready(ready_tb),
	.Result(Result_tb),
	.x(x_tb),
	.y(y_tb),
	.error(error_tb)

);

/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
   #0 reset_tb = 0;
   #5 reset_tb = 1;
end

/*********************************************************/
initial begin // start generator
	#5 start_tb = 1;
	#15 start_tb = 0;
	#105 start_tb = 1;
	//#15 start_tb = 0;
end

/*********************************************************/
initial begin // op generator
	#5 op_tb = 1;
	//#15 start_tb = 0;
	//#45 start_tb = 1;
	//#15 start_tb = 0;
end

/*********************************************************/
initial begin // load generator
	#5 load_tb = 0;
	#10 load_tb = 1;
	#5 load_tb = 0;
	#20 load_tb = 1;
end
/*********************************************************/

/*********************************************************/
initial begin // Data generator
	#5 Data_tb = -200;
	//#22 Data_tb = 3;
end
/*********************************************************/

endmodule