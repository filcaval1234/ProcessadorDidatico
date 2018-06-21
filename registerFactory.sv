module registerFactory #(int dataWidth = 9)(input logic[dataWidth-1:0] date, input logic registerEnable, input logic clock, output logic[dataWidth-1:0] dataOut); 
 always_ff @(posedge clock)
	if (registerEnable)
		dataOut <= date;
endmodule:registerFactory