
#include <pbc.h>
#include <stdio.h>
#include <errno.h>

int main() {
    FILE *f;
    element_t master;
    pairing_t pairing;
    int len;
    mpz_t m;

    if( (f = fopen("/usr/share/doc/libpbc-0.3.15/examples/param/d105171-196-185.param", "r")) == NULL ) {
        perror( (const char *) strerror(errno));
        exit(1);
    }

    pairing_init_inp_str(pairing, f); fclose(f);
    element_init_Zr(master, pairing);
    element_random(master);
    element_printf("master secret = %B\n", master);

    mpz_init(m);
    master->field->to_mpz(m, master);

    len = mpz_sizeinbase(m, 10);
    printf("master secret len=%d\n", len);

    mpz_clear(m);

    return 0;
}
