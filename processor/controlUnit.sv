module controlUnit #(int lenUpCode = 3, int amountRegister = 8, int widthAddressRegister = 3)(input logic clock, reset, input logic[lenUpCode-1:0] instructorRegister,
																															input logic[widthAddressRegister-1:0] addressRegX, addressRegY,
																															output logic[amountRegister-1:0] selectRegisterWrite, output logic done, selectMuxOrResultUla,
																															output logic enableRegisterA, output logic[2:0] selectRegisterRead);

	enum logic[2:0] {mov = 3'b000, movi = 3'b001, add = 3'b010, sub = 3'b011, 
						  add2 = 3'b100, sub2 = 3'b101, initialState = 3'b110} upCode, actualState, nextState = initialState;

	always_ff@(posedge clock, negedge reset) begin:changeActualState
		if(!reset) begin
			actualState <= initialState;
		end
		else
			actualState <= nextState;
	end:changeActualState
	
	always_comb begin:setNextState
		unique case(actualState)
			initialState:begin
					if(instructorRegister == add) nextState = add;
					else if(instructorRegister == mov) nextState = mov;
					else if(instructorRegister == movi) nextState = movi;
					else if(instructorRegister == sub) nextState = sub;
					else nextState = initialState;
				end
			mov:begin 
					nextState = initialState;
				end
			movi:begin
					nextState = initialState;
				end
			add:begin
					nextState = add2;
				end
			add2:begin
					nextState = initialState;
				end
			sub:begin
					nextState = sub2;
				end
			sub2:begin
					nextState = initialState;
				end
		endcase
	end:setNextState
	
	always_comb begin:setOutPuts
		unique case(actualState)
			initialState:begin
					done = '1; //outStateMachine = initialState;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('0));
					selectMuxOrResultUla = '1;
					enableRegisterA = '0;
				end
			mov:begin
					done = '0;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('1));
					selectMuxOrResultUla = '0;
					enableRegisterA = '0;
				end
			movi:begin
					done = '0;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('1));
					selectMuxOrResultUla = '0;
					enableRegisterA = '0;
				end
			add:begin
					done = '0;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('0));
					selectMuxOrResultUla = '0;
					enableRegisterA = '1;
				end
			add2:begin
					done = '0;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('1));
					selectMuxOrResultUla = '0;
					enableRegisterA = '0;
				end
			sub:begin
					done = '1;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('0));
					selectMuxOrResultUla = '0;
					enableRegisterA = '1;
				end
			sub2:begin
					done = '1;
					selectRegisterWrite = decoder3To8(.writeInRegister(addressRegX), .enableDecoder('1));
					selectMuxOrResultUla = '0;
					enableRegisterA = '0;
				end
		endcase
	end:setOutPuts
	
	function automatic logic[0:7] decoder3To8(logic [2:0] writeInRegister, logic enableDecoder);
	logic[0:7] outDecoder;
	 if (enableDecoder == 1)
		 unique case (writeInRegister)
			 3'b000: outDecoder = 8'b10000000;
			 3'b001: outDecoder = 8'b01000000;
			 3'b010: outDecoder = 8'b00100000;
			 3'b011: outDecoder = 8'b00010000;
			 3'b100: outDecoder = 8'b00001000;
			 3'b101: outDecoder = 8'b00000100;
			 3'b110: outDecoder = 8'b00000010;
			 3'b111: outDecoder = 8'b00000001;
		 endcase
	 else
		outDecoder = '0;
	return outDecoder;
endfunction: decoder3To8
endmodule:controlUnit