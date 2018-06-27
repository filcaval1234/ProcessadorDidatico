module processor #(int dataWidth = 9)(input logic[dataWidth-1:0] DataAndInstructionInput, input logic resetn, clock, Run, output logic Done, output logic[dataWidth-1:0] BusWires, input logic[2:0] selectionMuxInput, writeInRegister);
//module processor(input logic [2:0] w, input logic Em, output logic[0:7] Y);
//module processor(input logic[2:0] state, output logic[8:0] testParam);
	logic[7:0][dataWidth-1:0] muxInput;
	logic[dataWidth-1:0] resultUla;
	
	logic[7:0] selectRegisterWrite;
	logic selectMuxOrResultUla;
	logic enableRegisterA;
	logic[dataWidth-1:0] A;
	logic[dataWidth-1:0] outputMux8To1, outputMux2To1;
	//unidade de controle
	controlUnit #(.lenUpCode(3), .amountRegister(8), .widthAddressRegister(3)) controlUnit_h (.clock(clock), .reset(resetn), .instructorRegister(DataAndInstructionInput[2:0]),
																															.addressRegX(DataAndInstructionInput[5:3]), .addressRegY(DataAndInstructionInput[8:6]), 
																															.selectRegisterWrite(selectRegisterWrite), .done(done), .selectMuxOrResultUla(selectMuxOrResultUla),
																															.enableRegisterA(enableRegisterA));
	
	//variaveis temporarias
	logic emableWriteInBus = '1;
	
	always_comb begin
		//outputMux8To1 = mux8To1(.inputsMux(muxInput), .selectionMuxInput(),enableMuxOutput);
		//outputMux2To1;
		resultUla = ula(.wordA(A), .wordB(BusWires), .selectFunctionUla(mov));
	end
	
	registerFactoryWithTriState #(dataWidth) ulaResultRegister(.date(resultUla), .registerEnable(selectMuxOrResultUla), .clock(clock), .dataOut(BusWires));
	
	registerFactory #(dataWidth) registerOfValueA (.date(BusWires), .registerEnable(enableRegisterA), .clock(clock), .dataOut(A));
		
	registerFactory #(dataWidth) reg1 (.date(BusWires), .registerEnable(selectRegisterWrite[0]), .clock(clock), .dataOut(muxInput[0]));
	registerFactory #(dataWidth) reg2 (.date(BusWires), .registerEnable(selectRegisterWrite[1]), .clock(clock), .dataOut(muxInput[1]));
	registerFactory #(dataWidth) reg3 (.date(BusWires), .registerEnable(selectRegisterWrite[2]), .clock(clock), .dataOut(muxInput[2]));
	registerFactory #(dataWidth) reg4 (.date(BusWires), .registerEnable(selectRegisterWrite[3]), .clock(clock), .dataOut(muxInput[3]));
	registerFactory #(dataWidth) reg5 (.date(BusWires), .registerEnable(selectRegisterWrite[4]), .clock(clock), .dataOut(muxInput[4]));
	registerFactory #(dataWidth) reg6 (.date(BusWires), .registerEnable(selectRegisterWrite[5]), .clock(clock), .dataOut(muxInput[5]));
	registerFactory #(dataWidth) reg7 (.date(BusWires), .registerEnable(selectRegisterWrite[6]), .clock(clock), .dataOut(muxInput[6]));
	registerFactory #(dataWidth) reg8 (.date(BusWires), .registerEnable(selectRegisterWrite[7]), .clock(clock), .dataOut(muxInput[7]));
	
	always_comb begin
			BusWires = mux8To1(.inputsMux(muxInput), .selectionMuxInput(selectionMuxInput), .enableMuxOutput(!selectMuxOrResultUla));
	end
	
endmodule
parameter dataWidth = 9;
enum logic[2:0] {mov,movi, add, sub} upCode;

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
	return outMux;
endfunction:mux8To1

function automatic logic[dataWidth-1:0] mux2To1(logic sel, logic[1:0][dataWidth-1:0] muxInput);
	logic[dataWidth-1:0] outputMux;
	unique case(sel)
		1'b0: outputMux = muxInput[0];
		1'b1: outputMux = muxInput[1];
	endcase
	return outputMux;
endfunction:mux2To1

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
