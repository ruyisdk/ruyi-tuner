# 1 "../../src/core/udp.c"
 


































 
 




 
# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 43 "../../src/core/udp.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 45 "../../src/core/udp.c" 2

# 1 "../../src/include/lwip/memp.h" 1
 






































# 1 "../../src/arch/unix/include/arch/cc.h" 1
 




































typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
 

typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   long    u32_t;
typedef signed     long    s32_t;








# 40 "../../src/include/lwip/memp.h" 2

# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 41 "../../src/include/lwip/memp.h" 2


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





	  
# 46 "../../src/core/udp.c" 2

# 1 "../../src/include/ipv4/lwip/inet.h" 1
 




































# 1 "../../src/include/lwip/arch.h" 1
 












































# 1 "../../src/arch/unix/include/arch/cpu.h" 1
 









































# 46 "../../src/include/lwip/arch.h" 2
















# 38 "../../src/include/ipv4/lwip/inet.h" 2


# 1 "../../src/include/lwip/opt.h" 1
 






































 

























































# 40 "../../src/include/ipv4/lwip/inet.h" 2

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

# 1 "../../src/include/ipv4/lwip/ip_addr.h" 1
 










































 
struct ip_addr {
   u32_t addr  __attribute__((packed)) ;
} __attribute__((packed)) ;
 

extern struct ip_addr ip_addr_broadcast;






















				   



















# 42 "../../src/include/ipv4/lwip/inet.h" 2


u16_t inet_chksum(void *dataptr, u16_t len);
u16_t inet_chksum_pbuf(struct pbuf *p);
u16_t inet_chksum_pseudo(struct pbuf *p,
			 struct ip_addr *src, struct ip_addr *dest,
			 u8_t proto, u16_t proto_len);































































u16_t htons(u16_t n);
u32_t htonl(u32_t n);









# 47 "../../src/core/udp.c" 2

# 1 "../../src/include/lwip/netif.h" 1
 






































# 1 "../../src/include/lwip/err.h" 1
 








































typedef s8_t err_t;

 



























# 40 "../../src/include/lwip/netif.h" 2








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


# 48 "../../src/core/udp.c" 2

# 1 "../../src/include/lwip/udp.h" 1
 








































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




























# 42 "../../src/include/lwip/udp.h" 2






struct udp_hdr {
   u16_t src  __attribute__((packed)) ;
   u16_t dest  __attribute__((packed)) ;   
   u16_t len  __attribute__((packed)) ;
   u16_t chksum  __attribute__((packed)) ;
} __attribute__((packed)) ;




struct udp_pcb {
  struct udp_pcb *next;

  struct ip_addr local_ip, remote_ip;
  u16_t local_port, remote_port;
  
  u8_t flags;
  u16_t chksum_len;
  
  void (* recv)(void *arg, struct udp_pcb *pcb, struct pbuf *p,
		struct ip_addr *addr, u16_t port);
  void *recv_arg;  
};

 

struct udp_pcb * udp_new        (void);
void             udp_remove     (struct udp_pcb *pcb);
err_t            udp_bind       (struct udp_pcb *pcb, struct ip_addr *ipaddr,
				 u16_t port);
err_t            udp_connect    (struct udp_pcb *pcb, struct ip_addr *ipaddr,
				 u16_t port);
void             udp_recv       (struct udp_pcb *pcb,
				 void (* recv)(void *arg, struct udp_pcb *upcb,
					       struct pbuf *p,
					       struct ip_addr *addr,
					       u16_t port),
				 void *recv_arg);
err_t            udp_send       (struct udp_pcb *pcb, struct pbuf *p);





 
u8_t             udp_lookup     (struct ip_hdr *iphdr, struct netif *inp);
void             udp_input      (struct pbuf *p, struct netif *inp);
void             udp_init       (void);





# 49 "../../src/core/udp.c" 2

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








	  
# 50 "../../src/core/udp.c" 2


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





# 52 "../../src/core/udp.c" 2


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


# 54 "../../src/core/udp.c" 2


 

 
static struct udp_pcb *udp_pcbs = ((void *)0) ;

static struct udp_pcb *pcb_cache = ((void *)0) ;




	  
 
