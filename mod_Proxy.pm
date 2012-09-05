package mod_Proxy;

# by j03h

use mod_Curl;
use strict;
use LWP::UserAgent;

sub get {
	my $init = time;
	my $type = $_[0]; ## http, socks
	my $file = "inc/proxy/".$type.".txt";
	my @result;
	my @proxy_total = (
		&p1($type), ## freeproxylists.com
		&p2($type), ## nntime.com
		&p3($type), ## my-proxy.com
		&p4($type), ## proxylists.net
		&p5($type), ## shroomery.org
		&p6($type) ## samair.ru
	);
	push(@result, "Proxy: ".$type."");
	push(@result, "Total: ".scalar(@proxy_total)."");
	my %hash = map { $_, 1 } @proxy_total;
	my @listasinrep = keys %hash;
	my @sin_repetir_ordenado = sort @listasinrep;
	push(@result, "Filtrados: ".scalar(@sin_repetir_ordenado)."");
	open (texto,">".$file) or die "\nUnable to create $file\n";
	print texto @sin_repetir_ordenado;
	close (texto);
	push(@result, "Guardado: ".$file."");
	my $time = time - $init;
	push(@result, "Tiempo: ".$time."secs");
	return @result;
}

sub check {
	my $init = time;
	my $type = $_[0]; ## http, socks
	my @result;
	my @results;
	my $file = "inc/proxy/".$type.".txt";
	my $save = "inc/proxy/".$type."-good.txt";
	my $ua = LWP::UserAgent->new;
	$ua->timeout(5);
	$ua->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; YPC 3.2.0; .NET CLR 1.1.4322');
	
	open FILE, "<$file" or die $!;

	if($type =~ m/http/) {
		while (my $line = <FILE>) {
			my $proxy = "http://".$line;
			$ua->proxy('http', $proxy);
			my $response = $ua->get('http://google.com');
			if ($response->is_success) {
				push(@result, $line);
			}
		}
	}
	if($type =~ m/socks/) {
		while (my $line = <FILE>) {
			my $proxy = "socks://".$line;
			$ua->proxy('http', $proxy);
			my $response = $ua->get('http://google.com');
			if ($response->is_success) {
				push(@result, $line);
			}
		}
	}
	close FILE;
	open (texto,">".$save) or die "\nUnable to create $save\n";
	print texto @result;
	close (texto);
	push(@results, "Proxy: ".$type."");
	push(@results, "Total: ".scalar(@result)."");
	push(@results, "Guardado: ".$save."");
	my $time = time - $init;
	push(@results, "Tiempo: ".$time."secs");
	return @results;
}

sub p1 {
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http$/)
	{
		my @urls = ('http://www.freeproxylists.com/elite.php', 'http://www.freeproxylists.com/anonymous.html', 
					'http://www.freeproxylists.com/non-anonymous.html', 'http://www.freeproxylists.com/standard.html', 
					'http://www.freeproxylists.com/us.html', 'http://www.freeproxylists.com/ca.html',
					'http://www.freeproxylists.com/fr.html');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.freeproxylists.com');
			while($req =~ /<a href=\'(.*?).html\'>detailed list.*?<\/a>/g) {
				#print $1.".html\n\r";
				push(@list, $1.'.html');
			}
		}
		foreach my $lis (@list){
			my $req2 = mod_Curl::req('http://www.freeproxylists.com/'.$lis, 'http://www.freeproxylists.com');
			while($req2 =~ /onload=\"loadData\(\'dataID\', \'\/(.*?)\'\);\">/g) {
				#print $1."\n\r";
				push(@list2, $1);
			}
		}
		foreach my $lis2 (@list2){
			my $req3 = mod_Curl::req('http://www.freeproxylists.com/'.$lis2, 'http://www.freeproxylists.com');
			while($req3 =~ /&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;/g) {
				push(@final, $1.":".$2."\n");
			}
		}	
	}	
	if($type =~ m/socks$/)
	{
		my @urls = ('http://www.freeproxylists.com/socks.html');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.freeproxylists.com');
			while($req =~ /<a href=\'(.*?).html\'>detailed list.*?<\/a>/g) {
				#print $1.".html\n\r";
				push(@list, $1.'.html');
				#last;
			}
			#last;
		}
		foreach my $lis (@list){
			my $req2 = mod_Curl::req('http://www.freeproxylists.com/'.$lis, 'http://www.freeproxylists.com');
			while($req2 =~ /onload=\"loadData\(\'dataID\', \'\/(.*?)\'\);\">/g) {
				#print $1."\n\r";
				push(@list2, $1);
				#last;
			}
			#last;
		}
		foreach my $lis2 (@list2){
			my $req3 = mod_Curl::req('http://www.freeproxylists.com/'.$lis2, 'http://www.freeproxylists.com');
			while($req3 =~ /&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;td&gt;(.*?)&lt;\/td&gt;&lt;\/tr&gt;&lt;tr&gt;&lt;td&gt;/g) {
				#print $1.",".$2."\n\r";
				push(@final, $1.":".$2."\n");
			}
		}	
	}
	return @final;
}

