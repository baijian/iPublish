#!/usr/bin/perl -w
use strict;
use Net::SSH::Perl;

my $host = "192.168.1.1";
my $user = "root";
my $pass = "***";
my $cmd = "ls /tmp";
my $ssh = Net::SSH::Perl->new($host);
$ssh->login($user, $pass);
my($stdout, $stderr, $exit) = $ssh->cmd($cmd);

