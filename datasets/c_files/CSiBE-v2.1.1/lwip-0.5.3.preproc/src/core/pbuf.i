# 1 "../../src/core/pbuf.c"
 


































 
 





 
# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 44 "../../src/core/pbuf.c" 2


# 1 "../../src/include/lwip/stats.h" 1
 




































# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 38 "../../src/include/lwip/stats.h" 2

# 1 "../../src/arch/unix/include/arch/cc.h" 1
 




































typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
 

typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   long    u32_t;
typedef signed     long    s32_t;








# 39 "../../src/include/lwip/stats.h" 2


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





# 46 "../../src/core/pbuf.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 48 "../../src/core/pbuf.c" 2

# 1 "../../src/include/lwip/mem.h" 1
 






































# 1 "../../src/include/lwip/arch.h" 1
 












































# 1 "../../src/arch/unix/include/arch/cpu.h" 1
 









































# 46 "../../src/include/lwip/arch.h" 2
















# 40 "../../src/include/lwip/mem.h" 2





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













# 49 "../../src/core/pbuf.c" 2


# 1 "../../src/include/lwip/pbuf.h" 1
 

































 










typedef enum {
  PBUF_TRANSPORT,
  PBUF_IP,
  PBUF_LINK,
  PBUF_RAW
} pbuf_layer;

typedef enum {
  PBUF_RAM,
  PBUF_ROM,
  PBUF_POOL
} pbuf_flag;

 






struct pbuf {
  struct pbuf *next;
  
   
  u8_t flags, ref;
  void *payload;
  
   
  u16_t tot_len;
   
  u16_t len;  
  
};

 




void pbuf_init(void);

 

















struct pbuf *pbuf_alloc(pbuf_layer l, u16_t size, pbuf_flag flag);

 



void pbuf_realloc(struct pbuf *p, u16_t size); 

 





u8_t pbuf_header(struct pbuf *p, s16_t header_size);

 



void pbuf_ref(struct pbuf *p);

 




u8_t pbuf_free(struct pbuf *p);

 


u8_t pbuf_clen(struct pbuf *p);  

 




void pbuf_chain(struct pbuf *h, struct pbuf *t);

 



struct pbuf *pbuf_dechain(struct pbuf *p);


# 51 "../../src/core/pbuf.c" 2


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


# 53 "../../src/core/pbuf.c" 2


# 1 "../../src/arch/unix/include/arch/perf.h" 1
 




































# 1 "/SYS/include/sys/times.h" 1 3
 

















 






# 1 "/SYS/include/features.h" 1 3
 




















 






























































 




















 





 



 







 
# 142 "/SYS/include/features.h" 3


 









 








 



























# 208 "/SYS/include/features.h" 3


































 



 


 








 




 
















 


# 1 "/SYS/include/sys/cdefs.h" 1 3
 




















 




 






 





 








 



# 65 "/SYS/include/sys/cdefs.h" 3


 





 




 









 







 

















 















 







 






 








 








 








 











 










 







 




 


















# 283 "/SYS/include/features.h" 2 3



 








 





 

 








# 1 "/SYS/include/gnu/stubs.h" 1 3
 



















# 312 "/SYS/include/features.h" 2 3




# 26 "/SYS/include/sys/times.h" 2 3



# 1 "/SYS/include/time.h" 1 3
 

















 














# 51 "/SYS/include/time.h" 3





# 1 "/SYS/include/bits/types.h" 1 3
 

















 









# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


































typedef unsigned int size_t;






















 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 29 "/SYS/include/bits/types.h" 2 3


 
typedef unsigned char __u_char;
typedef unsigned short __u_short;
typedef unsigned int __u_int;
typedef unsigned long __u_long;

__extension__ typedef unsigned long long int __u_quad_t;
__extension__ typedef long long int __quad_t;
# 48 "/SYS/include/bits/types.h" 3

typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;

typedef __quad_t *__qaddr_t;

