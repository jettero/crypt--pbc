/*
** This probably shouldn't segfault, but it does... 11/25/06
**   -paul
*/

#include "pbc.h"

int main(void) {
    pairing_t pairing1;
    pairing_t pairing2;

    element_t G1_a;
    element_t G1_b;

    FILE * f;

    f = fopen("params.txt", "r"); pairing_init_inp_str(pairing1, f); fclose(f); 
    f = fopen("params.txt", "r"); pairing_init_inp_str(pairing2, f); fclose(f); 

    element_init_G1(G1_a, pairing1); element_from_hash(G1_a, "test !!", 5);
    element_init_G1(G1_b, pairing2); element_from_hash(G1_b, "test !!", 5);

    pairing_clear( pairing1 );
    pairing_clear( pairing2 );

    element_clear( G1_a );
    element_clear( G1_b );

    return 0;
}
