use mod_proxy;

use strict;
use warnings;

my ($test) = $ARGV[0];
print mod_proxy::get($test);

