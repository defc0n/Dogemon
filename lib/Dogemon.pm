package Dogemon;

use Moo;
use namespace::clean;

use Dogemon::Daemon;
use Dogemon::Worker;

use Sys::Info::Device::CPU;
use Data::Dumper;

### object attributes ###

has daemonize => ( is => 'ro' );
has pid_file => ( is => 'ro' );
has num_workers => ( is => 'rw' );
has worker_pids => ( is => 'rw' );

### public methods ###

sub run {

    my ( $self ) = @_;

    # check if we need to daemonize
    if ( $self->daemonize ) {

	my $daemon = Dogemon::Daemon->new( pid_file => $self->pid_file );

	my $pid = $daemon->daemonize;

	# just return if we're the original parent (not child)
	return $pid if $pid;
    }

    # check if we need to determine number of workers to use
    $self->_determine_num_workers if !$self->num_workers;

    # create all of our worker doges
    my @worker_pids;

    for ( my $n = 0; $n < $self->num_workers; $n++ ) {

	warn "creating worker $n";

	my $worker_pid = Dogemon::Worker->new( id => $n )->work;

	push @worker_pids, $worker_pid;
    }

    $self->worker_pids( @worker_pids );

    # wait for all our worker doges to return to their nest
    foreach my $worker_pid ( @worker_pids ) {

	waitpid $worker_pid, 0;
    }

    return 1;
}

### private methods ###

sub _determine_num_workers {

    my ( $self ) = @_;

    my $cpu_info = Sys::Info::Device::CPU->new;

    # use hyperthreading count, if its supported
    my $ht = $cpu_info->hyper_threading;

    if ( $ht ) {

	$self->num_workers( $ht );
	return;
    }

    # use total # of cores instead
    my $count = $cpu_info->count;

    $self->num_workers( $count );
}
    
1;
