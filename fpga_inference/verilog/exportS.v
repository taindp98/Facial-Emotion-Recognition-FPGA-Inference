/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Nove 14th, 2018
*/

module exportS_addsub(S,A,B,ansS);
output	[31:0]S;
input   [31:0]A,B,ansS;
reg	[31:0]S;

wire	flagNaNA,flagInfA,flag0A,flagNaNB,flagInfB,flag0B;

checkspecial	checkA(.flagInf(flagInfA),.flagNaN(flagNaNA),.flagZero(flag0A),.in(A));
checkspecial	checkB(.flagInf(flagInfB),.flagNaN(flagNaNB),.flagZero(flag0B),.in(B));

	
always@(A or B or ansS)
begin
	case ({flagInfA,flagInfB,flagNaNA,flagNaNB,flag0A,flag0B})
	6'b10_00_00, 6'b00_00_01:	S=A;			//A=Inf or B=0
	6'b01_00_00, 6'b00_00_10:	S=B;			//B=Inf or A=0
	6'b00_10_00, 6'b00_01_00, 6'b00_11_00:	S=32'h7FFFFFFF; //A or B NaN
	6'b11_00_00:  						//A with B = Inf
			if (B[31])  S=32'h7FFFFFFF;		//Inf-Inf=NaN
			else        S=A;			//Inf+Inf=Inf
	6'b00_00_11:  	S=32'h00000000;				//0+0=0
	default: S=ansS;
	endcase
end

endmodule

module exportS_mult(S,A,B,ansS);
output	[31:0]S;
input   [31:0]A,B,ansS;
reg	[31:0]S;

wire	flagNaNA,flagInfA,flag0A,flagNaNB,flagInfB,flag0B;

checkspecial	checkA(.flagInf(flagInfA),.flagNaN(flagNaNA),.flagZero(flag0A),.in(A));
checkspecial	checkB(.flagInf(flagInfB),.flagNaN(flagNaNB),.flagZero(flag0B),.in(B));

	
always@(A or B or ansS)
begin
	case ({flagInfA,flagInfB,flagNaNA,flagNaNB,flag0A,flag0B})
	6'b10_00_00, 6'b01_00_00:	S={ansS[31],31'h7f800000};	//A=Inf or B=Inf => S=Inf
	6'b00_00_10, 6'b00_00_01, 6'b00_00_11:	S=32'h00000000;		//B=0 or A=0     => S=0
	6'b00_10_00, 6'b00_01_00, 6'b00_11_00:	S=32'h7FFFFFFF; 	//A or B NaN    => S=NaN 
	6'b10_00_01, 6'b01_00_10:  	        S=32'h7FFFFFFF;		//A=0 and B=Inf => S=NaN							
	default: S=ansS;
	endcase
end

endmodule

module exportS_div(S,A,B,ansS);
output	[31:0]S;
input   [31:0]A,B,ansS;
reg	[31:0]S;

wire	flagNaNA,flagInfA,flag0A,flagNaNB,flagInfB,flag0B;

checkspecial	checkA(.flagInf(flagInfA),.flagNaN(flagNaNA),.flagZero(flag0A),.in(A));
checkspecial	checkB(.flagInf(flagInfB),.flagNaN(flagNaNB),.flagZero(flag0B),.in(B));

	
always@(A or B or ansS)
begin
	case ({flagInfA,flagInfB,flagNaNA,flagNaNB,flag0A,flag0B})
	6'b00_00_01, 6'b10_00_00:	S={ansS[31],31'h7f800000};	//B=Inf => S=Inf
	6'b00_00_10, 6'b01_00_00:	S=32'h00000000;		        //A=0     => S=0
	6'b00_10_00, 6'b00_01_00, 6'b00_11_00:	S=32'h7FFFFFFF; 	//A or B NaN    => S=NaN 
	6'b11_00_00, 6'b00_00_11:  	        S=32'h7FFFFFFF;		//A=0 and B=0, A and B = Inf => S=NaN							
	default: S=ansS;
	endcase
end

endmodule
