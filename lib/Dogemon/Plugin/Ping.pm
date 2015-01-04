package Dogemon::Plugin::Ping;

use Moo;

use Dogemon::Constants;

use AnyEvent;
use AnyEvent::Ping;

use Math::Round::Var;
use Data::Dumper;

with 'Dogemon::Role::Plugin';

has num_packets => ( is => 'ro',
		     required => 0,
		     default => 5 );

has packet_delay => ( is => 'ro',
		      required => 0,
		      default => 1 );

has loss_threshold => ( is => 'ro',
			required => 0,
			default => 1 );

has latency_threshold => ( is => 'ro',
			   required => 0,
			   default => 300 );

sub run {

    my ( $self ) = @_;

    my $cv = AnyEvent->condvar;

    my $num_packets = $self->num_packets;

    my $min;
    my $max;
    my $avg;
    my $total_latency = 0;
    
    my $num_lost = 0;
    my $num_found = 0;

    my $pinger = AnyEvent::Ping->new( timeout => $self->timeout,
				      interval => $self->packet_delay );

    $pinger->ping( $self->host, $num_packets, sub {

	my ( $results ) = @_;

	foreach my $result ( @$results ) {

	    warn Dumper $result;

	    my ( $status, $rtt ) = @$result;

	    # convert seconds to ms
	    $rtt *= 1000;

	    # lost packet
	    if ( $status ne 'OK' ) {

		$num_lost++;
		next;
	    }

	    $num_found++;
	    $total_latency += $rtt;

	    $min = $rtt if ( !defined $min || $rtt < $min );
	    $max = $rtt if ( !defined $max || $rtt > $max );
	}

	$cv->send;
    } );

    $cv->recv;
    $pinger->end;

    my $status = UP;

    $min = 'N/A' if ( !defined $min );
    $max = 'N/A' if ( !defined $max );
    
    if ( $num_found ) {
	
	$avg = $total_latency / $num_found;
	
	$status = DEGRADED if ( $avg > $self->latency_threshold );

	my $rounder = Math::Round::Var->new( 0.1 );
	
	$avg = $rounder->round( $avg ) . " ms";
    }

    $avg = 'N/A' if ( !defined $avg );

    $status = DOWN if ( $num_lost > $self->loss_threshold );    

    return {'host' => $self->host,
	    'description' => "Received $num_found/$num_packets packets, avg. latency $avg",
	    'status' => $status};
}

1;
