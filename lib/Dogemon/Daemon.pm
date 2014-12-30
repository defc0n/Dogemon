package Dogemon::Daemon;

use Moo;
use namespace::clean;

use Proc::Daemon;

has pid_file => ( is => 'ro' );

sub daemonize {

    my ( $self ) = @_;

    my $daemon = Proc::Daemon->new( pid_file => $self->pid_file );
    my $pid = $daemon->Init();

    # in child process
    if ( $pid == 0 ) {
	
	# fix our process name
	$0 = 'dogemon [main]';
    }

    return $pid;
}

1;
