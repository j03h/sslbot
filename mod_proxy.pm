package mod_proxy;

# by j03h

use mod_Curl;
use strict;
use warnings;

sub get {
	my $type = $_[0]; ## http, https, socks
	&p1($type);
}

sub p1 { ## freeproxylists.com
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http/)
	{
		my @urls = ('http://www.freeproxylists.com/elite.php', 'http://www.freeproxylists.com/anonymous.html', 
					'http://www.freeproxylists.com/non-anonymous.html', 'http://www.freeproxylists.com/standard.html', 
					'http://www.freeproxylists.com/us.html', 'http://www.freeproxylists.com/ca.html',
					'http://www.freeproxylists.com/fr.html');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.freeproxylists.com');
			while($req =~ /<a href=\'(.*?).html\'>detailed list.*?<\/a>/g) {
				print $1.".html\n\r";
				push(@list, $1.'.html');
				last;
			}
			last;
		}
		foreach my $lis (@list){
			my $req2 = mod_Curl::req('http://www.freeproxylists.com/'.$lis, 'http://www.freeproxylists.com');
			while($req2 =~ /onload=\"loadData\(\'dataID\', \'\/(.*?)\'\);\">/g) {
				print $1."\n\r";
				push(@list2, $1);
				last;
			}
			last;
		}
		foreach my $lis2 (@list2){
			my $req3 = mod_Curl::req('http://www.freeproxylists.com/'.$lis2, 'http://www.freeproxylists.com');
			while($req3 =~ /&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;/g) {
				push(@final, $1.",".$2.",".$6);
			}
		}	
	}	
}

1;
__END__

