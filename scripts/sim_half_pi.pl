#!perl

use Math::Trig 'pi';
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

my @y0;
my @dy;
my @y0_dy;
my $grid = 4096;
my $frac = 17;
my $total_bits = 18;
my $shift = 12;

my $NSAMPLES = $grid*256;
my $NSAMPLES_BITS = int(log($NSAMPLES)/log(2) + 0.5);
my $diff_max    = 0;
my $diff_total  = 0;
my $diff2_total = 0;
my $cnt;
my $err_cnt = 0;

open $fy0, ">", "rom_out/y36.mem" or die $!;
open $fdy, ">", "rom_out/dy18.mem" or die $!;

&get_table($grid);

close $fy0;
close $fdy;

for( my $i=0; $i<$NSAMPLES; $i++ ){
	my $phase = $i << (32-2-$NSAMPLES_BITS);
	# my $sin_fpga = &sin_half($phase, 0) / (1<<31);
	my $sin_fpga = &sin_half($phase, 0);
	if($sin_fpga & (1<<31)){
		$sin_fpga = (~$sin_fpga + 1) & ((1<<32)-1);
		$sin_fpga = -$sin_fpga;
	}
	$sin_fpga = $sin_fpga / (1<<30);

	my $theta = $phase / (1<<30) * pi / 2;
	my $sin_ideal = sin($theta);
	my $diff = abs($sin_fpga - $sin_ideal);

	$diff_max = ($diff_max<$diff) ? $diff : $diff_max;
	$diff_total += $diff;
	$diff2_total += $diff*$diff;
	$cnt++;

	if(($diff>1e-3)&&($err_cnt<10)){
		$err_cnt++;
		#$phase = $i << (32-2-$NSAMPLES_BITS);
		$sin_fpga_org = $sin_fpga;
		$sin_fpga = &sin_half($phase, 1);
		printf "theta = %.6e, sin_fpga = %.6e(%x), sin_ideal = %.6e, diff = %.6e\n", $theta, $sin_fpga_org,$sin_fpga, $sin_ideal, $diff;
	}
}
printf "diff_max = %.6e, diff(ave) = %.6e, sigma = %.6e\n", 
	$diff_max,
	$diff_total/$cnt,
	sqrt($diff2_total/$cnt - $diff_total*$diff_total/$cnt/$cnt);

# FPGA input is 32bits
# 2 bits are quadrant
# 30bits are address.
#   top 10bits will be the address, 20bits are calculated
sub sin_half {
	my $phase = shift; # 32bits
	my $en_print = shift;

	$phase = $phase & ((1<<32)-1);
	my $quadrant = $phase >> 30;
	if($quadrant & 1){
		if($en_print){ printf "phase %x -> %x\n", $phase, (-$phase) & ((1<<32)-1)};
		$phase = ~$phase;
	}
	my $addr     = ($phase >> 18) & (4095);
	my $frac     = $phase & ((1<<18) - 1);


	my $fpga_sin = &multAxBpC($dy[$addr], $frac, $y0[$addr]<<($shift));
	$fpga_sin = $fpga_sin >>(36-32+$shift+1) ; # was 13
	$fpga_sin = ($quadrant & 2) ? (~$fpga_sin) & ((1<<32)-1) : $fpga_sin;

	if($en_print){  printf "q = %x, a = %x, frac = %x, y0 = %x, dy = %x, fpga_sin = %08x\n", $quadrant, $addr, $frac, $y0[$addr], $dy[$addr], $fpga_sin};

	return $fpga_sin ;
}



sub multAxBpC {
	my $a = shift;
	my $b = shift;
	my $c = shift;

	return $a * $b + $c;
}


sub get_table {
	my $grid = shift;

	for( my $i=0; $i<$grid; $i++ ){
		my $sin0 = sin(pi/2*$i/$grid);
		my $sin1 = sin(pi/2*($i+1)/$grid);
		my $y = &quantize($sin0, 36-1, 36);
		my $d = &quantize($sin1 - $sin0, 17+$shift, 18);
		push @y0, $y;
		push @dy, $d;
		# printf "y0 = %09X, dy = %05X\n", $y, $d;
		printf $fy0 "%09X\n", $y;
		printf $fdy "%05X\n", $d;
	}
	return (@y0, @dy);
}


sub quantize {
	my $val = shift; # floating
	my $frac_bits = shift;
	my $total_bits = shift;

	my $val_int = int($val * (1<<$frac_bits) + 0.5);
	$val_int = $val_int & ((1<<$total_bits) - 1);
	return $val_int;
}



