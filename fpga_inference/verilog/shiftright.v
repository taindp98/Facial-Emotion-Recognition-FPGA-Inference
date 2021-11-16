/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module shiftright(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   [4:0]sel;

wire	[23:0]s4,s3,s2,s1;

shiftrightby16	stage4(s4,DI,sel[4]);
shiftrightby8	stage3(s3,s4,sel[3]);
shiftrightby4	stage2(s2,s3,sel[2]);
shiftrightby2	stage1(s1,s2,sel[1]);
shiftrightby1	stage0(DO,s1,sel[0]);

endmodule

module shiftrightby1(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   sel;

assign DO = sel?{1'b0,DI[23:1]}:DI;

endmodule

module shiftrightby2(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   sel;

assign DO = sel?{2'b00,DI[23:2]}:DI;

endmodule

module shiftrightby4(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   sel;

assign DO = sel?{4'h0,DI[23:4]}:DI;

endmodule

module shiftrightby8(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   sel;

assign DO = sel?{8'h00,DI[23:8]}:DI;

endmodule

module shiftrightby16(DO,DI,sel);
output	[23:0]DO;
input   [23:0]DI;
input   sel;

assign DO = sel?{16'h0000,DI[23:16]}:DI;

endmodule
