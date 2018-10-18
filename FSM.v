/******************************************************************
* Description
*	This is a FSM for the MRC module
* Inputs:
*	clk
* Outputs:
* 	Data_Output: Output data
*	1.0
* Author:
*	José Antonio Rodríguez Castañeda
* email:
*	md193781@iteso.mx
* Date:
*	14/10/2018
******************************************************************/
module FSM
#(
	parameter WORD_LENGTH = 16
)
(
	input op,
	input start,
	input clk,
	input reset,
	input [(WORD_LENGTH*2):0]  Result,
	input load,
	
	output reg flagx,
	output reg flagy,
	output reg ready,
	
	output reg load_Multiplier,
	output reg load_Data,
	output reg load_result,
	output reg load_Q,
	output reg shift_R,
	output reg shift,
	output reg shift_Q,
	output [7:0] snum_D,
	output reg snum_R,
	output reg snum_Q,
	output reg Sync_Reset,
	output reg Add_in_MUX_control,
	output reg [1:0] R_in_MUX_control,
	output reg [1:0] Q_or_MUX_control,
	output reg load_Mult_sign,
	output reg load_Data_sign,
	output reg ready_reg

);



//State machine states   ############TBD########
localparam IDLE = 0;
localparam X = 1;
localparam LOADX = 2; 
localparam Y = 3;
localparam LOADY = 4;
localparam SHIFT = 5; 
localparam READY = 6;
localparam SHIFTSQ = 7;
localparam SUM_S = 8;
localparam Q_SRP = 9;
localparam Q_SRN = 10;
localparam Q_L = 11;
localparam SQR = 12;
localparam Q_SLA= 13;
localparam SUB_S= 14;
localparam SHIFTSQ_L = 15;
localparam Q_SLS= 16;
localparam SHIFTSQ_W=17;
localparam Q_SWA=18;
localparam Q_SWS=19;
localparam READY_L = 20;


reg [4:0]State;

//Control Lines

reg counter_enable;
wire counter_flag;

reg counterSQR_enable;
wire counterSQR_flag;

reg counterDi_enable;

FlagCounter
#(
	.NBITS(4),
	.VALUE(WORD_LENGTH-1)
) 
FSM_counter 		   	        //Counter for the FSM Shift state multiplier
(
	.clk(clk),
	.reset(reset),
	.enable(counter_enable),
	
	.flag(counter_flag)

);

FlagCounter
#(
	.NBITS(8),
	.VALUE(((WORD_LENGTH/2))*7)
) 
FSM_counter_SQR 		   	        //Counter for the FSM loop states SQR
(
	.clk(clk),
	.reset(reset),
	.enable(counterSQR_enable),
	
	.flag(counterSQR_flag)

);

FlagCounterDi
#(
	.NBITS(8),
	.VALUE(WORD_LENGTH)
) 
FSM_counter_Di		   	        //Counter for the Data shift parameter
(
	.clk(clk),
	.reset(reset),
	.enable(counterDi_enable),
	.Sync_Reset(Sync_Reset),
	
	.count(snum_D)

);


always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IDLE;
	else 
		case(State)
			IDLE:
				if(start == 1 )
					State <= X;
				else 
					State <= IDLE;
			X:
				if(load == 1 )
					State <= LOADX;
				else
					State <= X;
			
			LOADX:
				if(op)
						State <= SQR;
				else
						State <= Y;
			Y:
				if(load == 1 )
					State <= LOADY;
				else
					State <= Y;
			
			LOADY:
				State <= SHIFT;
			
			SQR:
				State <= SHIFTSQ;

					
			// --- Multiplication	
			SHIFT:
				if(counter_flag)
					State <= READY_L;
				else
					State <= SHIFT;
					
			READY:
				State <= IDLE;
				
			// --- Square root
			SHIFTSQ:
					State <= SHIFTSQ_L;
			
			SHIFTSQ_L:
					State <= SHIFTSQ_W;
			
			SHIFTSQ_W:
				if(Result[WORD_LENGTH*2])
					State <= SUM_S;
				else
					State <= SUB_S;
				
			SUM_S:
				State <= Q_SLA;
				
			SUB_S:
				State <= Q_SLS;
			
			Q_SLA:
				State <= Q_SWA;
			
			Q_SLS:
				State <= Q_SWS;
			
			Q_SWA:
				if(Result[WORD_LENGTH*2])
					State <= Q_SRN;
				else
					State <= Q_SRP;
	
			Q_SWS:
				if(Result[WORD_LENGTH*2])
					State <= Q_SRN;
				else
					State <= Q_SRP;
			
			Q_SRP:
				if(counterSQR_flag)
					State <= Q_L;
				else
					State <= SHIFTSQ;
					
			Q_SRN:
				if(counterSQR_flag)
					State <= Q_L;
				else
					State <= SHIFTSQ;
			
			Q_L:
				State <= READY_L;
			
			READY_L:
				State <= READY;
					
			default:
				State <= IDLE;
	endcase
end


