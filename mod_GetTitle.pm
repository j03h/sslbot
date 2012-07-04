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
	while ($title =~ m/<title>(.*?)<\/title>/g) {
		return $1;
	}
}
1;
__END__