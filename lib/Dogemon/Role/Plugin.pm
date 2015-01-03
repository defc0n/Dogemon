package Dogemon::Role::Plugin;

use Moo::Role;

### attributes ###

has host => ( is => 'ro',
	      required => 1 );

# convert their response to arrayref if single alert returned
around 'run' => sub {
    
    my ( $orig, $self ) = @_;

    my $result = $orig->( $self, @_ );

    $result = [$result] if ( ref $result ne 'HASH' );

    return $result;
};

1;
