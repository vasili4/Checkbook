#!/usr/bin/perl
#########################
#
# Jacque Istok
# jistok@greenplum.com
#
# Easy Script to rsync
#
#########################
use etl;
use strict;

#########################
# STEP 4 - RSYNC
#########################
#take the hosts to be updated out of the picture
foreach my $web_host (@HOST_WEB)
{
	foreach my $host (@HOST_POSTGRES_1)
	{
		print "pulling $host out of $web_host\n";
		my $num = $host;
		$num =~ s/\D//g;
		$num--;
		foreach my $attr ('backend_hostname', 'backend_port', 'backend_weight')
		{
			print  "$CMD_SSH $web_host perl -p -i -e 's/^\\(${attr}${num}.+\\)/#\\\\1/' /usr/local/etc/pgpool.conf \n";
			system "$CMD_SSH $web_host perl -p -i -e 's/^\\(${attr}${num}.+\\)/#\\\\1/' /usr/local/etc/pgpool.conf" if $RUN;
		}
		print "\n";
	}
	print "$CMD_SSH $web_host 'pgpool -m fast stop; pgpool' \n";
	system "$CMD_SSH $web_host 'pgpool -m fast stop; pgpool'" if $RUN;
	print "\n";
}

foreach my $host (@HOST_POSTGRES_1)
{
	print "refreshing $host\n";

	print "( time $CMD_SSH $host \'gpstop -ia\' )\n";
	system "( time $CMD_SSH $host \'gpstop -ia\' )" if $RUN;

	print "( time $CMD_SSH $host \'gpstart -a\' )\n";
	system "( time $CMD_SSH $host \'gpstart -a\' )" if $RUN;

	print "( time $CMD_PSQL -h $host -c \'drop database \"$ENV{PGDATABASE}\"\' template1 )\n";
	system "( time $CMD_PSQL -h $host -c \'drop database \"$ENV{PGDATABASE}\"\' template1 )" if $RUN;

	print "( time $CMD_PSQL -h $host -f $TRANSFER_SQL template1 > ${TRANSFER_SQL}.$host 2>&1 )\n";
	system "( time $CMD_PSQL -h $host -f $TRANSFER_SQL template1 > ${TRANSFER_SQL}.$host 2>&1 )" if $RUN;
	print "\n";

}

#put the hosts back in
foreach my $web_host (@HOST_WEB)
{
	foreach my $host (@HOST_POSTGRES_1)
	{
		print "putting $host back in for $web_host\n";
		my $num = $host;
		$num =~ s/\D//g;
		$num--;
		foreach my $attr ('backend_hostname', 'backend_port', 'backend_weight')
		{
			print  "$CMD_SSH $web_host perl -p -i -e 's/^#\\(${attr}${num}.+\\)/\\\\1/' /usr/local/etc/pgpool.conf \n";
			system "$CMD_SSH $web_host perl -p -i -e 's/^#\\(${attr}${num}.+\\)/\\\\1/' /usr/local/etc/pgpool.conf" if $RUN;
		}
		print "\n";
	}
	print "$CMD_SSH $web_host 'pgpool -m fast stop; pgpool' \n";
	system "$CMD_SSH $web_host 'pgpool -m fast stop; pgpool'" if $RUN;
	print "\n";
}
