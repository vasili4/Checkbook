#!/usr/bin/perl
#########################
#
# Jacque Istok
# jistok@greenplum.com
#
# shared variables for ETL
#
#########################
package etl;
use Exporter;
use strict;

our @ISA = qw(Exporter);

our @EXPORT = qw
(
	$CMD_SSH
	$CMD_PSQL
	$P_JOBID
	$RUN
	$TRANSFER_SQL
	@HOST_GREENPLUM
	@HOST_POSTGRES_1
	@HOST_POSTGRES_2
	@HOST_WEB
	@ETL_SQL
);

our $CMD_SSH = "/usr/bin/ssh -q";
our $CMD_PSQL = "psql -A -t";
our $P_JOBID = `date +%j%y`; chop $P_JOBID;
our $RUN = 0;
our $TRANSFER_SQL = "tmp.transfer.sql";
$RUN = 1 if $ARGV[0] eq "-f";
#########################
#Define Greenplum Hosts
our @HOST_GREENPLUM = (
	"gpmaster.local",
	"gpslave-1.local",
	"gpslave-2.local",
	"gpslave-3.local",
	"gpslave-4.local",
	"gpslave-5.local",
	"gpslave-6.local",
	"gpslave-7.local",
	"gpslave-8.local"
);

#Define Postgres Hosts 1
our @HOST_POSTGRES_1 = (
	"postgres-3.local",
	"postgres-4.local",
	"postgres-5.local"
);

#Define Postgres Hosts 1
our @HOST_POSTGRES_2 = (
	"postgres-1.local",
	"postgres-2.local"
);

#Define Drupal/Web Hosts
our @HOST_WEB = (
	"drupal-web-1.local"
);

#Define SQL
our @ETL_SQL = (
	"select truncateAllAggregateTables(p_jobid);",
	"select normalizeandsyncupfaads(p_jobid); select refreshallaggregatetables(p_jobid, 'a');",
	"select processRawData(p_jobid);",
	"select synchronizeFPDStransactiontables(p_jobid)",
	"select refreshallaggregatetables(p_jobid, 'c');"
);

1;
