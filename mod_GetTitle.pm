<<<<<<< HEAD
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
=======
package GetTitle;# TESTING MODULEuse strict;use warning;use mod_Curl;sub GetTitle() {	#my ($url) = @_;	my $title = "lol";	return $title;}1;__END__
>>>>>>> 212f0dcfa311a6da5bf3180554fe9ce8cf29976c
