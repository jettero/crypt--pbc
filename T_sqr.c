/*
*/

#include "pbc.h"

int main(void) {
    pairing_t pairing;

    element_t G1, G2, GT, Zr;

    FILE * f = fopen("params.txt", "r");
    pairing_init_inp_str(pairing, f);
    fclose(f);

    element_init_G1(G1, pairing); element_random(G1);
    element_init_G2(G2, pairing); element_random(G2);
    element_init_GT(GT, pairing); element_random(GT);
    element_init_Zr(Zr, pairing); element_random(Zr);

    element_square(G1, G1);
    element_square(G2, G2);
    element_square(GT, GT);
    element_square(Zr, Zr);

    if( element_is_sqr(GT) ) printf("GT^2\n");
    if( element_is_sqr(Zr) ) printf("Zr^2\n");
    if( element_is_sqr(G1) ) printf("G1^2\n");
    if( element_is_sqr(G2) ) printf("G2^2\n");

    return 0;
}
