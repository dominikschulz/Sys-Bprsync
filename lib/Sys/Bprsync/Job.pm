package Sys::Bprsync::Job;
# ABSTRACT: an bprsync job, spawns a worker

use 5.010_000;
use mro 'c3';
use feature ':5.10';

use Moose;
use namespace::autoclean;

# use IO::Handle;
# use autodie;
# use MooseX::Params::Validate;

use Sys::Bprsync::Worker;

extends 'Job::Manager::Job';

has 'parent' => (
    'is'       => 'ro',
    'isa'      => 'Sys::Bprsync',
    'required' => 1,
);

has 'name' => (
    'is'       => 'ro',
    'isa'      => 'Str',
    'required' => 1,
);

has 'verbose' => (
    'is'      => 'rw',
    'isa'     => 'Bool',
    'default' => 0,
);

has 'dry' => (
    'is'      => 'ro',
    'isa'     => 'Bool',
    'default' => 0,
);

sub _init_worker {
    my $self = shift;

    my $Worker = Sys::Bprsync::Worker::->new(
        {
            'config'  => $self->config(),
            'logger'  => $self->logger(),
            'parent'  => $self->parent(),
            'name'    => $self->name(),
            'verbose' => $self->verbose(),
            'dry'     => $self->dry(),
        }
    );

    return $Worker;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sys::Bprsync::Job - a BPrsync job

=cut
