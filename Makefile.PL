#!perl

use strict;
use warnings;
use inc::Module::Install;

name 'Catalyst-Plugin-ErrorCatcher-Email-Env';
all_from 'lib/Catalyst/Plugin/ErrorCatcher/Email/Env.pm';

requires 'Catalyst::Plugin::ErrorCatcher::Email';
requires 'MIME::Lite';

test_requires 'Test::More';
test_requires 'Test::MockObject';

resources repository => 'git://github.com/dwc/Catalyst-Plugin-ErrorCatcher-Email-Env.git';

WriteAll;
