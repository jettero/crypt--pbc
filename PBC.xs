/* $Id: PBC.xs,v 1.3 2006/11/11 16:53:20 jettero Exp $ */

#include <pbc.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

INCLUDE: const-xs.inc

pairing_t
pairing_init_stream(stream)
    FILE * stream

    PREINIT:
    pairing_t pairing;

    CODE:
    pairing_init_inp_str(pairing, stream);

    RETVAL = pairing;

    OUTPUT:
    RETVAL

/*
void
pairing_clear(pairing)
	pairing_t pairing

    CODE:
    pairing_clear(pairing);
    */
