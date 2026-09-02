/*
 *  arch/s390/kernel/entry.S
 *    S390 low-level entry points.
 *
 *  S390 version
 *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
 *               Hartmut Penner (hp@de.ibm.com),
 *               Denis Joseph Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com),
 */

#include <linux/sys.h>
#include <linux/linkage.h>
#include <linux/config.h>
#include <asm/cache.h>
#include <asm/lowcore.h>
#include <asm/errno.h>
#include <asm/smp.h>
#include <asm/ptrace.h>

#include "asm-offsets.h"

/*
 * Stack layout for the system_call stack entry.
 * The first few entries are identical to the user_regs_struct.
 */
#if 0

SP_PTREGS    =  STACK_FRAME_OVERHEAD 
SP_PSW       =  STACK_FRAME_OVERHEAD + PT_PSWMASK
SP_R0        =  STACK_FRAME_OVERHEAD + PT_GPR0
SP_R1        =  STACK_FRAME_OVERHEAD + PT_GPR1
SP_R2        =  STACK_FRAME_OVERHEAD + PT_GPR2
SP_R3        =  STACK_FRAME_OVERHEAD + PT_GPR3
SP_R4        =  STACK_FRAME_OVERHEAD + PT_GPR4
SP_R5        =  STACK_FRAME_OVERHEAD + PT_GPR5
SP_R6        =  STACK_FRAME_OVERHEAD + PT_GPR6
SP_R7        =  STACK_FRAME_OVERHEAD + PT_GPR7
SP_R8        =  STACK_FRAME_OVERHEAD + PT_GPR8
SP_R9        =  STACK_FRAME_OVERHEAD + PT_GPR9
SP_R10       =  STACK_FRAME_OVERHEAD + PT_GPR10
SP_R11       =  STACK_FRAME_OVERHEAD + PT_GPR11
SP_R12       =  STACK_FRAME_OVERHEAD + PT_GPR12
SP_R13       =  STACK_FRAME_OVERHEAD + PT_GPR13
SP_R14       =  STACK_FRAME_OVERHEAD + PT_GPR14
SP_R15       =  STACK_FRAME_OVERHEAD + PT_GPR15
SP_AREGS     =  STACK_FRAME_OVERHEAD + PT_ACR0
SP_ORIG_R2   =  STACK_FRAME_OVERHEAD + PT_ORIGGPR2
/* Now the additional entries */
SP_TRAP      =  (SP_ORIG_R2+GPR_SIZE)
SP_SIZE      =  (SP_TRAP+4)

#endif

/*
 * Register usage in interrupt handlers:
 *    R9  - pointer to current task structure
 *    R13 - pointer to literal pool
 *    R14 - return register for function calls
 *    R15 - kernel stack pointer
 */

  /* ASM */

/*
 * Scheduler resume function, called by switch_to
 *  gpr2 = (task_struct *) prev
 *  gpr3 = (task_struct *) next
 * Returns:
 *  gpr2 = prev
 */

struct task_struct *resume(void *a, void *b)
{
  return (struct task_struct *) 0;
}
//resume_noper:

/*
 * do_softirq calling function. We want to run the softirq functions on the
 * asynchronous interrupt stack.
 */
void do_call_softirq(void)
{
}

/*
 * SVC interrupt handler routine. System calls are synchronous events and
 * are executed with interrupts enabled.
 */

void system_call(void)
{
}

//sysc_noemu:

//sysc_return:
//sysc_leave:

//sysc_signal_return:     

//sysc_reschedule:        
//sysc_tracesys:

//trace_svc:
//trace_svc_noemu:
//trace_svc_go:	

//ret_from_fork:  

//sys_clone_glue: 

//sys_fork_glue:  

//sys_vfork_glue: 

//sys_execve_glue:        
#ifdef CONFIG_S390_SUPPORT
//sys32_execve_glue:        
#endif

//sys_sigreturn_glue:     

#ifdef CONFIG_S390_SUPPORT
//sys32_sigreturn_glue:     
#endif

//sys_rt_sigreturn_glue:     

#ifdef CONFIG_S390_SUPPORT
//sys32_rt_sigreturn_glue:     
#endif


//sys_sigsuspend_glue:    

#ifdef CONFIG_S390_SUPPORT
//sys32_sigsuspend_glue:    
#endif

//sys_rt_sigsuspend_glue: 

#ifdef CONFIG_S390_SUPPORT
//sys32_rt_sigsuspend_glue: 
#endif

//sys_sigaltstack_glue:

#ifdef CONFIG_S390_SUPPORT
//sys32_sigaltstack_glue:
#endif

#ifdef CONFIG_S390_SUPPORT
#define SYSCALL(esame,esa) esame,esa
#else
#define SYSCALL(esame,esa) esame,sys_ni_syscall
#endif

#if 0
	.globl  sys_call_table	
