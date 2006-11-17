#include "pbc.h"
#include <gmp.h>

int main(void) {
    pairing_t pairing;

    element_t G1, G2, GT, Zr;
    mpz_t titty;

    int i;

    FILE * f = fopen("params.txt", "r");
    pairing_init_inp_str(pairing, f);
    fclose(f);

    element_init_G1(G1, pairing);
    element_init_G2(G2, pairing);
    element_init_GT(GT, pairing);
    element_init_Zr(Zr, pairing);

    for(i=0; i<30; i++) {
        element_random(G1);
        element_random(G2);
        element_random(GT);
        element_random(Zr);

        mpz_init(titty);
        element_to_mpz(titty, G1);
        gmp_printf("%s is an mpz %Zd\n", "titty", titty);

        element_square(G1, G1);
        element_square(G2, G2);
        element_square(GT, GT);
        element_square(Zr, Zr);

        printf("[%c] is_sqr(GT)\n", !element_is_sqr(GT) ? 'x' : ' ' );
        printf("[%c] is_sqr(Zr)\n", !element_is_sqr(Zr) ? 'x' : ' ' );
     // printf("[%c] is_sqr(G1)\n", !element_is_sqr(G1) ? 'x' : ' ' );
     // printf("[%c] is_sqr(G2)\n", !element_is_sqr(G2) ? 'x' : ' ' );
    }

    return 0;
}
