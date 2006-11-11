# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 01_load.t,v 1.1 2006/11/11 14:39:19 jettero Exp $

use strict;
use Test;

plan tests => 1;

eval {use Crypt::PBC; }; ok( not $@ );
