package Dogemon::Role::Plugin;

use Moo::Role;

use Dogemon::Constants;

### attributes ###

has host => ( is => 'ro',
	      required => 1 );

has timeout => ( is => 'ro',
		 required => 0,
		 default => DEFAULT_TIMEOUT );

# convert their response to arrayref if single alert returned
around 'run' => sub {
    
    my ( $orig, $self ) = @_;

    my $result = $orig->( $self, @_ );

    $result = [$result] if ( ref $result ne 'HASH' );

    return $result;
};

1;
