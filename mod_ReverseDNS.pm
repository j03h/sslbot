package mod_ReverseDNS;

# por j03h
# modulo que hace su nombre lo dice todo...
# 08/08/2012
# julio@j03h.com

use LWP::UserAgent; use HTTP::Request::Common;
use WWW::Mechanize; use JSON -support_by_pp;
use Socket;
use mod_Pastebin;

sub ReverseDNS {
	my $domain = $_[0];
	my $iipp = resolve($domain);
	my $nombre = 'dril_'.$domain;
	my @res = bing($iipp);
	printf @res;
	my @dril;
	my %hash = map { $_, 1 } @res;
	my @listasinrep = keys %hash;
	my @sin_repetir_ordenado = sort @listasinrep;
	my $num = scalar(@sin_repetir_ordenado);
	#print "Confirmed: ".$num."\n\r";
	#print "-------------\n\r";
    if ($num > 0) {
        foreach my $site (@sin_repetir_ordenado) {
			#my $dprincipal = ( split /\./, $site )[ -2 ].".".( split /\./, $site )[ -1 ];
			push(@dril,$site);
		}
	}		
	open(my $rdns_file, '>', $nombre) or die return "ERROR RDNS: No puedo escribir en $nombre: $!\n";
	print $rdns_file "Domain Reverse IP LookUp in: " . $domain . "\n";
	print $rdns_file "IP Adress: " . $iipp . "\n";
	print $rdns_file "###\n";
	print $rdns_file "by j03h\n";
	print $rdns_file "-----------------------\n\r";
	print $rdns_file @dril;
	close($rdns_file);
	return "Reverse DNS for : " . mod_Pastebin::paste($nombre);
	`rm $nombre`;
}

sub bing {
	my $this_ip = $_[0];
	my $offset = 500;
	my @lista;
	my $browser = WWW::Mechanize->new();
	my $_total;
	for (my $i=0; $i<=5000; $i+=10) {
		my $uurl = 'http://api.search.live.net/json.aspx?AppId=7066FAEB6435DB963AE3CD4AC79CBED8B962779C&Web.Offset='.$i.'&Query=IP%3a'.$this_ip.'&Sources=web';
		my ($json_url) = $uurl;
		eval{
			$browser->get( $json_url );
			my $content = $browser->content();
			while ($content =~ m/"Total":(.*?),/g) {
				$_total = $1;
				if ($_total <= $i) { print "READY whit this ip: ".$this_ip."\n\r"; $i = 5000;}
			}
			my $json = new JSON;
			my $json_text = $json->decode($content);
			
			foreach my $resultados(@{$json_text->{SearchResponse}->{Web}->{Results}}){
				my %ep_hash = ();
				$ep_hash{Url} = "$resultados->{Url}";
				while (my($k, $v) = each (%ep_hash)){
					my @grep = links($v);
					my @resolve = resolve(@grep, $this_ip)."\n"; 
					push(@lista,@resolve);
				}
			}
		}
		
	}
	return @lista;
}

sub links() {
    my @list;
    my $host = $_[0];
    $host =~ s/([-a-zA-Z0-9\.]+)\/.*/$1/;
    $host =~ s/http:\/\///g;
    push(@list,$host);
    return @list;
}

sub resolve { 
	$sitio = $_[0];
	$ip = $_[1];
	$va = inet_aton($sitio); 
	$dire = "Invalido";  
	if($ip) {
		if ($va) { 
			$dire = inet_ntoa($va); 
		} 
		if ($dire == $_[1])	{
			return $sitio;
		} 
		else { 
			return; 
		}
	} else {
		if ($va) { 
			$dire = inet_ntoa($va);
			return $dire;
		}
	}
}

1;
__END__