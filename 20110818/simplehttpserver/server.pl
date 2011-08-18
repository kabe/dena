#!/usr/bin/env perl

use strict;
use warnings;

use MyServer;

my $server = MyServer->new(8080);
$server->run();
