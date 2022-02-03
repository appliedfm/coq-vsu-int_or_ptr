#ifndef COQ_VSU_INT_OR_PTR__INT_OR_PTR_C
#define COQ_VSU_INT_OR_PTR__INT_OR_PTR_C

#include "../int_or_ptr.h"

int int_or_ptr__is_int (int_or_ptr x) {
    if ((uint_sizeofptr)0 == (uint_sizeofptr)(((int_sizeofptr)x)&1)) {
        return 0;
    }
    return 1;
}

int_sizeofptr int_or_ptr__to_int (int_or_ptr x) {
    return (int_sizeofptr)x;
}

void * int_or_ptr__to_ptr (int_or_ptr x) {
    return (void *)x;
}

int_or_ptr int_or_ptr__of_int(int_sizeofptr x) {
    return (int_or_ptr)x;
}

int_or_ptr int_or_ptr__of_ptr(void *x) {
    return (int_or_ptr)x;
}

#endif /* COQ_VSU_INT_OR_PTR__INT_OR_PTR_C */
