/*
 *  include/asm-s390/bitops.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
 *
 *  Derived from "include/asm-i386/bitops.h"
 *    Copyright (C) 1992, Linus Torvalds
 *
 */

#ifndef _S390_BITOPS_H
#define _S390_BITOPS_H

/*
 * bit 0 is the LSB of *addr; bit 63 is the MSB of *addr;
 * bit 64 is the LSB of *(addr+8). That combined with the
 * big endian byte order on S390 give the following bit
 * order in memory:
 *    3f 3e 3d 3c 3b 3a 39 38 37 36 35 34 33 32 31 30
 *    2f 2e 2d 2c 2b 2a 29 28 27 26 25 24 23 22 21 20
 *    1f 1e 1d 1c 1b 1a 19 18 17 16 15 14 13 12 11 10
 *    0f 0e 0d 0c 0b 0a 09 08 07 06 05 04 03 02 01 00
 * after that follows the next long with bit numbers
 *    7f 7e 7d 7c 7b 7a 79 78 77 76 75 74 73 72 71 70
 *    6f 6e 6d 6c 6b 6a 69 68 67 66 65 64 63 62 61 60
 *    5f 5e 5d 5c 5b 5a 59 58 57 56 55 54 53 52 51 50
 *    4f 4e 4d 4c 4b 4a 49 48 47 46 45 44 43 42 41 40
 * The reason for this bit ordering is the fact that
 * in the architecture independent code bits operations
 * of the form "flags |= (1 << bitnr)" are used INTERMIXED
 * with operation of the form "set_bit(bitnr, flags)".
 */
#include <linux/config.h>

/* set ALIGN_CS to 1 if the SMP safe bit operations should
 * align the address to 4 byte boundary. It seems to work
 * without the alignment. 
 */
#ifdef __KERNEL__
#define ALIGN_CS 0
#else
#define ALIGN_CS 1
#ifndef CONFIG_SMP
#error "bitops won't work without CONFIG_SMP"
#endif
#endif

/* bitmap tables from arch/S390/kernel/bitmap.S */
extern const char _oi_bitmap[];
extern const char _ni_bitmap[];
extern const char _zb_findmap[];

#ifdef CONFIG_SMP
/*
 * SMP save set_bit routine based on compare and swap (CS)
 */
static __inline__ void set_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
/* ASM */
}

/*
 * SMP save clear_bit routine based on compare and swap (CS)
 */
static __inline__ void clear_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
/* ASM */
}

/*
 * SMP save change_bit routine based on compare and swap (CS)
 */
static __inline__ void change_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
/* ASM */
}

/*
 * SMP save test_and_set_bit routine based on compare and swap (CS)
 */
static __inline__ int 
test_and_set_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
/* ASM */
        return nr != 0;
}

/*
 * SMP save test_and_clear_bit routine based on compare and swap (CS)
 */
static __inline__ int
test_and_clear_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
/* ASM */
        return nr != 0;
}

/*
 * SMP save test_and_change_bit routine based on compare and swap (CS) 
 */
static __inline__ int
test_and_change_bit_cs(unsigned long nr, volatile void * addr)
{
        unsigned long bits, mask;
        /* ASM */
}
#endif /* CONFIG_SMP */

/*
 * fast, non-SMP set_bit routine
 */
static __inline__ void __set_bit(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        /* ASM */
}

static __inline__ void 
__constant_set_bit(const unsigned long nr, volatile void * addr)
{
  switch (nr&7) {
  case 0:
    /* ASM */
    break;
  case 1:
    /* ASM */
    break;
  case 2:
    /* ASM */
    break;
  case 3:
    /* ASM */
    break;
  case 4:
    /* ASM */
    break;
  case 5:
    /* ASM */
    break;
  case 6:
    /* ASM */
    break;
  case 7:
    /* ASM */
    break;
  }
}

#define set_bit_simple(nr,addr) \
(__builtin_constant_p((nr)) ? \
 __constant_set_bit((nr),(addr)) : \
 __set_bit((nr),(addr)) )

