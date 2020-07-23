/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module compare_exp(numbershift,LT,A,B);
output [4:0]numbershift;
output LT;
input  [7:0]A,B;

wire   [8:0]tempB;
wire   [8:0]extA,extB;

wire   [7:0]cpl_exp_dif,exp_dif,temp_shift;
wire	checknumbershift;

assign  extA={1'b0,A};
assign  tempB={1'b0,B};

cpl9	cpl_B(extB,tempB);

adder9  addA_extB({LT,exp_dif},extA,extB);
cpl8    cp2_exp_dif(.out(cpl_exp_dif),.in(exp_dif));

assign temp_shift=LT?cpl_exp_dif:exp_dif;
	//checknumbershift = 1 if temp_shift>=24
assign checknumbershift=temp_shift[7]|temp_shift[6]|temp_shift[5]|(~temp_shift[7]&~temp_shift[6]&temp_shift[5]&temp_shift[4]);
assign numbershift=checknumbershift?5'd0:temp_shift[4:0];

endmodule
