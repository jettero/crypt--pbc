#include "pbc.h"

int main(void) {
    pairing_t pairing;
    element_t P, s, P_pub;
    element_t Q_id, d_id;

    element_t r, g_id, U, w;
    element_t w_from_U;

    pairing_init_inp_str(pairing, stdin);

    // printf("SETUP\n");

    element_init_G2(P, pairing);
    element_init_Zr(s, pairing);
    element_init_G2(P_pub, pairing);

    element_random(P);  // generator
    element_random(s);  // (secret)
    element_pow_zn(P_pub, P, s); // public key!

    // printf("EXTRACT\n");

    element_init_G1(Q_id, pairing);
    element_init_G1(d_id, pairing);

    element_random(Q_id);          // public key
    element_pow_zn(d_id, Q_id, s); // private key

    // printf("ENCRYPT\n");

    element_init_Zr(r, pairing);
    element_init_GT(g_id, pairing);
    element_init_G2(U, pairing);
    element_init_GT(w, pairing);

    element_random(r);
    element_pow_zn(U, P, r);    // shared secret

    pairing_apply(g_id, Q_id, P_pub, pairing);
    element_pow_zn(w, g_id, r); // (dead givaway for the d_id holder)

    // printf("DECRYPT\n");

    element_init_GT(w_from_U, pairing);
    pairing_apply(w_from_U, d_id, U, pairing);

    if( element_cmp(w, w_from_U) ) {
        printf("Oh no!! The secrets differ!!!\n");

    } else {
        char * c;
        char * d;
        int i, l, m;

        printf("The secrets are the same (as expected).\n");

        c = (char *) malloc( (l= element_length_in_bytes(w)) +2);
        d = (char *) malloc( (m= element_length_in_bytes(w_from_U)) +2);

        if( l != m )
            printf("\tthe lengths differ though...\n");

        element_to_bytes( c, w );
        element_to_bytes( d, w_from_U );

        for(i=0; i<l && i<m; i++) {
            if( c[i] != d[i] ) {
                printf("\thrm, and the strings differ...\n");
                break;
            }
        }
    }

    return 0;
}
