`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : conv_main.v
// Description  : 
//					
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 04/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module conv_main#(
	parameter BIT = 32,
	parameter CHANNEL = 1,
	parameter COL = 8,
	parameter ROW = 8,
	parameter F_COL = 3,
	parameter F_ROW = 3,
	parameter BATCH =3
	)
	(
	clk,
	rst_,
	ready_image,
	ready_weight,
	ready_bias,
	data_in,
	weight,
	bias,
	data_out,
	fb_image,
	fb_weight,
	fb_bias,
	stop_image
//	ready_maxpool
	);
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port in declarations
	input clk;
	input rst_;
	input 	ready_bias;
	input  ready_image;
	input  ready_weight;

	input [BIT*F_ROW*F_COL-1:0] data_in;
	input [BIT*F_ROW*F_COL-1:0] weight;
	input [BIT-1:0] bias;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port out declarations
	output reg fb_image;
	output reg fb_weight;

	output [BIT-1:0] data_out;
	output reg fb_bias;
	output reg stop_image;

//	output reg ready_maxpool;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port logic declarations


	wire [BIT*F_ROW*F_COL-1:0] weightCal;
	wire [BIT*F_ROW*F_COL-1:0] dataCal;
	reg enable1;
	reg enable2;
	reg enable3;
	reg enable4;
	reg enable5;
	reg enable6;
	wire [BIT-1:0] data_outTemp1[F_ROW*F_COL-1:0];
	wire [BIT-1:0] data_outTemp2[7:0];
	reg [BIT-1:0] data_outTemp3;
	
	reg [0:BIT*CHANNEL-1] data_outTemp4;
	reg [0:BIT*CHANNEL-1] data_outTemp5;
	wire [BIT*CHANNEL-1:0] data_outTemp6;
	reg [BIT-1:0] data_outTemp7 [0:CHANNEL];
	wire [BIT-1:0] data_outTemp8;
	reg [BIT-1:0] data_outTemp9;

	wire [BIT-1:0] data_outTemp10;
	
	wire [BIT-1:0] check_relu;
////////////////////////////////////////////////////////////////////////////////<-80 chars
	integer i,j,k;
	initial
		begin
			i =0;
			j =0;
			k=0;
			enable1 = 1'b1;
			enable2=1'b1;
			enable3=1'b0;
			enable4=1'b0;
			enable5=1'b0;
			enable6 =1'b0;
			fb_weight = 1'b0;
			fb_image = 1'b0;
			fb_bias = 1'b0;
			stop_image = 1'b1;
		//	ready_maxpool = 1'b0;
		end
////////////////////////////////////////////////////////////////////////////////<-80 chars
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
					i =0;
					j =0;
					k =0;
				end
			else if (ready_image && enable1) 
				begin
					if (i<CHANNEL*COL*ROW) 
						begin
							i=i+1;
							j=j;
							
							if (i==CHANNEL*ROW*COL-1) 
								begin
									fb_image = 1'b1;	//change batch
									fb_weight =1'b1;
								end
							if (i==CHANNEL*COL*ROW) 
								begin
									i=0;
									j=j+1;				//change batch
									fb_weight = 1'b0;
									
									if (j==BATCH) 
										begin
										stop_image = 1'b0;
										fb_image=1'b0;
										enable1=1'b0;
										end
								end
						end
				end
		end
	
	assign dataCal = data_in;
	assign weightCal = weight;

	generate
		genvar m;
		for(m = 0; m < F_ROW*F_COL; m = m + 1)
			begin : loop1_1
				multiplier mult1(
								.A(dataCal[m*BIT+:BIT]),
								.B(weightCal[m*BIT+:BIT]),
								.S(data_outTemp1[m])
								);
			
			end	
	endgenerate


			add_sub add1(
				.A(data_outTemp1[8]),
				.B(data_outTemp1[7]),
				.add_or_sub(0),
				.S(data_outTemp2[0])
				);
			add_sub add2(
						.A(data_outTemp1[6]),
						.B(data_outTemp2[0]),
						.add_or_sub(0),
						.S(data_outTemp2[1])
						);
			add_sub add3(
						.A(data_outTemp1[5]),
						.B(data_outTemp2[1]),
						.add_or_sub(0),
						.S(data_outTemp2[2])
						);
			add_sub add4(
						.A(data_outTemp1[4]),
						.B(data_outTemp2[2]),
						.add_or_sub(0),
						.S(data_outTemp2[3])
						);
			add_sub add5(
						.A(data_outTemp1[3]),
						.B(data_outTemp2[3]),
						.add_or_sub(0),
						.S(data_outTemp2[4])
						);
			add_sub add6(
						.A(data_outTemp1[2]),
						.B(data_outTemp2[4]),
						.add_or_sub(0),
						.S(data_outTemp2[5])
						);
			add_sub add7(
						.A(data_outTemp1[1]),
						.B(data_outTemp2[5]),
						.add_or_sub(0),
						.S(data_outTemp2[6])
						);
			add_sub add8(
						.A(data_outTemp1[0]),
						.B(data_outTemp2[6]),
						.add_or_sub(0),
						.S(data_outTemp2[7])
						);

////////////////////////////////////////////////////////////////////////////////<-80 chars
	always @(posedge clk) 
		begin
			data_outTemp3 = data_outTemp2[7];
		end

	integer x,y;
	initial
		begin
			x=0;
			y=0;
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
				x=0;
				y=0;
				end
			else if (enable2 && ready_weight) 
				begin
					data_outTemp4[x*BIT+:BIT]=data_outTemp3;
					
					if (x<CHANNEL) 
						begin
							x=x+1;
							y=y+1;
							enable3=1'b0;
							enable4=1'b1;
						end
					if (x==CHANNEL) 
						begin
							x=0;
							
							enable3=1'b1;
						end
					if (y==COL*ROW*BATCH*CHANNEL) 
						begin
							x=0;
							y=0;
							enable2=1'b0;
							
							
						end
				end
		end

	always @(posedge clk) 
		begin
			if (enable3) 
				begin
					data_outTemp5 = data_outTemp4;
				end
		end

	assign data_outTemp6 = data_outTemp5;


	integer z,t,w1,w2,w3;
	initial
		begin
			z=0;
			t=0;
			w1=0;
			w2=0;
			w3=0;
		end

		add_sub add9(
					.A(data_outTemp7[z]),
					.B(data_outTemp6[z*BIT+:BIT]),
					.add_or_sub(0),
					.S(data_outTemp8)
					);
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					z=0;
					t=0;
				end
			else if (enable4) 
				begin

					data_outTemp7[0] = 32'b0;
					data_outTemp7[z+1] = data_outTemp8;
					

					if (z<CHANNEL) 
						begin
							z=z+1;
						end
					if (z==CHANNEL) 
						begin
							z=0;

							data_outTemp9 = data_outTemp8;
							enable5=1'b1;
						end
				end
		end

////////////////////////////////////////////////////////////////////////////////<-80 chars
//////////////////////////Delay bias////////////////////////////////////////////
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
			// reset
				w1=0;
				//
				end
		
			else if (enable5) 
				begin
					if (w1<CHANNEL) 
						begin
						w1=w1+1;
						end
					if (w1==CHANNEL) 
						begin
						w1=0;
						fb_bias=1'b1;
						//ready_maxpool=1'b1;
						end
				end
		end
	//always @(posedge clk or negedge rst_) 
	//	begin
	//		if (!rst_) 
	//			begin
	//		// reset
	//			w2=0;
				//
	//			end
		
	//		else if (fb_bias) 
	//			begin
	//				if (w2<CHANNEL) 
	//					begin
	//					w2=w2+1;
	//					end
	//				if (w2==CHANNEL) 
	//					begin
	//					w2=0;
	//					enable6=1'b1;
	//					end
	//			end
	//	end
		
		add_sub add10(
					.A(data_outTemp9),
					.B(bias),
					.add_or_sub(0),
					.S(data_outTemp10)
					);
////////////////////////////////////////////////////////////////////////////////<-80 chars
////////////////////////////////////Relu Activation/////////////////////////////

	assign  data_out = (check_relu == 32'b1000_0000_0000_0000_0000_0000_0000_0000)?

						(data_outTemp10 & 32'b0) : data_outTemp10;
	
	assign check_relu = data_outTemp10 & 32'b1000_0000_0000_0000_0000_0000_0000_0000;


	
endmodule

	

	
	