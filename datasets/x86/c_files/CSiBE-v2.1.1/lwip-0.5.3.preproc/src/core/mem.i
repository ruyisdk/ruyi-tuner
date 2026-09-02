# 1 "../../src/core/mem.c"
 


































 
 




 
# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 43 "../../src/core/mem.c" 2


# 1 "../../src/include/lwip/arch.h" 1
 












































# 1 "../../src/arch/unix/include/arch/cpu.h" 1
 









































# 46 "../../src/include/lwip/arch.h" 2

# 1 "../../src/arch/unix/include/arch/cc.h" 1
 




































typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
 

typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   long    u32_t;
typedef signed     long    s32_t;








# 47 "../../src/include/lwip/arch.h" 2















# 45 "../../src/core/mem.c" 2

# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 46 "../../src/core/mem.c" 2

# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 47 "../../src/core/mem.c" 2

# 1 "../../src/include/lwip/mem.h" 1
 











































typedef u16_t mem_size_t;



void mem_init(void);

void *mem_malloc(mem_size_t size);
void *mem_malloc2(mem_size_t size);
void mem_free(void *mem);
void *mem_realloc(void *mem, mem_size_t size);
void *mem_reallocm(void *mem, mem_size_t size);







typedef mem_size_t (*mem_reclaim_func)(void *arg, mem_size_t size);
void mem_register_reclaim(mem_reclaim_func f, void *arg);
void mem_reclaim(unsigned int size);













# 48 "../../src/core/mem.c" 2


# 1 "../../src/include/lwip/sys.h" 1
 





































# 1 "../../src/arch/unix/include/arch/sys_arch.h" 1
 







































struct sys_sem;
typedef struct sys_sem * sys_sem_t;

struct sys_mbox;
typedef struct sys_mbox *sys_mbox_t;

struct sys_thread;
typedef struct sys_thread * sys_thread_t;



# 39 "../../src/include/lwip/sys.h" 2


typedef void (* sys_timeout_handler)(void *arg);

struct sys_timeout {
  struct sys_timeout *next;
  u16_t time;
  sys_timeout_handler h;
  void *arg;
};

struct sys_timeouts {
  struct sys_timeout *next;
};

 
void sys_init(void);

 








void sys_timeout(u16_t msecs, sys_timeout_handler h, void *arg);
struct sys_timeouts *sys_arch_timeouts(void);

 
sys_sem_t sys_sem_new(u8_t count);
void sys_sem_signal(sys_sem_t sem);
u16_t sys_arch_sem_wait(sys_sem_t sem, u16_t timeout);
void sys_sem_free(sys_sem_t sem);

void sys_sem_wait(sys_sem_t sem);

 
sys_mbox_t sys_mbox_new(void);
void sys_mbox_post(sys_mbox_t mbox, void *msg);
u16_t sys_arch_mbox_fetch(sys_mbox_t mbox, void **msg, u16_t timeout);
void sys_mbox_free(sys_mbox_t mbox);

void sys_mbox_fetch(sys_mbox_t mbox, void **msg);

 
void sys_thread_new(void (* thread)(void *arg), void *arg);

 

 
unsigned long sys_now(void);


# 50 "../../src/core/mem.c" 2


# 1 "../../src/include/lwip/stats.h" 1
 







































# 1 "../../src/include/lwip/memp.h" 1
 









































typedef enum {
  MEMP_PBUF,
  MEMP_UDP_PCB,
  MEMP_TCP_PCB,
  MEMP_TCP_PCB_LISTEN,
  MEMP_TCP_SEG,

  MEMP_NETBUF,
  MEMP_NETCONN,
  MEMP_API_MSG,
  MEMP_TCPIP_MSG,

  MEMP_SYS_TIMEOUT,
  
  MEMP_MAX
} memp_t;

void memp_init(void);

void *memp_malloc(memp_t type);
void *memp_mallocp(memp_t type);
void *memp_malloc2(memp_t type);
void *memp_realloc(memp_t fromtype, memp_t totype, void *mem);
void memp_free(memp_t type, void *mem);
void memp_freep(memp_t type, void *mem);


