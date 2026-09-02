/*
 *  arch/s390/kernel/cpcmd.c
 *
 *  S390 version
 *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 */

#include <linux/string.h>
#include <linux/spinlock.h>
#include <asm/cpcmd.h>
#include <asm/ebcdic.h>
#include <asm/system.h>

static spinlock_t cpcmd_lock = SPIN_LOCK_UNLOCKED;
static char cpcmd_buf[128];

void cpcmd(char *cmd, char *response, int rlen)
{
        const int mask = 0x40000000L;
	unsigned long flags;
        int cmdlen;

	spin_lock_irqsave(&cpcmd_lock, flags);
        cmdlen = strlen(cmd);
        strcpy(cpcmd_buf, cmd);
        ASCEBC(cpcmd_buf, cmdlen);

        if (response != NULL && rlen > 0) {
          /* ASM */
        } else {
          /* ASM */
        }
	spin_unlock_irqrestore(&cpcmd_lock, flags);
}

