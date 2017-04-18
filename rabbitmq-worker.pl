#!/usr/bin/perl
# rabbitmq-worker.pl
# Docker Container that acts as a RabbitMQ Worker.
# This Scripts does the magic
# acdaiv4v 31.03.2017
#

use strict;
use warnings;
use Net::RabbitMQ;
use     YAML qw( LoadFile);

# Your YAML Configuration File
my $yamlconfig="/usr/local/etc/rabbitmq-worker/rabbitmq-worker.yml";  # Configuration RabbitMQ Server

# Load Configuration
$yamlconfig = LoadFile($yamlconfig);

# Default Connections
# Fallback Values for your YAML Configuration
my $mq_server = "localhost";
my $mq_connection = "acdaic4v";
my $mq_user = "guest";
my $mq_password = "guest";
my $mq_vhost = "/";
my $mq_channel = 1;
my $mq_exchange = 'acdaic4vexchange';
my $mq_queuename = 'acdaic4vqueue';
my $mq_routing_key = '';

# Set the Values if defined in your YAML
for my $eintrag (@$yamlconfig)
{
        if($eintrag->{mq_server})
        {
                $mq_server = $eintrag->{mq_server};
        }
        if($eintrag->{mq_connection})
        {
                $mq_connection = $eintrag->{mq_connection};
        }
        if($eintrag->{mq_user})
        {
                $mq_user = $eintrag->{mq_user};
        }
        if($eintrag->{mq_password})
        {
                $mq_password = $eintrag->{mq_password};
        }
        if($eintrag->{mq_vhost})
        {
                $mq_vhost = $eintrag->{mq_vhost};
        }
        if($eintrag->{mq_channel})
        {
                $mq_channel = $eintrag->{mq_channel};
        }
        if($eintrag->{mq_exchange})
        {
                $mq_exchange = $eintrag->{mq_exchange};
        }
        if($eintrag->{mq_queuename})
        {
                $mq_queuename = $eintrag->{mq_queuename};
        }
        if($eintrag->{mq_routing_key})
        {
                $mq_routing_key = $eintrag->{mq_routing_key};
        }
}
my ($log, $mq);
$mq = Net::RabbitMQ->new;

print "CONNECT: $mq_server, { user => $mq_user, password => $mq_password, vhost => $mq_vhost }\n";
$mq->connect($mq_server, { user => $mq_user, password => $mq_password, vhost => $mq_vhost })
  or die "Can't connect to RabbitMQ\n";
  print "OPEN: $mq_channel \n";
$mq->channel_open($mq_channel);
print "EXCHANGE: $mq_channel, $mq_exchange\n";
$mq->exchange_declare($mq_channel, $mq_exchange);
print "DECLARE: $mq_channel, $mq_queuename\n";
$mq->queue_declare($mq_channel, $mq_queuename, {
    passive => 0,
    durable => 1,
    exclusive => 0,
    auto_delete => 0
  });
print "BIND: $mq_channel, $mq_queuename, $mq_exchange, $mq_routing_key\n";
$mq->queue_bind($mq_channel, $mq_queuename, $mq_exchange, $mq_routing_key);
print "CONSUME: $mq_channel, $mq_queuename\n";
$mq->consume($mq_channel, $mq_queuename);
print "Vor while\n";

while(1)
{
        my $rv = $mq->recv();
        print "BODY: $rv->{body}\n";
        # Your Action: Do what you have to do with the body:
        my $rc = system("/usr/local/bin/myworker/worker.pl $rv->{body}");
        print "RC: $rc\n";
        open FILE, ">/opt/transfer/rabbitworker.txt" or die "Cannot open logfile";
        print FILE "WORKER: $rc: $rv->{body}\n";
        close FILE;
}
