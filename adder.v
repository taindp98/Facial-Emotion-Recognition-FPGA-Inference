/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Nov 14th, 2018
*/
module adder6(Cout,S,A,B);
output [5:0]S;
output	Cout;
input  [5:0]A,B;

wire   [5:0]g,p;
wire   [5:0]c;

wire   [1:0]g_s01;
wire   [1:0]p_s01;
wire   [1:0]c_s02;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);
and	and3(g[3],A[3],B[3]);
and	and4(g[4],A[4],B[4]);
and	and5(g[5],A[5],B[5]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);
xor	xor3(p[3],A[3],B[3]);
xor	xor4(p[4],A[4],B[4]);
xor	xor5(p[5],A[5],B[5]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb2	   s0104(g_s01[1],p_s01[1],c[5:4],g[5:4],p[5:4],c_s02[1]);	

clb2 	   s0200(Cout,,c_s02,g_s01,p_s01,1'b0);

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);
xor	p_xor3(S[3],p[3],c[3]);
xor	p_xor4(S[4],p[4],c[4]);
xor	p_xor5(S[5],p[5],c[5]);

endmodule

module adder8(S,A,B);
output [7:0]S;
input  [7:0]A,B;

wire   [7:0]g,p;
wire   [7:0]c;

wire   [1:0]g_s01;
wire   [1:0]p_s01;
wire   [1:0]c_s02;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);
and	and3(g[3],A[3],B[3]);
and	and4(g[4],A[4],B[4]);
and	and5(g[5],A[5],B[5]);
and	and6(g[6],A[6],B[6]);
and	and7(g[7],A[7],B[7]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);
xor	xor3(p[3],A[3],B[3]);
xor	xor4(p[4],A[4],B[4]);
xor	xor5(p[5],A[5],B[5]);
xor	xor6(p[6],A[6],B[6]);
xor	xor7(p[7],A[7],B[7]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	

clb2 	   s0200(,,c_s02,g_s01,p_s01,1'b0);

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);
xor	p_xor3(S[3],p[3],c[3]);
xor	p_xor4(S[4],p[4],c[4]);
xor	p_xor5(S[5],p[5],c[5]);
xor	p_xor6(S[6],p[6],c[6]);
xor	p_xor7(S[7],p[7],c[7]);

endmodule

module adder9(S,A,B);
output [8:0]S;
input  [8:0]A,B;

wire   [8:0]g,p;
wire   [8:0]c;

wire   [1:0]g_s01;
wire   [1:0]p_s01;
wire   [1:0]c_s02;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);
and	and3(g[3],A[3],B[3]);
and	and4(g[4],A[4],B[4]);
and	and5(g[5],A[5],B[5]);
and	and6(g[6],A[6],B[6]);
and	and7(g[7],A[7],B[7]);
and	and8(g[8],A[8],B[8]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);
xor	xor3(p[3],A[3],B[3]);
xor	xor4(p[4],A[4],B[4]);
xor	xor5(p[5],A[5],B[5]);
xor	xor6(p[6],A[6],B[6]);
xor	xor7(p[7],A[7],B[7]);
xor 	xor8(p[8],A[8],B[8]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	

clb3 	   s0200(,,{c[8],c_s02},{g[8],g_s01},{p[8],p_s01},1'b0);

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);
xor	p_xor3(S[3],p[3],c[3]);
xor	p_xor4(S[4],p[4],c[4]);
xor	p_xor5(S[5],p[5],c[5]);
xor	p_xor6(S[6],p[6],c[6]);
xor	p_xor7(S[7],p[7],c[7]);
xor	p_xor8(S[8],p[8],c[8]);

endmodule

module adder10(S,A,B);
output [9:0]S;
input  [9:0]A,B;

wire   [9:0]g,p;
wire   [9:0]c;

wire   [2:0]g_s01;
wire   [2:0]p_s01;
wire   [2:0]c_s02;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);
and	and3(g[3],A[3],B[3]);
and	and4(g[4],A[4],B[4]);
and	and5(g[5],A[5],B[5]);
and	and6(g[6],A[6],B[6]);
and	and7(g[7],A[7],B[7]);
and	and8(g[8],A[8],B[8]);
and	and9(g[9],A[9],B[9]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);
xor	xor3(p[3],A[3],B[3]);
xor	xor4(p[4],A[4],B[4]);
xor	xor5(p[5],A[5],B[5]);
xor	xor6(p[6],A[6],B[6]);
xor	xor7(p[7],A[7],B[7]);
xor 	xor8(p[8],A[8],B[8]);
xor 	xor9(p[9],A[9],B[9]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	
clb2	   s0108(g_s01[2],p_s01[2],c[9:8],g[9:8],p[9:8],c_s02[2]);	

clb3 	   s0200(,,c_s02,g_s01,p_s01,1'b0);

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);
xor	p_xor3(S[3],p[3],c[3]);
xor	p_xor4(S[4],p[4],c[4]);
xor	p_xor5(S[5],p[5],c[5]);
xor	p_xor6(S[6],p[6],c[6]);
xor	p_xor7(S[7],p[7],c[7]);
xor	p_xor8(S[8],p[8],c[8]);
xor	p_xor9(S[9],p[9],c[9]);

endmodule

module adder12(Cout,S,A,B);
output [11:0]S;
output	Cout;
input  [11:0]A,B;

wire   [11:0]g,p;
wire   [11:0]c;

wire   [2:0]g_s01;
wire   [2:0]p_s01;
wire   [2:0]c_s02;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);
and	and3(g[3],A[3],B[3]);
and	and4(g[4],A[4],B[4]);
and	and5(g[5],A[5],B[5]);
and	and6(g[6],A[6],B[6]);
and	and7(g[7],A[7],B[7]);
and	and8(g[8],A[8],B[8]);
and	and9(g[9],A[9],B[9]);
and	and10(g[10],A[10],B[10]);
and	and11(g[11],A[11],B[11]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);
xor	xor3(p[3],A[3],B[3]);
xor	xor4(p[4],A[4],B[4]);
xor	xor5(p[5],A[5],B[5]);
xor	xor6(p[6],A[6],B[6]);
xor	xor7(p[7],A[7],B[7]);
xor 	xor8(p[8],A[8],B[8]);
xor 	xor9(p[9],A[9],B[9]);
xor 	xor10(p[10],A[10],B[10]);
xor 	xor11(p[11],A[11],B[11]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	
clb	   s0108(g_s01[2],p_s01[2],c[11:8],g[11:8],p[11:8],c_s02[2]);	

clb3 	   s0200(Cout,,c_s02,g_s01,p_s01,1'b0);

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);
xor	p_xor3(S[3],p[3],c[3]);
xor	p_xor4(S[4],p[4],c[4]);
xor	p_xor5(S[5],p[5],c[5]);
xor	p_xor6(S[6],p[6],c[6]);
xor	p_xor7(S[7],p[7],c[7]);
xor	p_xor8(S[8],p[8],c[8]);
xor	p_xor9(S[9],p[9],c[9]);
xor	p_xor10(S[10],p[10],c[10]);
xor	p_xor11(S[11],p[11],c[11]);

endmodule

module adder24(Cout,S,A,B);
output [23:0]S;
output	Cout;
input  [23:0]A,B;

wire   [23:0]g,p;
wire   [23:0]c;

wire   [5:0]g_s01;
wire   [5:0]p_s01;
wire   [1:0]g_s02;
wire   [1:0]p_s02;
wire   [5:0]c_s02;
wire   [1:0]c_s03;	

//Preprocessing
and a0(g[0],A[0],B[0]);
and a1(g[1],A[1],B[1]);
and a2(g[2],A[2],B[2]);
and a3(g[3],A[3],B[3]);
and a4(g[4],A[4],B[4]);
and a5(g[5],A[5],B[5]);
and a6(g[6],A[6],B[6]);
and a7(g[7],A[7],B[7]);
and a8(g[8],A[8],B[8]);
and a9(g[9],A[9],B[9]);
and a10(g[10],A[10],B[10]);
and a11(g[11],A[11],B[11]);
and a12(g[12],A[12],B[12]);
and a13(g[13],A[13],B[13]);
and a14(g[14],A[14],B[14]);
and a15(g[15],A[15],B[15]);
and a16(g[16],A[16],B[16]);
and a17(g[17],A[17],B[17]);
and a18(g[18],A[18],B[18]);
and a19(g[19],A[19],B[19]);
and a20(g[20],A[20],B[20]);
and a21(g[21],A[21],B[21]);
and a22(g[22],A[22],B[22]);
and a23(g[23],A[23],B[23]);

xor x0(p[0],A[0],B[0]);
xor x1(p[1],A[1],B[1]);
xor x2(p[2],A[2],B[2]);
xor x3(p[3],A[3],B[3]);
xor x4(p[4],A[4],B[4]);
xor x5(p[5],A[5],B[5]);
xor x6(p[6],A[6],B[6]);
xor x7(p[7],A[7],B[7]);
xor x8(p[8],A[8],B[8]);
xor x9(p[9],A[9],B[9]);
xor x10(p[10],A[10],B[10]);
xor x11(p[11],A[11],B[11]);
xor x12(p[12],A[12],B[12]);
xor x13(p[13],A[13],B[13]);
xor x14(p[14],A[14],B[14]);
xor x15(p[15],A[15],B[15]);
xor x16(p[16],A[16],B[16]);
xor x17(p[17],A[17],B[17]);
xor x18(p[18],A[18],B[18]);
xor x19(p[19],A[19],B[19]);
xor x20(p[20],A[20],B[20]);
xor x21(p[21],A[21],B[21]);
xor x22(p[22],A[22],B[22]);
xor x23(p[23],A[23],B[23]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	
clb	   s0108(g_s01[2],p_s01[2],c[11:8],g[11:8],p[11:8],c_s02[2]);
clb	   s0112(g_s01[3],p_s01[3],c[15:12],g[15:12],p[15:12],c_s02[3]);
clb	   s0116(g_s01[4],p_s01[4],c[19:16],g[19:16],p[19:16],c_s02[4]);
clb	   s0120(g_s01[5],p_s01[5],c[23:20],g[23:20],p[23:20],c_s02[5]);

clb 	   s0203(g_s02[0],p_s02[0],c_s02[3:0],g_s01[3:0],p_s01[3:0],c_s03[0]);
clb2       s0219(g_s02[1],p_s02[1],c_s02[5:4],g_s01[5:4],p_s01[5:4],c_s03[1]);

clb2 	   s0300(Cout,,c_s03,g_s02,p_s02,1'b0);

//Postprocessing
xor px0(S[0],p[0],c[0]);
xor px1(S[1],p[1],c[1]);
xor px2(S[2],p[2],c[2]);
xor px3(S[3],p[3],c[3]);
xor px4(S[4],p[4],c[4]);
xor px5(S[5],p[5],c[5]);
xor px6(S[6],p[6],c[6]);
xor px7(S[7],p[7],c[7]);
xor px8(S[8],p[8],c[8]);
xor px9(S[9],p[9],c[9]);
xor px10(S[10],p[10],c[10]);
xor px11(S[11],p[11],c[11]);
xor px12(S[12],p[12],c[12]);
xor px13(S[13],p[13],c[13]);
xor px14(S[14],p[14],c[14]);
xor px15(S[15],p[15],c[15]);
xor px16(S[16],p[16],c[16]);
xor px17(S[17],p[17],c[17]);
xor px18(S[18],p[18],c[18]);
xor px19(S[19],p[19],c[19]);
xor px20(S[20],p[20],c[20]);
xor px21(S[21],p[21],c[21]);
xor px22(S[22],p[22],c[22]);
xor px23(S[23],p[23],c[23]);

endmodule

module adder25(S,A,B);
output [24:0]S;
input  [24:0]A,B;

wire   [24:0]g,p;
wire   [24:0]c;

wire   [5:0]g_s01;
wire   [5:0]p_s01;
wire   [1:0]g_s02;
wire   [1:0]p_s02;
wire   [5:0]c_s02;
wire   [1:0]c_s03;	

//Preprocessing
and a0(g[0],A[0],B[0]);
and a1(g[1],A[1],B[1]);
and a2(g[2],A[2],B[2]);
and a3(g[3],A[3],B[3]);
and a4(g[4],A[4],B[4]);
and a5(g[5],A[5],B[5]);
and a6(g[6],A[6],B[6]);
and a7(g[7],A[7],B[7]);
and a8(g[8],A[8],B[8]);
and a9(g[9],A[9],B[9]);
and a10(g[10],A[10],B[10]);
and a11(g[11],A[11],B[11]);
and a12(g[12],A[12],B[12]);
and a13(g[13],A[13],B[13]);
and a14(g[14],A[14],B[14]);
and a15(g[15],A[15],B[15]);
and a16(g[16],A[16],B[16]);
and a17(g[17],A[17],B[17]);
and a18(g[18],A[18],B[18]);
and a19(g[19],A[19],B[19]);
and a20(g[20],A[20],B[20]);
and a21(g[21],A[21],B[21]);
and a22(g[22],A[22],B[22]);
and a23(g[23],A[23],B[23]);
and a24(g[24],A[24],B[24]);

xor x0(p[0],A[0],B[0]);
xor x1(p[1],A[1],B[1]);
xor x2(p[2],A[2],B[2]);
xor x3(p[3],A[3],B[3]);
xor x4(p[4],A[4],B[4]);
xor x5(p[5],A[5],B[5]);
xor x6(p[6],A[6],B[6]);
xor x7(p[7],A[7],B[7]);
xor x8(p[8],A[8],B[8]);
xor x9(p[9],A[9],B[9]);
xor x10(p[10],A[10],B[10]);
xor x11(p[11],A[11],B[11]);
xor x12(p[12],A[12],B[12]);
xor x13(p[13],A[13],B[13]);
xor x14(p[14],A[14],B[14]);
xor x15(p[15],A[15],B[15]);
xor x16(p[16],A[16],B[16]);
xor x17(p[17],A[17],B[17]);
xor x18(p[18],A[18],B[18]);
xor x19(p[19],A[19],B[19]);
xor x20(p[20],A[20],B[20]);
xor x21(p[21],A[21],B[21]);
xor x22(p[22],A[22],B[22]);
xor x23(p[23],A[23],B[23]);
xor x24(p[24],A[24],B[24]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	
clb	   s0108(g_s01[2],p_s01[2],c[11:8],g[11:8],p[11:8],c_s02[2]);
clb	   s0112(g_s01[3],p_s01[3],c[15:12],g[15:12],p[15:12],c_s02[3]);
clb	   s0116(g_s01[4],p_s01[4],c[19:16],g[19:16],p[19:16],c_s02[4]);
clb	   s0120(g_s01[5],p_s01[5],c[23:20],g[23:20],p[23:20],c_s02[5]);

clb 	   s0203(g_s02[0],p_s02[0],c_s02[3:0],g_s01[3:0],p_s01[3:0],c_s03[0]);
clb3       s0219(g_s02[1],p_s02[1],{c[24],c_s02[5:4]},{g[24],g_s01[5:4]},{p[24],p_s01[5:4]},c_s03[1]);

clb2 	   s0300(,,c_s03,g_s02,p_s02,1'b0);

//Postprocessing
xor px0(S[0],p[0],c[0]);
xor px1(S[1],p[1],c[1]);
xor px2(S[2],p[2],c[2]);
xor px3(S[3],p[3],c[3]);
xor px4(S[4],p[4],c[4]);
xor px5(S[5],p[5],c[5]);
xor px6(S[6],p[6],c[6]);
xor px7(S[7],p[7],c[7]);
xor px8(S[8],p[8],c[8]);
xor px9(S[9],p[9],c[9]);
xor px10(S[10],p[10],c[10]);
xor px11(S[11],p[11],c[11]);
xor px12(S[12],p[12],c[12]);
xor px13(S[13],p[13],c[13]);
xor px14(S[14],p[14],c[14]);
xor px15(S[15],p[15],c[15]);
xor px16(S[16],p[16],c[16]);
xor px17(S[17],p[17],c[17]);
xor px18(S[18],p[18],c[18]);
xor px19(S[19],p[19],c[19]);
xor px20(S[20],p[20],c[20]);
xor px21(S[21],p[21],c[21]);
xor px22(S[22],p[22],c[22]);
xor px23(S[23],p[23],c[23]);
xor px24(S[24],p[24],c[24]);

endmodule

module adder26(S,A,B);
output [25:0]S;
input  [25:0]A,B;

wire   [25:0]g,p;
wire   [25:0]c;

wire   [6:0]g_s01;
wire   [6:0]p_s01;
wire   [1:0]g_s02;
wire   [1:0]p_s02;
wire   [6:0]c_s02;
wire   [1:0]c_s03;	

//Preprocessing
and a0(g[0],A[0],B[0]);
and a1(g[1],A[1],B[1]);
and a2(g[2],A[2],B[2]);
and a3(g[3],A[3],B[3]);
and a4(g[4],A[4],B[4]);
and a5(g[5],A[5],B[5]);
and a6(g[6],A[6],B[6]);
and a7(g[7],A[7],B[7]);
and a8(g[8],A[8],B[8]);
and a9(g[9],A[9],B[9]);
and a10(g[10],A[10],B[10]);
and a11(g[11],A[11],B[11]);
and a12(g[12],A[12],B[12]);
and a13(g[13],A[13],B[13]);
and a14(g[14],A[14],B[14]);
and a15(g[15],A[15],B[15]);
and a16(g[16],A[16],B[16]);
and a17(g[17],A[17],B[17]);
and a18(g[18],A[18],B[18]);
and a19(g[19],A[19],B[19]);
and a20(g[20],A[20],B[20]);
and a21(g[21],A[21],B[21]);
and a22(g[22],A[22],B[22]);
and a23(g[23],A[23],B[23]);
and a24(g[24],A[24],B[24]);
and a25(g[25],A[25],B[25]);

xor x0(p[0],A[0],B[0]);
xor x1(p[1],A[1],B[1]);
xor x2(p[2],A[2],B[2]);
xor x3(p[3],A[3],B[3]);
xor x4(p[4],A[4],B[4]);
xor x5(p[5],A[5],B[5]);
xor x6(p[6],A[6],B[6]);
xor x7(p[7],A[7],B[7]);
xor x8(p[8],A[8],B[8]);
xor x9(p[9],A[9],B[9]);
xor x10(p[10],A[10],B[10]);
xor x11(p[11],A[11],B[11]);
xor x12(p[12],A[12],B[12]);
xor x13(p[13],A[13],B[13]);
xor x14(p[14],A[14],B[14]);
xor x15(p[15],A[15],B[15]);
xor x16(p[16],A[16],B[16]);
xor x17(p[17],A[17],B[17]);
xor x18(p[18],A[18],B[18]);
xor x19(p[19],A[19],B[19]);
xor x20(p[20],A[20],B[20]);
xor x21(p[21],A[21],B[21]);
xor x22(p[22],A[22],B[22]);
xor x23(p[23],A[23],B[23]);
xor x24(p[24],A[24],B[24]);
xor x25(p[25],A[25],B[25]);

//Processing
clb        s0100(g_s01[0],p_s01[0],c[3:0],g[3:0],p[3:0],c_s02[0]);	
clb	   s0104(g_s01[1],p_s01[1],c[7:4],g[7:4],p[7:4],c_s02[1]);	
clb	   s0108(g_s01[2],p_s01[2],c[11:8],g[11:8],p[11:8],c_s02[2]);
clb	   s0112(g_s01[3],p_s01[3],c[15:12],g[15:12],p[15:12],c_s02[3]);
clb	   s0116(g_s01[4],p_s01[4],c[19:16],g[19:16],p[19:16],c_s02[4]);
clb	   s0120(g_s01[5],p_s01[5],c[23:20],g[23:20],p[23:20],c_s02[5]);
clb2	   s0124(g_s01[6],p_s01[6],c[25:24],g[25:24],p[25:24],c_s02[6]);

clb 	   s0203(g_s02[0],p_s02[0],c_s02[3:0],g_s01[3:0],p_s01[3:0],c_s03[0]);
clb3       s0219(g_s02[1],p_s02[1],c_s02[6:4],g_s01[6:4],p_s01[6:4],c_s03[1]);

clb2 	   s0300(,,c_s03,g_s02,p_s02,1'b0);

//Postprocessing
xor px0(S[0],p[0],c[0]);
xor px1(S[1],p[1],c[1]);
xor px2(S[2],p[2],c[2]);
xor px3(S[3],p[3],c[3]);
xor px4(S[4],p[4],c[4]);
xor px5(S[5],p[5],c[5]);
xor px6(S[6],p[6],c[6]);
xor px7(S[7],p[7],c[7]);
xor px8(S[8],p[8],c[8]);
xor px9(S[9],p[9],c[9]);
xor px10(S[10],p[10],c[10]);
xor px11(S[11],p[11],c[11]);
xor px12(S[12],p[12],c[12]);
xor px13(S[13],p[13],c[13]);
xor px14(S[14],p[14],c[14]);
xor px15(S[15],p[15],c[15]);
xor px16(S[16],p[16],c[16]);
xor px17(S[17],p[17],c[17]);
xor px18(S[18],p[18],c[18]);
xor px19(S[19],p[19],c[19]);
xor px20(S[20],p[20],c[20]);
xor px21(S[21],p[21],c[21]);
xor px22(S[22],p[22],c[22]);
xor px23(S[23],p[23],c[23]);
xor px24(S[24],p[24],c[24]);
xor px25(S[25],p[25],c[25]);

endmodule
