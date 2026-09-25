# 1 "../../src/core/tcp_input.c"
 


































 
 







 

# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 47 "../../src/core/tcp_input.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 49 "../../src/core/tcp_input.c" 2

# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 50 "../../src/core/tcp_input.c" 2


# 1 "../../src/include/lwip/netif.h" 1
 






































# 1 "../../src/include/lwip/err.h" 1
 






































# 1 "../../src/arch/unix/include/arch/cc.h" 1
 




































typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
 

typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   long    u32_t;
typedef signed     long    s32_t;








# 40 "../../src/include/lwip/err.h" 2


typedef s8_t err_t;

 



























# 40 "../../src/include/lwip/netif.h" 2


# 1 "../../src/include/ipv4/lwip/ip_addr.h" 1
 




































# 1 "../../src/include/lwip/arch.h" 1
 












































# 1 "../../src/arch/unix/include/arch/cpu.h" 1
 









































# 46 "../../src/include/lwip/arch.h" 2
















# 38 "../../src/include/ipv4/lwip/ip_addr.h" 2






 
struct ip_addr {
   u32_t addr  __attribute__((packed)) ;
} __attribute__((packed)) ;
 

extern struct ip_addr ip_addr_broadcast;






















				   



















# 42 "../../src/include/lwip/netif.h" 2


# 1 "../../src/include/ipv4/lwip/inet.h" 1
 







































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


# 41 "../../src/include/ipv4/lwip/inet.h" 2



u16_t inet_chksum(void *dataptr, u16_t len);
u16_t inet_chksum_pbuf(struct pbuf *p);
u16_t inet_chksum_pseudo(struct pbuf *p,
			 struct ip_addr *src, struct ip_addr *dest,
			 u8_t proto, u16_t proto_len);































































u16_t htons(u16_t n);
u32_t htonl(u32_t n);









# 44 "../../src/include/lwip/netif.h" 2




struct netif {
  struct netif *next;
  u8_t num;
  struct ip_addr ip_addr;
  struct ip_addr netmask;   
  struct ip_addr gw;
  char hwaddr[6];

   

  err_t (* input)(struct pbuf *p, struct netif *inp);

   


  char name[2];
   

  err_t (* output)(struct netif *netif, struct pbuf *p,
		   struct ip_addr *ipaddr);
  err_t (* linkoutput)(struct netif *netif, struct pbuf *p);

   

  void *state;
};

 
extern struct netif *netif_list;
extern struct netif *netif_default;


 
void netif_init();

struct netif *netif_add(struct ip_addr *ipaddr, struct ip_addr *netmask,
			struct ip_addr *gw,
			void (* init)(struct netif *netif),
			err_t (* input)(struct pbuf *p, struct netif *netif));

 



struct netif *netif_find(char *name);

void netif_set_default(struct netif *netif);

void netif_set_ipaddr(struct netif *netif, struct ip_addr *ipaddr);
void netif_set_netmask(struct netif *netif, struct ip_addr *netmast);
void netif_set_gw(struct netif *netif, struct ip_addr *gw);


# 52 "../../src/core/tcp_input.c" 2

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













# 53 "../../src/core/tcp_input.c" 2

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





	  
# 54 "../../src/core/tcp_input.c" 2



# 1 "../../src/include/lwip/tcp.h" 1
 




































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


# 38 "../../src/include/lwip/tcp.h" 2





# 1 "../../src/include/ipv4/lwip/ip.h" 1
 













































void ip_init(void);
u8_t ip_lookup(void *header, struct netif *inp);
struct netif *ip_route(struct ip_addr *dest);
err_t ip_input(struct pbuf *p, struct netif *inp);
err_t ip_output(struct pbuf *p, struct ip_addr *src, struct ip_addr *dest,
		u8_t ttl, u8_t proto);
err_t ip_output_if(struct pbuf *p, struct ip_addr *src, struct ip_addr *dest,
		   u8_t ttl, u8_t proto,
		   struct netif *netif);








 







struct ip_hdr {
   
   u16_t _v_hl_tos  __attribute__((packed)) ;
   
   u16_t _len  __attribute__((packed)) ;
   
   u16_t _id  __attribute__((packed)) ;
   
   u16_t _offset  __attribute__((packed)) ;




   
   u16_t _ttl_proto  __attribute__((packed)) ;
   
   u16_t _chksum  __attribute__((packed)) ;
   
   struct ip_addr src  __attribute__((packed)) ;
   struct ip_addr dest  __attribute__((packed)) ; 
} __attribute__((packed)) ;




























# 43 "../../src/include/lwip/tcp.h" 2

# 1 "../../src/include/ipv4/lwip/icmp.h" 1
 























































enum icmp_dur_type {
  ICMP_DUR_NET = 0,     
  ICMP_DUR_HOST = 1,    
  ICMP_DUR_PROTO = 2,   
  ICMP_DUR_PORT = 3,    
  ICMP_DUR_FRAG = 4,    
  ICMP_DUR_SR = 5       
};

enum icmp_te_type {
  ICMP_TE_TTL = 0,      
  ICMP_TE_FRAG = 1      
};

void icmp_input(struct pbuf *p, struct netif *inp);

