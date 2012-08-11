package mod_Pastebin;

# por j03h
# modulo que sube el contenido de un archivo a un pastebin
# 08/08/2012
# correo@j03h.com

use mod_Curl;

sub paste {
	my $code = abrirarchivo($_[0]);
	my $re = limpia(mod_Curl::req('http://paste.kde.org', '', 'mode=xml&api_submit=true&paste_lang=text&paste_data='.$code));
	return $re;
}		
sub abrirarchivo {
	my $r;
	open (ARCHIVO,$_[0]);
	my @wor = <ARCHIVO>;
	close ARCHIVO;
	for(@wor) {
		$r.= $_;
	}
	return $r;
}
sub lleva {
	my $abre = LWP::UserAgent->new();
	$abre->timeout(10);
	$abre->agent("Mozilla/5.0 (Windows; U; Windows NT 5.1; nl; rv:1.8.1.12) Gecko/20080201Firefox/2.0.0.12");
	return $abre->post('http://paste.kde.org',{ 
	mode => 'xml',
	api_submit  => 'true',
	paste_lang => 'text',
	paste_data => $_[0]})->content;
} 
sub limpia {
	while ($_[0] =~ m/<id>(.*?)<\/id>/g) {
		return "http://paste.kde.org/".$1."/raw/";
	}
}

1;
__END__
