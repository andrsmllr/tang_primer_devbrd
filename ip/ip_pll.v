/************************************************************\
 **  Copyright (c) 2011-2021 Anlogic, Inc.
 **  All Right Reserved.
\************************************************************/
/************************************************************\
 ** Log	:	This file is generated by Anlogic IP Generator.
 ** File	:	C:/Users/andre/root/_local/anlogic_td/test_prj/al_ip/ip_pll.v
 ** Date	:	2019 09 01
 ** TD version	:	4.3.815
\************************************************************/

///////////////////////////////////////////////////////////////////////////////
//	Input frequency:             266.666Mhz
//	Clock multiplication factor: 13
//	Clock division factor:       13
//	Clock information:
//		Clock name	| Frequency 	| Phase shift
//		C0        	| 266.666MHZ	| 0  DEG     
//		C1        	| 133.333MHZ	| 0  DEG     
//		C2        	| 66.666 MHZ	| 0  DEG     
//		C3        	| 33.333 MHZ	| 0  DEG     
//		C4        	| 16.667 MHZ	| 0  DEG     
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 100 fs

module ip_pll(refclk,
		reset,
		extlock,
		clk0_out,
		clk1_out,
		clk2_out,
		clk3_out,
		clk4_out);

	input refclk;
	input reset;
	output extlock;
	output clk0_out;
	output clk1_out;
	output clk2_out;
	output clk3_out;
	output clk4_out;

	wire clk0_buf;

	EG_LOGIC_BUFG bufg_feedback( .i(clk0_buf), .o(clk0_out) );

	EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
		.DYNCFG("DISABLE"),
		.FIN("266.666"),
		.FEEDBK_MODE("NORMAL"),
		.FEEDBK_PATH("CLKC0_EXT"),
		.STDBY_ENABLE("DISABLE"),
		.PLLRST_ENA("ENABLE"),
		.SYNC_ENABLE("DISABLE"),
		.DERIVE_PLL_CLOCKS("DISABLE"),
		.GEN_BASIC_CLOCK("DISABLE"),
		.GMC_GAIN(6),
		.ICP_CURRENT(3),
		.KVCO(6),
		.LPF_CAPACITOR(3),
		.LPF_RESISTOR(2),
		.REFCLK_DIV(13),
		.FBCLK_DIV(13),
		.CLKC0_ENABLE("ENABLE"),
		.CLKC0_DIV(4),
		.CLKC0_CPHASE(3),
		.CLKC0_FPHASE(0),
		.CLKC1_ENABLE("ENABLE"),
		.CLKC1_DIV(8),
		.CLKC1_CPHASE(7),
		.CLKC1_FPHASE(0),
		.CLKC2_ENABLE("ENABLE"),
		.CLKC2_DIV(16),
		.CLKC2_CPHASE(15),
		.CLKC2_FPHASE(0),
		.CLKC3_ENABLE("ENABLE"),
		.CLKC3_DIV(32),
		.CLKC3_CPHASE(31),
		.CLKC3_FPHASE(0),
		.CLKC4_ENABLE("ENABLE"),
		.CLKC4_DIV(64),
		.CLKC4_CPHASE(63),
		.CLKC4_FPHASE(0)	)
	pll_inst (.refclk(refclk),
		.reset(reset),
		.stdby(1'b0),
		.extlock(extlock),
		.psclk(1'b0),
		.psdown(1'b0),
		.psstep(1'b0),
		.psclksel(3'b000),
		.psdone(open),
		.dclk(1'b0),
		.dcs(1'b0),
		.dwe(1'b0),
		.di(8'b00000000),
		.daddr(6'b000000),
		.do({open, open, open, open, open, open, open, open}),
		.fbclk(clk0_out),
		.clkc({clk4_out, clk3_out, clk2_out, clk1_out, clk0_buf}));

endmodule