typedef __u_quad_t __dev_t;		 
typedef __u_int __uid_t;		 
typedef __u_int __gid_t;		 
typedef __u_long __ino_t;		 
typedef __u_int __mode_t;		 
typedef __u_int __nlink_t; 		 
typedef long int __off_t;		 
typedef __quad_t __loff_t;		 
typedef int __pid_t;			 
typedef int __ssize_t;			 
typedef __u_long __rlim_t;		 
typedef __u_quad_t __rlim64_t;		 
typedef __u_int __id_t;			 

typedef struct
  {
    int __val[2];
  } __fsid_t;				 

 
typedef int __daddr_t;			 
typedef char *__caddr_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __swblk_t;		 

typedef long int __clock_t;

 
typedef int __clockid_t;

 
typedef int __timer_t;


 



typedef int __key_t;

 
typedef unsigned short int __ipc_pid_t;


 
typedef long int __blksize_t;

 

 
typedef long int __blkcnt_t;
typedef __quad_t __blkcnt64_t;

 
typedef __u_long __fsblkcnt_t;
typedef __u_quad_t __fsblkcnt64_t;

 
typedef __u_long __fsfilcnt_t;
typedef __u_quad_t __fsfilcnt64_t;

 
typedef __u_quad_t __ino64_t;

 
typedef __loff_t __off64_t;

 
typedef long int __t_scalar_t;
typedef unsigned long int __t_uscalar_t;

 
typedef int __intptr_t;

 
typedef unsigned int __socklen_t;


 

# 1 "/SYS/include/bits/pthreadtypes.h" 1 3
 
 
 
 
 
 
 
 
 
 
 
 
 









# 1 "/SYS/include/bits/sched.h" 1 3
 



















# 62 "/SYS/include/bits/sched.h" 3





 
struct __sched_param
  {
    int __sched_priority;
  };


# 23 "/SYS/include/bits/pthreadtypes.h" 2 3


typedef int __atomic_lock_t;

 
struct _pthread_fastlock
{
  long int __status;    
  __atomic_lock_t __spinlock;   

};


 
typedef struct _pthread_descr_struct *_pthread_descr;




 
typedef struct __pthread_attr_s
{
  int __detachstate;
  int __schedpolicy;
  struct __sched_param __schedparam;
  int __inheritsched;
  int __scope;
  size_t __guardsize;
  int __stackaddr_set;
  void *__stackaddr;
  size_t __stacksize;
} pthread_attr_t;


 
typedef struct
{
  struct _pthread_fastlock __c_lock;  
  _pthread_descr __c_waiting;         
} pthread_cond_t;


 
typedef struct
{
  int __dummy;
} pthread_condattr_t;

 
typedef unsigned int pthread_key_t;


 
 

typedef struct
{
  int __m_reserved;                
  int __m_count;                   
  _pthread_descr __m_owner;        
  int __m_kind;                    
  struct _pthread_fastlock __m_lock;  
} pthread_mutex_t;


 
typedef struct
{
  int __mutexkind;
} pthread_mutexattr_t;


 
typedef int pthread_once_t;


# 119 "/SYS/include/bits/pthreadtypes.h" 3


# 138 "/SYS/include/bits/pthreadtypes.h" 3



 
typedef unsigned long int pthread_t;


# 143 "/SYS/include/bits/types.h" 2 3




# 56 "/SYS/include/time.h" 2 3


 
typedef __clock_t clock_t;




# 72 "/SYS/include/time.h" 3



# 84 "/SYS/include/time.h" 3



# 96 "/SYS/include/time.h" 3




# 112 "/SYS/include/time.h" 3




# 364 "/SYS/include/time.h" 3



# 29 "/SYS/include/sys/times.h" 2 3



 

 
struct tms
  {
    clock_t tms_utime;		 
    clock_t tms_stime;		 

    clock_t tms_cutime;		 
    clock_t tms_cstime;		 
  };


 



