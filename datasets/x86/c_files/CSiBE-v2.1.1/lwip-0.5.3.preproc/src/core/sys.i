# 1 "../../src/core/sys.c"
 


































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 36 "../../src/core/sys.c" 2


# 1 "../../src/include/lwip/sys.h" 1
 




































# 1 "../../src/arch/unix/include/arch/cc.h" 1
 




































typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
 

typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   long    u32_t;
typedef signed     long    s32_t;








# 38 "../../src/include/lwip/sys.h" 2

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


# 38 "../../src/core/sys.c" 2

# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 39 "../../src/core/sys.c" 2

# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 40 "../../src/core/sys.c" 2

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





	  
# 41 "../../src/core/sys.c" 2


 
void
sys_mbox_fetch(sys_mbox_t mbox, void **msg)
{
  u16_t time;
  struct sys_timeouts *timeouts;
  struct sys_timeout *tmptimeout;
  sys_timeout_handler h;
  void *arg;

    
 again:
  timeouts = sys_arch_timeouts();
    
  if(timeouts->next == ((void *)0) ) {
    sys_arch_mbox_fetch(mbox, msg, 0);
  } else {
    if(timeouts->next->time > 0) {
      time = sys_arch_mbox_fetch(mbox, msg, timeouts->next->time);
    } else {
      time = 0;
    }

    if(time == 0) {
       


      tmptimeout = timeouts->next;
      timeouts->next = tmptimeout->next;
      h = tmptimeout->h;
      arg = tmptimeout->arg;
      memp_free(MEMP_SYS_TIMEOUT, tmptimeout);
      h(arg);
      
       
      goto again;
    } else {
       


      if(time <= timeouts->next->time) {
	timeouts->next->time -= time;
      } else {
	timeouts->next->time = 0;
      }
    }
    
  }
}
 
void
sys_sem_wait(sys_sem_t sem)
{
  u16_t time;
  struct sys_timeouts *timeouts;
  struct sys_timeout *tmptimeout;
  sys_timeout_handler h;
  void *arg;
  
   


 again:
  
  timeouts = sys_arch_timeouts();
  
  if(timeouts->next == ((void *)0) ) {
    sys_arch_sem_wait(sem, 0);
  } else {
    if(timeouts->next->time > 0) {
      time = sys_arch_sem_wait(sem, timeouts->next->time);
    } else {
      time = 0;
    }

    if(time == 0) {
       


      tmptimeout = timeouts->next;
      timeouts->next = tmptimeout->next;
      h = tmptimeout->h;
      arg = tmptimeout->arg;
      memp_free(MEMP_SYS_TIMEOUT, tmptimeout);
      h(arg);
	    
      
       
      goto again;
    } else {
       


      if(time <= timeouts->next->time) {
	timeouts->next->time -= time;
      } else {
	timeouts->next->time = 0;
      }
    }
    
  }
}
 
void
sys_timeout(u16_t msecs, sys_timeout_handler h, void *arg)
{
  struct sys_timeouts *timeouts;
  struct sys_timeout *timeout, *t;

  timeout = memp_malloc(MEMP_SYS_TIMEOUT);
  if(timeout == ((void *)0) ) {
    return;
  }
  timeout->next = ((void *)0) ;
  timeout->h = h;
  timeout->arg = arg;
  timeout->time = msecs;
  
  timeouts = sys_arch_timeouts();
  
  if(timeouts->next == ((void *)0) ) {
    timeouts->next = timeout;
    return;
  }  
  
  if(timeouts->next->time > msecs) {
    timeouts->next->time -= msecs;
    timeout->next = timeouts->next;
    timeouts->next = timeout;
  } else {
    for(t = timeouts->next; t != ((void *)0) ; t = t->next) {
      timeout->time -= t->time;
      if(t->next == ((void *)0)  ||
	 t->next->time > timeout->time) {
	if(t->next != ((void *)0) ) {
	  t->next->time -= timeout->time;
	}
	timeout->next = t->next;
	t->next = timeout;
	break;
      }
    }
  }
  
}
 

