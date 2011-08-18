#! /usr/bin/perl -w

use strict;
use warnings;

package MyServer2;

#use MyServer;
use MyServer;
use base qw(MyServer);
use IO::File;
use Path::Class qw(dir);

my $base_path = "contents/";

# dispatch table
my %dispatch = (
    '/hello' => \&resp_hello,
    );

sub handle_request {
    my ($self, $cgi) = @_;
    
    my $path = $cgi->path_info();
    print STDERR $path . " requested\n";
    # Search $path
    my $ok = 0;
    $ok = find_path(dir($base_path, $path));
    my $handler = $dispatch{$path};

    # Special Suffix
    if (!$ok && end_with_slash($path)) {
        $ok = find_path(dir($base_path, $path, "index.html"));
        if($ok) {
            $path = $path . "index.html";
        }
    }
    
    if ($ok) {  # Found
        print "HTTP/1.0 200 OK\r\n\n";
        my $buf = load_content(dir($base_path, $path));
        print load_content(dir($base_path, $path));
    }
    elsif (ref($handler) eq "CODE") {
        print "HTTP/1.0 200 OK\r\n";
        $handler->($cgi);
    }
    else {  # Not Found
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
        $cgi->start_html('Not found'),
        $cgi->h1("$path Not found"),
        $cgi->end_html;
    }
}

sub end_with_slash {
    my $path = shift;
    if ($path =~ m{/$}) {
        return 1 ;
    }
    return 0;
}

sub resp_hello {
    my $cgi  = shift;
    return if !ref $cgi;

    my $who = $cgi->param('name');
    if (!defined $who) {
        $who = "Someone";
    }

    if ($who =~ /Moe/) {
        print $cgi->header(-charset=>"utf-8"), $cgi->start_html("Hello"), $cgi->h1("こんにちは萌様！"), $cgi->end_html;
        return;
    } elsif ($who =~ /Katty/) {
        print $cgi->header(-charset=>"utf-8"), $cgi->start_html("Hello"), $cgi->h1("お前のせいでこんなことに！"), $cgi->end_html;
        return;
    }

    print $cgi->header,
    $cgi->start_html("Hello"),
    $cgi->h1("Hello $who!"),
    $cgi->end_html;
}

1;
