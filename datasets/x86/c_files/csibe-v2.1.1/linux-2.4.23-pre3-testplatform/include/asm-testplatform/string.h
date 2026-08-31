/*
 *  include/asm-s390/string.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 */

#ifndef _S390_STRING_H_
#define _S390_STRING_H_

#ifdef __KERNEL__

#ifndef _LINUX_TYPES_H
#include <linux/types.h>
#endif

#define __HAVE_ARCH_MEMCHR
#define __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_STRCAT
#define __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRLEN
#define __HAVE_ARCH_STRNCPY

#undef __HAVE_ARCH_MEMMOVE
#undef __HAVE_ARCH_STRNICMP
#undef __HAVE_ARCH_STRNCAT
#undef __HAVE_ARCH_STRNCMP
#undef __HAVE_ARCH_STRCHR
#undef __HAVE_ARCH_STRRCHR
#undef __HAVE_ARCH_STRNLEN
#undef __HAVE_ARCH_STRSPN
#undef __HAVE_ARCH_STRPBRK
#undef __HAVE_ARCH_STRTOK
#undef __HAVE_ARCH_BCOPY
#undef __HAVE_ARCH_MEMCMP
#undef __HAVE_ARCH_MEMSCAN
#undef __HAVE_ARCH_STRSTR

extern void *memset(void *, int, size_t);
extern void *memcpy(void *, const void *, size_t);
/*extern void *memmove(void *, const void *, size_t);*/
extern char *strncpy(char *, const char *, size_t);
extern int strcmp(const char *,const char *);

static inline void * memchr(const void * cs,int c,size_t count)
{
    void *ptr;

    /* ASM */
    return ptr;
}

static __inline__ char *strcpy(char *dest, const char *src)
{
    char *tmp = dest;

    /* ASM */
    return tmp;
}

static __inline__ size_t strlen(const char *s)
{
    size_t len;

    /* ASM */
    return len;
}

static __inline__ char *strcat(char *dest, const char *src)
{
    char *tmp = dest;

    /* ASM */
    return tmp;
}

extern void *alloca(size_t);
#endif /* __KERNEL__ */

#endif /* __S390_STRING_H_ */

