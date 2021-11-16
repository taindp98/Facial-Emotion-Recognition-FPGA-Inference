`timescale 1ns / 1ns
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
module tb;

	reg clk;
	reg rst_;

	reg control_image;
                          //4conv
	reg control_weight1;
	reg control_bias1;

	reg control_weight2;
	reg control_bias2;

	reg control_weight3;
	reg control_bias3;

	reg control_weight4;
	reg control_bias4;

	//reg control_weight5;
	//reg control_bias5;
                           //2 lop fc
	reg control_weight6;
	reg control_bias6;

	reg control_weight7;
	reg control_bias7;

	//reg control_weight8;
	//reg control_bias8;

	////////////////////////////////////////////////////////////////////////////

	initial
    	begin
        	rst_ = 0;
		#5 rst_=1;
		end

    always
    	begin
	
        	clk = 1;
        	#1;
        	clk = 0;
        	#1;
    	end

    ///////////////////////////////////////////////////////////////////////////
   
    parameter F_COL = 3;
    parameter F_ROW = 3;

 	parameter BATCH1 = 20;
 	parameter BATCH2 = 20;
 	parameter BATCH3 = 24;
 	parameter BATCH4 = 28;
 	parameter BATCH5 = 24;
 	parameter BATCH6 = 6;

	reg [31:0] imageTemp [0:2303]; //48x48x1
	reg [31:0] image;

	reg [31:0] weight1Temp [0:BATCH1*F_ROW*F_COL-1]; //3x3x32x1
	reg [31:0] weight1;
	reg [31:0] bias1Temp [0:BATCH1-1];	//32
	reg [31:0] bias1;

	reg [31:0] weight2Temp [0:BATCH1*BATCH2*F_COL*F_ROW-1]; //3x3x32x32
	reg [31:0] weight2;
	reg [31:0] bias2Temp [0:BATCH2-1];	//20
	reg [31:0] bias2;

	reg [31:0] weight3Temp [0:BATCH2*BATCH3*F_ROW*F_COL-1]; //3x3x32x36
	reg [31:0] weight3;
	reg [31:0] bias3Temp [0:BATCH3-1];	//36
	reg [31:0] bias3;

	reg [31:0] weight4Temp [0:BATCH3*BATCH4*F_COL*F_ROW-1]; //3x3x36x38
	reg [31:0] weight4;
	reg [31:0] bias4Temp [0:BATCH4-1];	//38
	reg [31:0] bias4;

	//reg [31:0] weight5Temp [0:73727]; //3x3x64x128
	//reg [31:0] weight5;
	//reg [31:0] bias5Temp [0:127];	//128
	//reg [31:0] bias5;

	reg [31:0] weight6Temp [0:BATCH4*BATCH5*F_ROW*F_COL-1]; //3x3x38x38
	reg [31:0] weight6;
	reg [31:0] bias6Temp [0:BATCH5-1];	//38
	reg [31:0] bias6;

	reg [31:0] weight7Temp [0:BATCH5*BATCH6-1]; //38x6
	reg [31:0] weight7;
	reg [31:0] bias7Temp [0:BATCH6-1];	//6
	reg [31:0] bias7;

	//reg [31:0] weight8Temp [0:383]; //64x6
	//reg [31:0] weight8;
	//reg [31:0] bias8Temp [0:5];		//6
	//reg [31:0] bias8;

	////////////////////////////////////////////////////////////////////

	wire [31:0] data_out;
	wire data_ready_out_fc;
	////////////////////////////////////////////////////////////////////

	conv_top uut(
		.clk(clk),
		.rst_(rst_),

		.image(image),
		.control_image(control_image),

		.weight1(weight1),
		.control_weight1(control_weight1),
		.bias1(bias1),
		.control_bias1(control_bias1),

		.weight2(weight2),
		.control_weight2(control_weight2),
		.bias2(bias2),
		.control_bias2(control_bias2),

		.weight3(weight3),
		.control_weight3(control_weight3),
		.bias3(bias3),
		.control_bias3(control_bias3),

		.weight4(weight4),
		.control_weight4(control_weight4),
		.bias4(bias4),
		.control_bias4(control_bias4),

		//.weight5(weight5),
		//.control_weight5(control_weight5),
		//.bias5(bias5),
		//.control_bias5(control_bias5),

		.weight6(weight6),
		.control_weight6(control_weight6),
		.bias6(bias6),
		.control_bias6(control_bias6),

		.weight7(weight7),
		.control_weight7(control_weight7),
		.bias7(bias7),
		.control_bias7(control_bias7),

		//.weight8(weight8),
		//.control_weight8(control_weight8),
		//.bias8(bias8),
		//.control_bias8(control_bias8),
	
		.data_out(data_out),
		.data_ready_out_fc(data_ready_out_fc)
		);

	/////////////////////////////////////////////////////////////////

	reg enable1;
	reg enable2;
	reg enable3;
	reg enable4;
	reg enable5;
	reg enable6;
	reg enable7;
	reg enable8;
	reg enable9;
	//reg enable10;
	//reg enable11;
	reg enable12;
	reg enable13;
	reg enable14;
	reg enable15;
	//reg enable16;
	//reg enable17;

	integer i1,i2,i3,i4,i5,i6,i7,i8,i9,i12,i13,i14,i15;

	initial
		begin
			i1=0;
			i2=0;
			i3=0;
			i4=0;
			i5=0;
			i6=0;
			i7=0;
			i8=0;
			i9=0;
			//i10=0;
			//i11=0;
			i12=0;
			i13=0;
			i14=0;
			i15=0;
			//i16=0;
			//i17=0;
			$readmemb("image.txt",imageTemp);				//doi ten anh
			$readmemb("CONV2D_1_kernel.txt",weight1Temp);
			$readmemb("CONV2D_1_bias.txt",bias1Temp);
			$readmemb("CONV2D_2_kernel.txt",weight2Temp);
			$readmemb("CONV2D_2_bias.txt",bias2Temp);
			$readmemb("CONV2D_3_kernel.txt",weight3Temp);
			$readmemb("CONV2D_3_bias.txt",bias3Temp);
			$readmemb("CONV2D_4_kernel.txt",weight4Temp);
			$readmemb("CONV2D_4_bias.txt",bias4Temp);
			//$readmemb("CONV2D_5_kernel.txt",weight5Temp);
			//$readmemb("CONV2D_5_bias.txt",bias5Temp);

			$readmemb("DENSE_1_kernel.txt",weight6Temp);
			$readmemb("DENSE_1_bias.txt",bias6Temp);
			$readmemb("DENSE_2_kernel.txt",weight7Temp);
			$readmemb("DENSE_2_bias.txt",bias7Temp);
			//$readmemb("DENSE_3_kernel.txt",weight8Temp);
			//$readmemb("DENSE_3_bias.txt",bias8Temp);

			enable1=1'b1;
			enable2=1'b1;
			enable3=1'b1;
			enable4=1'b1;
			enable5=1'b1;
			enable6=1'b1;
			enable7=1'b1;
			enable8=1'b1;
			enable9=1'b1;
			//enable10=1'b1;
			//enable11=1'b1;
			enable12=1'b1;
			enable13=1'b1;
			enable14=1'b1;
			enable15=1'b1;
			//enable16=1'b1;
			//enable17=1'b1;
		end

	/////////////////////////////////////////////////////////////////

	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i1=0;
			end
		else if (enable1) 
			begin
				control_image=1'b1;
				image = imageTemp [i1];
				i1=i1+1;
				if (i1==2304) 
					begin
						i1=0;
						enable1=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i2=0;
			end
		else if (enable2) 
			begin
				control_weight1=1'b1;
				weight1 = weight1Temp [i2];
				i2=i2+1;
				if (i2==BATCH1*F_ROW*F_COL) 
					begin
						i2=0;
						enable2=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i3=0;
			end
		else if (enable3) 
			begin
				control_bias1 =1'b1;
				bias1 = bias1Temp [i3];
				i3=i3+1;
				if (i3==BATCH1) 
					begin
						i3=0;
						enable3=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i4=0;
			end
		else if (enable4) 
			begin
				control_weight2=1'b1;
				weight2 = weight2Temp [i4];
				i4=i4+1;
				if (i4==BATCH1*BATCH2*F_COL*F_ROW) 
					begin
						i4=0;
						enable4=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i5=0;
			end
		else if (enable5) 
			begin
				control_bias2 =1'b1;
				bias2 = bias2Temp [i5];
				i5=i5+1;
				if (i5==BATCH2) 
					begin
						i5=0;
						enable5=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i6=0;
			end
		else if (enable6) 
			begin
				control_weight3=1'b1;
				weight3 = weight3Temp [i6];
				i6=i6+1;
				if (i6==BATCH2*BATCH3*F_ROW*F_COL) 
					begin
						i6=0;
						enable6=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i7=0;
			end
		else if (enable7) 
			begin
				control_bias3 =1'b1;
				bias3 = bias3Temp [i7];
				i7=i7+1;
				if (i7==BATCH3) 
					begin
						i7=0;
						enable7=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i8=0;
			end
		else if (enable8) 
			begin
				control_weight4=1'b1;
				weight4 = weight4Temp [i8];
				i8=i8+1;
				if (i8==BATCH3*BATCH4*F_COL*F_ROW) 
					begin
						i8=0;
						enable8=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i9=0;
			end
		else if (enable9) 
			begin
				control_bias4 =1'b1;
				bias4 = bias4Temp [i9];
				i9=i9+1;
				if (i9==BATCH4) 
					begin
						i9=0;
						enable9=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
/*	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i10=0;
			end
		else if (enable10) 
			begin
				control_weight5=1'b1;
				weight5 = weight5Temp [i10];
				i10=i10+1;
				if (i10==73728) 
					begin
						i10=0;
						enable10=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i11=0;
			end
		else if (enable11) 
			begin
				control_bias5 =1'b1;
				bias5 = bias5Temp [i11];
				i11=i11+1;
				if (i11==128) 
					begin
						i11=0;
						enable11=1'b0;
					end
			end
		
	end
*/
	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i12=0;
			end
		else if (enable12) 
			begin
				control_weight6=1'b1;
				weight6 = weight6Temp [i12];
				i12=i12+1;
				if (i12==BATCH4*BATCH5*F_ROW*F_COL) ////////
					begin
						i12=0;
						enable12=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i13=0;
			end
		else if (enable13) 
			begin
				control_bias6 =1'b1;
				bias6 = bias6Temp [i13];
				i13=i13+1;
				if (i13==BATCH5) 
					begin
						i13=0;
						enable13=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i14=0;
			end
		else if (enable14) 
			begin
				control_weight7=1'b1;
				weight7 = weight7Temp [i14];
				i14=i14+1;
				if (i14==BATCH5*BATCH6) 
					begin
						i14=0;
						enable14=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i15=0;
			end
		else if (enable15) 
			begin
				control_bias7 =1'b1;
				bias7 = bias7Temp [i15];
				i15=i15+1;
				if (i15==BATCH6) 
					begin
						i15=0;
						enable15=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	/*
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i16=0;
			end
		else if (enable16) 
			begin
				control_weight8=1'b1;
				weight8 = weight8Temp [i16];
				i16=i16+1;
				if (i16==384) 
					begin
						i16=0;
						enable16=1'b0;
					end
			end
		
	end

	/////////////////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_) 
	begin
		if (!rst_) 
			begin
				i17=0;
			end
		else if (enable17) 
			begin
				control_bias8 =1'b1;
				bias8 = bias8Temp [i17];
				i17=i17+1;
				if (i17==6) 
					begin
						i17=0;
						enable17=1'b0;
					end
			end
		
	end
*/

	test_write wr1(
		.clk(clk),
		.rst_(rst_),
		.flag_ready(data_ready_out_fc),
		.data_in(data_out),
		.done(done)
		);


endmodule


	module test_write(
	clk,
	rst_,
	flag_ready,
	data_in,
	done
	);
	input clk;
	input rst_;
	input flag_ready;
	input [31:0] data_in;
	output reg done;
	integer fd,scan,i,j;
	initial
		begin
			fd=$fopen("result_display.txt","w");
			i=0;
			j=0;
			done = 1'b0;
		end

	always @(posedge clk)
		begin
			if (flag_ready) 
				begin
					if (i<38) 
						begin
							i = i+1;
						end
					if (i==38) 
						begin
							$fwrite(fd,"%b\n",data_in);
							i=0;
							j=j+1;
						end
					if (j==6) 
						begin
							j=0;
							done = 1'b1;
							$fclose(fd);
						end
				end
		end

endmodule