sys_call_table:
        .long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 0 */
        .long  SYSCALL(sys_exit,sys32_exit_wrapper)
        .long  SYSCALL(sys_fork_glue,sys_fork_glue)
        .long  SYSCALL(sys_read,sys32_read_wrapper)
        .long  SYSCALL(sys_write,sys32_write_wrapper)
        .long  SYSCALL(sys_open,sys32_open_wrapper)             /* 5 */
        .long  SYSCALL(sys_close,sys32_close_wrapper)
        .long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* old waitpid syscall */
        .long  SYSCALL(sys_creat,sys32_creat_wrapper)
        .long  SYSCALL(sys_link,sys32_link_wrapper)
        .long  SYSCALL(sys_unlink,sys32_unlink_wrapper)         /* 10 */
        .long  SYSCALL(sys_execve_glue,sys32_execve_glue)
        .long  SYSCALL(sys_chdir,sys32_chdir_wrapper)
        .long  SYSCALL(sys_ni_syscall,sys32_time_wrapper) /* old time syscall */
        .long  SYSCALL(sys_mknod,sys32_mknod_wrapper)
        .long  SYSCALL(sys_chmod,sys32_chmod_wrapper)           /* 15 */
        .long  SYSCALL(sys_ni_syscall,sys32_stat64_wrapper)     /* 195 */
        .long  SYSCALL(sys_ni_syscall,sys32_lstat64_wrapper)   
        .long  SYSCALL(sys_ni_syscall,sys32_fstat64_wrapper)    
	.long  SYSCALL(sys_lchown,sys32_lchown_wrapper)
	.long  SYSCALL(sys_getuid,sys_getuid)
	.long  SYSCALL(sys_getgid,sys_getgid)         /* 200 */
	.long  SYSCALL(sys_geteuid,sys_geteuid)
	.long  SYSCALL(sys_getegid,sys_getegid)
	.long  SYSCALL(sys_setreuid,sys32_setreuid_wrapper)
	.long  SYSCALL(sys_setregid,sys32_setregid_wrapper)
	.long  SYSCALL(sys_getgroups,sys32_getgroups_wrapper)  /* 205 */
	.long  SYSCALL(sys_setgroups,sys32_setgroups_wrapper)
	.long  SYSCALL(sys_fchown,sys32_fchown_wrapper)
	.long  SYSCALL(sys_setresuid,sys32_setresuid_wrapper)
	.long  SYSCALL(sys_getresuid,sys32_getresuid_wrapper)
	.long  SYSCALL(sys_setresgid,sys32_setresgid_wrapper)  /* 210 */
	.long  SYSCALL(sys_getresgid,sys32_getresgid_wrapper)
	.long  SYSCALL(sys_chown,sys32_chown_wrapper)
	.long  SYSCALL(sys_setuid,sys32_setuid_wrapper)
	.long  SYSCALL(sys_setgid,sys32_setgid_wrapper)
	.long  SYSCALL(sys_setfsuid,sys32_setfsuid_wrapper)   /* 215 */
	.long  SYSCALL(sys_setfsgid,sys32_setfsgid_wrapper)
        .long  SYSCALL(sys_pivot_root,sys32_pivot_root_wrapper)
        .long  SYSCALL(sys_mincore,sys32_mincore_wrapper)
        .long  SYSCALL(sys_madvise,sys32_madvise_wrapper)
	.long  SYSCALL(sys_getdents64,sys32_getdents64_wrapper)/* 220 */
	.long  SYSCALL(sys_ni_syscall,sys32_fcntl64_wrapper)
	.long  SYSCALL(sys_readahead,sys32_readahead)
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall)
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 224 - reserved for setxattr  */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 225 - reserved for lsetxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 226 - reserved for fsetxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 227 - reserved for getxattr  */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 228 - reserved for lgetxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 229 - reserved for fgetxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 230 - reserved for listxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 231 - reserved for llistxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 232 - reserved for flistxattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 233 - reserved for removexattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 234 - reserved for lremovexattr */
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall) /* 235 - reserved for fremovexattr */
	.long  SYSCALL(sys_gettid,sys_gettid)
	.long  SYSCALL(sys_tkill,sys_tkill)
	.rept  255-237
	.long  SYSCALL(sys_ni_syscall,sys_ni_syscall)
	.endr
#endif
/*
 * Program check handler routine
 */

void pgm_check_handler(void)
{
}

/*
 * First we need to check for a special case:
 * Single stepping an instruction that disables the PER event mask will
 * cause a PER event AFTER the mask has been set. Example: SVC or LPSW.
 * For a single stepped SVC the program check handler gets control after
 * the SVC new PSW has been loaded. But we want to execute the SVC first and
 * then handle the PER event. Therefore we update the SVC old PSW to point
 * to the pgm_check_handler and branch to the SVC handler after we checked
 * if we have to load the kernel stack register.
 * For every other possible cause for PER event without the PER mask set
 * we just ignore the PER event (FIXME: is there anything we have to do
 * for LPSW?).
 */

//pgm_per:

//pgm_per_std:
//pgm_per_only:

//pgm_svcper:
//pgm_svcper_noemu:

//pgm_svcret:
	
//pgm_svcper_nosig:
//pgm_tracesys:

/*
 * IO interrupt handler routine
 */
void io_int_handler(void)
{
}


//io_return:
//io_return_bh:	
//io_leave:

//io_handle_bottom_half:        

//io_reschedule:        

//io_signal_return:     

/*
 * External interrupt handler routine
 */
void ext_int_handler(void)
{
}

//ext_int_loop:
//ext_int_next:

/*
 * Machine check handler routines
 */
void mcck_int_handler(void)
{
}

//mcck_return:
#ifdef CONFIG_SMP
/*
 * Restart interruption handler, kick starter for additional CPUs
 */
void restart_int_handler(void)
{
}

#else
/*
 * If we do not run with SMP enabled, let the new CPU crash ...
 */
void restart_int_handler(void)
{
}

//restart_base:
//restart_crash:
//restart_go:
#endif

/*
 * Integer constants
 */
