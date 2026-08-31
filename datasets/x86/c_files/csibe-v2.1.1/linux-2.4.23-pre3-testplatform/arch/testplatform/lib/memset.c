/*
 *  arch/s390/lib/memset.S
 *    S390 fast memset routine
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 */

/*
 * R2 = address to memory area
 * R3 = byte to fill memory with
 * R4 = number of bytes to fill
 */
void *memset(void *s, int c, int n)
{
  return (void *)0;
}