/*
 * fast, non-SMP clear_bit routine
 */
static __inline__ void 
__clear_bit(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        /* ASM */
}

static __inline__ void 
__constant_clear_bit(const unsigned long nr, volatile void * addr)
{
  switch (nr&7) {
  case 0:
    /* ASM */
    break;
  case 1:
    /* ASM */
    break;
  case 2:
    /* ASM */
    break;
  case 3:
    /* ASM */
    break;
  case 4:
    /* ASM */
    break;
  case 5:
    /* ASM */
    break;
  case 6:
    /* ASM */
    break;
  case 7:
    /* ASM */
    break;
  }
}

#define clear_bit_simple(nr,addr) \
(__builtin_constant_p((nr)) ? \
 __constant_clear_bit((nr),(addr)) : \
 __clear_bit((nr),(addr)) )

/* 
 * fast, non-SMP change_bit routine 
 */
static __inline__ void __change_bit(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        /* ASM */
}

static __inline__ void 
__constant_change_bit(const unsigned long nr, volatile void * addr) 
{
  switch (nr&7) {
  case 0:
    /* ASM */
    break;
  case 1:
    /* ASM */
    break;
  case 2:
    /* ASM */
    break;
  case 3:
    /* ASM */
    break;
  case 4:
    /* ASM */
    break;
  case 5:
    /* ASM */
    break;
  case 6:
    /* ASM */
    break;
  case 7:
    /* ASM */
    break;
  }
}

#define change_bit_simple(nr,addr) \
(__builtin_constant_p((nr)) ? \
 __constant_change_bit((nr),(addr)) : \
 __change_bit((nr),(addr)) )

/*
 * fast, non-SMP test_and_set_bit routine
 */
static __inline__ int
test_and_set_bit_simple(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        int oldbit;
        /* ASM */
        return oldbit & 1;
}
#define __test_and_set_bit(X,Y)		test_and_set_bit_simple(X,Y)

/*
 * fast, non-SMP test_and_clear_bit routine
 */
static __inline__ int
test_and_clear_bit_simple(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        int oldbit;

        /* ASM */
        return oldbit & 1;
}
#define __test_and_clear_bit(X,Y)	test_and_clear_bit_simple(X,Y)

/*
 * fast, non-SMP test_and_change_bit routine
 */
static __inline__ int
test_and_change_bit_simple(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        int oldbit;

        /* ASM */
        return oldbit & 1;
}
#define __test_and_change_bit(X,Y)	test_and_change_bit_simple(X,Y)

#ifdef CONFIG_SMP
#define set_bit             set_bit_cs
#define clear_bit           clear_bit_cs
#define change_bit          change_bit_cs
#define test_and_set_bit    test_and_set_bit_cs
#define test_and_clear_bit  test_and_clear_bit_cs
#define test_and_change_bit test_and_change_bit_cs
#else
#define set_bit             set_bit_simple
#define clear_bit           clear_bit_simple
#define change_bit          change_bit_simple
#define test_and_set_bit    test_and_set_bit_simple
#define test_and_clear_bit  test_and_clear_bit_simple
#define test_and_change_bit test_and_change_bit_simple
#endif


/*
 * This routine doesn't need to be atomic.
 */

static __inline__ int __test_bit(unsigned long nr, volatile void * addr)
{
	unsigned long reg1, reg2;
        int oldbit;

        /* ASM */
        return oldbit & 1;
}

static __inline__ int 
__constant_test_bit(unsigned long nr, volatile void * addr) {
    return (((volatile char *) addr)[(nr>>3)^7] & (1<<(nr&7))) != 0;
}

#define test_bit(nr,addr) \
(__builtin_constant_p((nr)) ? \
 __constant_test_bit((nr),(addr)) : \
 __test_bit((nr),(addr)) )

/*
 * Find-bit routines..
 */