sub p2 {
	my $type = $_[0];
	my @final;
	my @port;
	my $proxy;
	
	if($type =~ m/http$/)
	{
		for(my $i=1; $i<=15; $i++) { 
			$_ = sprintf("%02d", $i);
			my $req = mod_Curl::req("http://nntime.com/proxy-list-$_.htm", 'http://nntime.com');
			while($req =~ /<script type=\"text\/javascript\">\n(.*?);<\/script>/g) {
				my $ports = $1;
				@port = split(';', $ports);
			}	
			while($req =~ /onclick="choice\(\)" \/><\/td><td>(.*?)<script type="text\/javascript">document\.write\(":"(.*?)\)<\/script><\/td>/g) {
				my $ports2 = $2;
				my @port2 = split('\+', $ports2);
				$proxy .= $1.":";
				foreach my $lett (@port2) {
					my @results = grep /$lett/, @port;
					my $tor = @results[0];
					$tor =~ s/\w=//g;
					$proxy .= $tor;
					
				}
				$proxy .= "\n";
				push(@final, $proxy);
			}
		}
	}
	return @final;
}

sub p3 {
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http$/)
	{
		my @urls = ('http://www.my-proxy.com/free-proxy-list.html', 'http://www.my-proxy.com/free-proxy-list-2.html', 
					'http://www.my-proxy.com/free-proxy-list-3.html', 'http://www.my-proxy.com/free-proxy-list-4.html', 
					'http://www.my-proxy.com/free-proxy-list-5.html', 'http://www.my-proxy.com/free-proxy-list-6.html',
					'http://www.my-proxy.com/free-proxy-list-7.html', 'http://www.my-proxy.com/free-proxy-list-8.html',
					'http://www.my-proxy.com/free-proxy-list-9.html','http://www.my-proxy.com/free-proxy-list-10.html',
					'http://www.my-proxy.com/free-elite-proxy.html', 'http://www.my-proxy.com/free-anonymous-proxy.html',
					'http://www.my-proxy.com/free-transparent-proxy.html');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.my-proxy.com');
			while($req =~ m/<br>(.*?):(.*?)<br>/g) {
				my $ip = $1;
				my $po = $2;
				if($1 =~ m/(\d{1,3}\.){3}\d{1,3}/) {
					#print $ip.",".$po."\n\r";
					push(@final, $ip.":".$po."\n");
				}			
			}
		}
	}
	if($type =~ m/socks$/)
	{
		my @urls = ('http://www.my-proxy.com/free-socks-5-proxy.html');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.my-proxy.com');
			while($req =~ m/<br>(.*?):(.*?)<br>/g) {
				my $ip = $1;
				my $po = $2;
				if($1 =~ m/(\d{1,3}\.){3}\d{1,3}/) {
					#print $ip.",".$po."\n\r";
					push(@final, $ip.",".$po);
				}			
			}
		}	
	}
	return @final;
}

