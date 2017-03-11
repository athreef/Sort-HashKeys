#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdlib.h>
#include <string.h>
 
#include "ppport.h"
#include <stdio.h>

struct elem {
    const char *key;
    STRLEN keysz;
    void *val;
};

static int cmp_asc(const void *a, const void *b) {
    const struct elem *ia = a, *ib = b;
    return memcmp(ia->key, ib->key, MIN(ia->keysz, ib->keysz));
}

static int cmp_desc(const void *a, const void *b) {
    const struct elem *ia = a, *ib = b;
    return -memcmp(ia->key, ib->key, MIN(ia->keysz, ib->keysz));
}

MODULE = Sort::HashKeys		PACKAGE = Sort::HashKeys
 
PROTOTYPES: ENABLE
 
void
sort(...)
    PROTOTYPE: @
    ALIAS:
        reverse_sort = 1
    INIT:
        int i;
        struct elem *elems;
    CODE:
        if (!items) {
            XSRETURN_UNDEF;
        }
        if (items % 2 == 1) {
            ST(items) = &PL_sv_undef;
            items++;
        }

        Newx(elems, items / 2, struct elem);
        for (i = 0; i < items / 2; i++) {
            elems[i].key = SvPV(ST(2*i), elems[i].keysz);
            elems[i].val = ST(2*i+1);
        }

        qsort(elems, items / 2, sizeof (struct elem), ix ? cmp_desc : cmp_asc);

        for (i = 0; i < items / 2; i++) {
            ST(2*i+0) = newSVpv(elems[i].key, elems[i].keysz);
            ST(2*i+1) = elems[i].val;
        }

        Safefree(elems);

        XSRETURN(items);
