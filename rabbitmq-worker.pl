#!/usr/bin/perl
# rabbitmq-worker.pl
# Docker Container that acts as a RabbitMQ Worker.
# This Scripts does the magic
# acdaiv4v 31.03.2017
#
# Der einzulesende Dateiname ist fest: Wird über das Docker- Startscript vergeben
#
# Benoetigte Eintraege:
#   - redishash
#   - rediskey

use strict;
use warnings;
# use JSON;
# use YAML::XS;
# use Scalar::Util qw(looks_like_number);
use Net::RabbitMQ;
use     YAML qw( LoadFile);

my $yamlconfig="/usr/local/etc/rabbitmq-worker/rabbitmq-worker.yml";  # Configuration RabbitMQ Server

# Load Configuration 
$yamlconfig = LoadFile($yamlconfig);

# Default Connections
my $mq_server = "localhost";
my $mq_connection = "acdaic4v";
my $mq_user = "guest";
my $mq_password = "guest";

for my $eintrag (@$yamlconfig)
{
        if($eintrag->{id} eq "log4perl")
        {
                $log4perl = $eintrag->{wert};
        }
        elsif($eintrag->{id} eq "mq_server")
        {
                $mq_server = $eintrag->{wert};
        }
        elsif($eintrag->{id} eq "mq_connection")
        {
                $mq_connection = $eintrag->{wert};
        }
        elsif($eintrag->{id} eq "mq_user")
        {
                $mq_user = $eintrag->{wert};
        }
        elsif($eintrag->{id} eq "mq_password")
        {
                $mq_password = $eintrag->{wert};
        }
}


# Initialisieren
my ($log, $mq);
# Logging aktivieren
# Log::Log4perl->init($log4perl);
# $log = Log::Log4perl->get_logger();

my $mq = Net::RabbitMQ->new();
# $log->debug("RABBIT: ".$mq_server.":".$mq_port);
$mq->connect($mq_server, { user => $mq_user, password => $mq_password });
$mq->channel_open(1);

# Magic soon follows 
$mq->disconnect();