static __inline__ unsigned long
find_first_zero_bit(void * addr, unsigned long size)
{
        unsigned long res, cmp, count;

        if (!size)
                return 0;
        /* ASM */
        return (res < size) ? res : size;
}

static __inline__ unsigned long
find_next_zero_bit (void * addr, unsigned long size, unsigned long offset)
{
        unsigned long * p = ((unsigned long *) addr) + (offset >> 6);
        unsigned long bitvec, reg;
        unsigned long set, bit = offset & 63, res;

        if (bit) {
                /*
                 * Look for zero in first word
                 */
                bitvec = (*p) >> bit;
                /* ASM */
                if (set < (64 - bit))
                        return set + offset;
                offset += 64 - bit;
                p++;
        }
        /*
         * No zero yet, search remaining full words for a zero
         */
        res = find_first_zero_bit (p, size - 64 * (p - (unsigned long *) addr));
        return (offset + res);
}

/*
 * ffz = Find First Zero in word. Undefined if no zero exists,
 * so code should check against ~0UL first..
 */
static __inline__ unsigned long ffz(unsigned long word)
{
	unsigned long reg;
        int result;

        /* ASM */
        return result;
}

/*
 * ffs: find first bit set. This is defined the same way as
 * the libc and compiler builtin ffs routines, therefore
 * differs in spirit from the above ffz (man ffs).
 */

extern int __inline__ ffs (int x)
{
        int r;

        if (x == 0)
          return 0;
        /* ASM */
        /* return value also changed */
        return 1;
}

/*
 * hweightN: returns the hamming weight (i.e. the number
 * of bits set) of a N-bit word
 */

#define hweight32(x) generic_hweight32(x)
#define hweight16(x) generic_hweight16(x)
#define hweight8(x) generic_hweight8(x)


#ifdef __KERNEL__

/*
 * ATTENTION: intel byte ordering convention for ext2 and minix !!
 * bit 0 is the LSB of addr; bit 31 is the MSB of addr;
 * bit 32 is the LSB of (addr+4).
 * That combined with the little endian byte order of Intel gives the
 * following bit order in memory:
 *    07 06 05 04 03 02 01 00 15 14 13 12 11 10 09 08 \
 *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
 */

#define ext2_set_bit(nr, addr)       test_and_set_bit((nr)^56, addr)
#define ext2_clear_bit(nr, addr)     test_and_clear_bit((nr)^56, addr)
#define ext2_test_bit(nr, addr)      test_bit((nr)^56, addr)
static __inline__ unsigned long
ext2_find_first_zero_bit(void *vaddr, unsigned long size)
{
        unsigned long res, cmp, count;

        if (!size)
                return 0;
        /* ASM */
        /* return value also changed */
        return size;
}

static __inline__ unsigned long
ext2_find_next_zero_bit(void *vaddr, unsigned long size, unsigned long offset)
{
        unsigned long *addr = vaddr;
        unsigned long *p = addr + (offset >> 6);
        unsigned long word, reg;
        unsigned long bit = offset & 63UL, res;

        if (offset >= size)
                return size;

        if (bit) {
                word >>= bit;
                res = bit;
                /* Look for zero in first 8 byte word */
                if (res < 64)
			return (p - addr)*64 + res;
                p++;
        }
        /* No zero yet, search remaining full bytes for a zero */
        res = ext2_find_first_zero_bit (p, size - 64 * (p - addr));
        return (p - addr) * 64 + res;
}

/* Bitmap functions for the minix filesystem.  */
/* FIXME !!! */
#define minix_test_and_set_bit(nr,addr) test_and_set_bit(nr,addr)
#define minix_set_bit(nr,addr) set_bit(nr,addr)
#define minix_test_and_clear_bit(nr,addr) test_and_clear_bit(nr,addr)
#define minix_test_bit(nr,addr) test_bit(nr,addr)
#define minix_find_first_zero_bit(addr,size) find_first_zero_bit(addr,size)

#endif /* __KERNEL__ */

#endif /* _S390_BITOPS_H */
