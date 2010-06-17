#!perl

use strict;
use warnings;
use Test::More tests => 3;

use Catalyst::Plugin::ErrorCatcher::Email::Env;

my %env = (
    REMOTE_USER => 'dwc',
    ufid        => 12345678,
    glid        => 'dwc',
);

my $env_dump = Catalyst::Plugin::ErrorCatcher::Email::Env::_dump_env(\%env);
like($env_dump, qr/REMOTE_USER\n\tdwc/, 'environment dump has REMOTE_USER');
like($env_dump, qr/ufid\n\t12345678/, 'environment dump has ufid');
like($env_dump, qr/glid\n\tdwc/, 'environment dump has glid');
