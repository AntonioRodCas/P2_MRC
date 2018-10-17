 /*********************************************************
 * Description:
 * This module is a sequential of two two's complement numbers
 * 	Inputs:
 *			start: 			Start input signal
 *			Multiplier: 	Multiplier Input data
 *			Multiplicand: 	Multiplicand Input data
 *			clk:				Clock input data
 *			reset:			Asyncronous reset input data
 *		Outputs:
 *			ready: 			Ready output flag signal
 *			Product: 		Product (result) output data
 *
 *	Author:  Antonio Rodríguez    md193781   ITESO 
 *	Date:    27/09/18
 *
 **********************************************************/
module sequential_multiplier
#(
	parameter WORD_LENGTH = 8								//Input parameter definition
)

(	
	input start,
	input [WORD_LENGTH-1:0] Multiplier,	
	input [WORD_LENGTH-1:0] Multiplicand,	
	input clk,
	input reset,
	
	output reg ready,
	output [(WORD_LENGTH*2)-1:0] Product
);

//State machine states
localparam IDLE = 0;
localparam LOAD = 1; 
localparam SHIFT = 2; 
localparam READY = 3; 

reg [1:0]State;



reg shift;
reg load;
reg load_product;
reg Sync_Reset;
reg counter_enable;


wire [(WORD_LENGTH*2)-1:0] result_temp;
wire [(WORD_LENGTH*2)-1:0]  sum_one_reg;
wire counter_flag;
wire [WORD_LENGTH-1:0]  multiplicand_reg;
wire [WORD_LENGTH-1:0]  multiplier_reg;

// Two's complement
wire sign_multiplier;
wire sign_multiplicand;
wire sign_product;

wire [WORD_LENGTH-1:0]  Multiplicand_2C;
wire [WORD_LENGTH-1:0]  Multiplier_2C;

wire [(WORD_LENGTH*2)-1:0]  Product_2C;


// Combinational logic

shift_register
#(
	.WORD_LENGTH(WORD_LENGTH),
	.SHIFT_LR ( 0 )
)
SR_L_MULTIPLICAND					//Multiplicand shift register
(
	.D(Multiplicand_2C),
	.clk(clk),
	.reset(reset),
	.load(load),
	.shift(shift),
	
	.Q(multiplicand_reg)

);

shift_register
#(
	.WORD_LENGTH(WORD_LENGTH),
	.SHIFT_LR ( 1 )
) 
SR_R_MULTIPLIER			   	//Multiplier shift register
(
	.D(Multiplier_2C),
	.clk(clk),
	.reset(reset),
	.load(load),
	.shift(shift),
	
	.Q(multiplier_reg)

);

Register_With_Sync_Reset
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Accumulator		   	        //Register with sync reset for Accumulator
(
	.clk(clk),
	.reset(reset),
	.enable(load_product),
	.Sync_Reset(Sync_Reset),
	.Data_Input(result_temp),
	
	.Data_Output(Product_2C)

);

FlagCounter
#(
	.NBITS(4),
	.VALUE(WORD_LENGTH-1)
) 
FSM_counter 		   	        //Counter for the FSM Shift state
(
	.clk(clk),
	.reset(reset),
	.enable(counter_enable),
	
	.flag(counter_flag)

);



assign sum_one_reg = (multiplier_reg[0]==1) ? {{(WORD_LENGTH-1) {1'b0}} ,multiplicand_reg} : {((WORD_LENGTH*2)-1) {1'b0}};

assign result_temp = sum_one_reg + Product_2C;

// Two's complement decoder
assign sign_multiplier = Multiplier[WORD_LENGTH-1];
assign Multiplier_2C = (Multiplier[WORD_LENGTH-1]==0) ? Multiplier : (~Multiplier + 1'b1);

assign sign_multiplicand = Multiplicand[WORD_LENGTH-1];
assign Multiplicand_2C = (Multiplicand[WORD_LENGTH-1]==0) ? Multiplicand : (~Multiplicand + 1'b1);

assign sign_product = (sign_multiplier | sign_multiplicand);
assign Product[(WORD_LENGTH*2)-1] = sign_product;
assign Product[(WORD_LENGTH*2)-2:0] = (sign_product==0) ? Product_2C : (~Product_2C + 1'b1);


always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IDLE;
	else 
		case(State)
			IDLE:
			if(start == 1 )
				State <= LOAD;
			else 
				State <= IDLE;
							
			LOAD:
				State <= SHIFT;
					
			SHIFT:
				if(counter_flag)
					State <= READY;
				else
					State <= SHIFT;
					
			READY:
				State <= IDLE;
					
			default:
				State <= IDLE;
	endcase
end


always@(State) begin
		case(State)
			
			IDLE:
				begin
					shift = 0;
					load = 0;
					load_product = 0;
					Sync_Reset = 0;
					ready = 0;
					counter_enable=0;
				end
			LOAD:
				begin 
					shift = 0;
					load = 1;
					load_product = 1;
					Sync_Reset = 0;
					ready = 0;
					counter_enable=0;				
				end
					
			SHIFT:
				begin
					shift = 1;
					load = 0;
					load_product = 1;
					Sync_Reset = 1;
					ready = 0;
					counter_enable=1;					
				end
			READY:
				begin
					shift = 0;
					load = 0;
					load_product = 0;
					Sync_Reset = 0;
					ready = 1;
					counter_enable=0;	
				end

			default:
				begin
					shift = 0;
					load = 0;
					load_product = 0;
					Sync_Reset = 0;
					ready = 0;
					counter_enable=0;
				end
		endcase
end




endmodule
