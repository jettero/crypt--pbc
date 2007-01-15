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

pairing_t *
pairing_init_str(str)
    SV * str

    PREINIT:
    STRLEN len;
    char * ptr;
    pairing_t * pairing = malloc( sizeof(pairing_t) );

    CODE:
    ptr = SvPV(str, len);
    pairing_init_inp_buf(*pairing, ptr, len);
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

void
pairing_apply(LHS,RHS1,RHS2,pairing)
    element_t * LHS
    element_t * RHS1
    element_t * RHS2
    pairing_t * pairing

    CODE:
    pairing_apply(*LHS, *RHS1, *RHS2, *pairing);

int 
pairing_is_symmetric(me)
    pairing_t * me

    CODE:
    RETVAL = pairing_is_symmetric(*me);

    OUTPUT:
    RETVAL
