use mod_SQLiAdmBypass;

use strict;
use warnings;

my ($test) = $ARGV[0];
my @res = mod_SQLiAdmBypass::show($test);
foreach (@res) {
	print $_;
}
