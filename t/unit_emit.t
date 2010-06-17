#!perl

use strict;
use warnings;
use Test::More tests => 9;
use Test::MockObject;

use Catalyst::Plugin::ErrorCatcher::Email::Env;

my %env = (
    REMOTE_USER => 'dwc',
    ufid        => 12345678,
    glid        => 'dwc',
);

my $engine = Test::MockObject->new;
$engine->set_always('env', \%env);

my $msg;
sub _catch {
    $msg = shift;
}

my %config = (
    'Plugin::ErrorCatcher::Email' => {
        from    => 'address@example.com',
        to      => 'address@example.com',
        subject => 'Test error',
        send    => {
            type => 'sub',
            args => [ \&_catch ],
        },
    },
);

my $c = Test::MockObject->new;
$c->set_always('engine', $engine);
$c->set_always('config', \%config);
$c->set_always('_errorcatcher_c_cfg', \%config);

Catalyst::Plugin::ErrorCatcher::Email::Env->emit($c, 'STACK TRACE');

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
