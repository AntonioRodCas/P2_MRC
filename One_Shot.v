
module One_Shot
(
	// Input Ports
	input clk,
	input reset,
	input Start,

	// Output Ports
	output Shot
);


reg [1:0] state;

localparam Waiting_Shot = 1;
localparam Shot_State = 2;
localparam Waiting_Not_Shot = 3;

reg Shot_reg;
wire Not_Start;



assign Not_Start = Start;
/*------------------------------------------------------------------------------------------*/
/*Asignacion de estado*/

always@(posedge clk or negedge reset)
begin

if(reset == 1'b0) begin 
		state<=Waiting_Shot;
end
else begin
		case(state)
		
		Waiting_Shot:
			if(Not_Start == 1'b1)
				state <= Shot_State;
			else
				state <= Waiting_Shot;
				
		Shot_State:
				state <= Waiting_Not_Shot;
		
		Waiting_Not_Shot:
			if (Not_Start == 1'b1)
				state <= Waiting_Not_Shot;
			else 
				state <= Waiting_Shot;
		
		default:
				state <= Shot_State;

		endcase
	end
end//end always
/*------------------------------------------------------------------------------------------*/
/*Salida de control, proceso combintorio*/
always@(state) 
begin
	case(state)
		Waiting_Shot: 
			begin
				Shot_reg=1'b0;
			end

		Shot_State: 
			begin
				Shot_reg=1'b1;
			end
			
		Waiting_Not_Shot: 
			begin
				Shot_reg=1'b0;
			end

	default: 		
		begin 
				Shot_reg=1'b0;
		end
	endcase
end

assign Shot = Shot_reg;


endmodule




