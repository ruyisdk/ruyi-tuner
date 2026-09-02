/*
 *  arch/s390/kernel/s390fpu.c
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Denis Joseph Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
 *
 *  s390fpu.h functions for saving & restoring the fpu state.
 *
 *  I couldn't inline these as linux/sched.h included half the world
 *  & was required to at the task structure.
 *  & the functions were too complex to make macros from.
 *  ( & as usual I didn't feel like debugging inline code ).
 */

#include <linux/sched.h>

void save_fp_regs(s390_fp_regs *fpregs)
{
/*
 * I don't think we can use STE here as this would load
 * fp registers 0 & 2 into memory locations 0 & 1 etc. 
 */	
  /* ASM */
}

void restore_fp_regs(s390_fp_regs *fpregs)
{
	/* If we don't mask with the FPC_VALID_MASK here
	 * we've got a very quick shutdown -h now command
         * via a kernel specification exception.
	 */
	fpregs->fpc&=FPC_VALID_MASK;
        /* ASM */
}












