//module processor(input logic [2:0] w, input logic Em, output logic[0:7] Y);
module processor(input logic[2:0] state, output logic[8:0]);
 /*parameter T0 = 2’b00, T1 = 2’b01, T2 = 2’b10, T3 = 2’b11;
 assign I = IR[1:3];
 dec3to8 decX (IR[4:6], 1’b1, Xreg);
 dec3to8 decY (IR[7:9], 1’b1, Yreg);
 

 // Controle de estados do FSM
 always @(Tstep_Q, Run, Done)
 begin
 case (Tstep_Q)
 T0: // Os dados são carregados no IR nesse passo
 if (!Run) Tstep_D = T0;
 else Tstep_D = T1;
 T1: . . .
 endcase
 end


 // Controle das saídas da FSM
 always @(Tstep_Q or I or Xreg or Yreg)
 begin
 . . . especifique os valores iniciais
 case (Tstep_Q)
 T0: // Armazene DIN no registrador IR no passo 0
 begin
 IRin = 1’b1;
 end

 T1: // Defina os sinais do passo 1
 case (I)
 . . .
 endcase

 T2: // Defina os sinais do passo 2
 case (I)
 . . .
 endcase

 T3: // Defina os sinais do passo 3
 case (I)
 . . .
 endcase
 endcase
 end

 // Controle os flip-flops do FSM
 always @(posedge Clock, negedge Resetn)
 if (!Resetn)
 . . .
 regn reg_0 (BusWires, Rin[0], Clock, R0);
 . . . Instancie outros registradores e o somador/subtrator
 . . . definição do barramento*/

 always_comb begin
	Y = decoder3To8(w,Em);
 end
endmodule

function automatic logic[0:7] decoder3To8(input logic [2:0] W, input logic En);
	logic[0:7] Y;
	 if (En == 1)
		 unique case (W)
			 3'b000: Y = 8'b10000000;
			 3'b001: Y = 8'b01000000;
			 3'b010: Y = 8'b00100000;
			 3'b011: Y = 8'b00010000;
			 3'b100: Y = 8'b00001000;
			 3'b101: Y = 8'b00000100;
			 3'b110: Y = 8'b00000010;
			 3'b111: Y = 8'b00000001;
		 endcase
	 else
		Y = 8'b00000000;
	return Y;
endfunction: decoder3To8


function automatic void finiteStateMachine(input logic[2:0] state);
	enum logic[2:0] {mov, movi,add, sub} upCode;
	logic [9:0] testParam;
	unique case(state)
		add: testParam = 0;
		sub: testParam = 0;
		mov: testParam = 0;
		movi: testParam = 0;
		default: testParam = 0;
	endcase
endfunction:finiteStateMachine

/*module regn(R, Rin, Clock, Q);
 parameter n = 9;
 input [n-1:0] R;
 input Rin, Clock;
 output [n-1:0] Q;
 reg [n-1:0] Q;
 
 always @(posedge Clock)
 if (Rin)
 Q <= R;
endmodule*/