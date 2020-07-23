/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module postadder26(sign,frac,in);
output	sign;
output	[24:0]frac;
input	[25:0]in;

wire	[24:0]temp,cpltemp;

assign	sign=in[25];
	
assign 	temp=in[24:0];
cpl25	cplfrac(.out(cpltemp),.in(temp));
assign	frac=sign?cpltemp:temp;

endmodule
