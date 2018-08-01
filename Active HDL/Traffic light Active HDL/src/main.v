 module TrafficLight (
input wire SensorA,
input wire SensorB,
output reg CarGreen,
output reg CarYellow,
output reg CarRed,
output reg PedGreen,
output reg PedRed,
input wire RST,
input wire CLK
);
localparam WAIT_SensorB = 0, CY1= 1, SET_C=2, DECR_C=3, CRPG=4, SET_C2=5,
DECR_C2=6, WAIT_SensorA=7, PR=8, SET_C3=9, DECR_C3=10, CY2=11,
SET_C4=12, DECR_C4=13, CG=14, SET_C5=15, DECR_C5=16;
reg [31:0] C;
reg [4:0] state, next_state;
//--------------------------------------------------
always@(posedge CLK or posedge RST)
if (RST) state <= WAIT_SensorB;
else state <= next_state;
always @ (*)
begin
case (state)
WAIT_SensorB : if (SensorB) next_state <= CY1;
else next_state <= WAIT_SensorB;
CY1 : next_state <= SET_C;
SET_C : next_state <= DECR_C;
DECR_C : if (C==0) next_state <= CRPG;
else next_state <= DECR_C;
CRPG : next_state <=SET_C2;
SET_C2: next_state <= DECR_C2;
DECR_C2: if (C==0) next_state <= WAIT_SensorA;
else next_state <= DECR_C2;
WAIT_SensorA : if (SensorA) next_state <= PR;
else next_state <= WAIT_SensorA;
PR: next_state <= SET_C3;
SET_C3: next_state <= DECR_C3;
DECR_C3 : if (C==0) next_state <= CY2;
	else next_state <= DECR_C3;
CY2 : next_state <= SET_C4;
SET_C4 : next_state <= DECR_C4;
DECR_C4 : if (C==0) next_state <= CG;
else next_state <= DECR_C4;
CG : next_state <= SET_C5;
SET_C5 : next_state <= DECR_C5;
DECR_C5 : if (C==0) next_state <= WAIT_SensorB;
else next_state <= DECR_C5;
default: next_state <= WAIT_SensorB;
endcase
end
//--------------------------------------------------------------------------
parameter SIM = 1'b0;
always@(posedge CLK or posedge RST)
if(RST) C <=0;
else if (next_state==SET_C) C<=(SIM==1'b0)?32'hEE6B280 : 32'd5;//1;
else if (next_state==DECR_C) C <=C-32'd1;
else if (next_state==SET_C2) C<=(SIM==1'b0)?32'h59682F00: 32'd5;
else if (next_state==DECR_C2) C <=C-32'd1;
else if (next_state == SET_C3) C <=(SIM==1'b0)?32'hEE68280:32'd5;
else if (next_state==DECR_C3) C<=C-32'd1;
else if (next_state==SET_C4) C<=(SIM==1'b0)?32'h8f0D180:32'd5;
else if (next_state==DECR_C4) C<=C-32'd1;
else if (next_state==SET_C5) C <=(SIM==1'b0)? 32'h59682F00:32'd5;
else if (next_state==DECR_C5) C<=C-32'd1;
else C<=C;
//-------------------------------------------------------------------------
always@(posedge CLK or posedge RST)
if (RST)
begin CarGreen<=0;
CarYellow<=0;
CarRed<=0;
PedGreen<=0;
PedRed<=0; end
else if (next_state==CY1) begin CarYellow <= 1; PedGreen<=0; PedRed<=1; CarRed
<=0; CarGreen <=0 ;end
else if (next_state==CRPG)begin CarRed <=1; PedGreen<=1; CarYellow<=0; PedRed<=0;
CarGreen<=0 ; end
else if (next_state==PR) begin PedRed <=1; PedGreen <=0;CarRed<=0; CarYellow<=0;
CarGreen<=0 ; end
else if (next_state==CY2) begin CarYellow <= 1; PedGreen<=0; PedRed<=1; CarRed
<=0; CarGreen <=0; end
else if (next_state==CG) begin CarYellow <=0; PedGreen<=0; PedRed<=1; CarRed <=0;
CarGreen <=1
; end
//------------------------------------------------------------
endmodule