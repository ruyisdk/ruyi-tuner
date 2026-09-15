/*
 *  include/asm-s390/spinlock.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
 *
 *  Derived from "include/asm-i386/spinlock.h"
 */

#ifndef __ASM_SPINLOCK_H
#define __ASM_SPINLOCK_H

/*
 * Grmph, take care of %&#! user space programs that include
 * asm/spinlock.h. The diagnose is only available in kernel
 * context.
 */
#ifdef __KERNEL__
#include <asm/lowcore.h>
#define __DIAG44_INSN "ex"
#define __DIAG44_OPERAND __LC_DIAG44_OPCODE
#else
#define __DIAG44_INSN "#"
#define __DIAG44_OPERAND 0
#endif

/*
 * Simple spin lock operations.  There are two variants, one clears IRQ's
 * on the local processor, one does not.
 *
 * We make no fairness assumptions. They have a cost.
 */

typedef struct {
	volatile unsigned int lock;
} __attribute__ ((aligned (4))) spinlock_t;

#define SPIN_LOCK_UNLOCKED (spinlock_t) { 0 }
#define spin_lock_init(lp) do { (lp)->lock = 0; } while(0)
#define spin_unlock_wait(lp)	do { barrier(); } while(((volatile spinlock_t *)(lp))->lock)
#define spin_is_locked(x) ((x)->lock != 0)

extern inline void spin_lock(spinlock_t *lp)
{
	unsigned long reg1, reg2;
        /* ASM */
}

extern inline int spin_trylock(spinlock_t *lp)
{
	unsigned int result, reg;
        /* ASM */
	return !result;
}

extern inline void spin_unlock(spinlock_t *lp)
{
  /* ASM */
}
		
/*
 * Read-write spinlocks, allowing multiple readers
 * but only one writer.
 *
 * NOTE! it is quite common to have readers in interrupts
 * but no interrupt writers. For those circumstances we
 * can "mix" irq-safe locks - any writer needs to get a
 * irq-safe write-lock, but readers can get non-irqsafe
 * read-locks.
 */
typedef struct {
	volatile unsigned long lock;
	volatile unsigned long owner_pc;
} rwlock_t;

#define RW_LOCK_UNLOCKED (rwlock_t) { 0, 0 }

#define rwlock_init(x)	do { *(x) = RW_LOCK_UNLOCKED; } while(0)

/* ASM */
#define read_lock(rw)

/* ASM */
#define read_unlock(rw)

/* ASM */
#define write_lock(rw)

/* ASM */
#define write_unlock(rw)

#endif /* __ASM_SPINLOCK_H */

