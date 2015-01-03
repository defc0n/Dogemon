package Dogemon::Constants;

require Exporter;

@ISA = qw( Exporter );
@EXPORT = qw( UP DEGRADED DOWN UNKNOWN );

use constant UP => 0;
use constant DEGRADED => 1;
use constant DOWN => 2;
use constant UNKNOWN => 3;

1;
