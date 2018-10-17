 /*********************************************************
 * Description:
 * This is an Aritmetic Module for multiplicacion and Root Square
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
module MRC
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
	output [(WORD_LENGTH*2)-1:0] Result,
	output  x,
	output  y,
	output reg error
);


//Output signals
wire [(WORD_LENGTH*2)-1:0] Result_Out;
wire ready_reg;


//Multiplier signals
wire [(WORD_LENGTH*2)-1:0] result_temp;
wire [(WORD_LENGTH*2)-1:0]  sum_one_reg;	//Imp

wire [WORD_LENGTH-1:0]  Data_reg;			//Imp
wire [WORD_LENGTH-1:0]  multiplier_reg;	//Imp

//Add/Sub signals
wire [(WORD_LENGTH*2)-1:0] Add_input;     //Imp
wire [(WORD_LENGTH*2)-1:0] Add_output;    //Imp
wire [(WORD_LENGTH*2)-1:0] Sub_output;    //Imp


// Two's complement     ###########TBD
wire sign_data;									//Imp
wire sign_result;									//Imp
wire [WORD_LENGTH-1:0]  Data_2C;        //Imp
wire [(WORD_LENGTH*2)-1:0]  Result_2C;  //Imp

wire Multiplier_sign;						//Imp
wire Data_sign;								//Imp


//FSM control signals
wire Add_in_MUX_control;					//Imp
wire load_result;								//Imp
wire shift_R;									//Imp
wire Sync_Reset;								//Imp
wire snum_R;									//Imp
wire [7:0] snum_D;									//Imp
wire snum_Q;									//Imp
wire [1:0] R_in_MUX_control;				//Imp
wire load_Q;									//Imp
wire shift_Q;									//Imp
wire [1:0] Q_or_MUX_control;						//Imp
wire load_Multiplier;						//Imp
wire shift;
wire load_Data;								//Imp
wire load_Mult_sign;							//Imp
wire load_Data_sign;							//Imp




// R/Q reg signals
wire [(WORD_LENGTH*2)-1:0] R_input;   //Imp
wire [(WORD_LENGTH*2)-1:0] R_shift;	  //Imp
wire [(WORD_LENGTH*2)-1:0] Q_out;		//Imp
wire [(WORD_LENGTH*2)-1:0] Q_OR_MUX;   //Imp
wire [(WORD_LENGTH*2)-1:0] Q_shift;    //Imp
wire [(WORD_LENGTH*2)-1:0] Result_MUX; //Imp

// Error signals

wire SQR_error;
wire Mult_error;



// Modules implementation

//----------- Registers implementation 

shift_register
#(
	.WORD_LENGTH(WORD_LENGTH),
	.SHIFT_LR ( 1 )
) 
SR_R_MULTIPLIER			   	//Multiplier shift register
(
	.D(Data_2C),
	.clk(clk),
	.reset(reset),
	.load(load_Multiplier),
	.shift(shift),
	
	.Q(multiplier_reg)

);


shift_registerD
#(
	.WORD_LENGTH(WORD_LENGTH)
)
SR_DATA_MULTIPLICAND					//Multiplicand/Data shift register
(
	.D(Data_2C),
	.clk(clk),
	.reset(reset),
	.load(load_Data),
	.shift(shift),
	.op(op),
	.snum(snum_D),					
	
	.Q(Data_reg)

);

shift_registerRQ
#(
	.WORD_LENGTH((WORD_LENGTH*2)),
	.SHIFT_LR(0)
) 
Accumulator		   	        //Register with sync reset and shift for Accumulator
(
	.D(R_input),  					
	.clk(clk),
	.reset(reset),
	.load(load_result),			
	.shift(shift_R),					
	.Sync_Reset(Sync_Reset),   
	.snum(snum_R),					
	
	.Q(Result_2C)		

);

shift_registerRQ
#(
	.WORD_LENGTH((WORD_LENGTH*2)),
	.SHIFT_LR(0)
) 
Q_reg		   	        //Register with sync reset and shift for Q
(
	.D(Q_shift),  											
	.clk(clk),
	.reset(reset),
	.load(load_Q),						
	.shift(shift_Q),										
	.Sync_Reset(Sync_Reset),   
	.snum(snum_Q),									
	
	.Q(Q_out)		

);

Register
#(
	.WORD_LENGTH(1)
) 
Multiplier_sign_reg		   	        //Register with enable for Multiplier sign
(											
	.clk(clk),
	.reset(reset),
	.enable(load_Mult_sign),           						  
	.Data_Input(sign_data),									
	
	.Data_Output(Multiplier_sign)      	

);

Register
#(
	.WORD_LENGTH(1)
) 
Data_sign_reg		   	        //Register with enable for Data sign
(											
	.clk(clk),
	.reset(reset),
	.enable(load_Data_sign),           					  
	.Data_Input(sign_data),									
	
	.Data_Output(Data_sign)      	

);


Register
#(
	.WORD_LENGTH(WORD_LENGTH*2)
) 
Result_out_reg		   	        //Register with enable for Result output
(											
	.clk(clk),
	.reset(reset),
	.enable(ready_reg),           					  
	.Data_Input(Result_MUX),									
	
	.Data_Output(Result)      	

);

//----------- MUX implementation 
Mux2to1
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Out_in_MUX		   	        //Output MUX for select Multiplication or SQR
(
	.Selector(op),    
	.MUX_Data0(Result_Out),
	.MUX_Data1(Q_out),					 
	
	.MUX_Output(Result_MUX)			

);


Mux2to1
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Add_in_MUX		   	        //Add input MUX
(
	.Selector(Add_in_MUX_control),    
	.MUX_Data0(sum_one_reg),
	.MUX_Data1(Q_shift),					 
	
	.MUX_Output(Add_input)			

);

Mux3to1
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
R_in_MUX		   	        //R input MUX
(
	.Selector(R_in_MUX_control),    
	.MUX_Data0(R_shift),				  
	.MUX_Data1(Add_output),		
   .MUX_Data2(Sub_output),			  
	
	.MUX_Output(R_input)					

);

Mux3to1
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Q_or_MUX		   	        //Q or MUX
(
	.Selector(Q_or_MUX_control),       //-----missing
	.MUX_Data0({{(WORD_LENGTH*2-1) {1'b0}},1'b0}),				  
	.MUX_Data1({{(WORD_LENGTH*2-1) {1'b0}},1'b1}),		
   .MUX_Data2({{(WORD_LENGTH*2-2) {1'b0}},2'b11}),			  
	
	.MUX_Output(Q_OR_MUX)					

);


//----------- ADD/SUB implementation 
add_sub
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Adder				   	        //Adder module
(
	.op(1'b0),    
	.A0(Result_2C),
	.A1(Add_input),					 
	
	.Data_Output(Add_output)			

);

add_sub
#(
	.WORD_LENGTH((WORD_LENGTH*2))
) 
Sub				   	        //Sub module
(
	.op(1'b1),    
	.A0(Result_2C),			  
	.A1(Q_shift),					 
	
	.Data_Output(Sub_output)			

);

//----------- FSM implementation

FSM
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Main_FSM		   	        //Finite State Machine
(	
	.op(op),
	.start(start),
	.clk(clk),
	.reset(reset),
	.Result(Result_2C),           					  
	.load(load),	

	.flagx(x),
	.flagy(y),
	.ready(ready_reg),
	
	.load_Multiplier(load_Multiplier),
	.load_Data(load_Data),
	.load_result(load_result),
	.load_Q(load_Q),
	.shift_R(shift_R),
	.shift(shift),
	.shift_Q(shift_Q),
	.snum_D(snum_D),
	.snum_R(snum_R),
	.snum_Q(snum_Q),
	.Sync_Reset(Sync_Reset),
	.Add_in_MUX_control(Add_in_MUX_control),
	.R_in_MUX_control(R_in_MUX_control),
	.Q_or_MUX_control(Q_or_MUX_control),
	.load_Mult_sign(load_Mult_sign),
	.load_Data_sign(load_Data_sign)
	
);



// Assignation sentences

//----Output
assign ready = ready_reg;

//----Multiplicand MUX
assign sum_one_reg = (multiplier_reg[0]==1) ? {{(WORD_LENGTH-1) {1'b0}} ,Data_reg} : {((WORD_LENGTH*2)-1) {1'b0}};  //Imp

//----R/Q OR signals
assign R_shift = Result_2C | {{(WORD_LENGTH-1) {1'b0}} ,Data_reg};   //Imp
assign Q_shift = Q_out | Q_OR_MUX;												//Imp


// Two's complement decoder

assign sign_data = Data[WORD_LENGTH-1];										//Imp
assign Data_2C = (Data[WORD_LENGTH-1]==0) ? Data : (~Data + 1'b1);   //Imp

assign sign_result = (Multiplier_sign | Data_sign);
assign Result_Out[(WORD_LENGTH*2)-1] = sign_result;
assign Result_Out[(WORD_LENGTH*2)-2:0] = (sign_result==0) ? Result_2C : (~Result_2C + 1'b1);

// Error signals
assign SQR_error = (op==1) ? Data_sign : 1'b0;


endmodule
