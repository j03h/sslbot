package mod_Google;

use strict;
use mod_Curl;

sub search {
	my ($word) = @_;
	my @res; 
	my $req = mod_Curl::req('http://ajax.googleapis.com/ajax/services/search/web?v=1.0&start=0&rsz=5&q='.$word);
	while($req =~ m/"unescapedUrl":"(.*?)",.*?"titleNoFormatting":"(.*?)",/g) {
		push(@res, "".$2." | ".$1);
	}
	return @res;
}

1;
__END__