/*
 ***@Author: NGUYEN TRUNG HIEU
 ***@Date:   Oct 24th, 2018
*/

module mux24b(out,A,B,sel);
output [23:0]out;
input  [23:0]A,B;
input  sel;

assign out=sel?B:A;

endmodule

module mux8b(out,A,B,sel);
output [7:0]out;
input  [7:0]A,B;
input  sel;

assign out=sel?B:A;

endmodule

module mux1b(out,A,B,sel);
output [7:0]out;
input  [7:0]A,B;
input  sel;

assign out=sel?B:A;

endmodule