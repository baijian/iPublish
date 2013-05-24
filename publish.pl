#!/usr/bin/perl -w
use strict;

my @result = readpipe("ls -l /tmp");

print @result;



