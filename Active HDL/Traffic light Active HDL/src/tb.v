`timescale 1 ns / 1 ns
module Traffic_tb();
reg clk;
reg rst;
reg sa;
reg sb;
// initializing the clk signal with the unblocking assignment
wire cg, cy, cr, pg, pr;
initial clk <= 0;
always #5 clk <=~clk;
//-------------------------------------------
// initilizing rst signal with the blocking assignment to be one for just 5 ns and then back to zero
initial
begin
rst=1'b0;
#10
rst=1'b1;
#5
rst=1'b0;
end
//----------------------------------------------
//here we pass already 15 ns so we will wait 5 ns and then make posedge for sb and make it zero
//after 5ns again
initial
begin
sb=0;
#20
sb=1;
#10
sb=0;
#700
sb=1;
#20
sb=0;
end
//--------------------------------------------------
//we pass already 25 ns, so after 40 sec we will give posedge to sa
//@(posedge CLK)
initial
begin
sa=0;
#400
sa=1;
//@(posedge CLK)
#50
sa=0;
end
TrafficLight #(.SIM(1'b1)) inst(.CLK(clk), .RST(rst), .SensorA(sa), .SensorB(sb),
.CarGreen(cg) , .CarYellow(cy), .CarRed(cr), .PedGreen(pg), .PedRed(pr));
endmodule