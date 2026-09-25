# 1 "../../src/core/tcp.c"
 


































 
 






 

# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 46 "../../src/core/tcp.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 48 "../../src/core/tcp.c" 2

# 1 "../../src/include/lwip/mem.h" 1
 





































# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 39 "../../src/include/lwip/mem.h" 2

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













# 49 "../../src/core/tcp.c" 2

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





	  
# 50 "../../src/core/tcp.c" 2


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


# 41 "../../src/include/lwip/tcp.h" 2


# 1 "../../src/include/ipv4/lwip/ip.h" 1
 








































# 1 "../../src/include/ipv4/lwip/ip_addr.h" 1
 










































 
struct ip_addr {
   u32_t addr  __attribute__((packed)) ;
} __attribute__((packed)) ;
 

extern struct ip_addr ip_addr_broadcast;






















				   



















# 42 "../../src/include/ipv4/lwip/ip.h" 2

# 1 "../../src/include/lwip/netif.h" 1
 






































# 1 "../../src/include/lwip/err.h" 1
 








































typedef s8_t err_t;

 



























# 40 "../../src/include/lwip/netif.h" 2




# 1 "../../src/include/ipv4/lwip/inet.h" 1
 










































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


# 43 "../../src/include/ipv4/lwip/ip.h" 2




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





# 52 "../../src/core/tcp.c" 2


 

u32_t tcp_ticks;
const u8_t tcp_backoff[13] =
    { 1, 2, 4, 8, 16, 32, 64, 64, 64, 64, 64, 64, 64 };

 
struct tcp_pcb_listen *tcp_listen_pcbs;   
struct tcp_pcb *tcp_active_pcbs;   


struct tcp_pcb *tcp_tw_pcbs;       

struct tcp_pcb *tcp_tmp_pcb;




static u8_t tcp_memp_reclaim(void *arg, memp_t type);


static mem_size_t tcp_mem_reclaim(void *arg, mem_size_t size);


