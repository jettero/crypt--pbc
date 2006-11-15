#include <pbc.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "const-c.inc"

MODULE = Crypt::PBC		PACKAGE = Crypt::PBC		

PROTOTYPES: ENABLE

INCLUDE:   const-xs.inc
INCLUDE: pairing.xs
INCLUDE:   einit.xs
INCLUDE:  earith.xs
INCLUDE:   ecomp.xs

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

    // My bug posted to the pbc-dev newsgroup, where I was getting different
    // results for different elements that test equal?  Yeah, the following
    // line was not present when I got that result.  I'm awesome.
    element_to_bytes(buf, *element);

    RETVAL = newSVpvn(buf, len);

    free(buf);

    OUTPUT:
    RETVAL