void
udp_init(void)
{
}
 
 




 
# 137 "../../src/core/udp.c"

 
void
udp_input(struct pbuf *p, struct netif *inp)
{
  struct udp_hdr *udphdr;  
  struct udp_pcb *pcb;
  struct ip_hdr *iphdr;
  u16_t src, dest;
  
   ;
  

  ++stats.udp.recv;


  iphdr = p->payload;

  pbuf_header(p, -(8  + (((((((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff00) >> 8))  >> 8) & 0x0f)  * 4));

  udphdr = (struct udp_hdr *)((u8_t *)p->payload - 8 );
  
   ;
	
  src = (((((u16_t)( udphdr->src ) & 0xff)) << 8) | (((u16_t)( udphdr->src ) & 0xff00) >> 8)) ;
  dest = (((((u16_t)( udphdr->dest ) & 0xff)) << 8) | (((u16_t)( udphdr->dest ) & 0xff00) >> 8)) ;




  
   
  for(pcb = udp_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
     ;

    if(pcb->remote_port == src &&
       pcb->local_port == dest &&
       ((( &pcb->remote_ip ) == ((void *)0)  || ( &pcb->remote_ip )->addr == 0)  ||
	(( &(pcb->remote_ip) )->addr == (  &(iphdr->src) )->addr) ) &&
       ((( &pcb->local_ip ) == ((void *)0)  || ( &pcb->local_ip )->addr == 0)  ||
	(( &(pcb->local_ip) )->addr == (  &(iphdr->dest) )->addr) )) {
      break;
    }
  }

  if(pcb == ((void *)0) ) {
    for(pcb = udp_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
       ;

      if(pcb->local_port == dest &&
	 ((( &pcb->remote_ip ) == ((void *)0)  || ( &pcb->remote_ip )->addr == 0)  ||
	  (( &(pcb->remote_ip) )->addr == (  &(iphdr->src) )->addr) ) &&
	 ((( &pcb->local_ip ) == ((void *)0)  || ( &pcb->local_ip )->addr == 0)  ||
	  (( &(pcb->local_ip) )->addr == (  &(iphdr->dest) )->addr) )) {
	break;
      }      
    }
  }


   
   

  if(pcb != ((void *)0) ) {
     ;
    pbuf_header(p, 8 );    



    if(((((((u16_t)( ( iphdr )->_ttl_proto ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_ttl_proto ) & 0xff00) >> 8))  & 0xff)  == 170 ) {    

       
      if(inet_chksum_pseudo(p, (struct ip_addr *)&(iphdr->src),
			    (struct ip_addr *)&(iphdr->dest),
			    170 , htons (udphdr->len)) != 0) {
	 ;

	++stats.udp.chkerr;
	++stats.udp.drop;

	pbuf_free(p);
	goto end;
      }
    } else {
      if(udphdr->chksum != 0) {
	if(inet_chksum_pseudo(p, (struct ip_addr *)&(iphdr->src),
			      (struct ip_addr *)&(iphdr->dest),
			      17 , p->tot_len) != 0) {
	   ;
	  

	  ++stats.udp.chkerr;
	  ++stats.udp.drop;

	  pbuf_free(p);
	  goto end;
	}
      }
    }
    pbuf_header(p, - 8 );    
    if(pcb != ((void *)0) ) {
      pcb->recv(pcb->recv_arg, pcb, p, &(iphdr->src), src);
    } else {
       ;
      
       

      
      if(! ((((( &iphdr->dest )->addr) & ~((  &inp->netmask )->addr)) == (0xffffffff & ~((  &inp->netmask )->addr))) || (( &iphdr->dest )->addr == 0xffffffff) || (( &iphdr->dest )->addr == 0x00000000))  &&
	 ! ((( &iphdr->dest )->addr & htonl (0xf0000000)) == htonl (0xe0000000)) ) {
	
	 
	udphdr->src = htons(udphdr->src);
	udphdr->dest = htons(udphdr->dest); 
	
	 
	p->payload = iphdr;
	icmp_dest_unreach(p, ICMP_DUR_PORT);
      }

      ++stats.udp.proterr;
      ++stats.udp.drop;

      pbuf_free(p);
    }
  } else {
    pbuf_free(p);
  }
  end:
    
   ;
}
 
err_t
udp_send(struct udp_pcb *pcb, struct pbuf *p)
{
  struct udp_hdr *udphdr;
  struct netif *netif;
  struct ip_addr *src_ip;
  err_t err;
  struct pbuf *q;
  
  if(pbuf_header(p, 8 )) {
    q = pbuf_alloc(PBUF_IP, 8 , PBUF_RAM);
    if(q == ((void *)0) ) {
      return -1 ;
    }
    pbuf_chain(q, p);
    p = q;
  }

  udphdr = p->payload;
  udphdr->src = htons(pcb->local_port);
  udphdr->dest = htons(pcb->remote_port);
  udphdr->chksum = 0x0000;

  if((netif = ip_route(&(pcb->remote_ip))) == ((void *)0) ) {
     ;

    ++stats.udp.rterr;

    return -9 ;
  }

  if((( &pcb->local_ip ) == ((void *)0)  || ( &pcb->local_ip )->addr == 0) ) {
    src_ip = &(netif->ip_addr);
  } else {
    src_ip = &(pcb->local_ip);
  }
  
   ;
  
  if(pcb->flags & 0x02 ) {
    udphdr->len = htons(pcb->chksum_len);
     
    udphdr->chksum = inet_chksum_pseudo(p, src_ip, &(pcb->remote_ip),
					17 , pcb->chksum_len);
    if(udphdr->chksum == 0x0000) {
      udphdr->chksum = 0xffff;
    }
    err = ip_output_if(p, src_ip, &pcb->remote_ip, 255 , 170 , netif);    
  } else {
    udphdr->len = htons(p->tot_len);
     
    if((pcb->flags & 0x01 ) == 0) {
      udphdr->chksum = inet_chksum_pseudo(p, src_ip, &pcb->remote_ip,
					  17 , p->tot_len);
      if(udphdr->chksum == 0x0000) {
	udphdr->chksum = 0xffff;
      }
    }
    err = ip_output_if(p, src_ip, &pcb->remote_ip, 255 , 17 , netif);    
  }
  

  ++stats.udp.xmit;

  return err;
}
 
err_t
udp_bind(struct udp_pcb *pcb, struct ip_addr *ipaddr, u16_t port)
{
  struct udp_pcb *ipcb;
  ( &pcb->local_ip )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
  pcb->local_port = port;

   
  for(ipcb = udp_pcbs; ipcb != ((void *)0) ; ipcb = ipcb->next) {
    if(pcb == ipcb) {
       
      return 0 ;
    }
  }
   
  pcb->next = udp_pcbs;
  udp_pcbs = pcb;

   ;
  return 0 ;
}
 
err_t
udp_connect(struct udp_pcb *pcb, struct ip_addr *ipaddr, u16_t port)
{
  struct udp_pcb *ipcb;
  ( &pcb->remote_ip )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
  pcb->remote_port = port;

   
  for(ipcb = udp_pcbs; ipcb != ((void *)0) ; ipcb = ipcb->next) {
    if(pcb == ipcb) {
       
      return 0 ;
    }
  }
   
  pcb->next = udp_pcbs;
  udp_pcbs = pcb;
  return 0 ;
}
 
void
udp_recv(struct udp_pcb *pcb,
	 void (* recv)(void *arg, struct udp_pcb *upcb, struct pbuf *p,
		       struct ip_addr *addr, u16_t port),
	 void *recv_arg)
{
  pcb->recv = recv;
  pcb->recv_arg = recv_arg;
}
 
void
udp_remove(struct udp_pcb *pcb)
{
  struct udp_pcb *pcb2;
  
  if(udp_pcbs == pcb) {
    udp_pcbs = udp_pcbs->next;
  } else for(pcb2 = udp_pcbs; pcb2 != ((void *)0) ; pcb2 = pcb2->next) {
    if(pcb2->next != ((void *)0)  && pcb2->next == pcb) {
      pcb2->next = pcb->next;
    }
  }

  memp_free(MEMP_UDP_PCB, pcb);  
}
 
struct udp_pcb *
udp_new(void) {
  struct udp_pcb *pcb;
  pcb = memp_malloc(MEMP_UDP_PCB);
  if(pcb != ((void *)0) ) {
    bzero(pcb, sizeof(struct udp_pcb));
    return pcb;
  }
  return ((void *)0) ;

}
 
# 431 "../../src/core/udp.c"

 










