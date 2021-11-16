////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : add_sub.v
// Description  : .
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : Wed 03/07/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

module add_sub(overflag,underflag,S,A,B,add_or_sub);
output	underflag,overflag;
output [31:0]S;
input	[31:0]A,B;
input	add_or_sub;

//Extract floating-point A and B
wire	signA,signB,signS;
wire	[7:0]expA,expB,expS;
wire	[23:0]fracA,fracB,fracS;

assign	signA=A[31];
assign	signB=B[31]^add_or_sub;
assign	expA=A[30:23];
assign	expB=B[30:23];
assign	fracA={1'b1,A[22:0]};
assign	fracB={1'b1,B[22:0]};

//Signal 
wire	expA_LT_expB;

wire	[7:0]exp_before_normal;

wire	[23:0]frac_before_shift,frac_after_shift,frac_not_shift;
wire	[4:0]shift_right_by_n;

wire	sign_shift,sign_not_shift;

wire	[25:0]after_add,before_add_1,before_add_2;

wire	[24:0]frac_before_normal;

//Compare and choose exponent A and B 
	//expA_LT_expB=1 => expA <  expB
	//expA_LT_expB=0 => expA >= expB
compare_exp	compare_expAB(.numbershift(shift_right_by_n),.LT(expA_LT_expB),.A(expA),.B(expB));
mux8b		mux_choose_exp(.out(exp_before_normal),.A(expA),.B(expB),.sel(expA_LT_expB));

//Shift and add frac A to B
	//Choose and shift frac
	//expA_LT_expB=1 => expA <  expB => shift frac A
	//expA_LT_expB=0 => expA >= expB => shift frac B
mux24b		mux_not_shift(.out(frac_not_shift),.A(fracA),.B(fracB),.sel(expA_LT_expB));	
mux24b		mux_shift_right(.out(frac_before_shift),.A(fracB),.B(fracA),.sel(expA_LT_expB));
shiftright	shift_right24b(.DO(frac_after_shift),.DI(frac_before_shift),.sel(shift_right_by_n));

	//Choose sign for 2 frac
mux1b		mux_choose_sign_shift(.out(sign_shift),.A(signB),.B(signA),.sel(expA_LT_expB));
mux1b		mux_choose_sign_not_shift(.out(sign_not_shift),.A(signA),.B(signB),.sel(expA_LT_expB));

	//Add 2 frac
preadder26      preproccess(.full1(before_add_1),.full2(before_add_2),.sign1(sign_shift),.sign2(sign_not_shift),
                            .in1(frac_after_shift),.in2(frac_not_shift));
adder26		process_add(.S(after_add),.A(before_add_1),.B(before_add_2));
postadder26	postprocess(.sign(signS),.frac(frac_before_normal),.in(after_add));

//Normalize the frac answer
normalize	normalize_ans(.overf(overflag),.underf(underflag),.exp_out(expS),.frac_out(fracS),.exp_in(exp_before_normal),.frac_in(frac_before_normal));

//Export S
exportS_addsub	export_S_value(.S(S),.A({signA,expA,fracA[22:0]}),.B({signB,expB,fracB[22:0]}),.ansS({signS,expS,fracS[22:0]}));
		
endmodule
