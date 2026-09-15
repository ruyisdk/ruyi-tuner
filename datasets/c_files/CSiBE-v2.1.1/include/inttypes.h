#ifndef INTTYPES_H
#define INTTYPES_H

#ifndef __int8_t_defined
#define __int8_t_defined
typedef signed char int8_t;
typedef signed short int int16_t;
typedef int int32_t;
#endif

#ifndef __GLIBC_HAVE_LONG_LONG
typedef signed long long int64_t;
#endif

#ifndef _SYS_TYPES_H
typedef signed int intptr_t;
typedef unsigned int uintptr_t;
#endif

#ifndef _UINT8_T_DECLARED
typedef unsigned char uint8_t;
#define _UINT8_T_DECLARED
#endif

#ifndef _UINT16_T_DECLARED
typedef unsigned short int uint16_t;
#define _UINT16_T_DECLARED
#endif

#ifndef _UINT32_T_DECLARED
typedef unsigned long int uint32_t;
#define _UINT32_T_DECLARED
#endif

#ifndef _UINT64_T_DECLARED
typedef unsigned long long uint64_t;
#define _UINT64_T_DECLARED
#endif

#endif

