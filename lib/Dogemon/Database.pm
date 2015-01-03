package Dogemon::Database;

use Moo;

use AnyEvent;
use AnyEvent::DBI;

use Data::Dumper;

has filename => ( is => 'ro' );
has dbh => ( is => 'rw' );

### init ###

sub BUILD {
    
    my ( $self ) = @_;

    my $filename = $self->filename;
    my $cv = AnyEvent->condvar;

    my $dbh = AnyEvent::DBI->new( "DBI:SQLite:dbname=$filename", "", "",
				  on_connect => sub { $cv->send },
				  on_error => sub { warn @$ },
				  fetch => sub { my ( $sth ) = @_; $sth->fetchall_arrayref( {} ) } );
    
    $cv->recv;

    $self->dbh( $dbh );
}

1;
