`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : weightArray.v
// Description  : 
//					
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 04/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module weightArray#(
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
	control_weight,
	control_bias,
	ready_image_control,
	ready_fb,
	fb_bias,
	weight,
	bias,
	weight_out,
	bias_out,
	ready,
	ready_bias
	);
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port declarations
	input clk;
	input rst_;
	input ready_image_control;
	input ready_fb;
	input fb_bias;

	input control_weight;
	input control_bias;

	//////////////////////edit/////////////////////////////////
	input [BIT-1:0] weight;
	input [BIT-1:0] bias;
	///////////////////////////////////////////////////////////

	output [BIT*F_ROW*F_COL-1:0] weight_out;
	output [BIT-1:0] bias_out;
	output reg ready;
	output reg ready_bias;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Local signal declarations

	reg [BIT-1 : 0] biasArray [BATCH-1:0];

	reg enable3;
	reg enable4;
	reg enable2;
	reg enable5;
	reg enable6;
	reg enable7;
	reg enable8;
	reg enable9;
	reg [15:0] counter;	// counter k4 k5

	reg [BIT*F_COL*F_ROW-1:0] weight_outArray [0:CHANNEL*BATCH-1];
	reg [0:BIT*F_COL*F_ROW-1] weight_Temp;
	reg [0:BIT*F_ROW*F_COL-1] weight_outTemp;
	reg [BIT-1:0] bias_outTemp;
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Logic signal declarations

	integer i3,j3,k3,k4,i4,k5,k5_old,i5,i6,j4,d1;
	// i channel,j row, k col, l batch
	initial
		begin
			i3=0;
			j3=0;
			k3=0;
			k4=0;
			k5=0;
			j4=0;
			d1=0;
			k5_old=0;
			enable3 = 1'b1;
			i4=0;
			i5=0;
			i6=0;
			enable4 = 1'b1;
			enable2 = 1'b0;
			enable5 =1'b0;
			ready = 1'b0;
			ready_bias =1'b0;
			enable6=1'b1;
			enable7=1'b1;
			enable8=1'b0;
			enable9=1'b0;
		end
	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					// reset
					j3=0;
					j4=0;
					d1=0;
				end
			else if (enable7 && control_weight) 
				begin
						d1=d1+1;
					if (d1==1) 
						begin
							d1=0;
							enable7=1'b0;
							enable8=1'b1;
						end
				end

			else if (enable8) 
				begin
					j3=j3+1;
					//if (j3==F_COL*F_ROW-1) 
					//	begin
					//		enable9=1'b1;
					//	end
					if (j3==F_COL*F_ROW) 
						begin
							j3=0;
							//j4=j4+1;
							weight_outArray[j4] = weight_Temp;
							enable9=1'b1;
							enable8=1'b0;
							
						end
				end
			else if (enable9) 
				begin
					enable9=1'b0;
					enable8=1'b1;
					j3=j3+1;
					j4=j4+1;
					if (j4==CHANNEL*BATCH) 
						begin
							j4=0;
							enable9=1'b0;
							enable8=1'b0;
						end
					
				end
	end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					// reset
					i3=0;
					//j3=0;
					k3=0;
				//	i4=0;
					k4=0;
					k5=0;
					k5_old=0;

				//	i5=0;
				end
			else if (enable3 && control_weight) 
				begin
					weight_Temp[i3*BIT+:BIT] = weight;	////edit
					if (i3<F_COL*F_ROW) 
						begin
							i3=i3+1;
							//if (i3==F_ROW*F_COL-1) 
							//	begin
							//		enable2 = 1'b1;					
							//	end							
							if (i3==F_ROW*F_COL) 
							 	begin
							 		i3=0;
							 		k3=k3+1;
							 		//weight_outArray[j4] = weight_Temp;
									//enable3 = 1'b0;
									//enable3 <= (enable3==1'b0) ? 1'b1: enable3;
							 	end
							 if (k3==CHANNEL*BATCH) 
								begin
									k3=0;
							//enable2 = 1'b0;
									enable3 =1'b0;
									enable5=1'b1;
								end

						end
					//if (j3<F_ROW*F_COL*CHANNEL*BATCH) 
					//	begin
					//		j3=j3+1;
					//			if (j3==F_ROW*F_COL*CHANNEL*BATCH)
					//				begin
					//					j3=0;
					//					enable3 = 1'b0;
					//				end
					//	end

				end
			//else if (enable2) 
			//	begin
					//enable3 <= 1'b1;
			//		enable2 = 1'b0;
			//		k3=k3+1;
			//		if (k3==CHANNEL*BATCH) 
			//			begin
			//				k3=0;
			//				enable2 = 1'b0;
			//				enable3 =1'b0;
							//enable4 = 1'b1;
			//				enable5 = 1'b1;
			//			end
					//	end
			
			//	end
			else if (enable5 && ready_image_control) 
				begin
					counter = k4 + k5*CHANNEL;
					weight_outTemp = weight_outArray [counter];
					//
					ready = 1'b1;
					if (k4<CHANNEL) 
						begin
							k4=k4+1;
							//k5=k5;
							if (k4==CHANNEL) 
								begin
								//	k5=k5_old;
									k4=0;
									if (ready_fb) 
										begin
											k5=k5+1;
											
											k4=0;
											if (k5==BATCH) 
												begin
													k5=0;
													//i4=0;
													enable5 =1'b0;
												//	enable4 =1'b0;
												end

										end
								end
						end
					
					
				end

		end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
				// reset
				i5=0;
				i4=0;
				end
			else if (enable4 && fb_bias) 
				begin
					
					bias_outTemp = biasArray[i4];
					ready_bias = 1'b1;
					if (i5<COL*ROW*CHANNEL) 
						begin
							i5=i5+1;
						end
					if (i5==COL*ROW*CHANNEL) 
						begin
							i5=0;
							i4=i4+1;
							if (i4==BATCH) 	
								begin
									i4=0;
									enable4=1'b0;
								end
						end
									
					
												
				end
		end

	always @(posedge clk or negedge rst_) 
		begin
			if (!rst_) 
				begin
					// reset
					i6=0;
				end
			else if (enable6 && control_bias) 
				begin
					biasArray[i6]=bias;	////edit
					i6=i6+1;
					if (i6==BATCH) 
						begin
							i6=0;
							enable6=1'b0;
						end
				end
	end
 
	assign weight_out = weight_outTemp;
	
	assign bias_out = bias_outTemp ;


	
	
endmodule		