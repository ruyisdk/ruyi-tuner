/*
 *  arch/s390/kernel/strncpy.S
 *    S390 strncpy routine
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 */

/*
 * R2 = address of destination
 * R3 = address of source string
 * R4 = max number of bytes to copy
 */
char *strncpy(char *dest, const char *src, int n)
{
  return (char *)0;
}