always@(State) begin
	flagx = 0;
	flagy = 0;
	load_Multiplier = 0;
	load_Data = 0;
	load_result = 0;
	load_Q = 0;
	shift_R = 0;
	shift = 0;
	shift_Q = 0;
	snum_R = 0;
	snum_Q = 0;
	Sync_Reset = 0;
	Add_in_MUX_control = 0 ;
	R_in_MUX_control = 2'b0;
	Q_or_MUX_control = 2'b0;
	counter_enable = 0;
	counterSQR_enable = 0;
	load_Mult_sign = 0;
	load_Data_sign = 0;
	ready = 0;
	ready_reg = 0;
	counterDi_enable = 0;
		case(State)
			
			X:
				begin
					flagx = 1;
				end
			
			LOADX:
				begin
					load_result = 1;
					load_Q = 1;
					Sync_Reset = 1;
					counterDi_enable = 1;
					load_Data = 1;
					load_Data_sign = 1;
				end
			
			Y:
				begin
					flagy = 1;
				end
			
			LOADY:
				begin
					load_Multiplier = 1;
					load_Mult_sign = 1;
				end
			
			SQR:
				begin
					load_Data = 1;
				end
				
			SHIFT:
				begin
					shift = 1;
					load_result = 1;
					counter_enable=1;	
					R_in_MUX_control = 2'b1;
					Add_in_MUX_control = 0 ;
				end
			
			SHIFTSQ:
				begin
					shift_R = 1;
					snum_R = 1;
					shift = 1;
					R_in_MUX_control = 2'b0;
					//load_result = 1;
					counterSQR_enable = 1;
				end
			
			SHIFTSQ_L:
				begin
					shift_R = 1;
					snum_R = 1;
					shift = 1;
					R_in_MUX_control = 2'b0;
					load_result = 1;
					counterSQR_enable = 1;
				end
			
			SHIFTSQ_W:
				begin
					R_in_MUX_control = 2'b0;
					counterSQR_enable = 1;
				end
			
			SUM_S:
				begin
					shift_Q = 1;
					snum_Q = 1;
					Q_or_MUX_control = 2'b10;
					//load_result = 1;
					Add_in_MUX_control = 1 ;
					R_in_MUX_control = 2'b01;
					counterSQR_enable = 1;
				end
			
			SUB_S:
				begin
					shift_Q = 1;
					snum_Q = 1;
					Q_or_MUX_control = 2'b01;
					//load_result = 1;
					R_in_MUX_control = 2'b10;
					counterSQR_enable = 1;
				end
			
			Q_SLA:
				begin
					shift_Q = 1;
					snum_Q = 1;
					Add_in_MUX_control = 1 ;
					Q_or_MUX_control = 2'b10;
					load_result = 1;
				   R_in_MUX_control = 2'b01;
					counterSQR_enable = 1;
				end
			
			Q_SLS:
				begin
					shift_Q = 1;
					snum_Q = 1;
					Q_or_MUX_control = 2'b01;
					load_result = 1;
				   R_in_MUX_control = 2'b10;
					counterSQR_enable = 1;
				end
				
			Q_SWA:
				begin
					//shift_Q = 1;
					//snum_Q = 1;
					Add_in_MUX_control = 1 ;
					Q_or_MUX_control = 2'b01;
					//load_result = 1;
				   R_in_MUX_control = 2'b01;
					counterSQR_enable = 1;
				end
			
			Q_SWS:
				begin
					//shift_Q = 1;
					//snum_Q = 1;
					Q_or_MUX_control = 2'b1;
					//load_result = 1;
				   R_in_MUX_control = 2'b10;
					counterSQR_enable = 1;
				end	
				
			Q_SRP:
				begin
					shift_Q = 1;
					load_Q = 1;
					Q_or_MUX_control = 2'b1;
					counterSQR_enable = 1;
					counterDi_enable = 1;
				end
			
			Q_SRN:
				begin
					shift_Q = 1;
					load_Q = 1;
					Q_or_MUX_control = 2'b0;
					counterSQR_enable = 1;
					counterDi_enable = 1;
				end
			
			Q_L:
				begin
					shift_Q = 1;
					snum_Q = 0;
					Q_or_MUX_control = 2'b1;
					load_result = 1;
					Add_in_MUX_control = 1 ;
					R_in_MUX_control = 2'b1;
				end
			
			READY:
				begin
					ready = 1;
				end
			
			READY_L:
				begin
					ready_reg = 1;
				end
			
			default:
				begin
					flagx = 0;
					flagy = 0;
					load_Multiplier = 0;
					load_Data = 0;
					load_result = 0;
					load_Q = 0;
					shift_R = 0;
					shift = 0;
					shift_Q = 0;
					snum_R = 0;
					snum_Q = 0;
					Sync_Reset = 0;
					Add_in_MUX_control = 0 ;
					R_in_MUX_control = 2'b0;
					Q_or_MUX_control = 2'b0;
					counter_enable = 0;
				end
		endcase
end




endmodule
