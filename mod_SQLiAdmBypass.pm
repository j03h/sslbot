package mod_SQLiAdmBypass;

use mod_Curl;
use HTML::Form;
use strict;
use warnings;

sub show {
	my $t; my $n; my $v; my @res;
	my $data = mod_Curl::req($_[0]);
	my @form = HTML::Form->parse($data, $_[0]);	
	foreach my $metas(@form) {
		push(@res, "Action\t: ".$metas->action."\n\r");
		push(@res, "Method\t: ".$metas->method."\n\r");
		my @inputs = $metas->inputs;
		foreach my $input (@inputs) {
			if (defined($input->type())) { $t = $input->type(); } else { $t = "NULL"; }
			if (defined($input->name())) { $n = $input->name(); } else { $n = "NULL"; }
			if (defined($input->value())) { $v = $input->value(); } else { $v = "NULL"; }
			push(@res, "\t".$t." | ".$n." == ".$v."\n\r");
		}
		push(@res, "----------"."\n\r");
	}
	return @res;
}

1;
__END__