void icmp_dest_unreach(struct pbuf *p, enum icmp_dur_type t);
void icmp_time_exceeded(struct pbuf *p, enum icmp_te_type t);

struct icmp_echo_hdr {
   u16_t _type_code  __attribute__((packed)) ;
   u16_t chksum  __attribute__((packed)) ;
   u16_t id  __attribute__((packed)) ;
   u16_t seqno  __attribute__((packed)) ;
} __attribute__((packed)) ;



struct icmp_dur_hdr {
   u16_t _type_code  __attribute__((packed)) ;
   u16_t chksum  __attribute__((packed)) ;
   u32_t unused  __attribute__((packed)) ;
} __attribute__((packed)) ;

struct icmp_te_hdr {
   u16_t _type_code  __attribute__((packed)) ;
   u16_t chksum  __attribute__((packed)) ;
   u32_t unused  __attribute__((packed)) ;
} __attribute__((packed)) ;








	  
# 44 "../../src/include/lwip/tcp.h" 2






struct tcp_pcb;

 

 
void             tcp_init    (void);   

void             tcp_tmr     (void);   


 
struct tcp_pcb * tcp_new     (void);

void             tcp_arg     (struct tcp_pcb *pcb, void *arg);
void             tcp_accept  (struct tcp_pcb *pcb,
			      err_t (* accept)(void *arg, struct tcp_pcb *newpcb,
					       err_t err));
void             tcp_recv    (struct tcp_pcb *pcb,
			      err_t (* recv)(void *arg, struct tcp_pcb *tpcb,
				  struct pbuf *p, err_t err));
void             tcp_sent    (struct tcp_pcb *pcb,
			      err_t (* sent)(void *arg, struct tcp_pcb *tpcb,
					     u16_t len));
void             tcp_poll    (struct tcp_pcb *pcb,
			      err_t (* poll)(void *arg, struct tcp_pcb *tpcb),
			      u8_t interval);
void             tcp_err     (struct tcp_pcb *pcb,
			      void (* err)(void *arg, err_t err));



void             tcp_recved  (struct tcp_pcb *pcb, u16_t len);
err_t            tcp_bind    (struct tcp_pcb *pcb, struct ip_addr *ipaddr,
			      u16_t port);
err_t            tcp_connect (struct tcp_pcb *pcb, struct ip_addr *ipaddr,
			      u16_t port, err_t (* connected)(void *arg,
							      struct tcp_pcb *tpcb,
							      err_t err));
struct tcp_pcb * tcp_listen  (struct tcp_pcb *pcb);
void             tcp_abort   (struct tcp_pcb *pcb);
err_t            tcp_close   (struct tcp_pcb *pcb);
err_t            tcp_write   (struct tcp_pcb *pcb, const void *dataptr, u16_t len,
			      u8_t copy);

 

void             tcp_slowtmr (void);
void             tcp_fasttmr (void);


 
void             tcp_input   (struct pbuf *p, struct netif *inp);
 
err_t            tcp_output  (struct tcp_pcb *pcb);
















 
















struct tcp_hdr {
   u16_t src  __attribute__((packed)) ;
   u16_t dest  __attribute__((packed)) ;
   u32_t seqno  __attribute__((packed)) ;
   u32_t ackno  __attribute__((packed)) ;
   u16_t _offset_flags  __attribute__((packed)) ;
   u16_t wnd  __attribute__((packed)) ;
   u16_t chksum  __attribute__((packed)) ;
   u16_t urgp  __attribute__((packed)) ;
} __attribute__((packed)) ;










enum tcp_state {
  CLOSED      = 0,
  LISTEN      = 1,
  SYN_SENT    = 2,
  SYN_RCVD    = 3,
  ESTABLISHED = 4,
  FIN_WAIT_1  = 5,
  FIN_WAIT_2  = 6,
  CLOSE_WAIT  = 7,
  CLOSING     = 8,
  LAST_ACK    = 9,
  TIME_WAIT   = 10
};


 
struct tcp_pcb {
  struct tcp_pcb *next;    

  enum tcp_state state;    

  void *callback_arg;
  
   
  err_t (* accept)(void *arg, struct tcp_pcb *newpcb, err_t err);

  struct ip_addr local_ip;
  u16_t local_port;
  
  struct ip_addr remote_ip;
  u16_t remote_port;
  
   
  u32_t rcv_nxt;    
  u16_t rcv_wnd;    

   
  u16_t tmr;

   
  u8_t rtime;
  
  u16_t mss;    

  u8_t flags;






  
   
  u16_t rttest;  
  u32_t rtseq;   
  s32_t sa, sv;

  u16_t rto;     
  u8_t nrtx;     

   
  u32_t lastack;  
  u8_t dupacks;
  
   
  u16_t cwnd;  
  u16_t ssthresh;

   
  u32_t snd_nxt,        
    snd_max,        
    snd_wnd,        
    snd_wl1, snd_wl2,
    snd_lbb;      

  u16_t snd_buf;    
  u8_t snd_queuelen;

   
  err_t (* sent)(void *arg, struct tcp_pcb *pcb, u16_t space);
  u16_t acked;
  
   
  err_t (* recv)(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err);
  struct pbuf *recv_data;

   
  err_t (* connected)(void *arg, struct tcp_pcb *pcb, err_t err);

   
  err_t (* poll)(void *arg, struct tcp_pcb *pcb);

   
  void (* errf)(void *arg, err_t err);
  
