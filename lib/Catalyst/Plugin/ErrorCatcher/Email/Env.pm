package Catalyst::Plugin::ErrorCatcher::Email::Env;

use strict;
use warnings;
use MIME::Lite;
use base qw/Catalyst::Plugin::ErrorCatcher::Email/;

our $VERSION = '0.01';

=head1 NAME

Catalyst::Plugin::ErrorCatcher::Email::Env - An email emitter with extra information for Catalyst::Plugin::ErrorCatcher

=head1 SYNOPSIS

See L<Catalyst::Plugin::ErrorCatcher::Email>.

=head1 DESCRIPTION

This is an email emitter for L<Catalyst::Plugin::ErrorCatcher>. It is
similar to L<Catalyst::Plugin::ErrorCatcher::Email>, but adds an
attachment containing the request environment variables.

Due to the way that L<Catalyst::Plugin::ErrorCatcher::Email> is
constructed, we cannot easily wrap additional functionality, so we end
up duplicating some of what exists in
L<Catalyst::Plugin::ErrorCatcher::Email>.

=head1 METHODS

=head2 emit

Set up the email message as in
L<Catalyst::Plugin::ErrorCatcher::Email/emit>, but add an attachment
containing the environment information.

=cut

sub emit {
    my ($class, $c, $output) = @_;

    my $config;
    $config = Catalyst::Plugin::ErrorCatcher::Email::_check_config($c, $config);

    my $msg = _build_msg($c, $config, $output);

    Catalyst::Plugin::ErrorCatcher::Email::_send_email($msg, $config);
}

=head2 _build_msg

Build the email, including the text file containing the environment
information.

=cut

sub _build_msg {
    my ($c, $config, $output) = @_;

    my $msg = MIME::Lite->new(
        From    => $config->{from},
        To      => $config->{to},
        Subject => $config->{subject},
        Type    => 'multipart/mixed',
    );

    # Include the error report in the body
    $msg->attach(
        Type => 'TEXT',
        Data => $output,
    );

    # Attach the environment as a text file
    my $env_dump = _dump_env($c->engine->env);
    $msg->attach(
        Type        => 'TEXT',
        Filename    => 'env.txt',
        Disposition => 'attachment',
        Data        => $env_dump,
    );

    return $msg;
}

=head2 _dump_env

Return a string containing the environment keys and values.

=cut

sub _dump_env {
    my ($env) = @_;

    my $env_dump = '';

    foreach my $key (sort keys %$env) {
        $env_dump .= "$key\n"
            . "\t" . $env->{$key} . "\n"
            . "\n";
    }

    return $env_dump;
}

=head1 SEE ALSO

=over 4

=item * L<Catalyst::Plugin::ErrorCatcher::Email>

=back

=head1 AUTHOR

Daniel Westermann-Clark E<lt>danieltwc@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
