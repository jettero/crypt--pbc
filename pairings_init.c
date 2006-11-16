/*
** This turned out to actually be a bug -- which Ben fixed pretty much the
** same day.  11/15/06 0.3.16 -> 0.3.17
*/

#include "pbc.h"
#include <string.h>

char huge[1024*1024];

int main(void) {
    pairing_t pairing1;
    pairing_t pairing2;

    element_t G1_1, G1_2;
    element_t G2_1, G2_2;

    FILE * f = fopen("params.txt", "r");
    pairing_init_inp_str(pairing1, f);
    fclose(f);

    #if 1
    f = fopen("params.txt", "r");
    fread(huge, 1024*1024, 1, f);
    pairing_init_inp_buf(pairing2, huge, strlen(huge));
    fclose(f);
    #else 
    f = fopen("params.txt", "r");
    pairing_init_inp_str(pairing2, f);
    fclose(f);
    #endif

    element_init_G1(G1_1, pairing1); element_from_hash(G1_1, "test !!", 5);
    element_init_G2(G2_1, pairing1); element_from_hash(G2_1, "test !!", 5);

    element_init_G1(G1_2, pairing2); element_from_hash(G1_2, "test !!", 5);
    element_init_G2(G2_2, pairing2); element_from_hash(G2_2, "test !!", 5);

    if( element_cmp(G1_1, G1_2) )
        printf("ruh roh, the G1s differ...\n");

    if( element_cmp(G2_1, G2_2) )
        printf("ruh roh, the G2s differ...\n");

    return 0;
}
