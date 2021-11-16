module clb(gout,pout,cout,gin,pin,cin);
output gout,pout;
output [3:0]cout;
input  cin;
input  [3:0]gin,pin;

assign cout[0]=cin;
assign cout[1]=gin[0]|(pin[0]&cin);
assign cout[2]=gin[1]|(pin[1]&gin[0])|(pin[1]&pin[0]&cin);
assign cout[3]=gin[2]|(pin[2]&gin[1])|(pin[2]&pin[1]&gin[0])|(pin[2]&pin[1]&pin[0]&cin);

assign gout   =gin[3]|(pin[3]&gin[2])|(pin[3]&pin[2]&gin[1])|(pin[3]&pin[2]&pin[1]&gin[0]);
assign pout   =pin[3]&pin[2]&pin[1]&pin[0];

endmodule

module clb3(gout,pout,cout,gin,pin,cin);
output gout,pout;
output [2:0]cout;
input  cin;
input  [2:0]gin,pin;

assign cout[0]=cin;
assign cout[1]=gin[0]|(pin[0]&cin);
assign cout[2]=gin[1]|(pin[1]&gin[0])|(pin[1]&pin[0]&cin);

assign gout   =gin[2]|(pin[2]&gin[1])|(pin[2]&pin[1]&gin[0]);
assign pout   =pin[2]&pin[1]&pin[0];

endmodule

module clb2(gout,pout,cout,gin,pin,cin);
output gout,pout;
output [1:0]cout;
input  cin;
input  [1:0]gin,pin;

assign cout[0]=cin;
assign cout[1]=gin[0]|(pin[0]&cin);

assign gout   =gin[1]|(pin[1]&gin[0]);
assign pout   =pin[1]&pin[0];

endmodule