extern clock_t times (struct tms *__buffer)  ;

 


# 38 "../../src/arch/unix/include/arch/perf.h" 2


# 53 "../../src/arch/unix/include/arch/perf.h"





void perf_print(unsigned long c1l, unsigned long c1h,
		unsigned long c2l, unsigned long c2h,
		char *key);

void perf_print_times(struct tms *start, struct tms *end, char *key);

void perf_init(char *fname);


# 55 "../../src/core/pbuf.c" 2


static u8_t pbuf_pool_memory[(6  * ( 128  + sizeof(struct pbuf)  + (((( 128  + sizeof(struct pbuf) ) % 2 ) == 0)? 0 : (2  - (( 128  + sizeof(struct pbuf) ) % 2 )))) )];
static volatile u8_t pbuf_pool_free_lock, pbuf_pool_alloc_lock;
static sys_sem_t pbuf_pool_free_sem;
static struct pbuf *pbuf_pool = ((void *)0) ;
static struct pbuf *pbuf_pool_alloc_cache = ((void *)0) ;
static struct pbuf *pbuf_pool_free_cache = ((void *)0) ;

 
 










 
void
pbuf_init(void)
{
  struct pbuf *p, *q;
  u8_t i;

  pbuf_pool = (struct pbuf *)&pbuf_pool_memory[0];
   ;
   

  stats.pbuf.avail = 6 ;

  
   
  p = pbuf_pool;
  
  for(i = 0; i < 6 ; ++i) {
    p->next = (struct pbuf *)((u8_t *)p + 128  + sizeof(struct pbuf));
    p->len = p->tot_len = 128 ;
    p->payload = (void *)( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf))   + (((( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf))  ) % 2 ) == 0)? 0 : (2  - (( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf))  ) % 2 ))))  ;
    q = p;
    p = p->next;
  }
  
   

  q->next = ((void *)0) ;

  pbuf_pool_alloc_lock = 0;
  pbuf_pool_free_lock = 0;
  pbuf_pool_free_sem = sys_sem_new(1);
  
}
 
 
 
static struct pbuf *
pbuf_pool_alloc(void)
{
  struct pbuf *p = ((void *)0) ;

   
  if(pbuf_pool_alloc_cache) {
    p = pbuf_pool_alloc_cache;
    if(p) {
      pbuf_pool_alloc_cache = p->next; 
    }
  } else {
     

    if(pbuf_pool_free_lock) {

      ++stats.pbuf.alloc_locked;

      return ((void *)0) ;
    }
    ++pbuf_pool_alloc_lock;
    if(!pbuf_pool_free_lock) {
      p = pbuf_pool;
      if(p) {
	pbuf_pool = p->next; 
      }

    } else {
      ++stats.pbuf.alloc_locked;

    }
    --pbuf_pool_alloc_lock;
  }


  if(p != ((void *)0) ) {    
    ++stats.pbuf.used;
    if(stats.pbuf.used > stats.pbuf.max) {
      stats.pbuf.max = stats.pbuf.used;
    }
  }


  return p;   
}
 
