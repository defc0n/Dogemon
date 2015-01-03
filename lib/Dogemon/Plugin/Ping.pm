package Dogemon::Plugin::Ping;

use Moo;

with 'Dogemon::Role::Plugin';

use Dogemon::Constants;
use Dogemon::Alert;

use AnyEvent;
use AnyEvent::Ping;

use Math::Round::Var;
use Data::Dumper;

sub run {

    my ( $self ) = @_;

    my $cv = AnyEvent->condvar;

    my $status;
    my $rtt;
    
    my $pinger = AnyEvent::Ping->new;

    $pinger->ping( $self->host, 1, sub {

	my ( $result ) = @_;

	( $status, $rtt ) = @{$result->[0]};

	$cv->send;

		   } );

    $cv->recv;
    $pinger->end;

    # convert seconds to ms
    $rtt *= 1000;

    my $rounder = Math::Round::Var->new( 0.1 );

    $rtt = $rounder->round( $rtt );

    return Dogemon::Alert->new( host => $self->host,
				description => "$status: $rtt ms",
				status => ( $status eq "OK" ) ? UP : DOWN );
}

1;
