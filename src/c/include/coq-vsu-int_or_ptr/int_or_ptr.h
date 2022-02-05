#ifndef COQ_VSU_INT_OR_PTR__INT_OR_PTR_H
#define COQ_VSU_INT_OR_PTR__INT_OR_PTR_H

#include <stdint.h>
#include <stddef.h>

typedef void* int_or_ptr __attribute((aligned(_Alignof(void *))));

size_t int_or_ptr__sizeof();

size_t int_or_ptr__alignof();

/* returns 1 if int, 0 if aligned ptr */
int int_or_ptr__is_int(int_or_ptr x);

/* precondition: is int */
intptr_t int_or_ptr__to_int(int_or_ptr x);

/* precond: is aligned ptr */
void * int_or_ptr__to_ptr(int_or_ptr x);

/* precondition: is odd */
int_or_ptr int_or_ptr__of_int(intptr_t x);

/* precondition: is aligned */
int_or_ptr int_or_ptr__of_ptr(void *x);

#endif /* COQ_VSU_INT_OR_PTR__INT_OR_PTR_H */
