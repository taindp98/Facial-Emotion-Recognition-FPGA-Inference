`timescale 1ns / 100ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : fc.v
// Description  : fully connect
//
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 03/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module fc_final#(
	parameter BIT = 32,
	parameter COL = 4,
	parameter ROW = 4,
	parameter CHANNEL = 2,
	parameter BATCH = 10,
	parameter DELAY = 8		//DELAY THEO KICH THUOC MA TRAN TRUOC FC1
	
	)
	(
	clk,
	rst_,
	ready_data,
	//ready_weight,
	data_in,
	weight,
	bias,
	data_out,
	fb_weight,
	fb_bias,
	data_ready
	);

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port in declarations
	input clk;
	input rst_;
	input ready_data;
	input [BIT-1:0] data_in;

	input [BIT-1:0] weight;
	input [BIT-1:0] bias;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port out declarations
	output [BIT-1:0] data_out;
	output reg data_ready;
	output reg fb_weight;
	output reg fb_bias;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Local signal declarations
	reg enable1;
	reg enable2;
	reg enable3;
	reg enable4;
	reg enable5;
	wire [BIT-1:0] result_Cal;
	reg [BIT-1:0] data_Cal;
	reg [BIT-1:0] data_Array [0:COL*ROW*CHANNEL-1];
	reg [0:BIT*COL*ROW*CHANNEL-1] result_Array;

	reg [BIT-1:0] data_Cal1 [0:COL*ROW*CHANNEL];
	wire [BIT-1:0] data_Cal2;
	reg [BIT-1:0] data_Cal3;

	wire [BIT-1:0] data_out1; //check relu
//	wire [BIT-1:0] check_relu;
	

	integer i1,j1,k1,i2,j2,k2,delay,d;
	initial
		begin
			i1=0;
			j1=0;
			k1=0;
			i2=0;
			j2=0;
			k2=0;
			d=0;
			delay =0;
		//	delay2=0;
			enable1=1'b1;
			enable2=1'b0;
			enable3=1'b0;
			enable4=1'b1;
			enable5=1'b1;
			fb_weight=1'b0;
			fb_bias=1'b0;
			data_ready=1'b0;
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
					i1=0;
					j1=0;
					k1=0;
					d=0;
					
				end
			else if (enable1 && ready_data) 
				begin
					data_Array [i1] = data_in;
					//if (i1<COL*ROW*CHANNEL) 
						//begin
					if (d<DELAY) 
						begin
							d=d+1;
						end
					if (d==DELAY) 
						begin
							d=0;
							i1=i1+1;
						end
							
					//	end
					if (i1==COL*ROW*CHANNEL) 
						begin
							i1=0;
							enable1=1'b0;
							enable2=1'b1;
							fb_weight=1'b1;
						end
				end
			else if (enable2) 
				begin
					data_Cal = data_Array[j1];
				
					if (j1<COL*ROW*CHANNEL) 
						begin
							j1=j1+1;
							
						end
					if (j1==2)					//delay 
						begin
							enable3=1'b1;
						end
					if (j1==COL*ROW*CHANNEL) 
						begin
							j1=0;
							k1=k1+1;
						end
					if (k1==2) 
						begin
							fb_bias=1'b1;
						end
					if (k1==BATCH) 
						begin
							k1=0;
							enable2=1'b0;
						//	fb_bias=1'b1;
							
						end
				end
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
			// reset
					delay=0;
				end
			else if (enable4 && fb_bias) 
				begin
					delay = delay +1;
					if (delay==2) 
						begin
						delay=0;
						enable4=1'b0;
						data_ready=1'b1;
						end
				end
	end

	multiplier mult1(
					.A(data_Cal),
					.B(weight),
					.S(result_Cal)
					);

	///////////////////////////////////////////////
	//always @(posedge clk or negedge rst_) 
	//	begin
	//		if (rst_) 
	//			begin
	//				delay2=0;
	//			end
	//		else if (enable5) 
	//			begin
	//				enable3=1'b1;
	///				delay2=delay2+1;
	//				if (delay2==COL*ROW*CHANNEL*BATCH) 
	//					begin
	//						delay2=0;
	//						enable3=1'b0;
	//					end
	//			end
	//	end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					i2=0;
					j2=0;
					k2=0;
				end
			else if (enable3 && enable5) 
				begin
					result_Array[i2*BIT+:BIT] = result_Cal;
					data_Cal1[0] = 32'b0;
					data_Cal1[i2+1] = data_Cal2;
					if (i2<COL*ROW*CHANNEL) 
						begin
							i2=i2+1;
						end
					if (i2==COL*ROW*CHANNEL) 
						begin
							i2=0;
							k2=k2+1;
							data_Cal3 = data_Cal1[COL*ROW*CHANNEL];
							
						end
					if (k2==BATCH+1)		 
						begin
							k2=0;
							enable5=1'b0;
						end
				end
		end

	add_sub add1(
				.A(data_Cal1[i2]),
				.B(result_Array[i2*BIT+:BIT]),
				.add_or_sub(0),
				.S(data_Cal2)
				);


	add_sub add2(
				.A(data_Cal3),
				.B(bias),
				.add_or_sub(0),
				.S(data_out1)
				);

	assign data_out = data_out1 ;
	//assign  data_out = (check_relu == 32'b1000_0000_0000_0000_0000_0000_0000_0000)?

//						(data_out1 & 32'b0) : data_out1;
	
//	assign check_relu = data_out1 & 32'b1000_0000_0000_0000_0000_0000_0000_0000;
	
	endmodule