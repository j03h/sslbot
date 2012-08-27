#########################
# SSLBOT Base por j03h  #
# 08/08/2012		#
# julio@j03h.com	#
#########################

use IO::Socket::SSL;
use Digest::MD5 'md5_hex';
use MIME::Base64;
use mod_GetTitle;
use mod_SQLiAdmBypass;
use mod_Google;
use mod_MD5d;
use strict;
use warnings;


my $servidor= "irc.j03h.com";
my $puerto	= "6697";
my $nick 	= "perlBot";
my $canal	= "#ajja";
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
	$out =~ s/\n//g;
	$out =~ s/\r//g;
	print "$out\n\r";
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
				if($dssge =~ /(((http:\/\/)|(https:\/\/)|(www\.))\S+[^.,!?\/ ])/i){
					my $title_url = mod_GetTitle::GetTitle($1);
					if ($title_url) {
						$sock->print("PRIVMSG $dcpto :".$title_url."\n\r");
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
					my $md5 = md5_hex($1);
					$sock->print("PRIVMSG $dcpto :[MD5e] ".$md5."\n\r");
				}
				## md5d
				if($dssge =~ /\*md5d\s(.*?)$/) {
					my $md5 = mod_MD5d::d($1);
					$sock->print("PRIVMSG $dcpto :[MD5d] ".$md5."\n\r");
				}
				## b64e
				if($dssge =~ /\*b64e\s(.*?)$/) {
					my $b64e = MIME::Base64::encode($1); 
					$sock->print("PRIVMSG $dcpto :[B64e] ".$b64e."\n\r");
				}
				## b64d
				if($dssge =~ /\*b64d\s(.*?)$/) {
					my $b64e = MIME::Base64::decode($1);
					$sock->print("PRIVMSG $dcpto :[B64d] ".$b64e."\n\r");
				}
				#hexe
				if($dssge =~ /\*hexe\s(.*?)$/) {
					my $str = $1; 
					my $hex = unpack('H*', "$str"); 
					$sock->print("PRIVMSG $dcpto :[HEXe] ".$hex."\n\r");
				}
				#hexd
				if($dssge =~ /\*hexe\s(.*?)$/) {
					my $str = $1; 
					my $hex = pack("H*", "$str"); 
					$sock->print("PRIVMSG $dcpto :[HEXd] ".$hex."\n\r");
				}
				## Admin bypass show forms
				if($dssge =~ /\*abps\s(.*?)$/) {
					my @res = mod_SQLiAdmBypass::show($1);
					foreach (@res) {
						$sock->print("PRIVMSG $dcpto :[Abps] ".$_."\n\r");
					}					
				}
				## Admin bypass hack
				if($dssge =~ /\*abph\s(.*?)$/) {
					my @res = mod_SQLiAdmBypass::hack($1);
					foreach (@res) {
						$sock->print("PRIVMSG $dcpto :[Abph] ".$_."\n\r");
					}					
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
