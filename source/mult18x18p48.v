// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------

module mult18x18p48 // A * B + C
#(
	parameter ASIGNED	=	"SIGNED",
	parameter BSIGNED	=	"SIGNED",
	parameter REGINPUTA	=	"BYPASSED", // REGISTERED_ONCE, REGISTERED_TWICE, BYPASSED 
	parameter REGINPUTB	=	"BYPASSED", // REGISTERED_ONCE, REGISTERED_TWICE, BYPASSED 
	parameter REGINPUTC	=	"BYPASSED", // REGISTERED_ONCE, REGISTERED_TWICE, BYPASSED 
	parameter REGPIPE	=	"BYPASSED", // REGISTERED, BYPASSED
	parameter REGOUTPUT	=	"BYPASSED"  // REGISTERED, BYPASSED
)
(
	input        clk,
	input        resetn,
	input [17:0] A,
	input [17:0] B,
	input [47:0] C,
	output [47:0] Z
);


	MULTADDSUB18X18A #(
		.ASIGNED		(ASIGNED),
		.BSIGNED		(BSIGNED),
		.REGINPUTA		(REGINPUTA),
		.REGINPUTB		(REGINPUTB),
		.REGINPUTC		(REGINPUTC),
		.REGSHIFTOUTA		("BYPASSED"),
		.REGSHIFTOUTB		("BYPASSED"),
		.REGSHIFTOUTC		("BYPASSED"),
		.SHIFTINPUTA		("DISABLED"),
		.SHIFTINPUTB		("DISABLED"),
		.SHIFTINPUTC		("DISABLED"),
		.REGPREPIPE		("BYPASSED"),
		.REGPIPE		(REGPIPE),
		.REGOUTPUT		(REGOUTPUT),
		.REGCAS_ZOUT		("BYPASSED"),
		.REGACCUMCONTROLS	("BYPASSED"),
		.RESETMODE		("ASYNC"),
		.ACCUM_EN		("ENABLED"), // ("DISABLED"),
		.CAS_ZOUT_RSHIFT	("DISABLED"),
		.PREADD_EN		("DISABLED"),
		.REGADDSUBPRE		("BYPASSED"),
		.ACCUM_C_EN		("ENABLED"), // ("DISABLED"),
		.CAS_ZIN_EN		("DISABLED"),// ("ENABLED")
		.CAS_CIN_EN		("DISABLED"),
		.ROUNDMODE		("ROUND_TO_ZERO"),
		.SATURATION		("DISABLED"),
		.SATURATION_BITS	("48"),
		.GSR			("DISABLED")

	) multaddsub_m0 (
		.A			(A[17:0]),
		.B			(B[17:0]),
		.C			(C[47:0]),
		.CLK			(clk),
		.RST			(~resetn),
		.CEA1			(1'b1),
		.CEA2			(1'b1),
		.CEB1			(1'b1),
		.CEB2			(1'b1),
		.CEOUTPIPE		(1'b1),
		.CEC1			(1'b1),
		.CEC2			(1'b1),
		.ASHIFTIN		(18'd0),
		.BSHIFTIN		(18'd0),
		.CSHIFTIN		(18'd0),
		.CIN			(1'b0),
		.CAS_ZIN		(48'b0), // *****
		.CAS_CIN		(1'b0),
		.SELC_N			(1'b0),
		.SELCAS_ZIN_N		(1'b0),
		.SELCARRY		(1'b0),
		.ADDSUBPRE		(1'b0),
		.ADDSUBACCUM		(1'b0),
		.ASHIFTOUT		(),
		.BSHIFTOUT		(),
		.CSHIFTOUT		(),
		.ZOUT			(Z),
		.COUT			(),
		.OVERFLOW		(),
		.CAS_ZOUT		(),
		.CAS_COUT		()
	);
endmodule