  u8_t polltmr, pollinterval;
  
   
  struct tcp_seg *unsent;    
  struct tcp_seg *unacked;   

  struct tcp_seg *ooseq;     


};

struct tcp_pcb_listen {  
  struct tcp_pcb_listen *next;    
  
  enum tcp_state state;    

  void *callback_arg;
  
   
  void (* accept)(void *arg, struct tcp_pcb *newpcb);

  struct ip_addr local_ip;
  u16_t local_port;
};

 
struct tcp_seg {
  struct tcp_seg *next;     
  struct pbuf *p;           
  void *dataptr;            
  u16_t len;                
  struct tcp_hdr *tcphdr;   
};

 
struct tcp_pcb *tcp_pcb_copy(struct tcp_pcb *pcb);
void tcp_pcb_purge(struct tcp_pcb *pcb);
void tcp_pcb_remove(struct tcp_pcb **pcblist, struct tcp_pcb *pcb);

u8_t tcp_segs_free(struct tcp_seg *seg);
u8_t tcp_seg_free(struct tcp_seg *seg);
struct tcp_seg *tcp_seg_copy(struct tcp_seg *seg);











err_t tcp_send_ctrl(struct tcp_pcb *pcb, u8_t flags);
err_t tcp_enqueue(struct tcp_pcb *pcb, void *dataptr, u16_t len,
		u8_t flags, u8_t copy,
                u8_t *optdata, u8_t optlen);

void tcp_rexmit_seg(struct tcp_pcb *pcb, struct tcp_seg *seg);

void tcp_rst(u32_t seqno, u32_t ackno,
	     struct ip_addr *local_ip, struct ip_addr *remote_ip,
	     u16_t local_port, u16_t remote_port);

u32_t tcp_next_iss(void);

extern u32_t tcp_ticks;












 
extern struct tcp_pcb_listen *tcp_listen_pcbs;   
extern struct tcp_pcb *tcp_active_pcbs;   


extern struct tcp_pcb *tcp_tw_pcbs;       

extern struct tcp_pcb *tcp_tmp_pcb;       

 






 

# 379 "../../src/include/lwip/tcp.h"






# 395 "../../src/include/lwip/tcp.h"





# 57 "../../src/core/tcp_input.c" 2


# 1 "../../src/include/lwip/stats.h" 1
 











































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





# 59 "../../src/core/tcp_input.c" 2


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


# 61 "../../src/core/tcp_input.c" 2


