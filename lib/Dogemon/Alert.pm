package Dogemon::Alert;

use Moo;
use AnyEvent;
use Dogemon::Constants;

has host => ( is => 'ro',
	      required => 1 );

has description => ( is => 'ro',
		     required => 1 );

has status => ( is => 'ro',
		required => 1,
		isa => sub {
		    my ( $arg ) = @_;
		    die "Unknown status" if ( $arg != UP && $arg != DOWN && $arg != UNKNOWN )
		} );

has timestamp => ( is => 'ro',
		   required => 0 );


1;
