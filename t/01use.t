#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok('Catalyst::Plugin::ErrorCatcher::Email::Env') || print "Bail out!
";
}

diag("Testing Catalyst::Plugin::ErrorCatcher::Email::Env $Catalyst::Plugin::ErrorCatcher::Email::Env::VERSION, Perl $], $^X");
