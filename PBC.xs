#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <pbc.h>

#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

INCLUDE: const-xs.inc
