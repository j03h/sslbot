use mod_Proxy;

use strict;
use warnings;

my ($test) = $ARGV[0];
my @arr = mod_Proxy::check($test);
foreach my $pro (@arr){
	print $pro."\n";
}

