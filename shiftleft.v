/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module shiftleft(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   [4:0]sel;

wire	[24:0]s4,s3,s2,s1;

shiftleftby16	stage4(s4,DI,sel[4]);
shiftleftby8	stage3(s3,s4,sel[3]);
shiftleftby4	stage2(s2,s3,sel[2]);
shiftleftby2	stage1(s1,s2,sel[1]);
shiftleftby1	stage0(DO,s1,sel[0]);

endmodule

module shiftleftby1(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   sel;

assign DO = sel?{DI[23:0],1'b0}:DI;

endmodule

module shiftleftby2(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   sel;

assign DO = sel?{DI[22:0],2'b00}:DI;

endmodule

module shiftleftby4(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   sel;

assign DO = sel?{DI[20:0],4'h0}:DI;

endmodule

module shiftleftby8(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   sel;

assign DO = sel?{DI[16:0],8'h00}:DI;

endmodule

module shiftleftby16(DO,DI,sel);
output	[24:0]DO;
input   [24:0]DI;
input   sel;

assign DO = sel?{DI[8:0],16'h0000}:DI;

endmodule
