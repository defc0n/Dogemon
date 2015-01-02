package Dogemon::Database;

use Moo;
use namespace::clean;

use AnyEvent::DBI::Abstract;

has filename => ( is => 'ro' );
has dbh => ( is => 'rw' );

sub connect {
    
    my ( $self ) = @_;

    my $filename = $self->filename;

    my $dbh = AnyEvent::DBI::Abstract->new( "DBI:SQLite:dbname=$filename", "", "" );
						
    $self->dbh( $dbh );

    return 1;
}

1;
