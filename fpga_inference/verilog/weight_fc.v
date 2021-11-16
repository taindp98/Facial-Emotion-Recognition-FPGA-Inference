`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : weight_fc.v
// Description  : weight for fully connect
//
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 11/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module weight_fc#(
	parameter BIT = 32,
	parameter COL = 4,
	parameter ROW = 4,
	parameter CHANNEL = 2,
	parameter BATCH = 10
	)
	(
	clk,
	rst_,
	control_weight,
	control_bias,
	fb_weight,
	fb_bias,
	weight,
	bias,
	weight_out,
	bias_out,
	ready_weight,
	ready_bias
		);
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port declarations
	input clk;
	input rst_;
//	input ready_data_control;
	input fb_weight;
	input fb_bias;

	input control_weight;
	input control_bias;

	/////////////////edit///////////////////////
	input [BIT-1:0] weight;
	input [BIT-1:0] bias;

	output [BIT-1:0] weight_out;
	output [BIT-1:0] bias_out;
	output reg ready_weight;
	output reg ready_bias;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Local signal declarations
	
	reg enable1;
	reg enable2;
	reg enable3;
	reg enable4;

	reg enable5;
	reg enable6;
	reg enable7;
	reg [BIT-1:0] weight_Array [0:ROW*COL*CHANNEL*BATCH-1];
	reg [BIT-1:0] weight_outTemp;
	reg [BIT-1:0] bias_Array [0:BATCH-1];
	reg [BIT-1:0] bias_outTemp;

	integer i1,j1,k1,i2,j2,k2,i3,j3,k3;
	integer i4,j4,k4;
	initial
		begin
			i1=0;
			j1=0;
			k1=0;
			i2=0;
			j2=0;
			k2=0;
			i3=0;
			j3=0;
			k3=0;
			i4=0;
			j4=0;
			k4=0;
			enable1=1'b1;
			enable2=1'b1;
			enable3=1'b1;
			enable4=1'b1;
			enable5=1'b1;
			enable6=1'b0;
			enable7=1'b0;
			ready_weight=1'b0;
			ready_bias=1'b0;
		end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
					i1=0;
				//	j1=0;
				//	k1=0;
				end
			else if (enable1 && control_weight ) 
				begin
					weight_Array[i1] = weight;
				//	ready_weight =1'b1;
						if (i1<ROW*COL*CHANNEL*BATCH) 
							begin
								i1=i1+1;
							end
						if (i1==ROW*COL*CHANNEL*BATCH) 
							begin
								i1=0;
								enable1=1'b0;
								//enable3=1'b1;
							end
				end
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
				//	i1=0;
					j1=0;
				//	k1=0;
				end
			else if (enable3 && fb_weight) 
				begin
					weight_outTemp = weight_Array[j1];
					ready_weight =1'b1;
						if (j1<ROW*COL*CHANNEL*BATCH) 
							begin
								j1=j1+1;
							end
						if (j1==ROW*COL*CHANNEL*BATCH) 
							begin
								j1=0;
								enable3=1'b0;
							end
				end
		end
 
	assign weight_out = weight_outTemp;

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
				j2=0;
			//	k2=0;
				end
			else if (enable2 && control_bias) 
				begin
					bias_Array [j2] = bias;
					//ready_bias =1'b1;
						if (j2<BATCH) 
							begin
								j2=j2+1;
							end
						if (j2==BATCH) 
							begin
								j2=0;
								enable2=1'b0;
							//	enable4=1'b1;
							end
				end
		end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
				i3=0;
			//	j3=0;
				k3=0;
				end
			else if (enable4 && fb_bias) 
				begin
					bias_outTemp = bias_Array [i3];
					ready_bias =1'b1;
						if (k3<ROW*COL*CHANNEL) 
							begin
								k3=k3+1;
							end
						if (k3==ROW*COL*CHANNEL) 
							begin
								k3=0;
								i3=i3+1;
							end
						if (i3==BATCH) 
							begin
								i3=0;
								enable4=1'b0;
							end
				end
		end

//	assign bias_outTemp = bias_Array[j2];
	assign bias_out = bias_outTemp ;


endmodule