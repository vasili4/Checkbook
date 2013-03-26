#!/usr/bin/perl
#########################
#
# Jacque Istok
# jistok@greenplum.com
#
# Easy Script to create transfer SQL from all segments to a single host
# - requires Greenplum gptransfer program
#
#########################
use etl;
use strict;

#########################
# STEP 2 - CREATE GPTRANSFER
#########################
system "date";

#gptransfer -a <number of segments on target single host server> -s <staging schema> USASpending

open(SQL, "./gptransfer -a 8 -s s -z $ENV{PGDATABASE} |") or die "Cannot run gptransfer program";
open(OUT, ">./$TRANSFER_SQL");
my $table;
my $found;
while(my $line=<SQL>)
{
	$line =~ s/public_/p_/g;				#lose the  public schema notation because the table names get too long
        if($line =~ /^CREATE TABLE (\w+)\s/)
        {
                $table = $1;
                $found = 1;
        }
        if($found && $line =~ /^\)(.+;)$/)			#add compression into the table
        {
                $found = 0;
                print OUT ") WITH (appendonly=true, orientation=column, compresstype=quicklz) $1";
        }
        else
        {
                print OUT $line;
        }
}
system "date";

