#ifndef COQ_VSU_INT_OR_PTR__INT_OR_PTR_H
#define COQ_VSU_INT_OR_PTR__INT_OR_PTR_H

typedef void* int_or_ptr __attribute((aligned(_Alignof(void *))));

#if SIZEOF_PTR == SIZEOF_LONG
  typedef long int_sizeofptr;
  typedef unsigned long uint_sizeofptr;
  #define ARCH_INTNAT_PRINTF_FORMAT "l"
#elif SIZEOF_PTR == SIZEOF_INT
  typedef int int_sizeofptr;
  typedef unsigned int uint_sizeofptr;
  #define ARCH_INTNAT_PRINTF_FORMAT ""
#else
  #error "No integer type available to represent pointers"
#endif

/* returns 1 if int, 0 if aligned ptr */
int int_or_ptr__is_int(int_or_ptr x);

/* precondition: is int */
int_sizeofptr int_or_ptr__to_int(int_or_ptr x);

/* precond: is aligned ptr */
void * int_or_ptr__to_ptr(int_or_ptr x);

/* precondition: is odd */
int_or_ptr int_or_ptr__of_int(int_sizeofptr x);

/* precondition: is aligned */
int_or_ptr int_or_ptr__of_ptr(void *x);

#endif /* COQ_VSU_INT_OR_PTR__INT_OR_PTR_H */
