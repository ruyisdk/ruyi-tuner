/*
 *  include/asm-s390/page.h
 *
 *  S390 version
 *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Hartmut Penner (hpenner@de.ibm.com)
 */

#ifndef _S390_PAGE_H
#define _S390_PAGE_H

#include <asm/setup.h>

/* PAGE_SHIFT determines the page size */
#define PAGE_SHIFT      12
#define PAGE_SIZE       (1UL << PAGE_SHIFT)
#define PAGE_MASK       (~(PAGE_SIZE-1))

#ifdef __KERNEL__
#ifndef __ASSEMBLY__

static inline void clear_page(void *page)
{
  /* ASM */
}

static inline void copy_page(void *to, void *from)
{
  /* ASM */
}

#define clear_user_page(page, vaddr)    clear_page(page)
#define copy_user_page(to, from, vaddr) copy_page(to, from)

/* ASM */
#define BUG() do { \
        printk("kernel BUG at %s:%d!\n", "__FILE_", __LINE__); \
} while (0)                                       

#define PAGE_BUG(page) do { \
        BUG(); \
} while (0)                      

/* Pure 2^n version of get_order */
extern __inline__ int get_order(unsigned long size)
{
        int order;

        size = (size-1) >> (PAGE_SHIFT-1);
        order = -1;
        do {
                size >>= 1;
                order++;
        } while (size);
        return order;
}

/*
 * These are used to make use of C type-checking..
 */
typedef struct { unsigned long pte; } pte_t;
typedef struct { 
        unsigned long pmd0;
        unsigned long pmd1; 
        } pmd_t;
typedef unsigned int pgd_t;
typedef struct { unsigned long pgprot; } pgprot_t;

#define pte_val(x)      ((x).pte)
#define pmd_val(x)      ((x).pmd0)
#define pmd_val1(x)     ((x).pmd1)

static inline unsigned long __pgd_val(pgd_t *pgdp)
{
	unsigned long addr = (unsigned long) pgdp;
	unsigned long *pgd_slot = (unsigned long *) (addr & -8);

	return *pgd_slot + ((addr & 4) << 11);
}
#define pgd_val(pgd) __pgd_val(&(pgd))

#define pgprot_val(x)   ((x).pgprot)

#define __pte(x)        ((pte_t) { (x) } )
#define __pmd(x)        ((pmd_t) { (x) } )
#define __pgd(x)        ((pgd_t) { (x) } )
#define __pgprot(x)     ((pgprot_t) { (x) } )

#endif                                 /* !__ASSEMBLY__                    */

/* to align the pointer to the (next) page boundary */
#define PAGE_ALIGN(addr)        (((addr)+PAGE_SIZE-1)&PAGE_MASK)

#define __PAGE_OFFSET           0x0UL
#define PAGE_OFFSET             0x0UL
#define __pa(x)                 (unsigned long)(x)
#define __va(x)                 (void *)(x)
#define virt_to_page(kaddr)	(mem_map + (__pa(kaddr) >> PAGE_SHIFT))
#define VALID_PAGE(page)	((page - mem_map) < max_mapnr)

#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)

#define get_storage_key() 0
#define pfix_get_page_addr(addr) (unsigned long)addr
#define pfix_get_addr(addr) (unsigned long)addr

#endif                                 /* __KERNEL__                       */

#endif                                 /* _S390_PAGE_H                     */
