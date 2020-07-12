#!/usr/bin/perl -w
# Удаление записей из журнала регистрации

use strict; 

#$^I = "";
$^I = ".bak";

$/ = "},\r";

my $hdr;
my $nxt = 1;

while (<>) {
	my $m = /[\d\D]+?,6,2,2,\d+,\d,I,"",109,[\d\D]+/;

	if ($nxt && $m) { # Совпадение в первой строке, будет нужно вернуть заголовок
		/[^{]*/;
		$hdr = $&;
		$nxt = 0;
	} elsif (!$m) {
		chomp;
		if (defined $hdr) {
			print $hdr . substr($_, 1); # Добавляем заголовок, удаляем пустую строку
			undef $hdr;
		} else {
			print $/ . $_;
		}
	} elsif (eof && $m) { # Последняя скобка в файле без запятой
		print "}";
	}
	
	$nxt = 1 if eof;
}
 
