#!/usr/bin/perl -w

# Выводит топ транзакций по длительности
# perl -w top_transactions.plx /r/Конфликты\ на\ управляемых\ блокировках/logs_/*/*

use strict;
use Data::Dumper;

my @transactions;

my $top = 10;
my $trans;
my $fdate;

while (<>) {
	
	if (not defined $fdate) {
		$ARGV =~ /.+\/(\d{8}).log/;
		$fdate = $1;
	}
	
	if (/^(\d{2}:\d{2}\.\d+)-(\d+),SDBL.+(CommitTransaction|RollbackTransaction)/) {

		if (!@transactions || $transactions[-1]->{duration} < $2) {
			
			$trans = {file => $ARGV, eventTime => "$fdate:$1", duration => $2, state => $3, context => ''};
			
			push @transactions, $trans;
			
			@transactions = sort comparison @transactions;
			
			if (@transactions > $top) {
				@transactions = @transactions[1..$top];
			}
		}
		
	} elsif (defined $trans) {
		# Сохраняем контекст
		
		next if (/^\d{2}:\d{2}\.\d+-\d+,Context/);
		
		if ($_ !~ /^\d{2}:\d{2}\.\d+/) {
			$trans->{context} .= $_;
		} else {
			undef $trans;
		}
	}
	
	undef $fdate if eof;
	undef $trans if eof;
	
}

sub comparison {
	if ($a->{duration} > $b->{duration}) {
		return -1;
	} elsif ($a->{duration} < $b->{duration}) {
		return 1;
	} else {
		return 0;
	}
}

$Data::Dumper::Deepcopy = 1;
$Data::Dumper::Sortkeys = 1;
print Dumper(\@transactions);
