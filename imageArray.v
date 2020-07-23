`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : imageArray.v
// Description  : 
//
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 03/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module imageArray#(
	parameter BIT = 32,
	parameter CHANNEL = 2,
	parameter COL = 4,
	parameter ROW = 4,
	parameter F_COL = 3,
	parameter F_ROW = 3
	)
	(
	clk,
	rst_,
	control_data,
	stop_image,
	ready_fb,
	data_in,
	data_out,
	ready
	);
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port declarations
	input clk;
	input rst_;

	input control_data;
	input stop_image;


	///edit
	input [BIT-1:0] data_in;



	input ready_fb;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Output declarations

	output wire [BIT*F_ROW*F_COL-1:0] data_out;
	output reg ready;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Local signal declarations
	reg [BIT - 1 : 0] dataArray [0:CHANNEL-1][0:ROW-1][0:COL-1];
	reg [BIT - 1 : 0] dataArrayPad [0:CHANNEL-1][0:ROW+F_ROW-2][0:COL+F_COL-2];

	reg enable1;	//data in
	reg enable2;	//data Padding
	reg enable3;	//write 9 value
	reg[15:0] counter1;

	reg[BIT-1:0]dataArrayPad_temp1;
	reg[BIT-1:0]dataArrayPad_temp2;
	reg[BIT-1:0]dataArrayPad_temp3;
	reg[BIT-1:0]dataArrayPad_temp4;
	reg[BIT-1:0]dataArrayPad_temp5;
	reg[BIT-1:0]dataArrayPad_temp6;
	reg[BIT-1:0]dataArrayPad_temp7;
	reg[BIT-1:0]dataArrayPad_temp8;
	reg[BIT-1:0]dataArrayPad_temp9;

	wire [BIT-1:0] data_out1;
	wire [BIT-1:0] data_out2;
	wire [BIT-1:0] data_out3;
	wire [BIT-1:0] data_out4;
	wire [BIT-1:0] data_out5;
	wire [BIT-1:0] data_out6;
	wire [BIT-1:0] data_out7;
	wire [BIT-1:0] data_out8;
	wire [BIT-1:0] data_out9;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Logic signal declarations
//
/////////////////////////////////////Create array 2D////////////////////////////
	integer i1,j1,k1,i2,j2,k2,i3,j3,k3,i4,j4,k4;

	// i:channel; j:row; k:col
	initial 
		begin
			i1=0;
			j1=0;
			k1=0;
			k2 =0;
			j2 =0;
			i2 = 0;

			i3=0;
			j3=0;
			k3=0;
			counter1 = 0;
			enable1 = 1'b1;
			enable2 =1'b0;
			enable3 =1'b0;
			ready <= 1'b0;

			i4=0;
			j4=0;
			k4=0;
		end


	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					i1=0;
					j1=0;
					k1=0;
					k2 =0;
					j2 =0;
					i2 =0;
					i3=0;
					j3=0;
					k3=0;

					i4=0;
					j4=0;
					k4=0;

				end
			
			else if (enable1 && control_data)
				begin
					if (i1<CHANNEL && j1<ROW && k1<COL) 
						begin
							//counter1 = i1*ROW*COL+j1*ROW+k1 ;
							dataArray[i1][j1][k1] = data_in;
						end
					if (k1<COL) 
						begin
						k1 = k1+1;
						j1=j1;
						
						end
					
					if (j1 <ROW)
						begin
						j1=j1;
						end
					
					if (j1==ROW || k1==COL)
						begin
							if (k1==COL) 
								begin
									k1=0;
									j1=j1+1;
								end
							if (j1==ROW) 
								begin
									j1 =0;
									i1=i1+1;
								end
							if(i1==CHANNEL)
								begin
								enable1 = 1'b0;
								enable2 = 1'b1;
								end
						end
					
					
				end
			else if (enable2 && stop_image)
				begin
					if (j2<1 || j2>ROW || k2<1 || k2>COL) 
						begin
						dataArrayPad [i2][j2][k2] = 0;
						end
					if (1<=j2 && j2 <=ROW && 1<=k2 && k2<=COL)   
						begin
						dataArrayPad [i2][j2][k2] = 
							dataArray [i2][j2-1][k2-1];
						end
					if (k2<COL+F_COL-1) 
						begin
							k2= k2+1;
							j2=j2;
						end
					if (j2<ROW+F_ROW-1) 
						begin
							j2=j2;
						end
					if (k2==(COL+F_COL-1) || j2==(ROW+F_ROW-1)) 
						begin
							if (k2==(COL+F_COL-1)) 
								begin
									k2=0;
									j2=j2+1;
								end
							if (j2==(ROW+F_ROW-1)) 
								begin
									j2=0;
									i2=i2+1;
								end
							if (i2==CHANNEL) 
								begin
								enable2 = 1'b0;
								//enable3 = 1'b1;
								ready = 1'b1;
								end
						end
					

				end
			else if (ready && stop_image) 
				begin
					if (i3<CHANNEL)
						begin
							//if (ready_weight) 
							//	begin
									//ready = 1'b1;
									dataArrayPad_temp1 = dataArrayPad [i3][j3][k3];
									dataArrayPad_temp2 = dataArrayPad [i3][j3][k3+1];
									dataArrayPad_temp3 = dataArrayPad [i3][j3][k3+2];
									dataArrayPad_temp4 = dataArrayPad [i3][j3+1][k3];
									dataArrayPad_temp5 = dataArrayPad [i3][j3+1][k3+1];
									dataArrayPad_temp6 = dataArrayPad [i3][j3+1][k3+2];
									dataArrayPad_temp7 = dataArrayPad [i3][j3+2][k3];
									dataArrayPad_temp8 = dataArrayPad [i3][j3+2][k3+1];
									dataArrayPad_temp9 = dataArrayPad [i3][j3+2][k3+2];
									i3=i3+1;
							//	end
							
															/////////////////////////////////////////
							if (i3==CHANNEL) 
								begin
									i3=0;
									if (k3<COL) 
										begin
										k3=k3+1;
										j3=j3;
										end
									if (k3==COL) 
										begin
										k3=0;
										j3=j3+1;
										end
									if (j3==ROW) 
										begin
										j3=0;
										i3=0;
										k3=0;
										//ready =1'b0;
										enable2 = 1'b0;
										end
								end
						end
					
				end
			else if (ready_fb && stop_image) 
					begin
						if (i4<CHANNEL)
						begin
									dataArrayPad_temp1 = dataArrayPad [i4][j4][k4];
									dataArrayPad_temp2 = dataArrayPad [i4][j4][k4+1];
									dataArrayPad_temp3 = dataArrayPad [i4][j4][k4+2];
									dataArrayPad_temp4 = dataArrayPad [i4][j4+1][k4];
									dataArrayPad_temp5 = dataArrayPad [i4][j4+1][k4+1];
									dataArrayPad_temp6 = dataArrayPad [i4][j4+1][k4+2];
									dataArrayPad_temp7 = dataArrayPad [i4][j4+2][k4];
									dataArrayPad_temp8 = dataArrayPad [i4][j4+2][k4+1];
									dataArrayPad_temp9 = dataArrayPad [i4][j4+2][k4+2];
									i4=i4+1;
							//	end
							
			/////////////////////////////////////////
							if (i4==CHANNEL) 
								begin
									i4=0;
									if (k4<COL) 
										begin
										k4=k4+1;
										j4=j4;
										end
									if (k4==COL) 
										begin
										k4=0;
										j4=j4+1;
										end
									if (j4==ROW) 
										begin
										j4=0;
										i4=0;
										k4=0;
										//ready =1'b0;
										end
								end
						end
					
					end
		end





	assign data_out1 = dataArrayPad_temp1;
	assign data_out2 = dataArrayPad_temp2;
	assign data_out3 = dataArrayPad_temp3;
	assign data_out4 = dataArrayPad_temp4;
	assign data_out5 = dataArrayPad_temp5;
	assign data_out6 = dataArrayPad_temp6;
	assign data_out7 = dataArrayPad_temp7;
	assign data_out8 = dataArrayPad_temp8;
	assign data_out9 = dataArrayPad_temp9;

	assign data_out ={data_out1,data_out2,data_out3,data_out4,data_out5,data_out6,data_out7,data_out8,data_out9};

//	assign ready = ready_weight;
endmodule