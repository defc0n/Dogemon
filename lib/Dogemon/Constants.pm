package Dogemon::Constants;

require Exporter;

@ISA = qw( Exporter );
@EXPORT = qw( UP DEGRADED DOWN UNKNOWN DEFAULT_TIMEOUT );

use constant UP => 0;
use constant DEGRADED => 1;
use constant DOWN => 2;
use constant UNKNOWN => 3;

use constant DEFAULT_TIMEOUT => 30;

1;
