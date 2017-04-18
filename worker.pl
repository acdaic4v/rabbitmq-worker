#!/usr/bin/perl
# Example for your worker script in /usr/local/bin/myworker/worker.pl
use strict;
use warnings;

my $json = $ARGV[0];

print "WORKER: $json\n";
