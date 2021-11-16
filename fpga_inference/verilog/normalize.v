/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module normalize(overf,underf,exp_out,frac_out,exp_in,frac_in);
output  overf,underf;
output	[7:0]exp_out;
output	[23:0]frac_out;
input	[7:0]exp_in;
input	[24:0]frac_in;

wire	checkzero;
wire	[4:0]shift_left_by_n;
wire	[24:0]temp_frac;
wire	[9:0]cpl_n;

wire	[9:0]ext_exp_out,temp_cpl_n;

//Normalize fraction 
findbit1	find_bit_to_shift(.flagzero(checkzero),.Z(shift_left_by_n),.Y(frac_in));
shiftleft	shift_left_frac(.DO(temp_frac),.DI(frac_in),.sel(shift_left_by_n));
assign	frac_out=temp_frac[24:1];

//Normalize exponent
cpl10		cpl_shiftleft(.out(cpl_n),.in({6'd0,shift_left_by_n}));
adder10		normalize_exp1(.S(temp_cpl_n),.A(10'd1),.B(cpl_n));
adder10		normalize_exp2(.S(ext_exp_out),.A({2'b00,exp_in}),.B(temp_cpl_n));

assign  underf=ext_exp_out[9]&ext_exp_out[8]&checkzero;
assign  overf=~ext_exp_out[9]&ext_exp_out[8]&~checkzero;

assign	exp_out=(ext_exp_out[8]|checkzero)?8'd0:ext_exp_out[7:0];

endmodule