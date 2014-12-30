package Dogemon::Worker;

use Moo;
use namespace::clean;

has id => ( is => 'ro' );

sub work {

    my ( $self ) = @_;

    # fork background worker process
    my $pid = fork;

    # return child process id if in parent
    return $pid if $pid;

    # fix our child process name
    $0 = 'dogemon [worker]';
    
    # do work
    sleep 5 while 1;
}

1;
