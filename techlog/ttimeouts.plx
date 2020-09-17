#!/usr/bin/perl -w

#$ perl -w ttimeouts.plx  /r/Таймауты\ на\ управляемых\ блокировках/logs_/*/*

use strict;
use Data::Dumper;

my @tlocks;
my @victims;

my $ttwc; # TTIMEOUT WaitConnections

while (<>) {
	
	if (/^(\d{2}:\d{2}.\d+)-\d+,TLOCK.+?connectID=(\d+).+Regions=(.+?),.+?WaitConnections=(\d*)/) {
		
		my $tlock = {file => $ARGV, eventTime => $1, connectID => $2, regions => $3, waitConnections => $4};
					
		 if ($ttwc && $4 == $ttwc) {
			push @victims, $tlock;
			undef $ttwc;
		 } else {
			push @tlocks, $tlock;
		 }
		
				
		
	# } elsif (TTIMEOUT) {
		
	}		
	
	


	
}

print Dumper(\@tlocks);



