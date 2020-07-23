/*
 ***@Author: LE PHU NHAN
 ***@Date:   Nov 14th, 2018
*/
module mult24(S,A,B);
output	[47:0]S;
input	[23:0]A,B;

wire	[23:0]stage11,stage12,stage13,stage14;
wire	[23:0]stage2;
wire	stage2_c;
wire	[23:0]stage31,stage32;

//Stage1
mult12	block1(stage11,A[11:0],B[11:0]);
mult12	block2(stage12,A[11:0],B[23:12]);
mult12	block3(stage13,A[23:12],B[11:0]);
mult12	block4(stage14,A[23:12],B[23:12]);

//Stage2
adder24  block5(stage2_c,stage2,stage12,stage13);

//Stage3
adder24	block6(,stage31,{{12{1'b0}},stage11[23:12]},stage2);
adder24	block7(,stage32,stage14,{stage2_c,{11{1'b0}},stage31[23:12]});

assign	S = {stage32,stage31[11:0],stage11[11:0]};

endmodule

module mult12(S,A,B);
output	[23:0]S;
input	[11:0]A,B;

wire	[11:0]stage11,stage12,stage13,stage14;
wire	[11:0]stage2;
wire	stage2_c;
wire	[11:0]stage31,stage32;

//Stage1
mult6	block1(stage11,A[5:0],B[5:0]);
mult6	block2(stage12,A[5:0],B[11:6]);
mult6	block3(stage13,A[11:6],B[5:0]);
mult6	block4(stage14,A[11:6],B[11:6]);

//Stage2
adder12  block5(stage2_c,stage2,stage12,stage13);

//Stage3
adder12	block6(,stage31,{{6{1'b0}},stage11[11:6]},stage2);
adder12	block7(,stage32,stage14,{stage2_c,{5{1'b0}},stage31[11:6]});

assign	S = {stage32,stage31[5:0],stage11[5:0]};

endmodule

module mult6(S,A,B);
output	[11:0]S;
input	[5:0]A,B;

wire	[5:0]stage11,stage12,stage13,stage14;
wire	[5:0]stage2;
wire	stage2_c;
wire	[5:0]stage31,stage32;

//Stage1
mult3	block1(stage11,A[2:0],B[2:0]);
mult3	block2(stage12,A[2:0],B[5:3]);
mult3	block3(stage13,A[5:3],B[2:0]);
mult3	block4(stage14,A[5:3],B[5:3]);

//Stage2
adder6  block5(stage2_c,stage2,stage12,stage13);

//Stage3
adder6	block6(,stage31,{3'b000,stage11[5:3]},stage2);
adder6	block7(,stage32,stage14,{stage2_c,2'b00,stage31[5:3]});

assign	S = {stage32,stage31[2:0],stage11[2:0]};

endmodule

module mult3(S,A,B);
input [2:0] A;
input [2:0] B;
output [5:0] S;

wire [2:0] P0, P1, P2;
wire c0, c1, c2, c3, c4, s1, s2;

// stage 1
assign P0[2] = A[2] & B[0];
assign P0[1] = A[1] & B[0];
assign P0[0] = A[0] & B[0];

// stage 2
assign P1[2] = A[2] & B[1];
assign P1[1] = A[1] & B[1];
assign P1[0] = A[0] & B[1];

// stage 3
assign P2[2] = A[2] & B[2];
assign P2[1] = A[1] & B[2];
assign P2[0] = A[0] & B[2];

// Add all stages
assign S[0] = P0[0];
FA  block1(S[1], c0, P0[1], P1[0], 0);
FA  block2(s1, c1, P0[2], P1[1], P2[0]);
FA  block3(S[2], c2, c0, s1, 0);
FA  block4(s2, c3, P2[1], P1[2], c1);
FA  block5(S[3], c4, c2, s2, 0);
FA  block6(S[4], S[5], c4, P2[2], c3);
endmodule

module FA(output s,output cout, input a,input b,input cin);
wire z1,z2,z3;
xor(z1,a,b);
xor(s,z1,cin);
and(z2,z1,cin);
and(z3,a,b);
or(cout,z2,z3);

endmodule
