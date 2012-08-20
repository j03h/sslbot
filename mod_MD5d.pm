package mod_MD5d;

# by j03h
use mod_Curl;
use Digest::MD5 'md5_hex';

my $init = time;
my $hash;
my @good;
my @bad;

sub d {
	if ($_[0] =~ /test/) { $hash = '827ccb0eea8a706c4c34a16891f84e7b' } else { $hash = $_[0] }
	my %cracks = (
		'0' => {
			url => 'http://md5.my-addr.com/md5_decrypt-md5_cracker_online/md5_decoder_tool.php', ref => 'http://md5.my-addr.com/',
			pos => 'md5='.$hash.'&x=17&y=12', mat => 'Hashed string<\/span>: (.*?)<\/div>',
		},
		'1' => {
			url => 'http://md5.rednoize.com/?p&s=md5&q='.$hash.'&_=', ref => 'http://md5.rednoize.com/',
			pos => '', mat => '^(.*?)$',
		},
		'2' => {
			url => 'http://md5decryption.com/index.php', ref => 'http://md5decryption.com/',
			pos => 'hash='.$hash.'&submit=Decrypt+It%21', mat => 'Decrypted Text: <\/b>(.*?)<\/font>',
		},
		'3' => {
			url => 'http://md5.hashcracking.com/search.php?md5='.$hash.'', ref => 'http://md5.hashcracking.com/',
			pos => '', mat => 'is\s(.*?)$',
		},
		'4' => {
			url => 'http://www.stringfunction.com/md5-decrypter.html', ref => 'http://www.stringfunction.com/md5-decrypter.html',
			pos => 'string='.$hash.'&submit=Decrypt&result=', mat => 'id="textarea_md5_decrypter">(.*?)<\/textarea>',
		},
		'5' => {
			url => 'http://www.xmd5.org/md5/search.asp?hash='.$hash.'&xmd5=MD5+%BD%E2%C3%DC', ref => 'http://www.xmd5.org/',
			pos => '', mat => '(.*?)  &nbsp;&nbsp;>>>Good Luck !<<<',
		},
		'6' => {
			url => 'http://md5.noisette.ch/index.php', ref => 'http://md5.noisette.ch/index.php',
			pos => 'hash='.$hash, mat => '<div class="result">"<a href=".*?<\/a>" = md5\("(.*?)"\)<\/div>',
		},
		'7' => {
			url => 'http://www.md5-hash.com/md5-hashing-decrypt/'.$hash, ref => 'http://www.md5-hash.com',
			pos => '', mat => '<strong class="result">(.*?)<\/strong>',
		},
		'8' => {
			url => 'http://www.md5hacker.com/decrypt.php', ref => 'http://www.md5hacker.com/',
			pos => 'key='.$hash.'&rand=0.7393604939725836', mat => '<b>(.*?)<\/b>',
		},
		'9' => {
			url => 'http://www.netmd5crack.com/cgi-bin/Crack.py?InputHash='.$hash, ref => 'http://www.netmd5crack.com/cracker/',
			pos => '', mat => '<\/td><td class="border">(.*?)<\/td><\/tr><\/table>',
		},
		'10' => {
			url => 'http://www.md5crack.com/crackmd5.php', ref => 'http://www.md5crack.com/',
			pos => 'term='.$hash.'&crackbtn=Crack+that+hash+baby%21', mat => 'Found: md5\("(.*?)"\)',
		},
	);
	for $crack ( keys %cracks ) {
		my $req = mod_Curl::req($cracks{$crack}{'url'}, $cracks{$crack}{'ref'}, $cracks{$crack}{'pos'});
		while ($req =~ m/$cracks{$crack}{'mat'}/g) {
			if(md5_hex($1) eq $hash) {
				if ($_[0] =~ /test/) {
					push(@good, $crack); 
					next;
				} else {
					my $time = time - $init;
					return("hash found [$crack] [".$time."sec] : $1\r\n"); 
				}
			}
			push(@bad, $crack); 
        }
	}
	if ($_[0] =~ /test/) {
		return scalar (@good)."/".scalar(keys %cracks)."\n";
	} else {
		return "hash not found... :(\r\n"; 
	}
}

1;
__END__