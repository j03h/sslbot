use mod_Proxy;

use strict;
use warnings;

my ($test) = $ARGV[0];
print mod_Proxy::get($test);

