 /*********************************************************
 * Description:
 * Aritmetic module integration on a FPGA
 * 	Inputs:
 *			start: 			Start input signal
 *			load:				Load data into the module input signal
 *			Data: 			Input data
 *			op:				Operation selector input
 *			clk:				Clock input data
 *			reset:			Asyncronous reset input data
 *		Outputs:
 *			ready: 			Ready output flag signal
 *			Result: 			Result output data
 *			x:					Ready to receive x data flag
 *			y:					Ready to receive y data flag
 *			error:			Error flag signal
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    11/10/18
 *
 **********************************************************/
module MRC_FPGA
#(
	parameter WORD_LENGTH = 16								//Input parameter definition
)

(	
	input start,
	input load,	
	input [WORD_LENGTH-1:0] Data,
	input op,
	input clk,
	input reset,
	
	output ready,
	//output [(WORD_LENGTH*2)-1:0] Result,
	output  x,
	output  y,
	output error,
	
	output [6:0] H,
	output [6:0] T,
	output [6:0] U,
	output		 sign,
	
	output [WORD_LENGTH-1:0] Result_LED
	
);

wire Five_MEG_clk;
wire [(WORD_LENGTH*2)-1:0] Result_int;
wire ready_reg;
wire load_debounce;
wire start_neg;
wire load_neg;


assign Result_LED = Result_int[WORD_LENGTH-1:0];

clk_gen
clock_gen			   	//Clock Divider with PLL to generate 5MHz
(
	.clk(clk),
	.reset(reset),
	
	.clk_out(Five_MEG_clk)

);

One_Shot
 ShotModule
(
	// Input Ports
	.clk(Five_MEG_clk),
	.reset(reset),
	.Start(load_neg),

	// Output Ports
	.Shot(load_debounce)
);

MRC
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
MRC_module			   	//Multiplier and SQR module implementation
(
	.start(start_neg),
	.load(load_debounce),
	.Data(Data),
	.op(op),
	.clk(Five_MEG_clk),
	.reset(reset),
	
	.ready(ready_reg),
	.x(x),
	.y(y),
	.error(error),
	.Result(Result_int)

);



bin2BCD_t
#(
	.WORD_LENGTH(WORD_LENGTH/2)
) 
bin2BCD_module			   	//Binary to 7 segment module
(
	.bin(Result_int[WORD_LENGTH/2-1:0]),
	.clk(Five_MEG_clk),
	.reset(reset),
	.enable(ready_reg),
	
	.H(H),
	.T(T),
	.U(U),
	.sign(sign)

);

assign ready = ready_reg;
//assign Five_MEG_clk = clk;
assign load_neg = ~load;
assign start_neg = ~start;

endmodule
