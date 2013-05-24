#!/usr/bin/perl -w 
use strict;
use ExtUtils::Installed;

my $inst = ExtUtils::Installed->new();
my @modules = $inst->modules();

foreach(@modules){
    my $ver = $inst->version($_) || "???";
    printf("%-12s----Version=>%s\n", $_, $ver);
}

exit 0;
