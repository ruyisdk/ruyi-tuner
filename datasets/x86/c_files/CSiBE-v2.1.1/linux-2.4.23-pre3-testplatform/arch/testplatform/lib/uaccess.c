/*
 *  arch/s390x/lib/uaccess.S
 *    __copy_{from|to}_user functions.
 *
 *  s390
 *    Copyright (C) 2000,2002 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Authors(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
 *
 *  These functions have standard call interface
 */

#include <asm/lowcore.h>

long __copy_from_user_asm(void *to, long n, const void *from)
{
  return 0;
}


long __copy_to_user_asm(void *to, long n, const void *from)
{
  return 0;
}

long __clear_user_asm(void *to, long n)
{
  return 0;
}
