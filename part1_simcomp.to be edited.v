module simcomp1(clk,PC,IR,MBR,MAR);
 input clk;
 output PC,IR,MBR,MAR;
 reg [15:0]IR,MBR;
 reg [12:0]PC,MAR;
 reg [15:0]Memory[63:0];
 reg [2:0]state;
  reg [15:0]R[0:3];
 
 parameter load=3'b000, store= 3'b011, add=3'b100,sub=3'b111;
 //program
 initial begin
 Memory[10]=16'h3020;
 Memory[11]=16'h7021;
 Memory[12]=16'hB022;
 Memory[13]=16'h6023;
 //Data at byte address
 Memory[20]=16'd9;
 Memory[21]=16'd4;
 Memory[22]=16'd3;
 Memory[23]=16'd0;
 
 //set the program counter to the start of the program
 PC=10; state=0;
 end
 
 always @(posedge clk)
  begin 
   case(state)
    0:begin
	 PC <= MAR;
	 state = 1;
	 end
	1:begin //fetch the instruction from the memory
	  IR <=Memory[MAR];
	  PC<=PC+1;
	  state = 2;
	  end
	2:begin //instruction decode
	  MAR<= IR[11:0];
	  state =3;
	  end
	3:begin //operand fetch
	  state = 4;
	  case(IR[15:12])
	   load: MBR<= Memory[20];
	   add : MBR<= Memory[21];
	   store: MBR<= Memory[23];
	   sub: MBR<=Memory[22];
	  endcase
	  end
	4:begin//excute
	if (IR[15:12] == 4'h7) begin
	     R[IR[9:8]] <= MBR; //load
	   
		state=0;
	  end
	 else if (IR[15:12] == 4'h3) begin
	     R[IR[9:8]] <= R[IR[9:8]]+MBR; //ADD
	   
		state=0;
	  end
	  
	  else if (IR[15:12] == 4'hB) begin
	    Memory[MAR]= MBR; //Store
		state=0;
	  end
	  else if (IR[15:12] == 4'h6) begin
	     R[IR[9:8]] <= R[IR[9:8]]-MBR; //sub
		state=0;
	  end
	  end
	endcase
  end
 
 endmodule
 
  
	    
	