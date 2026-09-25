#ifndef _S390_BYTEORDER_H
#define _S390_BYTEORDER_H

/*
 *  include/asm-s390/byteorder.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
 */

#include <asm/types.h>

#ifdef __GNUC__

static __inline__ __const__ __u64 ___arch__swab64(__u64 x)
{
  __u64 result;

  /* ASM */
  return result;
}

static __inline__ __const__ __u64 ___arch__swab64p(__u64 *x)
{
  __u64 result;

  /* ASM */
  return result;
}

static __inline__ void ___arch__swab64s(__u64 *x)
{
  /* ASM */
}

static __inline__ __const__ __u32 ___arch__swab32(__u32 x)
{
  __u32 result;

  /* ASM */
  return result;
}

static __inline__ __const__ __u32 ___arch__swab32p(__u32 *x)
{
  __u32 result;

  /* ASM */
  return result;
}

static __inline__ void ___arch__swab32s(__u32 *x)
{
  /* ASM */
}

static __inline__ __const__ __u16 ___arch__swab16(__u16 x)
{
  __u16 result;

  /* ASM */
  return result;
}

static __inline__ __const__ __u16 ___arch__swab16p(__u16 *x)
{
  __u16 result;

  /* ASM */
  return result;
}

static __inline__ void ___arch__swab16s(__u16 *x)
{
  /* ASM */
}

#define __arch__swab64(x) ___arch__swab64(x)
#define __arch__swab32(x) ___arch__swab32(x)
#define __arch__swab16(x) ___arch__swab16(x)
#define __arch__swab64p(x) ___arch__swab64p(x)
#define __arch__swab32p(x) ___arch__swab32p(x)
#define __arch__swab16p(x) ___arch__swab16p(x)
#define __arch__swab64s(x) ___arch__swab64s(x)
#define __arch__swab32s(x) ___arch__swab32s(x)
#define __arch__swab16s(x) ___arch__swab16s(x)

#define __BYTEORDER_HAS_U64__

#endif /* __GNUC__ */

#include <linux/byteorder/big_endian.h>

#endif /* _S390_BYTEORDER_H */
