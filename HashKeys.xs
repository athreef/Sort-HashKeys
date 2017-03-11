#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdlib.h>
#include <string.h>
 
#include "ppport.h"
#include <stdio.h>

static int cmp_asc(const void *a, const void *b) {
    dTHX;
    return +sv_cmp(*(SV**)a, *(SV**)b);
}

static int cmp_desc(const void *a, const void *b) {
    dTHX;
    return -sv_cmp(*(SV**)a, *(SV**)b);
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
        SV **elems;
    CODE:
        if (!items) {
            XSRETURN_UNDEF;
        }
        if (items % 2 == 1) {
            ST(items) = &PL_sv_undef;
            items++;
        }

        /*PL_stack_base[ax + (off)]*/
        qsort(&PL_stack_base[ax], items / 2, 2*sizeof (void*), ix ? cmp_desc : cmp_asc);

        XSRETURN(items);
