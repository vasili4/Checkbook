#!/usr/bin/perl
#########################
#
# Jacque Istok
# jistok@greenplum.com
#
# etl.pl - Go through every table in the "s" schema, and use that to drive the ETL with the
#   following workflow:
#          1) Get List of ETL tables as all views in the "s" schema.
#          2) Get List of indexes for the "public" version of the table.
#          3) Truncate the corresponding table in the public schema of it's current data 
#          4) drop any/all indexes from the table
#          5) insert data from the main GP database
#          6) create any/all indexes
#          7) vacuum and analyze the newly created table
#
#########################
use strict;
use Time::HiRes;

my $RUN = 1;
my @TABLES;
my $numForks = 0;
my $maxForks = 1;
my $FILE_SQL = "./tmp/etl.sql";
my $SQL_INDEX = "SELECT c2.relname, pg_catalog.pg_get_indexdef(i.indexrelid, 0, true) FROM pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i WHERE c.relname like 'CHANGEME\%' AND c.oid = i.indrelid AND i.indexrelid = c2.oid ORDER BY i.indisprimary DESC, i.indisunique DESC, c2.relname";
my $SQL = "
	begin;

	truncate table public.CHANGEME_TABLE;
	CHANGEME_INDEX_DROP
	insert into public.CHANGEME_TABLE select * from staging.CHANGEME_TABLE;
	CHANGEME_INDEX_CREATE

	commit;
	vacuum analyze public.CHANGEME_TABLE;
";

print `date`;
open(TABLES, "psql   -d mmnyccheckbook_athu -p 5432 -A -t -c \"select viewname from pg_views where schemaname = 'staging' order by 1\" |") || die "Can't Get List of Tables";
while(my $table=<TABLES>)
{
	chop $table;
	push @TABLES, $table;
}

for(my $i=0; $i<$maxForks; $i++)
{
	forkChild($TABLES[$numForks], $numForks);
	$numForks++;
}

my $pid;
do
{
	# blocking wait for any child
	my $pid = waitpid(-1, 0);
	if($pid > 0)
	{
		if($numForks <= $#TABLES)
		{
			forkChild($TABLES[$numForks], $numForks);
			$numForks++;
		}
	}
} until($pid == -1 || $numForks >= $#TABLES + 1);
print `date`;

sub forkChild
{
	my $table = shift || die "Don't know which table";
	my $ctr = shift || 0;

	my $sql = $SQL;

	my $pid = fork();
	if(not defined $pid)
	{
		die "Unable to fork()";
	}
	# child (useful work here)
	elsif($pid == 0)
	{
		my $t_start = [Time::HiRes::gettimeofday];
		print "Start: $table\n";

		#Get indexes
		my $INDEX_DROP = "";
		my $INDEX_CREATE = "";
		my $tmp = $SQL_INDEX;
		$tmp =~ s/CHANGEME/$table/;
		open(INDEXES, "psql -d mmnyccheckbook_athu -p 5432 -A -t -c \"$tmp\" |") || die "Can't Get List of Indexes for $table";
		while(my $index=<INDEXES>)
		{
			chop $index;
			my @row = split(/\|/, $index);
			$INDEX_DROP .= "drop index $row[0];\n\t";	
			$INDEX_CREATE .= "$row[1];\n\t" if $row[0] !~ /_1_prt_/;
		}

		my $sql = $SQL;
		$sql =~ s/CHANGEME_TABLE/$table/g;
		$sql =~ s/CHANGEME_INDEX_DROP/$INDEX_DROP/g;
		$sql =~ s/CHANGEME_INDEX_CREATE/$INDEX_CREATE/g;

		open(SQL, ">$FILE_SQL.$ctr") || die "Can't Write SQL File: $FILE_SQL";
		print SQL $sql;
		close SQL;


		print "Running: $table\n";
		print "$sql\n\n";
		system("psql -d mmnyccheckbook_athu -p 5432 -f $FILE_SQL.$ctr") if $RUN;
		#unlink "$FILE_SQL.$ctr";

		my $t_end = [Time::HiRes::gettimeofday];
		my $t_interval = Time::HiRes::tv_interval($t_start, $t_end);
		print "End: $table ( ", Time::HiRes::tv_interval($t_start, $t_end) . " s)\n";
		exit(0);
	}
}
