package Dogemon::Database;

use Moo;

use AnyEvent;
use AnyEvent::DBI::Abstract;

use Data::Dumper;

### attributes ###

has filename => ( is => 'ro',
		  required => 1 );

has dbh => ( is => 'rw' );

### initialization ###

sub BUILD {
    
    my ( $self ) = @_;

    my $filename = $self->filename;
    my $cv = AnyEvent->condvar;

    my $dbh = AnyEvent::DBI::Abstract->new( "DBI:SQLite:dbname=$filename", "", "",
					    on_connect => sub { $cv->send },
					    on_error => sub { warn @$ } );
    
    $cv->recv;

    $self->dbh( $dbh );
}

### public methods ###

sub get_nodes {

    my ( $self, %args ) = @_;

    my $table = 'node';
    my $fields = ['node.node_id',
		  'node.name',
		  'node.ip_address'];
    my $where = [];
    my $order = ['node.node_id'];

    my $results = [];

    my $cv = AnyEvent->condvar;

    $self->dbh->select( $table,
			$fields,
                        $where,
			$order,
			sub {

                            my ( $dbh, $rows, $rv ) = @_;

                            foreach my $row ( @$rows ) {

				push $results, {'node_id' => $row->[0],
                                                'name' => $row->[1],
                                                'ip_address' => $row->[2]};
                            }

                            $cv->send;
			} );

    $cv->recv;

    return $results;
}

sub get_services {

    my ( $self, %args ) = @_;

    my $table = 'service',
    my $fields = ['service.service_id',
		  'service.node_id',
		  'service.name',
		  'service.plugin_id',
		  'service.interval',
		  'service.timeout'];    
    my $where = [];
    my $order = ['service.service_id'];

    my $results = [];

    my $cv = AnyEvent->condvar;

    $self->dbh->select( $table,
			$fields,
			$where,
			$order,
			sub {
			    
			    my ( $dbh, $rows, $rv ) = @_;
			    
			    foreach my $row ( @$rows ) {

				push $results, {'service_id' => $row->[0],
						'node_id' => $row->[1],
						'name' => $row->[2],
						'plugin_id' => $row->[3],
						'interval' => $row->[4],
						'timeout' => $row->[5]};
			    }
			    
			    $cv->send;
			} );
    
    $cv->recv;

    return $results;
}

1;
