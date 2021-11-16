`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// HoChiMinh University of Technology
//
// Filename     : conv_top.v
// Description  : 
//					
//
// Author       : tai.nguyen1011@hcmut.edu.vn
// Created On   : 04/10/2019
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////
module conv_top
	(
	clk,
	rst_,

	image,
	control_image,
                    //4 lop conv
	weight1,
	control_weight1,
	bias1,
	control_bias1,

	weight2,
	control_weight2,
	bias2,
	control_bias2,

	weight3,
	control_weight3,
	bias3,
	control_bias3,

	weight4,
	control_weight4,
	bias4,
	control_bias4,
                 //2 lop fc
	weight6,
	control_weight6,
	bias6,
	control_bias6,

	weight7,
	control_weight7,
	bias7,
	control_bias7,
	
	data_out,
	data_ready_out_fc
	);
////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port declarations
	input clk;
	input rst_;

	input [31:0] image; 	    //32x1x48x48
	input control_image;

	input [31:0] weight1;	    //32x32x1x3x3
	input control_weight1;
	input [31:0] bias1;	    //32x32
	input control_bias1;

	input [31:0] weight2;  	//32x32x32x3x3
	input control_weight2;	
	input [31:0] bias2;		//32x32	
	input control_bias2;

	input [31:0] weight3;	//32x48x32x3x3
	input control_weight3;
	input [31:0] bias3;		//32x48
	input control_bias3;

	input [31:0] weight4;	//32x64x48x3x3
	input control_weight4;
	input [31:0] bias4;		//32x64
	input control_bias4;



	input [31:0] weight6;	//32x128x(3x3x128)
	input control_weight6;
	input [31:0] bias6;		//32x128
	input control_bias6;

	input [31:0] weight7;	//32x64x128
	input control_weight7;
	input [31:0] bias7;		//32x64
	input control_bias7;

////////////////////////////////////////////////////////////////////////////////<-80 chars
// Port declarations
	output [31:0] data_out;
	output wire data_ready_out_fc;

////////////////////////////////////////////////////////////////////////////////<-80 chars


///////////////////////////////////// Layer1_Conv2d ////////////////////////////
///////////////////////////////////////Conv2d_Relu//////////////////////////////
	wire image_rd_1;
	wire weight_rd1_1;
	wire weight_rd2_1;
	wire conv_fb1_1;
	wire conv_fb2_1;
	wire conv_fb3_1;
	wire conv_fb4_1;
	wire data_rd_1;
	

	wire [287:0] image_out_1;						
	wire [287:0] weight_out_1;		
	wire [31:0] bias_out_1;
	wire [31:0] conv_out_1;
	wire [31:0] data_out_1;
	
	
	imageArray #(32,1,48,48,3,3) imAr1( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL
		.clk(clk),
		.rst_(rst_),
		.control_data(control_image),
		.stop_image(conv_fb3_1),
		.ready_fb(conv_fb1_1),
		.data_in(image),
		.ready(image_rd_1),
		.data_out(image_out_1)
		);

	weightArray #(32,1,48,48,3,3,20) wAr1( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight1),
		.control_bias(control_bias1),
		.ready_image_control(image_rd_1),
		.fb_bias(conv_fb4_1),
		.ready_fb(conv_fb2_1),
		.ready_bias(weight_rd1_1),
		.ready(weight_rd2_1),
		.weight(weight1),
		.bias(bias1),
		.weight_out(weight_out_1),
		.bias_out(bias_out_1)
		);
	conv_main #(32,1,48,48,3,3,20) cvm1( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.ready_bias(weight_rd1_1),
		.ready_image(image_rd_1),
		.ready_weight(weight_rd2_1),
		.data_in(image_out_1),
		.weight(weight_out_1),
		.bias(bias_out_1),
		.data_out(conv_out_1),
		.fb_image(conv_fb1_1),
		.fb_weight(conv_fb2_1),
		.stop_image(conv_fb3_1),
		.fb_bias(conv_fb4_1)
		);


	max_pool #(32,20,1,48,48,2,2) mpl1( //BIT,BATCH_BEFORE,CHANNEL_BEFORE,COL,ROW,M_COL
		.clk(clk),
		.rst_(rst_),
		.ready_maxpool(weight_rd1_1),
		.data_in(conv_out_1),
		.data_out(data_out_1),
		.data_ready(data_rd_1)
		);

///////////////////////////////////// Layer2_Conv2d//////////////////////////
////////////////////////////////////Conv2d_Relu_Maxpool//////////////////

	wire image_rd_2;
	wire weight_rd1_2;
	wire weight_rd2_2;
	wire conv_fb1_2;
	wire conv_fb2_2;
	wire conv_fb3_2;
	wire conv_fb4_2;
	wire data_rd_2;

	wire [287:0] image_out_2;						
	wire [287:0] weight_out_2;
	wire [31:0] conv_out_2;		////sai
	wire [31:0] bias_out_2;
	wire [31:0] data_out_2;

	imageArray #(32,20,24,24,3,3) imAr2( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL
		.clk(clk),
		.rst_(rst_),
		.control_data(data_rd_1),
		.stop_image(conv_fb3_2),
		.ready_fb(conv_fb1_2),
		.data_in(data_out_1),
		.ready(image_rd_2),
		.data_out(image_out_2)
		);

	weightArray #(32,20,24,24,3,3,20) wAr2( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight2),
		.control_bias(control_bias2),
		.ready_image_control(image_rd_2),
		.fb_bias(conv_fb4_2),
		.ready_fb(conv_fb2_2),
		.ready_bias(weight_rd1_2),
		.ready(weight_rd2_2),
		.weight(weight2),
		.bias(bias2),
		.weight_out(weight_out_2),
		.bias_out(bias_out_2)
		);

	conv_main #(32,20,24,24,3,3,20) cvm2( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.ready_bias(weight_rd1_2),
		.ready_image(image_rd_2),
		.ready_weight(weight_rd2_2),
		.data_in(image_out_2),
		.weight(weight_out_2),
		.bias(bias_out_2),
		.data_out(conv_out_2),
		.fb_image(conv_fb1_2),
		.fb_weight(conv_fb2_2),
		.stop_image(conv_fb3_2),
		.fb_bias(conv_fb4_2)
		);

	max_pool #(32,20,20,24,24,2,2) mpl2( //BIT,BATCH_BEFORE,CHANNEL_BEFORE,COL,ROW,M_COL
		.clk(clk),
		.rst_(rst_),
		.ready_maxpool(weight_rd1_2),
		.data_in(conv_out_2),
		.data_out(data_out_2),
		.data_ready(data_rd_2)
		);
	
////////////////////////////////////////////Layer3///////////////////////////////
///////////////////////////////////Conv2d_Relu_Maxpool//////////////////////////////

	wire image_rd_3;
	wire weight_rd1_3;
	wire weight_rd2_3;
	wire conv_fb1_3;
	wire conv_fb2_3;
	wire conv_fb3_3;
	wire conv_fb4_3;
	wire data_rd_3;

	wire [287:0] image_out_3;						
	wire [287:0] weight_out_3;
	wire [31:0] conv_out_3;			//sai
	wire [31:0] bias_out_3;
	wire [31:0] data_out_3;

	imageArray #(32,20,12,12,3,3) imAr3( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL
		.clk(clk),
		.rst_(rst_),
		.control_data(data_rd_2),
		.stop_image(conv_fb3_3),
		.ready_fb(conv_fb1_3),
		.data_in(data_out_2),
		.ready(image_rd_3),
		.data_out(image_out_3)
		);

	weightArray #(32,20,12,12,3,3,24) wAr3(//BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight3),
		.control_bias(control_bias3),
		.ready_image_control(image_rd_3),
		.fb_bias(conv_fb4_3),
		.ready_fb(conv_fb2_3),
		.ready_bias(weight_rd1_3),
		.ready(weight_rd2_3),
		.weight(weight3),
		.bias(bias3),
		.weight_out(weight_out_3),
		.bias_out(bias_out_3)
		);

	conv_main #(32,20,12,12,3,3,24) cvm3( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.ready_bias(weight_rd1_3),
		.ready_image(image_rd_3),
		.ready_weight(weight_rd2_3),
		.data_in(image_out_3),
		.weight(weight_out_3),
		.bias(bias_out_3),
		.data_out(conv_out_3),
		.fb_image(conv_fb1_3),
		.fb_weight(conv_fb2_3),
		.stop_image(conv_fb3_3),
		.fb_bias(conv_fb4_3)
		);

	max_pool #(32,24,20,12,12,2,2) mpl3( //BIT,BATCH_BEFORE,CHANNEL_BEFORE,COL,ROW,M_COL
		.clk(clk),
		.rst_(rst_),
		.ready_maxpool(weight_rd1_3),
		.data_in(conv_out_3),
		.data_out(data_out_3),
		.data_ready(data_rd_3)
		);

//////////////////////////////////////Layer4///////////////////////////////////////////
//////////////////////////////////Conv2d_Relu_Maxpool////////////////////////////////

	wire image_rd_4;
	wire weight_rd1_4;
	wire weight_rd2_4;
	wire conv_fb1_4;
	wire conv_fb2_4;
	wire conv_fb3_4;
	wire conv_fb4_4;
	wire data_rd_4;

	wire [287:0] image_out_4;						
	wire [287:0] weight_out_4;
	wire [31:0] conv_out_4;		
	wire [31:0] bias_out_4;
	wire [31:0] data_out_4;

	imageArray #(32,24,6,6,3,3) imAr4( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL
		.clk(clk),
		.rst_(rst_),
		.control_data(data_rd_3),
		.stop_image(conv_fb3_4),
		.ready_fb(conv_fb1_4),
		.data_in(data_out_3),
		.ready(image_rd_4),
		.data_out(image_out_4)
		);


	weightArray #(32,24,6,6,3,3,28) wAr4(//BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight4),
		.control_bias(control_bias4),
		.ready_image_control(image_rd_4),
		.fb_bias(conv_fb4_4),
		.ready_fb(conv_fb2_4),
		.ready_bias(weight_rd1_4),
		.ready(weight_rd2_4),
		.weight(weight4),
		.bias(bias4),
		.weight_out(weight_out_4),
		.bias_out(bias_out_4)
		);

	conv_main #(32,24,6,6,3,3,28) cvm4( //BIT,CHANNEL,ROW,COL,F_ROW,F_COL,BATCH
		.clk(clk),
		.rst_(rst_),
		.ready_bias(weight_rd1_4),
		.ready_image(image_rd_4),
		.ready_weight(weight_rd2_4),
		.data_in(image_out_4),
		.weight(weight_out_4),
		.bias(bias_out_4),
		.data_out(conv_out_4),
		.fb_image(conv_fb1_4),
		.fb_weight(conv_fb2_4),
		.stop_image(conv_fb3_4),
		.fb_bias(conv_fb4_4)
		);

	max_pool #(32,28,24,6,6,2,2) mpl4( //BIT,BATCH_BEFORE,CHANNEL_BEFORE,COL,ROW,M_COL,M-ROW
		.clk(clk),
		.rst_(rst_),
		.ready_maxpool(weight_rd1_4),
		.data_in(conv_out_4),
		.data_out(data_out_4),
		.data_ready(data_rd_4)
		);

////////////////////////////////////////////Layer6////////////////////////////////////////
//////////////////////////////////////Fully_connected/relu//////////////////////////////

	wire fc_fb1_6;
	wire fc_fb2_6;
	wire data_rd_6;
	wire [31:0] weight_out_6;
	wire [31:0] bias_out_6;
	wire [31:0] data_out_6;

	weight_fc #(32,3,3,28,24) wfc1(//BIT,COL,ROW,CHANNEL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight6),
		.control_bias(control_bias6),
		.fb_weight(fc_fb1_6),
		.fb_bias(fc_fb2_6),
		.weight(weight6),
		.bias(bias6),
		.weight_out(weight_out_6),
		.bias_out(bias_out_6)
		);

	fc #(32,3,3,28,24) fc1(//BIT,COL,ROW,CHANNEL,BATCH
		.clk(clk),
		.rst_(rst_),
		.ready_data(data_rd_4),
		.data_in(data_out_4),
		.weight(weight_out_6),
		.bias(bias_out_6),
		.data_out(data_out_6),
		.fb_weight(fc_fb1_6),
		.fb_bias(fc_fb2_6),
		.data_ready(data_rd_6)
		);

	////////////////////////////////////////////Layer7///////////////////////////////////////////
	////////////////////////////////////////Fully_connected/relu/////////////////////////////////

	wire fc_fb1_7;
	wire fc_fb2_7;
	//wire data_rd_7;
	wire [31:0] weight_out_7;
	wire [31:0] bias_out_7;
	//wire [31:0] data_out_7;

	weight_fc #(32,1,1,24,6) wfc2(//BIT,COL,ROW,CHANNEL,BATCH
		.clk(clk),
		.rst_(rst_),
		.control_weight(control_weight7),
		.control_bias(control_bias7),
		.fb_weight(fc_fb1_7),
		.fb_bias(fc_fb2_7),
		.weight(weight7),
		.bias(bias7),
		.weight_out(weight_out_7),
		.bias_out(bias_out_7)
		);

//	edit them delay = kich thuoc ma tran truoc khi vao fc1
//	DELAY = (3*3)*28kenh 

	fc_final #(32,1,1,24,6,252) fc2(         //BIT,COL,ROW,CHANNEL,BATCH_BEFORE 
		.clk(clk),
		.rst_(rst_),
		.ready_data(data_rd_6),
		.data_in(data_out_6),
		.weight(weight_out_7),
		.bias(bias_out_7),
		.data_out(data_out),   
		.fb_weight(fc_fb1_7),    
		.fb_bias(fc_fb2_7),
		.data_ready(data_ready_out_fc)   
		); 

endmodule