static u8_t tcp_timer;

 
 




 
void
tcp_init(void)
{
   
  tcp_listen_pcbs = ((void *)0) ;
  tcp_active_pcbs = ((void *)0) ;
  tcp_tw_pcbs = ((void *)0) ;
  tcp_tmp_pcb = ((void *)0) ;
  
   

  mem_register_reclaim((mem_reclaim_func)tcp_mem_reclaim, ((void *)0) );



  memp_register_reclaim(MEMP_PBUF, (memp_reclaim_func)tcp_memp_reclaim, ((void *)0) );
  memp_register_reclaim(MEMP_TCP_SEG, (memp_reclaim_func)tcp_memp_reclaim, ((void *)0) );
  memp_register_reclaim(MEMP_TCP_PCB, (memp_reclaim_func)tcp_memp_reclaim, ((void *)0) );


   
  tcp_ticks = 0;
  tcp_timer = 0;
  
}
 
 





 
void
tcp_tmr()
{
  ++tcp_timer;
  if(tcp_timer == 10) {
    tcp_timer = 0;
  }
  
  if(tcp_timer & 1) {
     

    tcp_fasttmr();
  }
  if(tcp_timer == 0 || tcp_timer == 5) {
     

    tcp_slowtmr();
  }
}
 
 





 
err_t
tcp_close(struct tcp_pcb *pcb)
{
  err_t err;






  switch(pcb->state) {
  case LISTEN:
    err = 0 ;
    tcp_pcb_remove((struct tcp_pcb **)&tcp_listen_pcbs, pcb);
    memp_free(MEMP_TCP_PCB_LISTEN, pcb);
    pcb = ((void *)0) ;
    break;
  case SYN_SENT:
    err = 0 ;
    tcp_pcb_remove(&tcp_active_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
    pcb = ((void *)0) ;
    break;
  case SYN_RCVD:
    err = tcp_send_ctrl(pcb, 0x01 );
    if(err == 0 ) {
      pcb->state = FIN_WAIT_1;
    }
    break;
  case ESTABLISHED:
    err = tcp_send_ctrl(pcb, 0x01 );
    if(err == 0 ) {
      pcb->state = FIN_WAIT_1;
    }
    break;
  case CLOSE_WAIT:
    err = tcp_send_ctrl(pcb, 0x01 );
    if(err == 0 ) {
      pcb->state = LAST_ACK;
    }
    break;
  default:
     
    err = 0 ;
    pcb = ((void *)0) ;
    break;
  }

  if(pcb != ((void *)0)  && err == 0 ) {
    err = tcp_output(pcb);
  }
  return err;
}
 
 







 
void
tcp_abort(struct tcp_pcb *pcb)
{
  u32_t seqno, ackno;
  u16_t remote_port, local_port;
  struct ip_addr remote_ip, local_ip;
  void (* errf)(void *arg, err_t err);
  void *errf_arg;

  
   


  if(pcb->state == TIME_WAIT) {
    tcp_pcb_remove(&tcp_tw_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
  } else if(pcb->state == LISTEN) {
    tcp_pcb_remove((struct tcp_pcb **)&tcp_listen_pcbs, pcb);
    memp_free(MEMP_TCP_PCB_LISTEN, pcb);
  } else {
    seqno = pcb->snd_nxt;
    ackno = pcb->rcv_nxt;
    ( &local_ip )->addr = ((  &(pcb->local_ip) ) == 0 ? 0 :	((struct ip_addr *)  &(pcb->local_ip) )->addr) ;
    ( &remote_ip )->addr = ((  &(pcb->remote_ip) ) == 0 ? 0 :	((struct ip_addr *)  &(pcb->remote_ip) )->addr) ;
    local_port = pcb->local_port;
    remote_port = pcb->remote_port;
    errf = pcb->errf;
    errf_arg = pcb->callback_arg;
    tcp_pcb_remove(&tcp_active_pcbs, pcb);
    memp_free(MEMP_TCP_PCB, pcb);
    if(errf != ((void *)0) ) {
      errf(errf_arg, -3 );
    }
     ;
    tcp_rst(seqno, ackno, &local_ip, &remote_ip, local_port, remote_port);
  }
}
 
 







 
err_t
tcp_bind(struct tcp_pcb *pcb, struct ip_addr *ipaddr, u16_t port)
{
  struct tcp_pcb *cpcb;

   
  for(cpcb = (struct tcp_pcb *)tcp_listen_pcbs;
      cpcb != ((void *)0) ; cpcb = cpcb->next) {
    if(cpcb->local_port == port) {
      if((( &(cpcb->local_ip) ) == ((void *)0)  || ( &(cpcb->local_ip) )->addr == 0)  ||
	 (( ipaddr ) == ((void *)0)  || ( ipaddr )->addr == 0)  ||
	 (( &(cpcb->local_ip) )->addr == (  ipaddr )->addr) ) {
	return -10 ;
      }
    }
  }
  for(cpcb = tcp_active_pcbs;
      cpcb != ((void *)0) ; cpcb = cpcb->next) {
    if(cpcb->local_port == port) {
      if((( &(cpcb->local_ip) ) == ((void *)0)  || ( &(cpcb->local_ip) )->addr == 0)  ||
	 (( ipaddr ) == ((void *)0)  || ( ipaddr )->addr == 0)  ||
	 (( &(cpcb->local_ip) )->addr == (  ipaddr )->addr) ) {
	return -10 ;
      }
    }
  }
  if(! (( ipaddr ) == ((void *)0)  || ( ipaddr )->addr == 0) ) {
    pcb->local_ip = *ipaddr;
  }
  pcb->local_port = port;
   ;
  return 0 ;
}
 
 








 
struct tcp_pcb *
tcp_listen(struct tcp_pcb *pcb)
{
  pcb->state = LISTEN;
  pcb = memp_realloc(MEMP_TCP_PCB, MEMP_TCP_PCB_LISTEN, pcb);
  if(pcb == ((void *)0) ) {
    return ((void *)0) ;
  }
  do {   pcb ->next = * (struct tcp_pcb **)&tcp_listen_pcbs ; * (struct tcp_pcb **)&tcp_listen_pcbs  =   pcb ; } while(0) ;
  return pcb;
}
 
 







 
void
tcp_recved(struct tcp_pcb *pcb, u16_t len)
{
  pcb->rcv_wnd += len;
  if(pcb->rcv_wnd > 1024 ) {
    pcb->rcv_wnd = 1024 ;
  }
  if(!(pcb->flags & 0x01 ) ||
     !(pcb->flags & 0x02 )) {
    if(( pcb )->flags & 0x01 ) { ( pcb )->flags |= 0x02 ; tcp_output( pcb ); } else { ( pcb )->flags |= 0x01 ; } ;
  }
   ;

}
 
 





 
static u16_t
tcp_new_port(void)
{
  struct tcp_pcb *pcb;
  static u16_t port = 4096;
  
 again:
  if(++port > 0x7fff) {
    port = 4096;
  }
  
  for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  for(pcb = tcp_tw_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  for(pcb = (struct tcp_pcb *)tcp_listen_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
    if(pcb->local_port == port) {
      goto again;
    }
  }
  return port;
}
 
 






 
err_t
tcp_connect(struct tcp_pcb *pcb, struct ip_addr *ipaddr, u16_t port,
	    err_t (* connected)(void *arg, struct tcp_pcb *tpcb, err_t err))
{
  u32_t optdata;
  err_t ret;
  u32_t iss;

   ;
  if(ipaddr != ((void *)0) ) {
    pcb->remote_ip = *ipaddr;
  } else {
    return -7 ;
  }
  pcb->remote_port = port;
  if(pcb->local_port == 0) {
    pcb->local_port = tcp_new_port();
  }
  iss = tcp_next_iss();
  pcb->rcv_nxt = 0;
  pcb->snd_nxt = iss;
  pcb->lastack = iss - 1;
  pcb->snd_lbb = iss - 1;
  pcb->rcv_wnd = 1024 ;
  pcb->snd_wnd = 1024 ;
  pcb->mss = 128 ;
  pcb->cwnd = 1;
  pcb->ssthresh = pcb->mss * 10;
  pcb->state = SYN_SENT;
  pcb->connected = connected;
  do {   pcb ->next = * &tcp_active_pcbs ; * &tcp_active_pcbs  =   pcb ; } while(0) ;
  
   
  optdata = (((((u32_t)( ((u32_t)2 << 24) | 
		  ((u32_t)4 << 16) | 
		  (((u32_t)pcb->mss / 256) << 8) |
		  (pcb->mss & 255) ) & 0xff)) << 24) | ((((u32_t)( ((u32_t)2 << 24) |  		  ((u32_t)4 << 16) |  		  (((u32_t)pcb->mss / 256) << 8) | 		  (pcb->mss & 255) ) & 0xff00)) << 8) | ((((u32_t)( ((u32_t)2 << 24) |  		  ((u32_t)4 << 16) |  		  (((u32_t)pcb->mss / 256) << 8) | 		  (pcb->mss & 255) ) & 0xff0000)) >> 8) | ((((u32_t)( ((u32_t)2 << 24) |  		  ((u32_t)4 << 16) |  		  (((u32_t)pcb->mss / 256) << 8) | 		  (pcb->mss & 255) ) & 0xff000000)) >> 24)) ;

  ret = tcp_enqueue(pcb, ((void *)0) , 0, 0x02 , 0, (u8_t *)&optdata, 4);
  if(ret == 0 ) { 
    tcp_output(pcb);
  }
  return ret;
} 
 
 






 
void
tcp_slowtmr(void)
{
  static struct tcp_pcb *pcb, *pcb2, *prev;
  static struct tcp_seg *seg, *useg;
  static u32_t eff_wnd;
  static u8_t pcb_remove;       

  ++tcp_ticks;
  
   
  prev = ((void *)0) ;
  pcb = tcp_active_pcbs;
  while(pcb != ((void *)0) ) {
     ;
     ;
     ;

    pcb_remove = 0;

    if(pcb->state == SYN_SENT && pcb->nrtx == 4 ) {
      ++pcb_remove;
    } else if(pcb->nrtx == 12 ) {
      ++pcb_remove;
    } else {
      ++pcb->rtime;
      seg = pcb->unacked;
      if(seg != ((void *)0)  && pcb->rtime >= pcb->rto) {
        
         ;


	 

	if(pcb->state != SYN_SENT) {
	  pcb->rto = ((pcb->sa >> 3) + pcb->sv) << tcp_backoff[pcb->nrtx];
	}

         
        if(seg->next != ((void *)0) ) {
          for(useg = seg->next; useg->next != ((void *)0) ; useg = useg->next);
           
          useg->next = pcb->unsent;
          pcb->unsent = seg->next;
          seg->next = ((void *)0) ;
          pcb->snd_nxt = htonl (pcb->unsent->tcphdr->seqno);
        }

	 
        tcp_rexmit_seg(pcb, seg);

         
        eff_wnd = ( pcb->cwnd ) < (  pcb->snd_wnd )? ( pcb->cwnd ): (  pcb->snd_wnd ) ;
        pcb->ssthresh = eff_wnd >> 1;
        if(pcb->ssthresh < pcb->mss) {
          pcb->ssthresh = pcb->mss * 2;
        }
        pcb->cwnd = pcb->mss;

         ;

      }
    }
	  
     
    if(pcb->state == FIN_WAIT_2) {
      if((u32_t)(tcp_ticks - pcb->tmr) >
	 20000  / 500 ) {
        ++pcb_remove;
      }
    }

     



    if(pcb->ooseq != ((void *)0)  &&
       (u32_t)tcp_ticks - pcb->tmr >=
       pcb->rto * 6 ) {
      tcp_segs_free(pcb->ooseq);
      pcb->ooseq = ((void *)0) ;
    }


     
    if(pcb->state == SYN_RCVD) {
      if((u32_t)(tcp_ticks - pcb->tmr) >
	 20000  / 500 ) {
        ++pcb_remove;
      }
    }


     
    if(pcb_remove) {
      tcp_pcb_purge(pcb);      
       
      if(prev != ((void *)0) ) {
	 ;
        prev->next = pcb->next;
      } else {
         
         ;
        tcp_active_pcbs = pcb->next;
      }

      if(pcb->errf != ((void *)0) ) {
	pcb->errf(pcb->callback_arg, -3 );
      }

      pcb2 = pcb->next;
      memp_free(MEMP_TCP_PCB, pcb);
      pcb = pcb2;
    } else {

       
      ++pcb->polltmr;
      if(pcb->polltmr >= pcb->pollinterval &&
	 pcb->poll != ((void *)0) ) {
	pcb->polltmr = 0;
	pcb->poll(pcb->callback_arg, pcb);
	tcp_output(pcb);
      }
      
      prev = pcb;
      pcb = pcb->next;
    }
  }

  
   
  prev = ((void *)0) ;    
  pcb = tcp_tw_pcbs;
  while(pcb != ((void *)0) ) {
     ;
    pcb_remove = 0;

     
    if((u32_t)(tcp_ticks - pcb->tmr) > 2 * 60000  / 500 ) {
      ++pcb_remove;
    }
    


     
    if(pcb_remove) {
      tcp_pcb_purge(pcb);      
       
      if(prev != ((void *)0) ) {
	 ;
        prev->next = pcb->next;
      } else {
         
         ;
        tcp_tw_pcbs = pcb->next;
      }
      pcb2 = pcb->next;
      memp_free(MEMP_TCP_PCB, pcb);
      pcb = pcb2;
    } else {
      prev = pcb;
      pcb = pcb->next;
    }
  }
}
 
 




 
void
tcp_fasttmr(void)
{
  struct tcp_pcb *pcb;

     
  for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
    if(pcb->flags & 0x01 ) {
       ;
      ( pcb )->flags |= 0x02 ; tcp_output( pcb ) ;
      pcb->flags &= ~(0x01  | 0x02 );
    }
  }
}
 
 





 
u8_t
tcp_segs_free(struct tcp_seg *seg)
{
  u8_t count = 0;
  struct tcp_seg *next;
 again:  
  if(seg != ((void *)0) ) {
    next = seg->next;
    count += tcp_seg_free(seg);
    seg = next;
    goto again;
  }
  return count;
}
 
 





 
u8_t
tcp_seg_free(struct tcp_seg *seg)
{
  u8_t count = 0;
  
  if(seg != ((void *)0) ) {
    if(seg->p == ((void *)0) ) {
      memp_free(MEMP_TCP_SEG, seg);
    } else {
      count = pbuf_free(seg->p);



      memp_free(MEMP_TCP_SEG, seg);
    }
  }
  return count;
}
 
 




 
 
struct tcp_seg *
tcp_seg_copy(struct tcp_seg *seg)
{
  struct tcp_seg *cseg;

  cseg = memp_malloc(MEMP_TCP_SEG);
  if(cseg == ((void *)0) ) {
    return ((void *)0) ;
  }
  bcopy(seg, cseg, sizeof(struct tcp_seg));
  pbuf_ref(cseg->p);
  return cseg;
}
 
 






 
struct tcp_pcb *
tcp_new(void)
{
  struct tcp_pcb *pcb;
  u32_t iss;
  
  pcb = memp_malloc2(MEMP_TCP_PCB);
  if(pcb != ((void *)0) ) {
    bzero(pcb, sizeof(struct tcp_pcb));
    pcb->snd_buf = 256 ;
    pcb->snd_queuelen = 0;
    pcb->rcv_wnd = 1024 ;
    pcb->mss = 128 ;
    pcb->rto = 3000 / 500 ;
    pcb->sa = 0;
    pcb->sv = 3000 / 500 ;
    pcb->rtime = 0;
    pcb->cwnd = 1;
    iss = tcp_next_iss();
    pcb->snd_wl2 = iss;
    pcb->snd_nxt = iss;
    pcb->snd_max = iss;
    pcb->lastack = iss;
    pcb->snd_lbb = iss;   
    pcb->tmr = tcp_ticks;

    pcb->polltmr = 0;

    return pcb;
  }
  return ((void *)0) ;
}
 
 






 

static mem_size_t
tcp_mem_reclaim(void *arg, mem_size_t size)
{
  static struct tcp_pcb *pcb, *inactive;
  static u32_t inactivity;
  static mem_size_t reclaimed;

  reclaimed = 0;

   

  inactivity = 0;
  inactive = ((void *)0) ;
  for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
    if((u32_t)(tcp_ticks - pcb->tmr) > inactivity) {
      inactivity = tcp_ticks - pcb->tmr;
      inactive = pcb;
    }
  }
  if(inactive != ((void *)0) ) {
     ;

    tcp_abort(inactive);
  }
  return reclaimed;
}

 
 






 

static u8_t
tcp_memp_reclaim(void *arg, memp_t type)
{
  struct tcp_pcb *pcb, *inactive;
  u32_t inactivity;

  switch(type) {
  case MEMP_TCP_SEG:

     
    for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
      if(pcb->ooseq) {
	 ;
	tcp_segs_free(pcb->ooseq);
	pcb->ooseq = ((void *)0) ;
	return 1;
      }
    }
   



    break;
    
  case MEMP_PBUF:
    return tcp_memp_reclaim(arg, MEMP_TCP_SEG);

  case MEMP_TCP_PCB:
     

    pcb = tcp_tw_pcbs;
    if(pcb != ((void *)0) ) {
      tcp_tw_pcbs = tcp_tw_pcbs->next;
      memp_free(MEMP_TCP_PCB, pcb);
      return 1;
    } else {
      inactivity = 0;
      inactive = ((void *)0) ;
      for(pcb = tcp_active_pcbs; pcb != ((void *)0) ; pcb = pcb->next) {
	if((u32_t)(tcp_ticks - pcb->tmr) > inactivity) {
	  inactivity = tcp_ticks - pcb->tmr;
	  inactive = pcb;
	}
      }
      if(inactive != ((void *)0) ) {
	 ;

	tcp_abort(inactive);
	return 1;
      }      
    }
    break;
    
  default:
     ;
    break;
  }
  return 0;
}

 
 





 
 
