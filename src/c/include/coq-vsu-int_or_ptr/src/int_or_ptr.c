#ifndef COQ_VSU_INT_OR_PTR__INT_OR_PTR_C
#define COQ_VSU_INT_OR_PTR__INT_OR_PTR_C

#include "../int_or_ptr.h"

size_t int_or_ptr__sizeof() {
    return sizeof(int_or_ptr);
}

size_t int_or_ptr__alignof() {
    return _Alignof(int_or_ptr);
}

int int_or_ptr__is_int(int_or_ptr x)
{
    const intptr_t zero = 0;
    const intptr_t one = 1;
    if (zero == ((intptr_t)x & one))
    {
        return 0;
    }
    return 1;
}

intptr_t int_or_ptr__to_int(int_or_ptr x)
{
    return (intptr_t)x;
}

void * int_or_ptr__to_ptr(int_or_ptr x)
{
    return (void *)x;
}

int_or_ptr int_or_ptr__of_int(intptr_t x)
{
    return (int_or_ptr)x;
}

int_or_ptr int_or_ptr__of_ptr(void *x)
{
    return (int_or_ptr)x;
}

#endif /* COQ_VSU_INT_OR_PTR__INT_OR_PTR_C */
