#!perl

use strict;
use warnings;
use Test::More tests => 10;
use Test::MockObject;

use Catalyst::Plugin::ErrorCatcher::Email::Env;

my %env = (
    REMOTE_USER => 'dwc',
    ufid        => 12345678,
    glid        => 'dwc',
);

my $engine = Test::MockObject->new;
$engine->set_always('env', \%env);

my $c = Test::MockObject->new;
$c->set_always('engine', $engine);

my %config = (
    from    => 'address@example.com',
    to      => 'address@example.com',
    subject => 'Test error',
);

my $msg = Catalyst::Plugin::ErrorCatcher::Email::Env::_build_msg($c, \%config, 'STACK TRACE');

isa_ok($msg, 'MIME::Lite');

my $str = $msg->as_string;
like($str, qr/^From:\s+address\@example\.com/m, 'message contains correct From: address');
like($str, qr/^To:\s+address\@example\.com/m, 'message contains correct To: address');
like($str, qr/^Subject:\s+Test error/m, 'message contains correct Subject: line');
like($str, qr/^Content-Type:\s+multipart\/mixed/m, 'message has multiple parts');
like($str, qr/STACK TRACE/, 'message contains dummy stack trace');
like($str, qr/^Content-Disposition:\s+attachment;\s+filename="env.txt"/m, 'message contains a file attachment named "env.txt"');
like($str, qr/REMOTE_USER\n\tdwc/, 'message has REMOTE_USER');
like($str, qr/ufid\n\t12345678/, 'message has ufid');
like($str, qr/glid\n\tdwc/, 'message has glid');