static void
pbuf_pool_free(struct pbuf *p)
{
  struct pbuf *q;


    for(q = p; q != ((void *)0) ; q = q->next) {
      --stats.pbuf.used;
    }

  
  if(pbuf_pool_alloc_cache == ((void *)0) ) {
    pbuf_pool_alloc_cache = p;
  } else {  
    for(q = pbuf_pool_alloc_cache; q->next != ((void *)0) ; q = q->next);
    q->next = p;    
  }
}
 
 
















 
struct pbuf *
pbuf_alloc(pbuf_layer l, u16_t size, pbuf_flag flag)
{
  struct pbuf *p, *q, *r;
  u16_t offset;
  s32_t rsize;

  offset = 0;
  switch(l) {
  case PBUF_TRANSPORT:
    offset += 20 ;
     
  case PBUF_IP:
    offset += 20 ;
    offset += 16 ;
     
  case PBUF_LINK:
    break;
  case PBUF_RAW:
    break;
  default:
     ;
    return ((void *)0) ;
  }

  switch(flag) {
  case PBUF_POOL:
     
    p = pbuf_pool_alloc();
    if(p == ((void *)0) ) {

      ++stats.pbuf.err;

      return ((void *)0) ;
    }
    p->next = ((void *)0) ;
    
     

    p->payload = (void *)( (u32_t) (void *)((u8_t *)p + (sizeof(struct pbuf) + offset))   + (((( (u32_t) (void *)((u8_t *)p + (sizeof(struct pbuf) + offset))  ) % 2 ) == 0)? 0 : (2  - (( (u32_t) (void *)((u8_t *)p + (sizeof(struct pbuf) + offset))  ) % 2 ))))  ;

     
    p->tot_len = size;

     
    p->len = size > 128  - offset? 128  - offset: size;

    p->flags = 0x02 ;
    
     
    r = p;
    rsize = size - p->len;
    while(rsize > 0) {      
      q = pbuf_pool_alloc();
      if(q == ((void *)0) ) {
	 ;

        ++stats.pbuf.err;

        pbuf_pool_free(p);
        return ((void *)0) ;
      }
      q->next = ((void *)0) ;
      r->next = q;
      q->len = rsize > 128 ? 128 : rsize;
      q->flags = 0x02 ;
      q->payload = (void *)((u8_t *)q + sizeof(struct pbuf));
      r = q;
      q->ref = 1;
      q = q->next;
      rsize -= 128 ;
    }
    r->next = ((void *)0) ;

     ;

    break;
  case PBUF_RAM:
     
    p = mem_malloc(( sizeof(struct pbuf) + size + offset  + (((( sizeof(struct pbuf) + size + offset ) % 2 ) == 0)? 0 : (2  - (( sizeof(struct pbuf) + size + offset ) % 2 )))) );
    if(p == ((void *)0) ) {
      return ((void *)0) ;
    }
     
    p->payload = (void *)( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf) + offset)   + (((( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf) + offset)  ) % 2 ) == 0)? 0 : (2  - (( (u32_t) (void *)((u8_t *)p + sizeof(struct pbuf) + offset)  ) % 2 ))))  ;
    p->len = p->tot_len = size;
    p->next = ((void *)0) ;
    p->flags = 0x00 ;

     ;

    break;
  case PBUF_ROM:
     

    p = memp_mallocp(MEMP_PBUF);
    if(p == ((void *)0) ) {
      return ((void *)0) ;
    }
    p->payload = ((void *)0) ;
    p->len = p->tot_len = size;
    p->next = ((void *)0) ;
    p->flags = 0x01 ;
    break;
  default:
     ;
    return ((void *)0) ;
  }
  p->ref = 1;
  return p;
}
 
 





 
void
pbuf_refresh(void)
{
  struct pbuf *p;

  sys_sem_wait(pbuf_pool_free_sem);
  
  if(pbuf_pool_free_cache != ((void *)0) ) {
    ++pbuf_pool_free_lock;
    if(!pbuf_pool_alloc_lock) {
      if(pbuf_pool == ((void *)0) ) {
	pbuf_pool = pbuf_pool_free_cache;	
      } else {  
	for(p = pbuf_pool; p->next != ((void *)0) ; p = p->next);
	p->next = pbuf_pool_free_cache;   
      }
      pbuf_pool_free_cache = ((void *)0) ;

    } else {
      ++stats.pbuf.refresh_locked;

    }
    
    --pbuf_pool_free_lock;  
  }
  
  sys_sem_signal(pbuf_pool_free_sem);
}






 
 









 
void
pbuf_realloc(struct pbuf *p, u16_t size)
{
  struct pbuf *q, *r;
  u16_t rsize;

   ;



  
  if(p->tot_len <= size) {
    return;
  }
  
  switch(p->flags) {
  case 0x02 :
     
    rsize = size;
    q = p;  
    while(rsize > q->len) {
      rsize -= q->len;      
      q = q->next;
    }
     
    q->len = rsize;

     
    r = q->next;
    q->next = ((void *)0) ;
    q = r;
    while(q != ((void *)0) ) {
      r = q->next;
      do { sys_sem_wait(pbuf_pool_free_sem);  q ->next = pbuf_pool_free_cache; pbuf_pool_free_cache =  q ; sys_sem_signal(pbuf_pool_free_sem); } while(0) ;

      --stats.pbuf.used;

      q = r;
    }
    break;
  case 0x01 :    
    p->len = size;
    break;
  case 0x00 :
     
    rsize = size;
    q = p;
    while(rsize > q->len) {
      rsize -= q->len;
      q = q->next;
    }
    if(q->flags == 0x00 ) {
     
      mem_realloc(q, (u8_t *)q->payload - (u8_t *)q + rsize);
    }
    
    q->len = rsize;
    
     
    r = q->next;
    q->next = ((void *)0) ;
    q = r;
    while(q != ((void *)0) ) {
      r = q->next;
      pbuf_free(q);
      q = r;
    }
    break;
  }
  p->tot_len = size;

  pbuf_refresh();
}
 
 




 
u8_t
pbuf_header(struct pbuf *p, s16_t header_size)
{
  void *payload;

  payload = p->payload;
  p->payload = (u8_t *)p->payload - header_size/sizeof(u8_t);

   ;
  
  if((u8_t *)p->payload < (u8_t *)p + sizeof(struct pbuf)) {
     ;


    p->payload = payload;
    return -1;
  }
  p->len += header_size;
  p->tot_len += header_size;
  
  return 0;
}
 
 




 
 
