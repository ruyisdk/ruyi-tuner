# 1 "../../src/core/tcp_output.c"
 


































 
 




 

# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 44 "../../src/core/tcp_output.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 46 "../../src/core/tcp_output.c" 2

# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 47 "../../src/core/tcp_output.c" 2




# 1 "../../src/include/lwip/mem.h" 1
 






































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













# 51 "../../src/core/tcp_output.c" 2

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





	  
# 52 "../../src/core/tcp_output.c" 2

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


# 53 "../../src/core/tcp_output.c" 2


# 1 "../../src/include/lwip/netif.h" 1
 






































# 1 "../../src/include/lwip/err.h" 1
 








































typedef s8_t err_t;

 



























# 40 "../../src/include/lwip/netif.h" 2


# 1 "../../src/include/ipv4/lwip/ip_addr.h" 1
 










































 
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


# 55 "../../src/core/tcp_output.c" 2



# 1 "../../src/include/lwip/tcp.h" 1
 









































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





# 58 "../../src/core/tcp_output.c" 2


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





# 60 "../../src/core/tcp_output.c" 2







 
static void tcp_output_segment(struct tcp_seg *seg, struct tcp_pcb *pcb);


 
err_t
tcp_send_ctrl(struct tcp_pcb *pcb, u8_t flags)
{
  return tcp_enqueue(pcb, ((void *)0) , 0, flags, 1, ((void *)0) , 0);

}
 
err_t
tcp_write(struct tcp_pcb *pcb, const void *arg, u16_t len, u8_t copy)
{
  if(pcb->state == SYN_SENT ||
     pcb->state == SYN_RCVD ||
     pcb->state == ESTABLISHED ||
     pcb->state == CLOSE_WAIT) {
    if(len > 0) {
      return tcp_enqueue(pcb, (void *)arg, len, 0, copy, ((void *)0) , 0);
    }
    return 0 ;
  } else {
    return -6 ;
  }
}
 
