/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

/*
 ***Used: 2'Compliment of number 25bit
*/
module cpl25(out,in);
output	[24:0]out;
input	[24:0]in;

wire	[24:0]temp;
//Not 
not	not0(temp[0],in[0]);	
not	not1(temp[1],in[1]);
not	not2(temp[2],in[2]);
not	not3(temp[3],in[3]);
not	not4(temp[4],in[4]);
not	not5(temp[5],in[5]);
not	not6(temp[6],in[6]);
not	not7(temp[7],in[7]);
not	not8(temp[8],in[8]);	
not	not9(temp[9],in[9]);
not	not10(temp[10],in[10]);
not	not11(temp[11],in[11]);
not	not12(temp[12],in[12]);
not	not13(temp[13],in[13]);
not	not14(temp[14],in[14]);
not	not15(temp[15],in[15]);
not	not16(temp[16],in[16]);	
not	not17(temp[17],in[17]);
not	not18(temp[18],in[18]);
not	not19(temp[19],in[19]);
not	not20(temp[20],in[20]);
not	not21(temp[21],in[21]);
not	not22(temp[22],in[22]);
not	not23(temp[23],in[23]);
not	not24(temp[24],in[24]);

//add 1
adder25  add1(out,temp,25'd1);

endmodule

/*
 ***Used: 2'Compliment of number 10bit
*/
module cpl10(out,in);
output	[9:0]out;
input	[9:0]in;

wire	[9:0]temp;

//Not 
not	not0(temp[0],in[0]);	
not	not1(temp[1],in[1]);
not	not2(temp[2],in[2]);
not	not3(temp[3],in[3]);
not	not4(temp[4],in[4]);
not	not5(temp[5],in[5]);
not	not6(temp[6],in[6]);
not	not7(temp[7],in[7]);
not	not8(temp[8],in[8]);
not	not9(temp[9],in[9]);

//add 1
adder10  add1(out,temp,10'd1);

endmodule

/*
 ***Used: 2'Compliment of number 9bit
*/
module cpl9(out,in);
output	[8:0]out;
input	[8:0]in;

wire	[8:0]temp;

//Not 
not	not0(temp[0],in[0]);	
not	not1(temp[1],in[1]);
not	not2(temp[2],in[2]);
not	not3(temp[3],in[3]);
not	not4(temp[4],in[4]);
not	not5(temp[5],in[5]);
not	not6(temp[6],in[6]);
not	not7(temp[7],in[7]);
not	not8(temp[8],in[8]);

//add 1
adder9  add1(out,temp,9'd1);

endmodule

/*
 ***Used: 2'Compliment of number 8bit
*/
module cpl8(out,in);
output	[7:0]out;
input	[7:0]in;

wire	[7:0]temp;

//Not 
not	not0(temp[0],in[0]);	
not	not1(temp[1],in[1]);
not	not2(temp[2],in[2]);
not	not3(temp[3],in[3]);
not	not4(temp[4],in[4]);
not	not5(temp[5],in[5]);
not	not6(temp[6],in[6]);
not	not7(temp[7],in[7]);

//add 1
adder8  add1(out,temp,8'd1);

endmodule