typedef u8_t (*memp_reclaim_func)(void *arg, memp_t type);
void memp_register_reclaim(memp_t type, memp_reclaim_func f, void *arg);





	  
# 41 "../../src/include/lwip/stats.h" 2




struct stats_proto {
  u16_t xmit;     
  u16_t rexmit;   
  u16_t recv;     
  u16_t fw;       
  u16_t drop;     
  u16_t chkerr;   
  u16_t lenerr;   
  u16_t memerr;   
  u16_t rterr;    
  u16_t proterr;  
  u16_t opterr;   
  u16_t err;      
  u16_t cachehit;
};

struct stats_mem {
  u16_t avail;
  u16_t used;
  u16_t max;  
  u16_t err;
  u16_t reclaimed;
};

struct stats_pbuf {
  u16_t avail;
  u16_t used;
  u16_t max;  
  u16_t err;
  u16_t reclaimed;

  u16_t alloc_locked;
  u16_t refresh_locked;
};

struct stats_syselem {
  u16_t used;
  u16_t max;
  u16_t err;
};

struct stats_sys {
  struct stats_syselem sem;
  struct stats_syselem mbox;
};

struct stats_ {
  struct stats_proto link;
  struct stats_proto ip;
  struct stats_proto icmp;
  struct stats_proto udp;
  struct stats_proto tcp;
  struct stats_pbuf pbuf;
  struct stats_mem mem;
  struct stats_mem memp[MEMP_MAX];
  struct stats_sys sys;
};

extern struct stats_ stats;



void stats_init(void);





# 52 "../../src/core/mem.c" 2



struct mem_reclaim_ {
  struct mem_reclaim_ *next;
  mem_reclaim_func f;
  void *arg;  
};


struct mem {
  mem_size_t next, prev;
  u8_t used;

  u8_t dummy;

};

static struct mem *ram_end;
static u8_t ram[( 1000  + sizeof(struct mem)  + (((( 1000  + sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( 1000  + sizeof(struct mem) ) % 2 )))) ];



 




static struct mem *lfree;    


static struct mem_reclaim_ *mrlist;


static sys_sem_t mem_sem;

 
static void
plug_holes(struct mem *mem)
{
  struct mem *nmem;
  struct mem *pmem;

   ;
   ;
   ;
  
   
   ;
  
  nmem = (struct mem *)&ram[mem->next];
  if(mem != nmem && nmem->used == 0 && (u8_t *)nmem != (u8_t *)ram_end) {
    if(lfree == nmem) {
      lfree = mem;
    }
    mem->next = nmem->next;
    ((struct mem *)&ram[nmem->next])->prev = (u8_t *)mem - ram;
  }

   
  pmem = (struct mem *)&ram[mem->prev];
  if(pmem != mem && pmem->used == 0) {
    if(lfree == mem) {
      lfree = pmem;
    }
    pmem->next = mem->next;
    ((struct mem *)&ram[mem->next])->prev = (u8_t *)pmem - ram;
  }

}
 
void
mem_init(void)
{
  struct mem *mem;

  bzero(ram, 1000 );
  mem = (struct mem *)ram;
  mem->next = 1000 ;
  mem->prev = 0;
  mem->used = 0;
  ram_end = (struct mem *)&ram[1000 ];
  ram_end->used = 1;
  ram_end->next = 1000 ;
  ram_end->prev = 1000 ;

  mem_sem = sys_sem_new(1);

  lfree = (struct mem *)ram;


  mrlist = ((void *)0) ;

  

  stats.mem.avail = 1000 ;

}
 

void
mem_reclaim(unsigned int size)
{
  struct mem_reclaim_ *mr;
  int rec;

  rec = 0;
      
  for(mr = mrlist; mr != ((void *)0) ; mr = mr->next) {
     ;
    rec += mr->f(mr->arg, size);
  }

  stats.mem.reclaimed += rec;

}

 
void *
mem_malloc2(mem_size_t size)
{
  void *mem;
  mem = mem_malloc(size);

  if(mem == ((void *)0) ) {
    mem_reclaim(size);    
    mem = mem_malloc(size);
  }

  return mem;
}
 
void *
mem_malloc(mem_size_t size)
{
  mem_size_t ptr, ptr2;
  struct mem *mem, *mem2;

  if(size == 0) {
    return ((void *)0) ;
  }

   

  if((size % 2 ) != 0) {
    size += 2  - ((size + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ) % 2 );
  }
  
  if(size > 1000 ) {
    return ((void *)0) ;
  }
  
  sys_sem_wait(mem_sem);

  for(ptr = (u8_t *)lfree - ram; ptr < 1000 ; ptr = ((struct mem *)&ram[ptr])->next) {
    mem = (struct mem *)&ram[ptr];
    if(!mem->used &&
       mem->next - (ptr + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ) >= size + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ) {
      ptr2 = ptr + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))   + size;
      mem2 = (struct mem *)&ram[ptr2];

      mem2->prev = ptr;      
      mem2->next = mem->next;
      mem->next = ptr2;      
      if(mem2->next != 1000 ) {
        ((struct mem *)&ram[mem2->next])->prev = ptr2;
      }
      
      mem2->used = 0;      
      mem->used = 1;

      stats.mem.used += size;
       


      if(stats.mem.max < ptr2) {
        stats.mem.max = ptr2;
      }      


  


      if(mem == lfree) {
	 
        while(lfree->used && lfree != ram_end) {
	  lfree = (struct mem *)&ram[lfree->next];
        }
         ;
      }
      sys_sem_signal(mem_sem);
       ;

       ;

      return (u8_t *)mem + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ;
    }    
  }
   ;

  ++stats.mem.err;
  
  sys_sem_signal(mem_sem);
  return ((void *)0) ;
}
 