sub p4 {
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http$/)
	{
		my @urls = ('http://www.proxylists.net/http_highanon.txt');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.proxylists.net');
			while($req =~ m/(.*?):(.*?)\n/g) {
				my $ip = $1;
				my $po = $2;
				if($1 =~ m/(\d{1,3}\.){3}\d{1,3}/) {
					#print $ip.",".$po."\n\r";
					push(@final, $ip.":".$po."\n");
				}			
			}
		}
	}
	if($type =~ m/socks$/)
	{
		my @urls = ('http://www.proxylists.net/socks5.txt');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.proxylists.net');
			while($req =~ m/(.*?):(.*?)\n/g) {
				my $ip = $1;
				my $po = $2;
				if($1 =~ m/(\d{1,3}\.){3}\d{1,3}/) {
					#print $ip.",".$po."\n\r";
					push(@final, $ip.":".$po."\n");
				}			
			}
		}
	}
	return @final;
}

sub p5 {
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http$/)
	{
		my @urls = ('http://www.shroomery.org/ythan/proxylist.php');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.shroomery.org');
			while($req =~ m/(.*?):(.*?)\n/g) {
				my $ip = $1;
				my $po = $2;
				if($1 =~ m/(\d{1,3}\.){3}\d{1,3}/) {
					#print $ip.",".$po."\n\r";
					push(@final, $ip.":".$po."\n");
				}			
			}
		}
	}
	return @final;
}

sub p6 {
	my $type = $_[0];
	my @list;
	my @list2;
	my @final;
	if($type =~ m/http$/)
	{
		my @urls = ('http://www.samair.ru/proxy/');
		foreach my $get (@urls) {
			my $req = mod_Curl::req($get, 'http://www.samair.ru');
			while($req =~ m/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,6}/sg) {
				my $proxy = $&;
				#print $proxy."\n";
				push(@final, $proxy."\n")	
			}
		}
		my $pagina = 2;
		while ($pagina <= 20) {
			print $pagina;
			my $req = mod_Curl::req('http://www.samair.ru/proxy/proxy-'.sprintf("%02d", $pagina).'.htm', 'http://www.samair.ru');
			while($req =~ m/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,6}/sg) {
				my $proxy = $&;
				#print $proxy."\n";
				push(@final, $proxy."\n");
			}
			sleep 2;
			$pagina++;
			if($req =~ m/next/) {	
				next;
			} else {
				return @final;
			}
		}
	}
	
	if($type =~ m/socks$/)
	{
		my @port;
		my $proxy;
		for(my $i=1; $i<=15; $i++) { 
			$_ = sprintf("%02d", $i);
			my $req = mod_Curl::req("http://www.samair.ru/proxy/socks$_.htm", 'http://www.samair.ru');
			while($req =~ /<script type=\"text\/javascript\">\n(.*?);<\/script>/g) {
				#print $1;
				my $ports = $1;
				@port = split(';', $ports);
			}	
			while($req =~ /<tr><td>(.*?)<script type="text\/javascript">document\.write\(":"(.*?)\)<\/script>/g) {
				my $ports2 = $2;
				my @port2 = split('\+', $ports2);
				$proxy .= $1.",";
				foreach my $lett (@port2) {
					my @results = grep /$lett/, @port;
					my $tor = @results[0];
					$tor =~ s/\w=//g;
					$proxy .= $tor;
					
				}
				$proxy .= "\n";
				#print $proxy;
				push(@final, $proxy);
			}
			sleep 2;
			if($req =~ m/next/) {	
				next;
			} else {
				return @final;
			}
		}
	}
	return @final;
}

1;
__END__

