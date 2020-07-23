/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module preadder26(full1,full2,sign1,sign2,in1,in2);
output [25:0]full1,full2;
input  [23:0]in1,in2;
input  sign1,sign2;

wire   [24:0]temp1,temp2;


cpl25	cpl_1(.out(temp1),.in({1'b0,in1}));	
cpl25	cpl_2(.out(temp2),.in({1'b0,in2}));	

assign	full1=sign1?{1'b1,temp1}:{1'b0,in1};
assign	full2=sign2?{1'b1,temp2}:{1'b0,in2};

endmodule