err_t
tcp_enqueue(struct tcp_pcb *pcb, void *arg, u16_t len,
	    u8_t flags, u8_t copy,
            u8_t *optdata, u8_t optlen)
{
  struct pbuf *p;
  struct tcp_seg *seg, *useg, *queue;
  u32_t left, seqno;
  u16_t seglen;
  void *ptr;
  u8_t queuelen;

  left = len;
  ptr = arg;
  
  if(len > pcb->snd_buf) {
     ;
    return -1 ;
  }
  
  seqno = pcb->snd_lbb;
  
  queue = ((void *)0) ;
   ;
  queuelen = pcb->snd_queuelen;
  if(queuelen >= 4 * 256 / 128  ) {
     ;
    goto memerr;
  }   
  






  
  seg = ((void *)0) ;
  seglen = 0;
  
  while(queue == ((void *)0)  || left > 0) {
    
    seglen = left > pcb->mss? pcb->mss: left;
    
     
    seg = memp_malloc(MEMP_TCP_SEG);
    if(seg == ((void *)0) ) {
       ;
      goto memerr;
    }
    seg->next = ((void *)0) ;
    seg->p = ((void *)0) ;
    
    
    if(queue == ((void *)0) ) {
      queue = seg;
    } else {
      for(useg = queue; useg->next != ((void *)0) ; useg = useg->next);
      useg->next = seg;
    }
      
     



    if(optdata != ((void *)0) ) {
      if((seg->p = pbuf_alloc(PBUF_TRANSPORT, optlen, PBUF_RAM)) == ((void *)0) ) {
	goto memerr;
      }
      ++queuelen;
      seg->dataptr = seg->p->payload;
    } else if(copy) {
      if((seg->p = pbuf_alloc(PBUF_TRANSPORT, seglen, PBUF_RAM)) == ((void *)0) ) {
	 ;	  
	goto memerr;
      }
      ++queuelen;
      if(arg != ((void *)0) ) {
	bcopy(ptr, seg->p->payload, seglen);
      }
      seg->dataptr = seg->p->payload;
    } else {
       
      if((p = pbuf_alloc(PBUF_TRANSPORT, seglen, PBUF_ROM)) == ((void *)0) ) {
	 ;	  	  
	goto memerr;
      }
      ++queuelen;
      p->payload = ptr;
      seg->dataptr = ptr;
      if((seg->p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_RAM)) == ((void *)0) ) {
	pbuf_free(p);
	 ;		  
	goto memerr;
      }
      ++queuelen;
      pbuf_chain(seg->p, p);
    }
    if(queuelen > 4 * 256 / 128  ) {
       ; 	
      goto memerr;
    }
      
    seg->len = seglen;
     


      
     
    if(pbuf_header(seg->p, 20 )) {
	
       ;
	

      ++stats.tcp.err;

      goto memerr;
    }
    seg->tcphdr = seg->p->payload;
    seg->tcphdr->src = htons(pcb->local_port);
    seg->tcphdr->dest = htons(pcb->remote_port);
    seg->tcphdr->seqno = htonl(seqno);
    seg->tcphdr->urgp = 0;
    ( seg->tcphdr )->_offset_flags = (((((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  flags ) ) & 0xff)) << 8) | (((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  flags ) ) & 0xff00) >> 8))  ;
     
      
    if(optdata == ((void *)0) ) {
      ( seg->tcphdr )->_offset_flags = (((((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff)) << 8) | (((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff00) >> 8))  ;
    } else {
      ( seg->tcphdr )->_offset_flags = (((((u16_t)( ((  (5 + optlen / 4) << 4 ) << 8) | ((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff)) << 8) | (((u16_t)( ((  (5 + optlen / 4) << 4 ) << 8) | ((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff00) >> 8))  ;
       


      bcopy(optdata, seg->dataptr, optlen);
    }
     ;




    left -= seglen;
    seqno += seglen;
    ptr = (void *)((char *)ptr + seglen);
  }

    
       
  if(pcb->unsent == ((void *)0) ) {
    useg = ((void *)0) ;
  } else {
    for(useg = pcb->unsent; useg->next != ((void *)0) ; useg = useg->next);
  }
    
   

  if(useg != ((void *)0)  &&
     (( useg )->len + ((((((((u16_t)( ( ( useg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( useg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( useg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( useg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  != 0 &&
     !(((((((u16_t)( ( useg->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( useg->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & (0x02  | 0x01 )) &&
     !(flags & (0x02  | 0x01 )) &&
     useg->len + queue->len <= pcb->mss) {
     
    pbuf_header(queue->p, - 20 );
    pbuf_chain(useg->p, queue->p);
    useg->len += queue->len;
    useg->next = queue->next;
      
     ;
    if(seg == queue) {
      seg = ((void *)0) ;
    }
    memp_free(MEMP_TCP_SEG, queue);
  } else {      
    if(useg == ((void *)0) ) {
      pcb->unsent = queue;
    } else {
      useg->next = queue;
    }
  }
  if((flags & 0x02 ) || (flags & 0x01 )) {
    ++len;
  }
  pcb->snd_lbb += len;
  pcb->snd_buf -= len;
  pcb->snd_queuelen = queuelen;
   ;







    
   

  if(seg != ((void *)0)  && seglen > 0 && seg->tcphdr != ((void *)0) ) {
    ( seg->tcphdr )->_offset_flags = (((((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  ((((((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  | 0x08  ) ) & 0xff)) << 8) | (((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  ((((((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  | 0x08  ) ) & 0xff00) >> 8))  ;
  }
  
  return 0 ;
 memerr:

  ++stats.tcp.memerr;


  if(queue != ((void *)0) ) {
    tcp_segs_free(queue);
  }







     ;
  return -1 ;
}
 
 
err_t
tcp_output(struct tcp_pcb *pcb)
{
  struct pbuf *p;
  struct tcp_hdr *tcphdr;
  struct tcp_seg *seg, *useg;
  u32_t wnd;



  
  wnd = ( pcb->snd_wnd ) < (  pcb->cwnd )? ( pcb->snd_wnd ): (  pcb->cwnd ) ;

  
  seg = pcb->unsent;

  if(pcb->flags & 0x02 ) {
     

    pcb->flags &= ~(0x01  | 0x02 );
    p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_RAM);
    if(p == ((void *)0) ) {
       ;
      return -2 ;
    }
     ;    
    if(pbuf_header(p, 20 )) {
       ;
      

      ++stats.tcp.err;

      pbuf_free(p);
      return -2 ;
    }
    
    tcphdr = p->payload;
    tcphdr->src = htons(pcb->local_port);
    tcphdr->dest = htons(pcb->remote_port);
    tcphdr->seqno = htonl(pcb->snd_nxt);
    tcphdr->ackno = htonl(pcb->rcv_nxt);
    ( tcphdr )->_offset_flags = (((((u16_t)( (((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  0x10  ) ) & 0xff)) << 8) | (((u16_t)( (((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  0x10  ) ) & 0xff00) >> 8))  ;
    tcphdr->wnd = htons(pcb->rcv_wnd);
    tcphdr->urgp = 0;
    ( tcphdr )->_offset_flags = (((((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff)) << 8) | (((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff00) >> 8))  ;
    
    tcphdr->chksum = 0;
    tcphdr->chksum = inet_chksum_pseudo(p, &(pcb->local_ip), &(pcb->remote_ip),
					6 , p->tot_len);

    ip_output(p, &(pcb->local_ip), &(pcb->remote_ip), 255 ,
	      6 );
    pbuf_free(p);

    return 0 ;
  } 
  





# 388 "../../src/core/tcp_output.c"

  
  while(seg != ((void *)0)  &&
	htonl (seg->tcphdr->seqno) - pcb->lastack + seg->len <= wnd) {
    pcb->rtime = 0;









    pcb->unsent = seg->next;
    
    
    if(pcb->state != SYN_SENT) {
      ( seg->tcphdr )->_offset_flags = (((((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  ((((((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  | 0x10  ) ) & 0xff)) << 8) | (((u16_t)( (((((((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  seg->tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  ((((((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( seg->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  | 0x10  ) ) & 0xff00) >> 8))  ;
      pcb->flags &= ~(0x01  | 0x02 );
    }
    
    tcp_output_segment(seg, pcb);
    pcb->snd_nxt = htonl (seg->tcphdr->seqno) + (( seg )->len + ((((((((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0)) ;
    if(((s32_t)(( pcb->snd_max )-(  pcb->snd_nxt )) < 0) ) {
      pcb->snd_max = pcb->snd_nxt;
    }
     
    if((( seg )->len + ((((((((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01  || ((((((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( ( seg )->tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 )? 1: 0))  > 0) {
      seg->next = ((void *)0) ;
      if(pcb->unacked == ((void *)0) ) {
        pcb->unacked = seg;
      } else {
        for(useg = pcb->unacked; useg->next != ((void *)0) ; useg = useg->next);
        useg->next = seg;
      }
             
    } else {
      tcp_seg_free(seg);
    }
    seg = pcb->unsent;
  }  
  return 0 ;
}
 
static void
tcp_output_segment(struct tcp_seg *seg, struct tcp_pcb *pcb)
{
  u16_t len, tot_len;
  struct netif *netif;

   

  seg->tcphdr->ackno = htonl(pcb->rcv_nxt);

   
  if(pcb->rcv_wnd < pcb->mss) {
    seg->tcphdr->wnd = 0;
  } else {
    seg->tcphdr->wnd = htons(pcb->rcv_wnd);
  }

   

  if((( &(pcb->local_ip) ) == ((void *)0)  || ( &(pcb->local_ip) )->addr == 0) ) {
    netif = ip_route(&(pcb->remote_ip));
    if(netif == ((void *)0) ) {
      return;
    }
    ( &(pcb->local_ip) )->addr = ((  &(netif->ip_addr) ) == 0 ? 0 :	((struct ip_addr *)  &(netif->ip_addr) )->addr) ;
  }

  pcb->rtime = 0;
  
  if(pcb->rttest == 0) {
    pcb->rttest = tcp_ticks;
    pcb->rtseq = htonl (seg->tcphdr->seqno);

     ;
  }
   ;



  seg->tcphdr->chksum = 0;
  seg->tcphdr->chksum = inet_chksum_pseudo(seg->p,
					   &(pcb->local_ip),
					   &(pcb->remote_ip),
					   6 , seg->p->tot_len);

  ++stats.tcp.xmit;


  len = seg->p->len;
  tot_len = seg->p->tot_len;
  ip_output(seg->p, &(pcb->local_ip), &(pcb->remote_ip), 255 ,
	    6 );
  seg->p->len = len;
  seg->p->tot_len = tot_len;
  seg->p->payload = seg->tcphdr;

}
 
void
tcp_rexmit_seg(struct tcp_pcb *pcb, struct tcp_seg *seg)
{
  u32_t wnd;
  u16_t len, tot_len;
  struct netif *netif;
  
   ;



  wnd = ( pcb->snd_wnd ) < (  pcb->cwnd )? ( pcb->snd_wnd ): (  pcb->cwnd ) ;
  
  if(htonl (seg->tcphdr->seqno) - pcb->lastack + seg->len <= wnd) {

     
    ++pcb->nrtx;
    
    if((netif = ip_route((struct ip_addr *)&(pcb->remote_ip))) == ((void *)0) ) {
       ;

      ++stats.tcp.rterr;

      return;
    }

    seg->tcphdr->ackno = htonl(pcb->rcv_nxt);
    seg->tcphdr->wnd = htons(pcb->rcv_wnd);

     
    seg->tcphdr->chksum = 0;
    seg->tcphdr->chksum = inet_chksum_pseudo(seg->p,
                                             &(pcb->local_ip),
                                             &(pcb->remote_ip),
                                             6 , seg->p->tot_len);
    
    len = seg->p->len;
    tot_len = seg->p->tot_len;
    pbuf_header(seg->p, 20 );
    ip_output_if(seg->p, ((void *)0) , ((void *)0)  , 255 , 6 , netif);
    seg->p->len = len;
    seg->p->tot_len = tot_len;
    seg->p->payload = seg->tcphdr;


    ++stats.tcp.xmit;
    ++stats.tcp.rexmit;


    pcb->rtime = 0;
    
         
    pcb->rttest = 0;
  } else {
     ;

  }
}
 
void
tcp_rst(u32_t seqno, u32_t ackno,
	struct ip_addr *local_ip, struct ip_addr *remote_ip,
	u16_t local_port, u16_t remote_port)
{
  struct pbuf *p;
  struct tcp_hdr *tcphdr;
  p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_RAM);
  if(p == ((void *)0) ) {

    mem_reclaim(sizeof(struct pbuf));
    p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_RAM);
    
    if(p == ((void *)0) ) {
       ;
      return;
    }
  }
  if(pbuf_header(p, 20 )) {
     ;


    ++stats.tcp.err;

    return;
  }

  tcphdr = p->payload;
  tcphdr->src = htons(local_port);
  tcphdr->dest = htons(remote_port);
  tcphdr->seqno = htonl(seqno);
  tcphdr->ackno = htonl(ackno);
  ( tcphdr )->_offset_flags = (((((u16_t)( (((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  0x04  | 0x10  ) ) & 0xff)) << 8) | (((u16_t)( (((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  >> 8)  << 8) | (  0x04  | 0x10  ) ) & 0xff00) >> 8))  ;
  tcphdr->wnd = 0;
  tcphdr->urgp = 0;
  ( tcphdr )->_offset_flags = (((((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff)) << 8) | (((u16_t)( ((  5 << 4 ) << 8) | ((((((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( (  tcphdr  )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  ) & 0xff00) >> 8))  ;
  
  tcphdr->chksum = 0;
  tcphdr->chksum = inet_chksum_pseudo(p, local_ip, remote_ip,
				      6 , p->tot_len);


  ++stats.tcp.xmit;

  ip_output(p, local_ip, remote_ip, 255 , 6 );
  pbuf_free(p);
   ;
}
 











