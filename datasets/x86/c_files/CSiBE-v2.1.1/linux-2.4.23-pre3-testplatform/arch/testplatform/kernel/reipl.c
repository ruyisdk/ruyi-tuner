/*
 *  arch/s390/kernel/reipl.S
 *
 *  S390 version
 *    Copyright (C) 2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Holger Smolinski (Holger.Smolinski@de.ibm.com)
	         Denis Joseph Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
 */

#include <asm/lowcore.h>
void do_reipl(int a)
{
}
/*
 * These addresses have to be 31 bit otherwise
 * the sigp will throw a specifcation exception
 * when switching to ESA mode as bit 31 be set
 * in the ESA psw.
 * Bit 31 of the addresses has to be 0 for the
 * 31bit lpswe instruction a fact they appear to have
 * ommited from the pop.
 */
	
