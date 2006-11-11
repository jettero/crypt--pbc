
#include <stdio.h>

// pairing_t is typedef pairing_s pairing_t[1] -- presumably to make pairing_t a pointer
// so this is a demo on copying them (improperly) -- we're going to need some malloc...
struct lol1 {
    int v;
};
typedef struct lol1 lol2[1];

int main() {
    lol2 i;
    lol2 j;
    struct lol1 * k;
    lol2 m;

    i->v = 77;
    *j = *i; // set j off i
    k = (struct lol1 *) j; // set k off j
    *m = *k; // set m off k

    printf("i=%d\n", i->v);
    printf("j=%d\n", j->v);
    printf("k=%d\n", k->v);
    printf("m=%d\n", m->v);

    return 0;
}
