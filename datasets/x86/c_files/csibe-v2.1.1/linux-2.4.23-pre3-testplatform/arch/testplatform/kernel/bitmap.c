/*
 *  arch/s390/kernel/bitmap.S
 *    Bitmaps for set_bit, clear_bit, test_and_set_bit, ...
 *    See include/asm-s390/{bitops.h|posix_types.h} for details
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 */

const char _oi_bitmap[] = {0};
const char _ni_bitmap[] = {0};
const char _zb_findmap[] = {0};
