/*
 *  arch/s390/kernel/time.c
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Hartmut Penner (hp@de.ibm.com),
 *               Martin Schwidefsky (schwidefsky@de.ibm.com),
 *               Denis Joseph Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
 *
 *  Derived from "arch/i386/kernel/time.c"
 *    Copyright (C) 1991, 1992, 1995  Linus Torvalds
 */

#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/param.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/interrupt.h>
#include <linux/time.h>
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/smp.h>
#include <linux/types.h>

#include <asm/uaccess.h>
#include <asm/delay.h>

#include <linux/timex.h>
#include <linux/config.h>

#include <asm/irq.h>
#include <asm/s390_ext.h>

/* change this if you have some constant time drift */
#define USECS_PER_JIFFY     ((unsigned long) 1000000/HZ)
#define CLK_TICKS_PER_JIFFY ((unsigned long) USECS_PER_JIFFY << 12)

#define TICK_SIZE tick

static ext_int_info_t ext_int_info_timer;
static uint64_t init_timer_cc;

extern rwlock_t xtime_lock;
extern unsigned long wall_jiffies;

void tod_to_timeval(__u64 todval, struct timeval *xtime)
{
}

static inline unsigned long do_gettimeoffset(void) 
{
	return (unsigned long) 1;
}

/*
 * This version of gettimeofday has microsecond resolution.
 */
void do_gettimeofday(struct timeval *tv)
{
}

void do_settimeofday(struct timeval *tv)
{
}

/*
 * timer_interrupt() needs to keep up the real-time clock,
 * as well as call the "do_timer()" routine every clocktick
 */

#ifdef CONFIG_SMP
extern __u16 boot_cpu_addr;
#endif

static void do_comparator_interrupt(struct pt_regs *regs, __u16 error_code)
{
}

/*
 * Start the clock comparator on the current CPU
 */
void init_cpu_timer(void)
{
}

/*
 * Initialize the TOD clock and the CPU timer of
 * the boot cpu.
 */
void __init time_init(void)
{
}
