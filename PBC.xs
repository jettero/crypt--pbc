/* $Id: PBC.xs,v 1.2 2006/11/11 15:03:53 jettero Exp $ */

#include <pbc.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

INCLUDE: const-xs.inc
