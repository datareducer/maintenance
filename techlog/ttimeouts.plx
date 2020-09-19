#!/usr/bin/perl -w

#$ perl -w ttimeouts.plx  /r/Таймауты\ на\ управляемых\ блокировках/logs_/*/* > result.txt

use strict;
use Data::Dumper;

my @tlocks;
my @conflicts;

my $fdate;
my $ttwc; # TTIMEOUT WaitConnections

while (<>) {
	
	if (not defined $fdate) {
		$ARGV =~ /.+\/(\d{8}).log/;
		$fdate = $1;
	}
	
	if (/^(\d{2}:\d{2}.\d+)-\d+,TLOCK.+?connectID=(\d+).+Regions=(.+?),Locks='(.+)',WaitConnections=(\d*)(,alreadyLocked=true)?/) {
		
		next if defined $6; # Блокировка была наложена ранее, пропускаем событие
						
		my $tlock = {file => $ARGV, eventTime => "$fdate:$1", connectID => $2, regions => $3, locks => $4, waitConnections => $5};
					
		 if ($ttwc && $5 == $ttwc) { # WaitConnections событий TTIMEOUT и TLOCK "жертвы" должны совпадать
			push @conflicts, {victim => $tlock};
			undef $ttwc;
		 } else {
			push @tlocks, $tlock;
		 }	
		 
	} elsif (/^\d{2}:\d{2}.\d+-\d+,TTIMEOUT.+WaitConnections=(\d+)/) {
		$ttwc = $1; # Сразу после TTIMEOUT'а ожидаем увидеть TLOCK "жертвы" 
	}

	undef $fdate if eof;
	
}

for my $tlock (@tlocks) {
	for my $conflict (@conflicts) {
		if ($tlock->{connectID} == $conflict->{victim}->{waitConnections}	# connectID "виновника" должен совпадать с waitConnections "жертвы"
			&& $tlock->{regions} eq $conflict->{victim}->{regions}	# Пространства блокировок "виновника" и "жертвы" должны совпадать
			&& $tlock->{eventTime} lt $conflict->{victim}->{eventTime}) {	# Событие "виновника" раньше события "жертвы"
			
			$conflict->{causer} = $tlock;
		}
	}
}

$Data::Dumper::Deepcopy = 1;
$Data::Dumper::Sortkeys = 1;
print Dumper(\@conflicts);

