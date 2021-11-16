/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Nov 14th, 2018
*/

module adder3(S,Cout,A,B);
output [2:0]S;
output	Cout;
input  [2:0]A,B;

wire   [3:0]g,p;
wire   [3:0]c;

//Preadder   
and	and0(g[0],A[0],B[0]);
and	and1(g[1],A[1],B[1]);		
and	and2(g[2],A[2],B[2]);

xor	xor0(p[0],A[0],B[0]);
xor	xor1(p[1],A[1],B[1]);		
xor	xor2(p[2],A[2],B[2]);

//Processing
clb3    s0100(Cout,,c[2:0],g[2:0],p[2:0],0);	

//Postadder  
xor	p_xor0(S[0],p[0],c[0]);
xor	p_xor1(S[1],p[1],c[1]);		
xor	p_xor2(S[2],p[2],c[2]);

endmodule
