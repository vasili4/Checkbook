#!/usr/bin/perl
use strict;

die "$0 <filename>" unless $ARGV[0];

my %FAILED = ();

open(LOG, "grep -i err $ARGV[0] | awk -F: '{print \$2}' | sort | uniq |");
while(my $file=<LOG>)
{
        chop $file;
        $FAILED{$file} = 1 if -e "$file";
}

foreach my $file (keys(%FAILED))
{
        $file =~ /(\d+)/;
        my $num = $1;

        print "time ( psql -d checkbook -f $file ) > fix.$num 2>&1\n";
}
