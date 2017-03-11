#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdlib.h>
#include <string.h>
 
#include "ppport.h"
#include <stdio.h>

static int cmp_asc(const void *a, const void *b) {
    const char *ia = *(const char **)a;
    const char *ib = *(const char **)b;
    return strcmp(ia, ib);
}
static int cmp_desc(const void *a, const void *b) {
    const char *ia = *(const char **)a;
    const char *ib = *(const char **)b;
    return -strcmp(ia, ib);
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
        void **elems;
    CODE:
        if (!items) {
            XSRETURN_UNDEF;
        }
        if (items % 2 == 1) {
            ST(items) = &PL_sv_undef;
            items++;
        }

        Newx(elems, items, void*);
        for (i = 0; i < items; i+=2) {
            elems[i+0] = SvPV_nolen(ST(i));
            elems[i+1] = ST(i+1);
        }

        qsort(elems, items / 2, 2 * sizeof(void*), ix ? cmp_desc : cmp_asc);

        for (i = 0; i < items; i+=2) {
            ST(i+0) = newSVpv(elems[i], 0);
            ST(i+1) = elems[i+1];
        }

        Safefree(elems);

        XSRETURN(items);
