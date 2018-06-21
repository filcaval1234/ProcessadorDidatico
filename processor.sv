module processor #(int dataWidth = 9)(input logic[dataWidth-1:0] DataAndInstructionInput, input logic resetn, clock, Run, output logic Done, output logic[dataWidth-1:0] BusWires, input logic[2:0] selectionMuxInput, writeInRegister, input logic[dataWidth-1:0] a,b);
//module processor(input logic [2:0] w, input logic Em, output logic[0:7] Y);
//module processor(input logic[2:0] state, output logic[8:0] testParam);
	logic[7:0][dataWidth-1:0] muxInput;
	logic[0:7] selectRegister;
	logic[dataWidth-1:0] resultUla;
	
	//variaveis temporarias
	logic emableWriteInBus = '1;
	
	always_comb begin
		resultUla = ula(.wordA(a), .wordB(b), .selectFunctionUla(mov));
	end
	
	always_comb begin
		selectRegister = decoder3To8(.writeInRegister(writeInRegister),.enableDecoder(1'b0));
	end
	
	registerFactoryWithTriState #(dataWidth) ulaResultRegister(.date(resultUla), .registerEnable(emableWriteInBus), .clock(clock), .dataOut(BusWires));
	
	registerFactory #(dataWidth) reg1 (.date(DataAndInstructionInput), .registerEnable(selectRegister[0]), .clock(clock), .dataOut(muxInput[0]));
	registerFactory #(dataWidth) reg2 (.date(DataAndInstructionInput), .registerEnable(selectRegister[1]), .clock(clock), .dataOut(muxInput[1]));
	registerFactory #(dataWidth) reg3 (.date(DataAndInstructionInput), .registerEnable(selectRegister[2]), .clock(clock), .dataOut(muxInput[2]));
	registerFactory #(dataWidth) reg4 (.date(DataAndInstructionInput), .registerEnable(selectRegister[3]), .clock(clock), .dataOut(muxInput[3]));
	registerFactory #(dataWidth) reg5 (.date(DataAndInstructionInput), .registerEnable(selectRegister[4]), .clock(clock), .dataOut(muxInput[4]));
	registerFactory #(dataWidth) reg6 (.date(DataAndInstructionInput), .registerEnable(selectRegister[5]), .clock(clock), .dataOut(muxInput[5]));
	registerFactory #(dataWidth) reg7 (.date(DataAndInstructionInput), .registerEnable(selectRegister[6]), .clock(clock), .dataOut(muxInput[6]));
	registerFactory #(dataWidth) reg8 (.date(DataAndInstructionInput), .registerEnable(selectRegister[7]), .clock(clock), .dataOut(muxInput[7]));
	
	always_ff @(posedge clock) begin
			BusWires <= mux8To1(.inputsMux(muxInput), .selectionMuxInput(selectionMuxInput), .enableMuxOutput(!emableWriteInBus));
	end
	
endmodule
parameter dataWidth = 9;
enum logic[2:0] {mov,movi, add, sub} upCode;

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

function automatic logic[dataWidth-1:0] mux8To1(logic[7:0][dataWidth-1:0] inputsMux, logic[2:0] selectionMuxInput, logic enableMuxOutput);
	enum logic [2:0] {inputA, inputB, inputC,inputD,inputE,inputF,inputG,inputH} inputMux;
	logic[dataWidth-1:0] outMux;
	if(enableMuxOutput)
		unique case(selectionMuxInput)
			inputA: outMux = inputsMux[0];
			inputB: outMux = inputsMux[1];
			inputC: outMux = inputsMux[2];
			inputD: outMux = inputsMux[3];
			inputE: outMux = inputsMux[4];
			inputF: outMux = inputsMux[5];
			inputG: outMux = inputsMux[6];
			inputH: outMux = inputsMux[7];
		endcase
	else
		outMux = 'z;
	return outMux;
endfunction:mux8To1

function automatic logic[dataWidth-1:0] ula (logic[dataWidth-1:0] wordA, wordB, logic[2:0] selectFunctionUla);
	logic[dataWidth-1:0] outUla;
	unique case(selectFunctionUla)
		mov: outUla = wordB;
		movi: outUla = wordA + wordB;
		add: outUla = wordA + wordB;
		sub: outUla = wordA - wordB;
	endcase
	return outUla;
endfunction:ula
