package mod_GetTitle;

# por j03h
# modulo que obtiene el titulo de las paginas web
# 04/07/2012
# correo@j03h.com

use strict;
use mod_Curl;

sub GetTitle {
	my ($url) = @_;
	my $title = mod_Curl::req($url);
	while ($title =~ m/<title>\s*(.*?)<\/title>/s) {
		my $res = $1;
		$res =~ s/\r|\n|\t|^\s|\s+$|\s\s//g;
		return $res;
	}
}
1;
__END__