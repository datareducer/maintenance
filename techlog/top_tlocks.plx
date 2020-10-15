#!/usr/bin/perl -w

# Выводит топ ожиданий на управляемых блокировках по длительности
# perl -w top_tlocks.plx /r/Конфликты\ на\ управляемых\ блокировках/logs_/*/*

use strict;
use Data::Dumper;

my @tlocks;

my $top = 10;
my $tlock;
my $fdate;

while (<>) {
	
	if (not defined $fdate) {
		$ARGV =~ /.+\/(\d{8}).log/;
		$fdate = $1;
	}
	
	if (/^(\d{2}:\d{2}\.\d+)-(\d+),TLOCK.+?connectID=(\d+).+Regions=(.+?),Locks=(.+),WaitConnections=(\d*)/) {

		if (!@tlocks || $tlocks[-1]->{duration} < $2) {
			
			$tlock = {file => $ARGV, eventTime => "$fdate:$1", duration => $2, connectID => $3, regions => $4, locks => $5, waitConnections => $6, context => ''};
			
			push @tlocks, $tlock;
			
			@tlocks = sort comparison @tlocks;
			
			if (@tlocks > $top) {
				@tlocks = @tlocks[1..$top];
			}
		}
		
	} elsif (defined $tlock) {
		# Сохраняем контекст
		
		next if (/^\d{2}:\d{2}\.\d+-\d+,Context/);
		
		if ($_ !~ /^\d{2}:\d{2}\.\d+/) {
			$tlock->{context} .= $_;
		} else {
			undef $tlock;
		}
	}
	
	undef $fdate if eof;
	undef $tlock if eof;
	
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
print Dumper(\@tlocks);
