module controlUnit#(int dataWidth = 9)(input logic clock, reset, input logic[dataWidth-1:0] InstructorRegister,output logic[15:0] outStateMachine, output logic done);

	enum logic[3:0] {mov = 4'b0000, movi = 4'b0001, add = 4'b0010, sub = 4'b0011, mov2 = 4'b0100, movi2 = 4'b0101, 
						  add2 = 4'b0111, add3 = 4'b100, sub2 = 4'b1011, sub3 = 4'b1100, initialState =4'b1101} upCode, actualState, nextState;

	always_ff@(posedge clock, negedge reset) begin:changeState
		if(!reset) begin
			done <= '0;
			actualState <= initialState;
		end
		else
			actualState = nextState;
	end:changeState
	
	always_comb begin:behavior
		unique case(actualState)
			mov:begin 
					outStateMachine = mov;
					nextState = mov2;
				end
			mov2:begin
					outStateMachine = mov2;
					nextState = initialState;
				end
			movi:begin
					outStateMachine = movi2;
					nextState = initialState;
				end
			movi2:begin
					outStateMachine = movi2;
					nextState = initialState;
				end
		endcase
	end:behavior
endmodule:controlUnit