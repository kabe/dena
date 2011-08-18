#!/usr/bin/env perl

use strict;
use warnings;

use MyServer2;

my $server = MyServer2->new(8081);
$server->run();
