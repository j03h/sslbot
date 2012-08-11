use mod_ReverseDNS;

use strict;
use warnings;

my ($test) = $ARGV[0];
print mod_ReverseDNS::ReverseDNS($test);
