/*
** Should this segfault?  I don't think so, but I could be wrong. 11/25/06
**  -Paul
*/

#include "pbc.h"

int main(void) {
    pairing_t pairing1;
    pairing_t pairing2;

    element_t G1_a;
    element_t G1_b;

    FILE * f;

    fprintf(stderr, "here-%s-%d [OK] \n", __FILE__, __LINE__);

    f = fopen("params.txt", "r"); pairing_init_inp_str(pairing1, f); fclose(f); 
    element_init_G1(G1_a, pairing1); element_from_hash(G1_a, "test !!", 5);
    pairing_clear( pairing1 );

    fprintf(stderr, "here-%s-%d [OK] \n", __FILE__, __LINE__);

    f = fopen("params.txt", "r"); pairing_init_inp_str(pairing2, f); fclose(f); 
    element_init_G1(G1_b, pairing2); element_from_hash(G1_b, "test !!", 5);
    pairing_clear( pairing2 );

    fprintf(stderr, "here-%s-%d [OK] \n", __FILE__, __LINE__);

    element_clear( G1_b ); fprintf(stderr, "here-%s-%d (about to segfault)\n", __FILE__, __LINE__);
    element_clear( G1_a ); fprintf(stderr, "here-%s-%d (segfaulted?)\n",       __FILE__, __LINE__);

    return 0;
}
