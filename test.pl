use mod_Curl;

use strict;
use warnings;

my ($url) = $ARGV[0];
	my $title = mod_Curl::req($url);
	#print $title;
	while ($title =~ m!<title>s*(.*?)</title>!s) {
		#print $1;
		my $res = $1;
		$res =~ s/\r|\n|\t|^\s|\s+$|\s\s//g;
		print $res."\n\r";
		exit;
	}
