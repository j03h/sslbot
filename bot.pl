#########################
# SSLBOT Base por j03h  #
# 08/08/2012		#
# julio@j03h.com	#
#########################

use IO::Socket::SSL;
use Digest::MD5;
use mod_GetTitle;

use mod_Google;
#use mod_ReverseDNS;
use strict;
use warnings;


my $servidor= "irc.j03h.com";
my $puerto	= "6697";
my $nick 	= "perlBot";
my $canal	= "#j03h";
my $admin	= "j03h!j03h\@6a303368.636f6d";

my $sock = new IO::Socket::SSL(PeerAddr => $servidor, PeerPort => $puerto, Proto => 'tcp');

if ($sock) {
	print "\n++ Conectado\n\r";
} else {
	print "\n++ No se pudo conectar\n\r";
	exit 1;
}

$sock->print("USER $nick $nick $nick $nick\n\r");
$sock->print("NICK $nick\n\r");

while (<$sock>) {
	chomp;
	my $out = $_;
	##print "$out\n\r";
	## server ping
	if ($out =~ /^PING\s*:(.*?)$/i) {
		#print "\n$out\n\r";
		$sock->print("PONG $1\n\r");
		#print "** PONG :$1\n\r";
	}
	
	$sock->print("JOIN $canal\n\r");
	
	## parser
	if ($out=~/^:(.*?)\!(.*?)\s+(.*?)\s+(.*?)\s+:(.*?)$/i) {
		my $dnick=$1; # nick
		my $dhost=$2; # host
		my $dtype=$3; # tipo
		my $dcpto=$4; # para
		my $dssge=$5; # msg
		
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
				if($dssge =~ /\*sorc/){
					$sock->print("PRIVMSG $dcpto :Mi código de fuente esta aquí: https://github.com/j03h/sslbot/\n\r");
				}
				## get title
				if($dssge =~ /(((http:\/\/)|(https:\/\/)|(www\.))\S+[^.,!?\/ ])/g){
					my $title_url = mod_GetTitle::GetTitle($1);
					if ($title_url) {
						$sock->print("PRIVMSG $dcpto :$title_url\n\r");
					}
				}
				## google
				if($dssge =~ /\*find\s(.*?)$/){
					my @find = mod_Google::search($1);
					foreach (@find) {
						$sock->print("PRIVMSG $dcpto :$_\n\r");
					} 
				}
				## rot13
				if ( my ($rot13) = $dssge =~ /\*rot13\s(.*?)$/) {
					$rot13 =~ tr[a-zA-Z][n-za-mN-ZA-M];
					$sock->print("PRIVMSG $dcpto :[ROT13] ".$rot13."\n\r");
				}
				## md5e
				if($dssge =~ /\*md5e\s(.*?)$/) {
					my $md5 = Digest::MD5::md5_hex($1);
					$sock->print("PRIVMSG $dcpto :[MD5] ".$md5."\n\r");
				}
				### md5e
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
				## exec
				if($dssge =~ m/\*exec/){
					my @hash = split /\*exec /, $out;					
					if ($hash[1] =~ /cd (.*)/) {
						chdir("$1") || $sock->print("PRIVMSG $dcpto :No such file or directory... \n\r");
						return;
					}
						   my @resp=`$hash[1] 2>&1 3>&1`;
						   foreach my $linha (@resp) {
							chop $linha;
							print $linha;
						$sock->print("PRIVMSG $dcpto :$linha\n\r");
					}
				}
				## exit
				if($dssge =~ /\*exit/){
					$sock->print("PRIVMSG $dcpto :Matando proceso $$ ... adios!\n\r");
					`kill -9 $$`;
				}
			}
		}
	}
}

close $sock; 
print "\n++ Desconectado...\n\r";