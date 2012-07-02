use IO::Socket::SSL;
use strict;
use warnings;

my $servidor	= "irc.j03h.com";
my $puerto		= "6697";
my $nick 		= "perlBot";
my $canal		= "#j03h";
my $admin		= "j03h!j03h\@1.0.0.127";

my $sock = new IO::Socket::SSL(PeerAddr => $servidor, PeerPort => $puerto, Proto => 'tcp');

if (!$sock) {
	print "\n++ No se puedo conectar\n\r";
	exit 1;
} else {
	print "\n++ Conectado\n\r";
}

$sock->print("USER $nick a a a\n\r");
$sock->print("NICK $nick\n\r");

while (<$sock>) {
    chomp;
	my $out = $_;
    print "$out\n\r";
	## server ping
	if ($out =~ /^PING\s*:(.*?)$/i) {
		print "\n$out\n\r";
		$sock->print("PONG $1\n\r");
		print "** PONG :$1\n\r";
	}
	
	$sock->print("JOIN $canal\n\r");
	
	## parser
	if ($out=~/^:(.*?)\!(.*?)\s+(.*?)\s+(.*?)\s+:(.*?)$/i) {
		my $dnick=$1;
		my $dhost=$2;
		my $dtype=$3;
		my $dcpto=$4;
		my $dssge=$5;
		
		## channel parser
		if($dtype && $dtype =~ /PRIVMSG/i){
			## test
			if($dssge =~ /\*test/){
				$sock->print("PRIVMSG $dcpto :Todo okey $dnick!\n\r");
			}
			## admin cmds
			my $adm = $dnick."!".$dhost;
			if($adm =~ /$admin/) {
				## join
				if($dssge =~ /\*join\s#(.*?)$/){
					my $chan = "#$1";
					$sock->print("PRIVMSG $dcpto :Entrando a #$1\n\r");
					$sock->print("JOIN $chan\n\r");
				}
				## part
				if($dssge =~ /\*part\s#(.*?)$/){
					my $chan = "#$1";
					$sock->print("PRIVMSG $dcpto :Saliendo de #$1\n\r");
					$sock->print("PART $chan\n\r");
				}
				## say
				if($dssge =~ /\*say\s#(.*?)\s(.*?)$/){
					my $chan = "#$1";
					my $msje = $2;
					$sock->print("PRIVMSG $chan :$2\n\r");
				}
			} else {
				$sock->print("NOTICE $dnick :Lo siento, no tienes los privilegios suficientes para ejecutar este tipo de comando! xD\n\r");
			}
		}
	}
}

close $sock; 
print "\n++ Desconectado...\n\r";