static struct tcp_seg inseg;

 
static err_t tcp_process(struct tcp_pcb *pcb);
static void tcp_receive(struct tcp_pcb *pcb);
static void tcp_parseopt(struct tcp_pcb *pcb);

 
 






 
void
tcp_input(struct pbuf *p, struct netif *inp)
{
  struct tcp_hdr *tcphdr;
  struct tcp_pcb *pcb, *prev;
  struct ip_hdr *iphdr;
  u8_t offset;
  err_t err;


   ;
  

  ++stats.tcp.recv;


  iphdr = p->payload;
  tcphdr = (struct tcp_hdr *)((u8_t *)p->payload + (((((((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff00) >> 8))  >> 8) & 0x0f)  * 4/sizeof(u8_t));

  pbuf_header(p, -((((((((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff00) >> 8))  >> 8) & 0x0f)  * 4/sizeof(u8_t)));
  
   
  if(((((( &(iphdr->dest) )->addr) & ~((  &(inp->netmask) )->addr)) == (0xffffffff & ~((  &(inp->netmask) )->addr))) || (( &(iphdr->dest) )->addr == 0xffffffff) || (( &(iphdr->dest) )->addr == 0x00000000))  ||
     ((( &(iphdr->dest) )->addr & htonl (0xf0000000)) == htonl (0xe0000000)) ) {
    pbuf_free(p);
    return;
  }

  
   
  if(inet_chksum_pseudo(p, (struct ip_addr *)&(iphdr->src),
			(struct ip_addr *)&(iphdr->dest),
			6 , p->tot_len) != 0) {
     ;






    ++stats.tcp.chkerr;
    ++stats.tcp.drop;


    pbuf_free(p);
    return;
  }

   

  offset = ((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  >> 8)  >> 4;

  pbuf_header(p, -(offset * 4));

   
  tcphdr->src = htons (tcphdr->src);
  tcphdr->dest = htons (tcphdr->dest);
  tcphdr->seqno = htonl (tcphdr->seqno);
  tcphdr->ackno = htonl (tcphdr->ackno);
  tcphdr->wnd = htons (tcphdr->wnd);


   
  
  prev = ((void *)0) ;  
  for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
     ;
     ;
     ;
    if(pcb->remote_port == tcphdr->src &&
       pcb->local_port == tcphdr->dest &&
       (( &(pcb->remote_ip) )->addr == (  &(iphdr->src) )->addr)  &&
       (( &(pcb->local_ip) )->addr == (  &(iphdr->dest) )->addr) ) {
      
       


       ;
      if(prev != ((void *)0) ) {
	prev->next = pcb->next;
	pcb->next = tcp_active_pcbs;
	tcp_active_pcbs = pcb; 
      }
       ;
      break;
    }
    prev = pcb;
  }

   

  if(pcb == ((void *)0) ) {
    for(pcb = tcp_tw_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
       ;
      if(pcb->remote_port == tcphdr->src &&
	 pcb->local_port == tcphdr->dest &&
	 (( &(pcb->remote_ip) )->addr == (  &(iphdr->src) )->addr)  &&
         (( &(pcb->local_ip) )->addr == (  &(iphdr->dest) )->addr) ) {
	 


	break;
      }
    }  
  
   

    prev = ((void *)0) ;  
    if(pcb == ((void *)0) ) {
      for(pcb = (struct tcp_pcb *)tcp_listen_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
	 ;
	if(((( &(pcb->local_ip) ) == ((void *)0)  || ( &(pcb->local_ip) )->addr == 0)  ||
               (( &(pcb->local_ip) )->addr == (  &(iphdr->dest) )->addr) ) &&
	   pcb->local_port == tcphdr->dest) {	  
	   


	  if(prev != ((void *)0) ) {
	    prev->next = pcb->next;
	    pcb->next = (struct tcp_pcb *)tcp_listen_pcbs;
	    tcp_listen_pcbs = (struct tcp_pcb_listen *)pcb; 
	  }
	  break;
	}
	prev = pcb;
      }
    }
  }
  






   

  if(pcb != ((void *)0) ) {
      





    
     
    inseg.next = ((void *)0) ;
    inseg.len = p->tot_len;
    inseg.dataptr = p->payload;
    inseg.p = p;
    inseg.tcphdr = tcphdr;
    
     


     

   

    if(pcb->state != LISTEN && pcb->state != TIME_WAIT) {
      pcb->recv_data = ((void *)0) ;
    }
    err = tcp_process(pcb);
     

    if(err != -3 ) {
      if(pcb->state != LISTEN) {
	if(pcb->flags & 0x08 ) {
	  if(pcb->state != LISTEN) {
	    if(pcb->errf != ((void *)0) ) {
	      pcb->errf(pcb->callback_arg, -4 );
	    }
	  }
	  if(pcb->state == TIME_WAIT) {
	    tcp_pcb_remove(&tcp_tw_pcbs, pcb);
	  } else {
	    tcp_pcb_remove(&tcp_active_pcbs, pcb);      
	  }
	  memp_free(MEMP_TCP_PCB, pcb);
	} else if(pcb->flags & 0x10 ) {
	  tcp_pcb_remove(&tcp_active_pcbs, pcb);
	  memp_free(MEMP_TCP_PCB, pcb);
	} else {
	  if(pcb->state < TIME_WAIT) {
	    err = 0 ;
	     


	    if(pcb->acked > 0 && pcb->sent != ((void *)0) ) {
	      err = pcb->sent(pcb->callback_arg, pcb, pcb->acked);
	    }
	    if(pcb->recv != ((void *)0) ) {
	      if(pcb->recv_data != ((void *)0) ) {
		err = pcb->recv(pcb->callback_arg, pcb, pcb->recv_data, 0 );
	      }
	      if(pcb->flags & 0x20 ) {
		err = pcb->recv(pcb->callback_arg, pcb, ((void *)0) , 0 );
	      }
	    } else {
	      err = 0 ;
	      pbuf_free(pcb->recv_data);
	      if(pcb->flags & 0x20 ) {
		tcp_close(pcb);
	      }
	    }	    
	    if(err == 0 ) {
	      tcp_output(pcb);
	    }
	  } else if(pcb->state == TIME_WAIT) {
	    pbuf_free(pcb->recv_data);	  
	    tcp_output(pcb);
	  }
	}
      }
    }

    pbuf_free(inseg.p);





    
  } else {
     

     ;
    if(!(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x04 )) {

      ++stats.tcp.proterr;
      ++stats.tcp.drop;
      
      tcp_rst(tcphdr->ackno, tcphdr->seqno + p->tot_len +
	      ((((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0),
	      &(iphdr->dest), &(iphdr->src),
	      tcphdr->dest, tcphdr->src);
    }
    pbuf_free(p);
  }

   ;  
   ;
}
 
 






 
static err_t
tcp_process(struct tcp_pcb *pcb)
{
  struct tcp_pcb *npcb;
  struct ip_hdr *iphdr;
  struct tcp_hdr *tcphdr;
  u32_t seqno, ackno;
  u8_t flags;
  u32_t optdata;
  struct tcp_seg *rseg;
  u8_t acceptable = 0;
  
  iphdr = (struct ip_hdr *)((u8_t *)inseg.tcphdr - 20 /sizeof(u8_t));
  tcphdr = inseg.tcphdr;
  flags = ((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff) ;
  seqno = tcphdr->seqno;
  ackno = tcphdr->ackno;


  
   
  if(flags & 0x04 ) {
     
    if(pcb->state != LISTEN) {
      if(pcb->state == SYN_SENT) {
	if(ackno == pcb->snd_nxt) {
	  acceptable = 1;
	}
      } else {
	if(((s32_t)(( seqno )-(  pcb->rcv_nxt )) >= 0)  &&
	   ((s32_t)(( seqno )-(  pcb->rcv_nxt + pcb->rcv_wnd )) <= 0) ) {
	  acceptable = 1;
	}
      }
    }
    if(acceptable) {
       ;
       ;
      pcb->flags |= 0x08 ;
      pcb->flags &= ~0x01 ;
    } else {
       ;

       ;

    }

    return -4 ;
  }

   


  if(pcb->state != LISTEN) {
    pcb->tmr = tcp_ticks;
  }
  
   
  switch(pcb->state) {
  case CLOSED:
     


    break;
  case LISTEN:
     

    if(flags & 0x10 ) {
       

       ;
      tcp_rst(ackno + 1, seqno + (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ,
	      &(iphdr->dest), &(iphdr->src),
	      tcphdr->dest, tcphdr->src);
    } else if(flags & 0x02 ) {
       ;
      npcb = tcp_new();
       


      if(npcb == ((void *)0) ) {

        ++stats.tcp.memerr;

	break;
      }
       
      ( &(npcb->local_ip) )->addr = ((  &(iphdr->dest) ) == 0 ? 0 :	((struct ip_addr *)  &(iphdr->dest) )->addr) ;
      npcb->local_port = pcb->local_port;
      ( &(npcb->remote_ip) )->addr = ((  &(iphdr->src) ) == 0 ? 0 :	((struct ip_addr *)  &(iphdr->src) )->addr) ;
      npcb->remote_port = tcphdr->src;
      npcb->state = SYN_RCVD;
      npcb->rcv_nxt = seqno + 1;
      npcb->snd_wnd = tcphdr->wnd;
      npcb->ssthresh = npcb->snd_wnd;
      npcb->snd_wl1 = tcphdr->seqno;
      npcb->accept = pcb->accept;
      npcb->callback_arg = pcb->callback_arg;

       

      do {   npcb ->next = * &tcp_active_pcbs ; * &tcp_active_pcbs  =   npcb ; } while(0) ;

       
      tcp_parseopt(npcb);
      
       
      optdata = (((((u32_t)( ((u32_t)2 << 24) | 
		      ((u32_t)4 << 16) | 
		      (((u32_t)npcb->mss / 256) << 8) |
		      (npcb->mss & 255) ) & 0xff)) << 24) | ((((u32_t)( ((u32_t)2 << 24) |  		      ((u32_t)4 << 16) |  		      (((u32_t)npcb->mss / 256) << 8) | 		      (npcb->mss & 255) ) & 0xff00)) << 8) | ((((u32_t)( ((u32_t)2 << 24) |  		      ((u32_t)4 << 16) |  		      (((u32_t)npcb->mss / 256) << 8) | 		      (npcb->mss & 255) ) & 0xff0000)) >> 8) | ((((u32_t)( ((u32_t)2 << 24) |  		      ((u32_t)4 << 16) |  		      (((u32_t)npcb->mss / 256) << 8) | 		      (npcb->mss & 255) ) & 0xff000000)) >> 24)) ;
       
      tcp_enqueue(npcb, ((void *)0) , 0, 0x02  | 0x10 , 0, (u8_t *)&optdata, 4);
      return tcp_output(npcb);
    }  
    break;
  case SYN_SENT:
     ;

    if(flags & 0x10  &&
       flags & 0x02  &&
       ackno == htonl (pcb->unacked->tcphdr->seqno) + 1) {
      pcb->rcv_nxt = seqno + 1;
      pcb->lastack = ackno;
      pcb->rcv_wnd = tcphdr->wnd;
      pcb->state = ESTABLISHED;
      pcb->cwnd = pcb->mss;
      --pcb->snd_queuelen;
       ;
      rseg = pcb->unacked;
      pcb->unacked = rseg->next;
      tcp_seg_free(rseg);

       
      tcp_parseopt(pcb);

       

      if(pcb->connected != ((void *)0) ) {
	pcb->connected(pcb->callback_arg, pcb, 0 );
      }
      if(( pcb )->flags & 0x01 ) { ( pcb )->flags |= 0x02 ; tcp_output( pcb ); } else { ( pcb )->flags |= 0x01 ; } ;
    }    
    break;
  case SYN_RCVD:
    if(flags & 0x10  &&
       !(flags & 0x04 )) {
      if(((s32_t)(( pcb->lastack )-(  ackno )) < 0)  &&
	 ((s32_t)(( ackno )-(  pcb->snd_nxt )) <= 0) ) {
        pcb->state = ESTABLISHED;
         ;
	 
        if(pcb->accept != ((void *)0) ) {
          if(pcb->accept(pcb->callback_arg, pcb, 0 ) != 0 ) {
	     

	    tcp_abort(pcb);
	    break;
	  }
        } else {
	   




	  tcp_abort(pcb);
	  break;
	}
	 

	tcp_receive(pcb);	
        pcb->cwnd = pcb->mss;
      }	
    }  
    break;
  case CLOSE_WAIT:
  case ESTABLISHED:
    tcp_receive(pcb);	  
    if(flags & 0x01 ) {
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
      pcb->state = CLOSE_WAIT;
    }
    break;
  case FIN_WAIT_1:
    tcp_receive(pcb);
    if(flags & 0x01 ) {
      if(flags & 0x10  && ackno == pcb->snd_nxt) {
         ;

	( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
	tcp_pcb_purge(pcb);
	do { if(* &tcp_active_pcbs  ==   pcb ) { * &tcp_active_pcbs  = (* &tcp_active_pcbs )->next; } else for(tcp_tmp_pcb = * &tcp_active_pcbs ; tcp_tmp_pcb != ((void *)0) ; tcp_tmp_pcb = tcp_tmp_pcb->next) { if(tcp_tmp_pcb->next != ((void *)0)  && tcp_tmp_pcb->next ==   pcb ) { tcp_tmp_pcb->next =   pcb ->next; break; } }   pcb ->next = ((void *)0) ; } while(0) ;
	pcb->state = TIME_WAIT;
	 
	do {   pcb ->next = * &tcp_tw_pcbs ; * &tcp_tw_pcbs  =   pcb ; } while(0) ;
      } else {
	( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
	pcb->state = CLOSING;
      }
    } else if(flags & 0x10  && ackno == pcb->snd_nxt) {
      pcb->state = FIN_WAIT_2;
    }
    break;
  case FIN_WAIT_2:
    tcp_receive(pcb);
    if(flags & 0x01 ) {
       ;
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
      tcp_pcb_purge(pcb);
      do { if(* &tcp_active_pcbs  ==   pcb ) { * &tcp_active_pcbs  = (* &tcp_active_pcbs )->next; } else for(tcp_tmp_pcb = * &tcp_active_pcbs ; tcp_tmp_pcb != ((void *)0) ; tcp_tmp_pcb = tcp_tmp_pcb->next) { if(tcp_tmp_pcb->next != ((void *)0)  && tcp_tmp_pcb->next ==   pcb ) { tcp_tmp_pcb->next =   pcb ->next; break; } }   pcb ->next = ((void *)0) ; } while(0) ;
       
      pcb->state = TIME_WAIT;
      do {   pcb ->next = * &tcp_tw_pcbs ; * &tcp_tw_pcbs  =   pcb ; } while(0) ;
    }
    break;
  case CLOSING:
    tcp_receive(pcb);
    if(flags & 0x10  && ackno == pcb->snd_nxt) {
       ;
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
      tcp_pcb_purge(pcb);
      do { if(* &tcp_active_pcbs  ==   pcb ) { * &tcp_active_pcbs  = (* &tcp_active_pcbs )->next; } else for(tcp_tmp_pcb = * &tcp_active_pcbs ; tcp_tmp_pcb != ((void *)0) ; tcp_tmp_pcb = tcp_tmp_pcb->next) { if(tcp_tmp_pcb->next != ((void *)0)  && tcp_tmp_pcb->next ==   pcb ) { tcp_tmp_pcb->next =   pcb ->next; break; } }   pcb ->next = ((void *)0) ; } while(0) ;
       
      pcb->state = TIME_WAIT;
      do {   pcb ->next = * &tcp_tw_pcbs ; * &tcp_tw_pcbs  =   pcb ; } while(0) ;
    }
    break;
  case LAST_ACK:
    tcp_receive(pcb);
    if(flags & 0x10  && ackno == pcb->snd_nxt) {
       ;
      pcb->state = CLOSED;
      pcb->flags |= 0x10 ;
    }
    break;
  case TIME_WAIT:
    if(((s32_t)(( seqno + (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  )-(  pcb->rcv_nxt )) > 0) ) {
      pcb->rcv_nxt = seqno + (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
    }
    if((( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  > 0) {
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
    }
    break;
  }
  
  return 0 ;
}

 
 










 
 

static void
tcp_receive(struct tcp_pcb *pcb)
{
  struct tcp_seg *next, *prev, *cseg;
  struct pbuf *p;
  u32_t ackno, seqno;
  s32_t off;
  int m;

  ackno = inseg.tcphdr->ackno;
  seqno = inseg.tcphdr->seqno;
      
      
  if(((((((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x10 ) {
     
    if(((s32_t)(( pcb->snd_wl1 )-(  seqno )) < 0)  ||
       (pcb->snd_wl1 == seqno && ((s32_t)(( pcb->snd_wl2 )-(  ackno )) < 0) ) ||
       (pcb->snd_wl2 == ackno && inseg.tcphdr->wnd > pcb->snd_wnd)) {
      pcb->snd_wnd = inseg.tcphdr->wnd;
      pcb->snd_wl1 = seqno;
      pcb->snd_wl2 = ackno;
       ;







    }
    

    if(pcb->lastack == ackno) {
      ++pcb->dupacks;
      if(pcb->dupacks >= 3 && pcb->unacked != ((void *)0) ) {
        if(!(pcb->flags & 0x04 )) {
           
           ;


          tcp_rexmit_seg(pcb, pcb->unacked);
           
          pcb->ssthresh = (( (pcb->snd_max -
                                pcb->lastack) / 2 ) > ( 
                               2 * pcb->mss ) ? ( (pcb->snd_max -                                 pcb->lastack) / 2 ) : (                                 2 * pcb->mss )) ;

          pcb->cwnd = pcb->ssthresh + 3 * pcb->mss;
          pcb->flags |= 0x04 ;          
        } else {
	   

	  if(pcb->cwnd + pcb->mss > pcb->cwnd) {
	    pcb->cwnd += pcb->mss;
	  }
	  
        }
      }
    } else if(((s32_t)(( pcb->lastack )-(  ackno )) < 0)  &&
              ((s32_t)(( ackno )-(  pcb->snd_max )) <= 0) ) {
       

       


      if(pcb->flags & 0x04 ) {
	pcb->flags &= ~0x04 ;
	pcb->cwnd = pcb->ssthresh;
      }

       
      pcb->nrtx = 0;
       
      pcb->rto = (pcb->sa >> 3) + pcb->sv;
      
       
      pcb->acked = ackno - pcb->lastack;
      pcb->snd_buf += pcb->acked;

       
      pcb->dupacks = 0;
      pcb->lastack = ackno;

      
       

      if(pcb->state >= ESTABLISHED) {
        if(pcb->cwnd < pcb->ssthresh) {
	  if(pcb->cwnd + pcb->mss > pcb->cwnd) {
	    pcb->cwnd += pcb->mss;
	  }
           ;
        } else {
	  if(pcb->cwnd + pcb->mss * pcb->mss / pcb->cwnd > pcb->cwnd) {
	    pcb->cwnd += pcb->mss * pcb->mss / pcb->cwnd;
	  }
           ;
        }
      }
       ;






       





      while(pcb->unsent != ((void *)0)  && 
	    ((s32_t)(( htonl (pcb->unsent->tcphdr->seqno) + (( pcb->unsent )->len + ((((((((u16_t)( ( ( pcb->unsent )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( pcb->unsent )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( pcb->unsent )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( pcb->unsent )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  )-( 
                        ackno )) <= 0) ) {
	 ;




	next = pcb->unsent;
	pcb->unsent = pcb->unsent->next;
	 ;
	pcb->snd_queuelen -= pbuf_clen(next->p);
	tcp_seg_free(next);
	 ;






	
        if(pcb->unsent != ((void *)0) ) {
          pcb->snd_nxt = htonl(pcb->unsent->tcphdr->seqno);
        }
      }
      
       

      while(pcb->unacked != ((void *)0)  && 
	    ((s32_t)(( htonl (pcb->unacked->tcphdr->seqno) +
			(( pcb->unacked )->len + ((((((((u16_t)( ( ( pcb->unacked )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( pcb->unacked )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( pcb->unacked )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( pcb->unacked )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  )-(  ackno )) <= 0) ) {
	 ;




	next = pcb->unacked;
	pcb->unacked = pcb->unacked->next;
	 ;
	pcb->snd_queuelen -= pbuf_clen(next->p);
	tcp_seg_free(next);

	 ;






      }
      pcb->polltmr = 0;
    }
     
    
     ;

    
     


    if(pcb->rttest && ((s32_t)(( pcb->rtseq )-(  ackno )) < 0) ) {
      m = tcp_ticks - pcb->rttest;

       ;


             
      m = m - (pcb->sa >> 3);
      pcb->sa += m;
      if(m < 0) {
	m = -m;
      }
      m = m - (pcb->sv >> 2);
      pcb->sv += m;
      pcb->rto = (pcb->sa >> 3) + pcb->sv;
      
       ;


      pcb->rttest = 0;
    } 
  }
  
   

  if((( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  > 0) {
     























     



    if(((s32_t)(( seqno )-(  pcb->rcv_nxt )) < 0)  &&
       ((s32_t)(( pcb->rcv_nxt )-(  seqno + inseg.len )) < 0) ) {
       


















      off = pcb->rcv_nxt - seqno;
      if(inseg.p->len < off) {
	p = inseg.p;
	while(p->len < off) {
	  off -= p->len;
	  inseg.p->tot_len -= p->len;
	  p->len = 0;
	  p = p->next;
	}
	pbuf_header(p, -off);
	 
	 
      } else {
	pbuf_header(inseg.p, -off);
      }
      inseg.dataptr = inseg.p->payload;
      inseg.len -= pcb->rcv_nxt - seqno;      
      inseg.tcphdr->seqno = seqno = pcb->rcv_nxt;
    }

     


    if(((s32_t)(( seqno )-(  pcb->rcv_nxt )) >= 0)  &&
       ((s32_t)(( seqno )-(  pcb->rcv_nxt + pcb->rcv_wnd )) < 0) ) {
      if(pcb->rcv_nxt == seqno) {			
	 



	if(pcb->ooseq != ((void *)0)  &&
	   ((s32_t)(( pcb->ooseq->tcphdr->seqno )-(  seqno + inseg.len )) <= 0) ) {
	   

	  inseg.len = pcb->ooseq->tcphdr->seqno - seqno;
	  pbuf_realloc(inseg.p, inseg.len);
	}


	pcb->rcv_nxt += (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
	
	 
	if(pcb->rcv_wnd < (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ) {
	  pcb->rcv_wnd = 0;
	} else {
	  pcb->rcv_wnd -= (( &inseg )->len + ((((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( &inseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
	}
	
	 







      
	if(inseg.p->tot_len > 0) {
	  pcb->recv_data = inseg.p;
	   


	  inseg.p = ((void *)0) ;
	}
	if(((((((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01 ) {
	   ;
	  pcb->flags |= 0x20 ;
	}
	

	 

	while(pcb->ooseq != ((void *)0)  &&
	      pcb->ooseq->tcphdr->seqno == pcb->rcv_nxt) {

	  cseg = pcb->ooseq;
	  seqno = pcb->ooseq->tcphdr->seqno;
	  
	  pcb->rcv_nxt += (( cseg )->len + ((((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
	  if(pcb->rcv_wnd < (( cseg )->len + ((((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ) {
	    pcb->rcv_wnd = 0;
	  } else {
	    pcb->rcv_wnd -= (( cseg )->len + ((((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( cseg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
	  }
	  if(cseg->p->tot_len > 0) {
	     

	    pbuf_chain(pcb->recv_data, cseg->p);
	    cseg->p = ((void *)0) ;
	  }
	  if(((((((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01 ) {
	     ;
	    pcb->flags |= 0x20 ;
	  }	    
	  

	  pcb->ooseq = cseg->next;
	  tcp_seg_free(cseg);
	}



	 
	if(( pcb )->flags & 0x01 ) { ( pcb )->flags |= 0x02 ; tcp_output( pcb ); } else { ( pcb )->flags |= 0x01 ; } ;

      } else {
	 
	( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;

	 
	if(pcb->ooseq == ((void *)0) ) {
	  pcb->ooseq = tcp_seg_copy(&inseg);
	} else {
	   











	  prev = ((void *)0) ;
	  for(next = pcb->ooseq; next != ((void *)0) ; next = next->next) {
	    if(seqno == next->tcphdr->seqno) {
	       



	      if(inseg.len > next->len) {
		 


		cseg = tcp_seg_copy(&inseg);
		if(cseg != ((void *)0) ) {
		  cseg->next = next->next;
		  if(prev != ((void *)0) ) {
		    prev->next = cseg;
		  } else {
		    pcb->ooseq = cseg;
		  }
		}
		break;
	      } else {
		 


		break;
	      } 
	    } else {
	      if(prev == ((void *)0) ) {
		if(((s32_t)(( seqno )-(  next->tcphdr->seqno )) < 0) ) {
		   



		  
		  if(((s32_t)(( seqno + inseg.len )-(  next->tcphdr->seqno )) > 0) ) {
		     
		    inseg.len = next->tcphdr->seqno - seqno;
		    pbuf_realloc(inseg.p, inseg.len);
		  }
		  cseg = tcp_seg_copy(&inseg);
		  if(cseg != ((void *)0) ) {
		    cseg->next = next;
		    pcb->ooseq = cseg;
		  }
		  break;
		}
	      } else if(((s32_t)(( prev->tcphdr->seqno )-(  seqno )) < 0)  &&
		 ((s32_t)(( seqno )-(  next->tcphdr->seqno )) < 0) ) {
		 




		if(((s32_t)(( seqno + inseg.len )-(  next->tcphdr->seqno )) > 0) ) {
		   
		  inseg.len = next->tcphdr->seqno - seqno;
		  pbuf_realloc(inseg.p, inseg.len);
		}

		cseg = tcp_seg_copy(&inseg);
		if(cseg != ((void *)0) ) {		 		  
		  cseg->next = next;
		  prev->next = cseg;
		  if(((s32_t)(( prev->tcphdr->seqno + prev->len )-(  seqno )) > 0) ) {
		     
		    prev->len = seqno - prev->tcphdr->seqno;
		    pbuf_realloc(prev->p, prev->len);
		  }
		}
		break;
		}
	       


	      if(next->next == ((void *)0)  &&
		 ((s32_t)(( seqno )-(  next->tcphdr->seqno )) > 0) ) {
		next->next = tcp_seg_copy(&inseg);
		if(next->next != ((void *)0) ) {		
		  if(((s32_t)(( next->tcphdr->seqno + next->len )-(  seqno )) > 0) ) {
		     
		    next->len = seqno - next->tcphdr->seqno;
		    pbuf_realloc(next->p, next->len);
		  }
		}
		break;
	      }
	    }
	    prev = next;
	  }    
	} 

	     
      }    
    }
  } else {
     

    if(((s32_t)(( pcb->rcv_nxt )-(  seqno )) > 0)  ||
       ((s32_t)(( seqno )-(  pcb->rcv_nxt + pcb->rcv_wnd )) >= 0) ) {
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
    }      
  }
}
 
 






 
static void
tcp_parseopt(struct tcp_pcb *pcb)
{
  u8_t c;
  u8_t *opts, opt;
  u16_t mss;

  opts = (u8_t *)inseg.tcphdr + 20 ;
  
   
  if((((((((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff00) >> 8))  >> 8)  & 0xf0) > 0x50) {
    for(c = 0; c < ((((((((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( inseg.tcphdr )->_offset_flags ) & 0xff00) >> 8))  >> 8)  >> 4) - 5) << 2 ;) {
      opt = opts[c];
      if(opt == 0x00) {
            
	break;
      } else if(opt == 0x01) {
        ++c;
         
      } else if(opt == 0x02 &&
                opts[c + 1] == 0x04) {
                
        mss = (opts[c + 2] << 8) | opts[c + 3];
        pcb->mss = mss > 128 ? 128 : mss;
        
         
        break;
      } else {
	if(opts[c + 1] == 0) {
           

          break;
        }
         

        c += opts[c + 1];
      }      
    }
  }
}
 
  
