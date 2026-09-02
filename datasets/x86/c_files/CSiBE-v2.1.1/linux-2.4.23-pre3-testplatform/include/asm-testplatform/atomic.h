#ifndef __ARCH_S390_ATOMIC__
#define __ARCH_S390_ATOMIC__

/*
 *  include/asm-s390x/atomic.h
 *
 *  S390 version
 *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 *               Denis Joseph Barrow
 *
 *  Derived from "include/asm-i386/bitops.h"
 *    Copyright (C) 1992, Linus Torvalds
 *
 */

/*
 * Atomic operations that C can't guarantee us.  Useful for
 * resource counting etc..
 * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
 */

typedef struct { volatile int counter; } __attribute__ ((aligned (4))) atomic_t;
#define ATOMIC_INIT(i)  { (i) }

#define atomic_eieio()          {/* ASM */}

#define __CS_LOOP(old_val, new_val, ptr, op_val, op_string) {/* ASM */}

#define atomic_read(v)          ((v)->counter)
#define atomic_set(v,i)         (((v)->counter) = (i))

static __inline__ void atomic_add(int i, atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, i, "ar");
}

static __inline__ int atomic_add_return (int i, atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, i, "ar");
	return new_val;
}

static __inline__ int atomic_add_negative(int i, atomic_t *v)
{
	int old_val, new_val;
        __CS_LOOP(old_val, new_val, v, i, "ar");
        return new_val < 0;
}

static __inline__ void atomic_sub(int i, atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, i, "sr");
}

static __inline__ void atomic_inc(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "ar");
}

static __inline__ int atomic_inc_return(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "ar");
        return new_val;
}

static __inline__ int atomic_inc_and_test(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "ar");
	return new_val != 0;
}

static __inline__ void atomic_dec(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "sr");
}

static __inline__ int atomic_dec_return(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "sr");
	return new_val;
}

static __inline__ int atomic_dec_and_test(volatile atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, 1, "sr");
        return new_val == 0;
}

static __inline__ void atomic_clear_mask(unsigned long mask, atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, ~mask, "nr");
}

static __inline__ void atomic_set_mask(unsigned long mask, atomic_t *v)
{
	int old_val, new_val;
	__CS_LOOP(old_val, new_val, v, mask, "or");
}

/*
  returns 0  if expected_oldval==value in *v ( swap was successful )
  returns 1  if unsuccessful.
*/
static __inline__ int
atomic_compare_and_swap(int expected_oldval,int new_val,atomic_t *v)
{
        int retval;
/* ASM */
        return retval;
}

/*
  Spin till *v = expected_oldval then swap with newval.
 */
static __inline__ void
atomic_compare_and_swap_spin(int expected_oldval,int new_val,atomic_t *v)
{
/* ASM */
}

#define atomic_compare_and_swap_debug(where,from,to) \
if (atomic_compare_and_swap ((from), (to), (where))) {\
	printk (KERN_WARNING"%s/%d atomic counter:%s couldn't be changed from %d(%s) to %d(%s), was %d\n",\
		"__FILE_",__LINE__,#where,(from),#from,(to),#to,atomic_read (where));\
        atomic_set(where,(to));\
}

#define smp_mb__before_atomic_dec()	smp_mb()
#define smp_mb__after_atomic_dec()	smp_mb()
#define smp_mb__before_atomic_inc()	smp_mb()
#define smp_mb__after_atomic_inc()	smp_mb()

#endif                                 /* __ARCH_S390_ATOMIC __            */