void
mem_free(void *rmem)
{
  struct mem *mem;

  if(rmem == ((void *)0) ) {
    return;
  }
  
  sys_sem_wait(mem_sem);

   ;

  
  
  if((u8_t *)rmem < (u8_t *)ram || (u8_t *)rmem >= (u8_t *)ram_end) {
     ;

    ++stats.mem.err;

    return;
  }
  mem = (struct mem *)((u8_t *)rmem - ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  );

   ;
  
  mem->used = 0;

  if(mem < lfree) {
    lfree = mem;
  }
  

  stats.mem.used -= mem->next - ((u8_t *)mem - ram) - ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ;



  

  plug_holes(mem);
  sys_sem_signal(mem_sem);
}
 
void *
mem_reallocm(void *rmem, mem_size_t newsize)
{
  void *nmem;
  nmem = mem_malloc(newsize);
  if(nmem == ((void *)0) ) {
    return mem_realloc(rmem, newsize);
  }
  bcopy(rmem, nmem, newsize);
  mem_free(rmem);
  return nmem;
}
 
void *
mem_realloc(void *rmem, mem_size_t newsize)
{
  mem_size_t size;
  mem_size_t ptr, ptr2;
  struct mem *mem, *mem2;
  
  sys_sem_wait(mem_sem);
  
   ;

  
  if((u8_t *)rmem < (u8_t *)ram || (u8_t *)rmem >= (u8_t *)ram_end) {
     ;
    return rmem;
  }
  mem = (struct mem *)((u8_t *)rmem - ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  );

  ptr = (u8_t *)mem - ram;

  size = mem->next - ptr - ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))  ;

  stats.mem.used -= (size - newsize);


 

  
  if(newsize + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))   + 12  < size) {
    ptr2 = ptr + ( sizeof(struct mem)  + (((( sizeof(struct mem) ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct mem) ) % 2 ))))   + newsize;
    mem2 = (struct mem *)&ram[ptr2];
    mem2->used = 0;
    mem2->next = mem->next;
    mem2->prev = ptr;
    mem->next = ptr2;
    if(mem2->next != 1000 ) {
      ((struct mem *)&ram[mem2->next])->prev = ptr2;
    }

    plug_holes(mem2);
  }
  sys_sem_signal(mem_sem);  
  return rmem;
}
 

void
mem_register_reclaim(mem_reclaim_func f, void *arg)
{
  struct mem_reclaim_ *mr;

  mr = mem_malloc(sizeof(struct mem_reclaim_));
  if(mr == ((void *)0) ) {
    return;
  }
  mr->next = mrlist;
  mrlist = mr;
  mr->f = f;
  mr->arg = arg;
}     

 
