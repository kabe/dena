#! /usr/bin/perl -w

package MyServer;

use strict;
use warnings;

our(@ISA, @EXPORT, @EXPORT_OK);
use Exporter;
push @ISA, qw/Exporter/;
@EXPORT = qw(find_path load_content);
@EXPORT_OK = qw/find_path load_content/;

use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);
use IO::File;
use Path::Class qw(dir);

my $base_path = "contents/";

sub handle_request {
    my ($self, $cgi) = @_;

    my $path = $cgi->path_info();
    print STDERR $path . " requested\n";
    # Search $path
    my $ok = 0;
    $ok = find_path(dir($base_path, $path));

    if ($ok) {                  # Found
        print "HTTP/1.0 200 OK\r\n\n";
        print load_content(dir($base_path, $path));
    }
    else {                      # Not Found
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
            $cgi->start_html('Not found'),
                $cgi->h1("$path Not found"),
                    $cgi->end_html;
    }
}

# Search the specified file path
sub find_path {
    my $path = shift;
    if (-f $path && -r $path) {
        return 1;
    }
    return 0;
}

# Returns the content of the path
sub load_content {
    my $path = shift;
    my $fh = IO::File->new();
    my $buffer = "";
    $fh->binmode();
    $fh->open($path, "r") or die $!; # won't die, as long as permitted
    while (<$fh>) {
        $buffer .= $_;
    }
    $fh->close();
    return $buffer;
}

1;
