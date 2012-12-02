#!/usr/bin/perl
# ABSTRACT: bullet-proof rsync wrapper
# PODNAME: bprsync.pl
use strict;
use warnings;

use Sys::Bprsync::Cmd;

my $Cmd = Sys::Bprsync::Cmd::->new();
$Cmd->run();

exit 1;

__END__

=head1 NAME

bprsync - bullet-proof rsync wrapper

=cut
