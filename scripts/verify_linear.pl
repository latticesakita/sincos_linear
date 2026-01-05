#!/var/env perl
#
#
use Math::Trig 'pi';

$Y_BITS = 32;

open $csv, "<", $ARGV[0] or die $!;
$max_err=0;
$cnt=0;
$sum_err=0;
$sum2_err=0;
my @y0;
my @dy;
my $frac = 35;
my $total_bits = 36;

&get_table(1024);

$cnt_terrible = 0;

while(<$csv>){
	chomp;
	next if !/^[0-9A-Fa-f]+,/;
	@fld = split /,/;
	$phase = hex $fld[1];
        $y_out = hex $fld[2];

	$theta = $phase * pi / (1<<30) / 2;
	$y_ideal = sin($theta);

	if ($y_out & (1<<($Y_BITS-1))) {
		$y_out_neg = (~$y_out + 1) & ((1<<$Y_BITS) - 1);
		$y_fpga = -$y_out_neg;
	}
	else{
		$y_fpga = $y_out;
	}
	$y_fpga = $y_fpga / (1<<($Y_BITS-1));


	# $err = ($y_fpga > $y_ideal) ? $y_fpga - $y_ideal : $y_ideal - $y_fpga;
	$err = abs($y_fpga - $y_ideal);
	if(($err>1e-3) && ($cnt_terrible<10))
        {
		$cnt_terrible++;
	 	# printf "y_out=%03x, %09x\n",$y_out, ($y_out & (1<<($Y_BITS-1)));
		printf "%-25s, theta=%.6e y_fpga=%13.6e y_ideal=%13.6e err=%13.6e\n", $_, $theta, $y_fpga, $y_ideal, $err;
		&sin_half($phase, 1);
	}

        $max_err = ($err > $max_err) ? $err : $max_err;
        $cnt++;
        $sum_err+=$err;
	$sum2_err+=$err*$err;

}

printf "cnt = 0x%x, max_err = %.3e, err(ave)=%.3e, err(sigma)=%.3e\n", $cnt, $max_err, $sum_err/$cnt, sqrt($sum2_err/$cnt - $sum_err*$sum_err/$cnt/$cnt);



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
	my $addr     = ($phase >> 20) & (1023);
	my $frac     = $phase & ((1<<20) - 1);


	my $fpga_sin = &multAxBpC($dy[$addr], $frac, $y0[$addr]<<20);
	$fpga_sin = $fpga_sin >> 24;
	$fpga_sin = ($quadrant & 2) ? (~$fpga_sin) & ((1<<32)-1) : $fpga_sin;

	if($en_print){  printf "q = %x, a = %d, frac = %x, y0 = %d, dy = %d, fpga_sin = %x\n", $quadrant, $addr, $frac, $y0[$addr], $dy[$addr], $fpga_sin};

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
		my $y = &quantize($sin0, $frac, $total_bits);
		my $d = &quantize($sin1 - $sin0, $frac, $total_bits);
		push @y0, $y;
		push @dy, $d;
		# printf "y0 = %05X, dy = %05X\n", $y, $d;
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
