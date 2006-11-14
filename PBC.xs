/* $Id: PBC.xs,v 1.14 2006/11/12 20:13:32 jettero Exp $ */

#include <pbc.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

INCLUDE: const-xs.inc

PROTOTYPES: ENABLE

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

void
element_fprintf(stream,format,element)
    FILE * stream
    char * format
    element_t * element

    CODE:
    element_fprintf(stream, format, *element);


SV * 
export_element(element)
    element_t * element

    PREINIT:
    char *buf;
    int len;
    
    CODE:
    len = element_length_in_bytes(*element);
    buf = malloc( len + 2 );

    RETVAL = newSVpv(buf, len);

    free(buf);

    OUTPUT:
    RETVAL

element_t *
import_element(str)
    SV * str

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );
    
    CODE:
    element_from_bytes(*element, SvPV_nolen(str));

    RETVAL = element;

    OUTPUT:
    RETVAL

int
element_is0(element)
    element_t * element

    CODE:
    RETVAL = element_is0(*element);

    OUTPUT:
    RETVAL

int
element_is1(element)
    element_t * element

    CODE:
    RETVAL = element_is1(*element);

    OUTPUT:
    RETVAL

int
element_is_sqr(element)
    element_t * element

    CODE:
    RETVAL = element_is_sqr(*element);

    OUTPUT:
    RETVAL

int
element_cmp(a,b)
    element_t * a
    element_t * b

    CODE:
    RETVAL = element_cmp(*a, *b);

    OUTPUT:
    RETVAL

element_t *
element_from_hash(str)
    SV * str

    PREINIT:
    element_t * element = malloc( sizeof(element_t) );
    int i;
    char *buf;

    CODE:
    buf = SvPV_nolen(str);
    i = strlen(buf);

    element_from_hash(*element, buf, i);

    RETVAL = element;

    OUTPUT:
    RETVAL

void
element_set0(element)
    element_t * element

    CODE:
    element_set0(*element);

void
element_set1(element)
    element_t * element

    CODE:
    element_set1(*element);

void
element_set(a,b)
    element_t * a
    element_t * b

    CODE:
    element_set(*a, *b);

void
element_set_si(a,b)
    element_t * a
    long b

    CODE:
    element_set_si(*a, b);