void
tcp_arg(struct tcp_pcb *pcb, void *arg)
{  
  pcb->callback_arg = arg;
}
 
 





 
 
void
tcp_recv(struct tcp_pcb *pcb,
	 err_t (* recv)(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err))
{
  pcb->recv = recv;
}
 
 





 
 
void
tcp_sent(struct tcp_pcb *pcb,
	 err_t (* sent)(void *arg, struct tcp_pcb *tpcb, u16_t len))
{
  pcb->sent = sent;
}
 
 





 
 
void
tcp_err(struct tcp_pcb *pcb,
	 void (* errf)(void *arg, err_t err))
{
  pcb->errf = errf;
}
 
 






 
 
void
tcp_poll(struct tcp_pcb *pcb,
	 err_t (* poll)(void *arg, struct tcp_pcb *tpcb), u8_t interval)
{
  pcb->poll = poll;
  pcb->pollinterval = interval;
}
 
 





 
 
void
tcp_accept(struct tcp_pcb *pcb,
	   err_t (* accept)(void *arg, struct tcp_pcb *newpcb, err_t err))
{
  pcb->accept = accept;
}
 
 





 
void
tcp_pcb_purge(struct tcp_pcb *pcb)
{
  if(pcb->state != CLOSED &&
     pcb->state != TIME_WAIT &&
     pcb->state != LISTEN) {

# 953 "../../src/core/tcp.c"

    tcp_segs_free(pcb->unsent);

    tcp_segs_free(pcb->ooseq);

    tcp_segs_free(pcb->unacked);
    pcb->unacked = pcb->unsent =

      pcb->ooseq =

      ((void *)0) ;
  }
}
 
 





 
void
tcp_pcb_remove(struct tcp_pcb **pcblist, struct tcp_pcb *pcb)
{
  do { if(* pcblist  ==   pcb ) { * pcblist  = (* pcblist )->next; } else for(tcp_tmp_pcb = * pcblist ; tcp_tmp_pcb != ((void *)0) ; tcp_tmp_pcb = tcp_tmp_pcb->next) { if(tcp_tmp_pcb->next != ((void *)0)  && tcp_tmp_pcb->next ==   pcb ) { tcp_tmp_pcb->next =   pcb ->next; break; } }   pcb ->next = ((void *)0) ; } while(0) ;

  tcp_pcb_purge(pcb);
  
   
  if(pcb->state != TIME_WAIT &&
     pcb->state != LISTEN &&
     pcb->flags & 0x01 ) {
    pcb->flags |= 0x02 ;
    tcp_output(pcb);
  }  
  pcb->state = CLOSED;

   ;
}
 
 





 
u32_t
tcp_next_iss(void)
{
  static u32_t iss = 6510;
  
  iss += tcp_ticks;        
  return iss;
}
 
# 1148 "../../src/core/tcp.c"

 









