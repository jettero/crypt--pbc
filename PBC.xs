/* $Id: PBC.xs,v 1.11 2006/11/12 03:47:06 jettero Exp $ */

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
    // fprintf(stderr, " ... malloced a pairing ... \n");
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

element_t *
element_init_G1(pairing)
    pairing_t * pairing

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );

    CODE:
    // fprintf(stderr, " ... malloced a G1 element ... \n");
    element_init_G1(*element, *pairing);
    RETVAL = element;

    OUTPUT:
    RETVAL

element_t *
element_init_G2(pairing)
    pairing_t * pairing

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );

    CODE:
    // fprintf(stderr, " ... malloced a G2 element ... \n");
    element_init_G2(*element, *pairing);
    RETVAL = element;

    OUTPUT:
    RETVAL

element_t *
element_init_GT(pairing)
    pairing_t * pairing

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );

    CODE:
    // fprintf(stderr, " ... malloced a GT element ... \n");
    element_init_GT(*element, *pairing);
    RETVAL = element;

    OUTPUT:
    RETVAL

element_t *
element_init_Zr(pairing)
    pairing_t * pairing

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );

    CODE:
    // fprintf(stderr, " ... malloced a Zr element ... \n");
    element_init_Zr(*element, *pairing);
    RETVAL = element;

    OUTPUT:
    RETVAL

void
element_clear(element)
    element_t * element

    CODE:
    // fprintf(stderr, " ... freeing an element ... \n");
    element_clear(*element);
    free(element);

void
element_random(element)
    element_t * element

    CODE:
    element_random(*element);

void
element_pow_zn(LHS,RHS_base,RHS_expo)
    element_t * LHS
    element_t * RHS_base
    element_t * RHS_expo

    CODE:
    element_pow_zn(*LHS, *RHS_base, *RHS_expo);

void
pairing_apply(LHS,RHS1,RHS2,pairing)
    element_t * LHS
    element_t * RHS1
    element_t * RHS2
    pairing_t * pairing

    CODE:
    pairing_apply(*LHS, *RHS1, *RHS2, *pairing);

SV *
stringify_gmp(element)
    element_t * element
    // function stolen from Math::GMP (GMP.xs) with only slight modifications

    PREINIT:
    mpz_t m;
    int len;
    
    CODE:
    mpz_init(m); // there are (of course) some minor differences from GMP.xs ...
    // (*element)->field->to_mpz(m, *element);
    element_to_mpz(m, *element);
    len = mpz_sizeinbase(m, 10);
    {
        char *buf;
        buf = malloc(len + 2);
        mpz_get_str(buf, 10, m);
        RETVAL = newSVpv(buf, strlen(buf));
        free(buf);
    }
    mpz_clear(m);

    OUTPUT:
    RETVAL
