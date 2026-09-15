/*
 *  include/asm-s390/system.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 *
 *  Derived from "include/asm-i386/system.h"
 */

#ifndef __ASM_SYSTEM_H
#define __ASM_SYSTEM_H

#include <linux/config.h>
#include <asm/types.h>
#ifdef __KERNEL__
#include <asm/lowcore.h>
#endif
#include <linux/kernel.h>

#define prepare_to_switch()	do { } while(0)
#define switch_to(prev,next,last) do {                                       \
        if (prev == next)                                                    \
                break;                                                       \
	save_fp_regs(&prev->thread.fp_regs);                                 \
	restore_fp_regs(&next->thread.fp_regs);              		     \
	last = resume(prev,next);					     \
} while (0)

struct task_struct;

/* ASM */
#define nop() {}

#define xchg(ptr,x) \
  ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(void *)(ptr),sizeof(*(ptr))))

extern void __misaligned_u16(void);
extern void __misaligned_u32(void);
extern void __misaligned_u64(void);

static inline unsigned long __xchg(unsigned long x, void * ptr, int size)
{
  /* ASM */
        return x;
}

/*
 * Force strict CPU ordering.
 * And yes, this is required on UP too when we're talking
 * to devices.
 *
 * This is very similar to the ppc eieio/sync instruction in that is
 * does a checkpoint syncronisation & makes sure that 
 * all memory ops have completed wrt other CPU's ( see 7-15 POP  DJB ).
 */

/* ASM */
#define eieio()  {}
# define SYNC_OTHER_CORES(x)   eieio() 
#define mb()    eieio()
#define rmb()   eieio()
#define wmb()   eieio()
#define smp_mb()       mb()
#define smp_rmb()      rmb()
#define smp_wmb()      wmb()
#define smp_mb__before_clear_bit()     smp_mb()
#define smp_mb__after_clear_bit()      smp_mb()

#define set_mb(var, value)      do { var = value; mb(); } while (0)
#define set_wmb(var, value)     do { var = value; wmb(); } while (0)

/* interrupt control.. */
/* ASM */
#define __sti() ({ \
        unsigned long dummy; \
        })

/* ASM */
#define __cli() ({ \
        unsigned long flags; \
        flags; \
        })

/* ASM */
#define __save_flags(x) {}

/* ASM */
#define __restore_flags(x) {}

/* ASM */
#define __load_psw(psw) {}

/* ASM */
#define __ctl_load(array, low, high) ({ \
	})

/* ASM */
#define __ctl_store(array, low, high) ({ \
	})

/* ASM */
#define __ctl_set_bit(cr, bit) ({ \
        __u8 dummy[24]; \
        })

/* ASM */
#define __ctl_clear_bit(cr, bit) ({ \
        __u8 dummy[24]; \
        })


#define __save_and_cli(x)       do { __save_flags(x); __cli(); } while(0);
#define __save_and_sti(x)       do { __save_flags(x); __sti(); } while(0);

/* For spinlocks etc */
#define local_irq_save(x)	((x) = __cli())
#define local_irq_set(x)	__save_and_sti(x)
#define local_irq_restore(x)	__restore_flags(x)
#define local_irq_disable()	__cli()
#define local_irq_enable()	__sti()

#ifdef CONFIG_SMP

extern void __global_cli(void);
extern void __global_sti(void);

extern unsigned long __global_save_flags(void);
extern void __global_restore_flags(unsigned long);
#define cli() __global_cli()
#define sti() __global_sti()
#define save_flags(x) ((x)=__global_save_flags())
#define restore_flags(x) __global_restore_flags(x)
#define save_and_cli(x) do { save_flags(x); cli(); } while(0);
#define save_and_sti(x) do { save_flags(x); sti(); } while(0);

extern void smp_ctl_set_bit(int cr, int bit);
extern void smp_ctl_clear_bit(int cr, int bit);
#define ctl_set_bit(cr, bit) smp_ctl_set_bit(cr, bit)
#define ctl_clear_bit(cr, bit) smp_ctl_clear_bit(cr, bit)

#else

#define cli() __cli()
#define sti() __sti()
#define save_flags(x) __save_flags(x)
#define restore_flags(x) __restore_flags(x)
#define save_and_cli(x) __save_and_cli(x)
#define save_and_sti(x) __save_and_sti(x)

#define ctl_set_bit(cr, bit) __ctl_set_bit(cr, bit)
#define ctl_clear_bit(cr, bit) __ctl_clear_bit(cr, bit)


#endif

#ifdef __KERNEL__
extern struct task_struct *resume(void *, void *);

extern int save_fp_regs1(s390_fp_regs *fpregs);
extern void save_fp_regs(s390_fp_regs *fpregs);
extern int restore_fp_regs1(s390_fp_regs *fpregs);
extern void restore_fp_regs(s390_fp_regs *fpregs);

extern void (*_machine_restart)(char *command);
extern void (*_machine_halt)(void);
extern void (*_machine_power_off)(void);

#endif

#endif



