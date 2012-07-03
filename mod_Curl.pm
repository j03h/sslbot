package mod_Curl;

# by j03h
#
# Modulo que hace request GET y POST con Curl

use WWW::Curl::Easy;

sub req {
    my ($url, $ref, $pos) = @_;
    my $cookie_file = "inc/cookies.txt";
    my $response_body;
    my $useragent = 'Mozilla/5.0 (X11; Linux i686; rv:8.0.1) Gecko/20100101 Firefox/13.0.1';
      
    if(!$ref){$ref = $url;}
    my $curl = new WWW::Curl::Easy;
    $curl->setopt(CURLOPT_URL, $url);
    $curl->setopt(CURLOPT_REFERER, $ref);
    $curl->setopt(CURLOPT_USERAGENT, $useragent);
    $curl->setopt(CURLOPT_FOLLOWLOCATION, 1);
    $curl->setopt(CURLOPT_CONNECTTIMEOUT, 10);
    $curl->setopt(CURLOPT_VERBOSE, 0);
    $curl->setopt(CURLOPT_COOKIEFILE, $cookie_file);
    $curl->setopt(CURLOPT_COOKIEJAR, $cookie_file);
    $curl->setopt(CURLOPT_SSL_VERIFYPEER, 0);
    $curl->setopt(CURLOPT_SSL_VERIFYHOST, 2);
      
    if($pos){
        $curl->setopt(CURLOPT_POST, 1);
        $curl->setopt(CURLOPT_POSTFIELDS, $pos);
    }
      
    open (my $fileb, ">", \$response_body);
    $curl->setopt(CURLOPT_WRITEDATA,$fileb);
    my $retcode = $curl->perform;
    if ($retcode == 0) {
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        if ($response_code == 200){
            return $response_body;
        }else{
            return;
        }
    }else{
        return "Error Curl ('".$retcode."')\n";
    }
}

1;
__END__