u8_t
pbuf_free(struct pbuf *p)
{
  struct pbuf *q;
  u8_t count = 0;
    
  if(p == ((void *)0) ) {
    return 0;
  }

   ;
  
   ;


  
   ;
    
     
  p->ref--;

  q = ((void *)0) ;
   
  if(p->ref == 0) {

    while(p != ((void *)0) ) {
       
      if(p->flags == 0x02 ) {
	p->len = p->tot_len = 128 ;
	p->payload = (void *)((u8_t *)p + sizeof(struct pbuf));
	q = p->next;
	do { sys_sem_wait(pbuf_pool_free_sem);  p ->next = pbuf_pool_free_cache; pbuf_pool_free_cache =  p ; sys_sem_signal(pbuf_pool_free_sem); } while(0) ;

	--stats.pbuf.used;

      } else if(p->flags == 0x01 ) {
	q = p->next;
	memp_freep(MEMP_PBUF, p);
      } else {
	q = p->next;
	mem_free(p);
      }
      p = q;
      count++;
    }
    pbuf_refresh();
  }

   ;
  
  return count;
}
 
 



 
u8_t
pbuf_clen(struct pbuf *p)
{
  u8_t len;

  if(p == ((void *)0) ) {
    return 0;
  }
  
  for(len = 0; p != ((void *)0) ; p = p->next) {
    ++len;
  }
  return len;
}
 
 



 
void
pbuf_ref(struct pbuf *p)
{
  if(p == ((void *)0) ) {
    return;
  }
  ++(p->ref);
}
 
 




 
void
pbuf_chain(struct pbuf *h, struct pbuf *t)
{
  struct pbuf *p;

  for(p = h; p->next != ((void *)0) ; p = p->next);
  p->next = t;
  h->tot_len += t->tot_len;  
}
 
 




 
struct pbuf *
pbuf_dechain(struct pbuf *p)
{
  struct pbuf *q;
  
  q = p->next;
  if (q != ((void *)0) ) {
    q->tot_len = p->tot_len - p->len;
  }
  p->tot_len = p->len;
  p->next = ((void *)0) ;
  return q;
}
 
