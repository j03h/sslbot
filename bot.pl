#########################
# SSLBOT Base por j03h  #
# 02/07/2012		#
# correo@j03h.com	#
#########################


use IO::Socket::SSL;
use strict;
use warnings;

#use mod_ReverseDNS;
use mod_GetTitle;


my $servidor	= "96.126.108.176";
my $puerto	= "6697";
my $nick 	= "perlBot";
my $canal	= "#j03h";
my $admin	= "j03h!j03h\@1.0.0.127";

my $sock = new IO::Socket::SSL(PeerAddr => $servidor, PeerPort => $puerto, Proto => 'tcp');

if (!$sock) {
	print "\n++ No se puedo conectar\n\r";
	exit 1;
} else {
	print "\n++ Conectado\n\r";
}

$sock->print("USER $nick $nick $nick $nick\n\r");
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
		if($dtype && $dtype =~ /PRIVMSG/i) {
			## channel cmds
			if($dcpto && $dcpto =~ /^#*/i) {
				## users cmds
				## test
				if($dssge =~ /\*test/){
					$sock->print("PRIVMSG $dcpto :Todo okey $dnick!\n\r");
				}
				## source
				if($dssge =~ /\*source/){
					$sock->print("PRIVMSG $dcpto :Mi código de fuente esta aquí: https://github.com/j03h/sslbot/\n\r");
				}
				## get title
				if($dssge =~ m@(((http://)|(https://)|(www\.))\S+[^.,!? ])@g){
					my $title_url = mod_GetTitle::GetTitle($1);
					$sock->print("PRIVMSG $dcpto :$dnick : $title_url\n\r");
				}
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
			}
		}
	}
}

close $sock; 
print "\n++ Desconectado...\n\r";

