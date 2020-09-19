#!/usr/bin/perl -w

#$ perl -w tdeadlocks.plx  /r/Таймауты\ на\ управляемых\ блокировках/logs_/*/* > result.txt

use strict;
use Data::Dumper;

my @tlocks;
my @conflicts;

my $winner;
my $victim;
my $dlcid; # connectID события TDEADLOCK, совпадает с connectID "жертвы"

my $fdate;

while (<>) {
	
	if (not defined $fdate) {
		$ARGV =~ /.+\/(\d{8}).log/;
		$fdate = $1;
	}
	
	if (/^(\d{2}:\d{2}.\d+)-\d+,TLOCK.+?connectID=(\d+).+Regions=(.+?),Locks='(.+)',WaitConnections=(\d*)(,alreadyLocked=true)?/) {
		
		next if defined $6; # Блокировка была наложена ранее, пропускаем TLOCK
						
		my $tlock = {file => $ARGV, eventTime => "$fdate:$1", connectID => $2, regions => $3, locks => $4, waitConnections => $5};
				
		if ($dlcid) {
			if ($dlcid == $2) {
				$victim = $tlock;
			} else {
				$winner = $tlock;
			}
			if (defined $winner && defined $victim) {
				push @conflicts, {winner => $winner, victim => $victim};
				undef $dlcid;
				undef $winner;
				undef $victim;
			}
		} else {
			push @tlocks, $tlock;
		}	
		 
	} elsif (/^\d{2}:\d{2}.\d+-\d+,TDEADLOCK.+?t:connectID=(\d+)/) {
		$dlcid = $1; # Сразу после TDEADLOCK'а ожидаем увидеть TLOCK'и "жертвы" и "победителя"
	}

	undef $fdate if eof;
	
}

for my $tlock (@tlocks) {
	for my $conflict (@conflicts) {
		if ($tlock->{connectID} == $conflict->{winner}->{waitConnections} 
			&& $tlock->{regions} eq $conflict->{winner}->{regions}	
			&& $tlock->{eventTime} lt $conflict->{winner}->{eventTime}) {
			
			$conflict->{causer_w} = $tlock;
			
		} elsif ($tlock->{connectID} == $conflict->{victim}->{waitConnections} 
			&& $tlock->{regions} eq $conflict->{victim}->{regions}	
			&& $tlock->{eventTime} lt $conflict->{victim}->{eventTime}) {
				
			$conflict->{causer_v} = $tlock;
		}
	}
}

$Data::Dumper::Deepcopy = 1;
$Data::Dumper::Sortkeys = 1;
print Dumper(\@conflicts);

