package Dogemon::Worker;

use Moo;

use Dogemon::Database;
use Dogemon::Scheduler;

use AnyEvent;
use Data::Dumper;

has id => ( is => 'ro' );
has db => ( is => 'rw' );

sub work {

    my ( $self ) = @_;

    # fork background worker process
    my $pid = fork;

    # return child process id if in parent
    return $pid if $pid;

    # we're the child, fix our child process name
    $0 = 'dogemon [worker]';

    # establish our own database connection
    my $db = Dogemon::Database->new( filename => '/tmp/dogemon.db' );
    $self->db( $db );
    
    # do work, doge
    while ( 1 ) {

	my $cv = AnyEvent->condvar;

	$db->dbh->exec( 'select * from node', sub {

	    my ( $dbh, $rows, $rv ) = @_;
	    
	    $cv->send( $rows );
	    
			} );
	
	my $rows = $cv->recv;

	warn Dumper $rows;

	sleep 5;
    }

}

1;
