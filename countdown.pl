#!/usr/bin/perl -w

use strict;
use warnings;

sub countdown($) {
    my $duration = shift @_;
    my $end_time = time + $duration;
    my $time = time;
    while ($time < $end_time) {
        $time = time;
        printf("\r%02d:%02d:%02d:%02d", 
        	($end_time - $time) / (60*60*24),
        	($end_time - $time) / (60*60) % 24, 
        	($end_time - $time) / (60) % 60,
        	($end_time - $time) % 60);
        $|++;
        sleep 1;
    }
    print("\n");
}

countdown($ARGV[0]);
