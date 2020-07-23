`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : max_pool.v
// Description  : 
//					
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 04/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module max_pool#(
	parameter BIT = 32,
	parameter CHANNEL = 2,		//batch_layer_before
	parameter CHANNEL_DELAY=3,	//channel_layer_before
	parameter COL = 4,
	parameter ROW = 4,
	parameter M_COL = 2,
	parameter M_ROW = 2
	)
	(
	clk,
	rst_,
	ready_maxpool,
	data_in,
	data_out,
	data_ready
	);

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port in declarations
	input clk;
	input rst_;
	input ready_maxpool;
	input [BIT-1:0] data_in;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port out declarations

	output [BIT-1:0] data_out;
	output reg data_ready;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port logic declarations
	reg enable1;
	reg enable2;
	reg enable3;

	reg [BIT-1:0] data_Array [0:CHANNEL-1][0:ROW-1][0:COL-1];

	reg [BIT-1:0] data_outTemp1;
	reg [BIT-1:0] data_outTemp2;
	reg [BIT-1:0] data_outTemp3;
	reg [BIT-1:0] data_outTemp4;

	wire [BIT-1:0] data_compare1;
	wire [BIT-1:0] data_compare2;
	wire [BIT-1:0] data_compare3;
	wire [BIT-1:0] check1; //negative
	wire [BIT-1:0] check2; //negative
	wire [BIT-1:0] check3; //negative
	wire [BIT-1:0] max1;
	wire [BIT-1:0] max2;
	wire [BIT-1:0] max3;




	integer i1,j1,k1,i2,j2,k2,d1,d2,d3,d4;
	initial
		begin
			i1=0;
			j1=0;
			k1=0;
			i2=0;
			j2=0;
			k2=0;
			enable1=1'b1;
			enable2=1'b0;
			enable3=1'b0;

			d1=0;	//delay
			d2=0;
			d3=0;
			d4=0;

			data_ready=1'b0;
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					i1=0;
					j1=0;
					k1=0;
					i2=0;
					j2=0;
					k2=0;

					d1=0;	//delay
					d2=0;
					d3=0;
					d4=0;
				end
			else if (enable1 && ready_maxpool) 
				begin
					data_Array[i1][j1][k1]=data_in;
					if (k1<COL)
						begin
							if (d1<CHANNEL_DELAY) 
								begin
									d1=d1+1;
									if (d1==CHANNEL_DELAY) 
										begin
											d1=0;
											k1=k1+1;
											if (k1==COL) 
												begin
													k1=0;
													j1=j1+1;
														if (j1==ROW) 
															begin
																j1=0;
																i1=i1+1;
																	if (i1==CHANNEL) 
																		begin
																			i1=0;
																			enable1=1'b0;
																			enable2=1'b1;
																		end	
															end
												end
																				
										end
								end
						end
															
					if (j1<ROW) 
						begin
							j1=j1;		
						end
							
					
					
				end
			else if (enable2) 
				begin
					data_ready=1'b1;
					data_outTemp1 = data_Array [i2][j2][k2];
					data_outTemp2 = data_Array [i2][j2][k2+1];
					data_outTemp3 = data_Array [i2][j2+1][k2];
					data_outTemp4 = data_Array [i2][j2+1][k2+1];

					if (k2<COL)
						begin
							k2=k2+2;
									
						end
					if (j2<ROW) 
						begin
							j2=j2;		
						end
					if (k2==COL) 
						begin
							k2=0;
							j2=j2+2;		
						end		
					if (j2==ROW) 
						begin
							j2=0;
							i2=i2+1;
						end
					if (i2==CHANNEL) 
						begin
							i2=0;
							enable2=1'b0;
						end	
				end

		end

	add_sub sub1(
				.A(data_outTemp1),
				.B(data_outTemp2),
				.add_or_sub(1),
				.S(data_compare1)
				);
	assign check1 = data_compare1 & 32'b1000_0000_0000_0000_0000_0000_0000_0000;
	assign max1 = (check1 == 32'b1000_0000_0000_0000_0000_0000_0000_0000)? data_outTemp2 : data_outTemp1;

	add_sub sub2(
				.A(max1),
				.B(data_outTemp3),
				.add_or_sub(1),
				.S(data_compare2)
				);
	assign check2 = data_compare2 & 32'b1000_0000_0000_0000_0000_0000_0000_0000;
	assign max2 = (check2 == 32'b1000_0000_0000_0000_0000_0000_0000_0000)? data_outTemp3 : max1;

	add_sub sub3(
				.A(max2),
				.B(data_outTemp4),
				.add_or_sub(1),
				.S(data_compare3)
				);
	assign check3 = data_compare3 & 32'b1000_0000_0000_0000_0000_0000_0000_0000;
	assign max3 = (check3 == 32'b1000_0000_0000_0000_0000_0000_0000_0000)? data_outTemp4 : max2;

	assign data_out = max3;

endmodule