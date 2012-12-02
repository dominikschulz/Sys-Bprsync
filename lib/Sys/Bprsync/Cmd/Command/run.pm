package Sys::Bprsync::Cmd::Command::run;
# ABSTRACT: run all pending sync jobs

use 5.010_000;
use mro 'c3';
use feature ':5.10';

use Moose;
use namespace::autoclean;

# use IO::Handle;
# use autodie;
# use MooseX::Params::Validate;
# use Carp;
# use English qw( -no_match_vars );
# use Try::Tiny;
use Linux::Pidfile;
use Sys::Bprsync;

# extends ...
extends 'Sys::Bprsync::Cmd::Command';
# has ...
has '_pidfile' => (
    'is'    => 'ro',
    'isa'   => 'Linux::Pidfile',
    'lazy'  => 1,
    'builder' => '_init_pidfile',
);
# with ...
# initializers ...
sub _init_pidfile {
    my $self = shift;

    my $PID = Linux::Pidfile::->new({
        'pidfile'   => $self->config()->get('Bprsync::Pidfile', { Default => '/var/run/bprsync.pid', }),
        'logger'    => $self->logger(),
    });

    return $PID;
}

# your code here ...
sub execute {
    my $self = shift;

    $self->_pidfile()->create() or die('Script already running.');

    my $concurrency = $self->config()->get( 'Sys::Bprsync::Concurrency', { Default => 1, } );

    my $BP = Sys::Bprsync::->new(
        {
            'config'      => $self->config(),
            'logger'      => $self->logger(),
            'logfile'     => $self->config()->get( 'Sys::Bprsync::Logfile', { Default => '/tmp/bprsync.log' } ),
            'concurrency' => $concurrency,
        }
    );

    my $status = $BP->run();
    $self->_pidfile()->remove();

    return $status;
}

sub abstract {
    return 'Do some syncs';
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sys::Bprsync::Cmd::Command::run - run all pending sync jobs

=method execute

Run the sync.

=method DEMOLISH

Remove our pidfile.

=method abstract

Workaround

=cut
