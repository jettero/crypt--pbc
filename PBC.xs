/* $Id: PBC.xs,v 1.5 2006/11/11 18:54:42 jettero Exp $ */

#include <pbc.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

INCLUDE: const-xs.inc

pairing_t *
pairing_init_stream(stream)
    FILE * stream

    PREINIT:
    pairing_t * pairing = malloc( sizeof(pairing_t) );

    CODE:
    // fprintf(stderr, " ... mallocing a pairing ... \n");
    pairing_init_inp_str(*pairing, stream);
    RETVAL = pairing;

    OUTPUT:
    RETVAL

void
pairing_clear(pairing)
    pairing_t * pairing

    CODE:
    // fprintf(stderr, " ... freeing a pairing ... \n");
    pairing_clear(*pairing);
    free(pairing);
