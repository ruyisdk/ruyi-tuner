# 1 "../../src/api/api_lib.c"
 


































 


# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 39 "../../src/api/api_lib.c" 2

# 1 "../../src/include/lwip/api.h" 1
 




































# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 38 "../../src/include/lwip/api.h" 2

# 1 "../../src/include/lwip/pbuf.h" 1
 

































 




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















# 40 "../../src/include/lwip/pbuf.h" 2






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


# 39 "../../src/include/lwip/api.h" 2

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


# 40 "../../src/include/lwip/api.h" 2


# 1 "../../src/include/ipv4/lwip/ip.h" 1
 






































# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 40 "../../src/include/ipv4/lwip/ip.h" 2


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




























# 42 "../../src/include/lwip/api.h" 2


# 1 "../../src/include/lwip/udp.h" 1
 














































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





# 44 "../../src/include/lwip/api.h" 2

# 1 "../../src/include/lwip/tcp.h" 1
 





































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













# 39 "../../src/include/lwip/tcp.h" 2





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





# 45 "../../src/include/lwip/api.h" 2







enum netconn_type {
  NETCONN_TCP,
  NETCONN_UDP,
  NETCONN_UDPLITE,
  NETCONN_UDPNOCHKSUM
};

enum netconn_state {
  NETCONN_NONE,
  NETCONN_WRITE,
  NETCONN_ACCEPT,
  NETCONN_RECV,
  NETCONN_CONNECT,
  NETCONN_CLOSE
};

struct netbuf {
  struct pbuf *p, *ptr;
  struct ip_addr *fromaddr;
  u16_t fromport;
  err_t err;
};

struct netconn {
  enum netconn_type type;
  enum netconn_state state;
  union {
    struct tcp_pcb *tcp;
    struct udp_pcb *udp;
  } pcb;
  err_t err;
  sys_mbox_t mbox;
  sys_mbox_t recvmbox;
  sys_mbox_t acceptmbox;
  sys_sem_t sem;
};

 
struct netbuf *   netbuf_new      (void);
void              netbuf_delete   (struct netbuf *buf);
void *            netbuf_alloc    (struct netbuf *buf, u16_t size);
void              netbuf_free     (struct netbuf *buf);
void              netbuf_ref      (struct netbuf *buf,
				   void *dataptr, u16_t size);
void              netbuf_chain    (struct netbuf *head,
				   struct netbuf *tail);

u16_t             netbuf_len      (struct netbuf *buf);
err_t             netbuf_data     (struct netbuf *buf,
				   void **dataptr, u16_t *len);
s8_t              netbuf_next     (struct netbuf *buf);
void              netbuf_first    (struct netbuf *buf);

void              netbuf_copy     (struct netbuf *buf,
				   void *dataptr, u16_t len);
struct ip_addr *  netbuf_fromaddr (struct netbuf *buf);
u16_t             netbuf_fromport (struct netbuf *buf);

 
struct netconn *  netconn_new     (enum netconn_type type);
err_t             netconn_delete  (struct netconn *conn);
enum netconn_type netconn_type    (struct netconn *conn);
err_t             netconn_peer    (struct netconn *conn,
				   struct ip_addr **addr,
				   u16_t *port);
err_t             netconn_addr    (struct netconn *conn,
				   struct ip_addr **addr,
				   u16_t *port);
err_t             netconn_bind    (struct netconn *conn,
				   struct ip_addr *addr,
				   u16_t port);
err_t             netconn_connect (struct netconn *conn,
				   struct ip_addr *addr,
				   u16_t port);
err_t             netconn_listen  (struct netconn *conn);
struct netconn *  netconn_accept  (struct netconn *conn);
struct netbuf *   netconn_recv    (struct netconn *conn);
err_t             netconn_send    (struct netconn *conn,
				   struct netbuf *buf);
err_t             netconn_write   (struct netconn *conn,
				   void *dataptr, u16_t size,
				   u8_t copy);
err_t             netconn_close   (struct netconn *conn);

err_t             netconn_err     (struct netconn *conn);




# 40 "../../src/api/api_lib.c" 2

# 1 "../../src/include/lwip/api_msg.h" 1
 















































enum api_msg_type {
  API_MSG_NEWCONN,
  API_MSG_DELCONN,
  
  API_MSG_BIND,
  API_MSG_CONNECT,

  API_MSG_LISTEN,
  API_MSG_ACCEPT,

  API_MSG_SEND,
  API_MSG_RECV,
  API_MSG_WRITE,

  API_MSG_CLOSE,
  
  API_MSG_MAX
};

struct api_msg_msg {
  struct netconn *conn;
  enum netconn_type conntype;
  union {
    struct pbuf *p;   
    struct  {
      struct ip_addr *ipaddr;
      u16_t port;
    } bc;
    struct {
      void *dataptr;
      u16_t len;
      unsigned char copy;
    } w;    
    sys_mbox_t mbox;
    u16_t len;
  } msg;
};

struct api_msg {
  enum api_msg_type type;
  struct api_msg_msg msg;
};

void api_msg_input(struct api_msg *msg);
void api_msg_post(struct api_msg *msg);



# 41 "../../src/api/api_lib.c" 2

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





	  
# 42 "../../src/api/api_lib.c" 2




 
struct
netbuf *netbuf_new(void)
{
  struct netbuf *buf;

  buf = memp_mallocp(MEMP_NETBUF);
  if(buf != ((void *)0) ) {
    buf->p = ((void *)0) ;
    buf->ptr = ((void *)0) ;
    return buf;
  } else {
    return ((void *)0) ;
  }
}
 
void
netbuf_delete(struct netbuf *buf)
{
  if(buf != ((void *)0) ) {
    if(buf->p != ((void *)0) ) {
      pbuf_free(buf->p);
      buf->p = buf->ptr = ((void *)0) ;
    }
    memp_freep(MEMP_NETBUF, buf);
  }
}
 
void *
netbuf_alloc(struct netbuf *buf, u16_t size)
{
   
  if(buf->p != ((void *)0) ) {
    pbuf_free(buf->p);
  }
  buf->p = pbuf_alloc(PBUF_TRANSPORT, size, PBUF_RAM);
  if(buf->p == ((void *)0) ) {
     return ((void *)0) ;
  }
  buf->ptr = buf->p;
  return buf->p->payload;
}
 
void
netbuf_free(struct netbuf *buf)
{
  if(buf->p != ((void *)0) ) {
    pbuf_free(buf->p);
  }
  buf->p = buf->ptr = ((void *)0) ;
}
 
void
netbuf_ref(struct netbuf *buf, void *dataptr, u16_t size)
{
  if(buf->p != ((void *)0) ) {
    pbuf_free(buf->p);
  }
  buf->p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_ROM);
  buf->p->payload = dataptr;
  buf->p->len = buf->p->tot_len = size;
  buf->ptr = buf->p;
}
 
void
netbuf_chain(struct netbuf *head, struct netbuf *tail)
{
  pbuf_chain(head->p, tail->p);
  head->ptr = head->p;
  memp_freep(MEMP_NETBUF, tail);
}
 
u16_t
netbuf_len(struct netbuf *buf)
{
  return buf->p->tot_len;
}
 
err_t
netbuf_data(struct netbuf *buf, void **dataptr, u16_t *len)
{
  if(buf->ptr == ((void *)0) ) {
    return -2 ;
  }
  *dataptr = buf->ptr->payload;
  *len = buf->ptr->len;
  return 0 ;
}
 
s8_t
netbuf_next(struct netbuf *buf)
{
  if(buf->ptr->next == ((void *)0) ) {
    return -1;
  }
  buf->ptr = buf->ptr->next;
  if(buf->ptr->next == ((void *)0) ) {
    return 1;
  }
  return 0;
}
 
void
netbuf_first(struct netbuf *buf)
{
  buf->ptr = buf->p;
}
 
void
netbuf_copy_partial(struct netbuf *buf, void *dataptr, u16_t len, u16_t offset)
{
  struct pbuf *p;
  u16_t i, left;

  left = 0;

  if(buf == ((void *)0) ) {
    return;
  }
  
   

  for(p = buf->p; left < len && p != ((void *)0) ; p = p->next) {
    if(offset != 0 && offset >= p->len) {
      offset -= p->len;
    } else {    
      for(i = offset; i < p->len; ++i) {
	((char *)dataptr)[left] = ((char *)p->payload)[i];
	if(++left >= len) {
	  return;
	}
      }
    }
  }
}
 
void
netbuf_copy(struct netbuf *buf, void *dataptr, u16_t len)
{
  netbuf_copy_partial(buf, dataptr, len, 0);
}
 
struct ip_addr *
netbuf_fromaddr(struct netbuf *buf)
{
  return buf->fromaddr;
}
 
u16_t
netbuf_fromport(struct netbuf *buf)
{
  return buf->fromport;
}
 
struct
netconn *netconn_new(enum netconn_type t)
{
  struct netconn *conn;

  conn = memp_mallocp(MEMP_NETCONN);
  if(conn == ((void *)0) ) {
    return ((void *)0) ;
  }
  conn->type = t;
  conn->pcb.tcp = ((void *)0) ;

  if((conn->mbox = sys_mbox_new()) == ((void *)0)  ) {
    memp_freep(MEMP_NETCONN, conn);
    return ((void *)0) ;
  }
  conn->recvmbox = ((void *)0)  ;
  conn->acceptmbox = ((void *)0)  ;
  conn->sem = ((void *)0)  ;
  conn->state = NETCONN_NONE;
  return conn;
}
 
err_t
netconn_delete(struct netconn *conn)
{
  struct api_msg *msg;
  void *mem;
  
  if(conn == ((void *)0) ) {
    return 0 ;
  }
  
  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return -1 ;
  }
  
  msg->type = API_MSG_DELCONN;
  msg->msg.conn = conn;
  api_msg_post(msg);  
  sys_mbox_fetch(conn->mbox, ((void *)0) );
  memp_freep(MEMP_API_MSG, msg);

   
  if(conn->recvmbox != ((void *)0)  ) {
    while(sys_arch_mbox_fetch(conn->recvmbox, &mem, 1) != 0) {
      if(conn->type == NETCONN_TCP) {
	pbuf_free((struct pbuf *)mem);
      } else {
	netbuf_delete((struct netbuf *)mem);
      }
    }
    sys_mbox_free(conn->recvmbox);
    conn->recvmbox = ((void *)0)  ;
  }
 

   
  if(conn->acceptmbox != ((void *)0)  ) {
    while(sys_arch_mbox_fetch(conn->acceptmbox, &mem, 1) != 0) {
      netconn_delete((struct netconn *)mem);
    }
    
    sys_mbox_free(conn->acceptmbox);
    conn->acceptmbox = ((void *)0)  ;
  }

  sys_mbox_free(conn->mbox);
  conn->mbox = ((void *)0)  ;
  if(conn->sem != ((void *)0)  ) {
    sys_sem_free(conn->sem);
  }
   
  memp_free(MEMP_NETCONN, conn);
  return 0 ;
}
 
enum netconn_type
netconn_type(struct netconn *conn)
{
  return conn->type;
}
 
err_t
netconn_peer(struct netconn *conn, struct ip_addr **addr,
	     u16_t *port)
{
  switch(conn->type) {
  case NETCONN_UDPLITE:
  case NETCONN_UDPNOCHKSUM:
  case NETCONN_UDP:
    *addr = &(conn->pcb.udp->remote_ip);
    *port = conn->pcb.udp->remote_port;
    break;
  case NETCONN_TCP:
    *addr = &(conn->pcb.tcp->remote_ip);
    *port = conn->pcb.tcp->remote_port;
    break;
  }
  return (conn->err = 0 );
}
 
err_t
netconn_addr(struct netconn *conn, struct ip_addr **addr,
	     u16_t *port)
{
  switch(conn->type) {
  case NETCONN_UDPLITE:
  case NETCONN_UDPNOCHKSUM:
  case NETCONN_UDP:
    *addr = &(conn->pcb.udp->local_ip);
    *port = conn->pcb.udp->local_port;
    break;
  case NETCONN_TCP:
    *addr = &(conn->pcb.tcp->local_ip);
    *port = conn->pcb.tcp->local_port;
    break;
  }
  return (conn->err = 0 );
}
 
err_t
netconn_bind(struct netconn *conn, struct ip_addr *addr,
	    u16_t port)
{
  struct api_msg *msg;

  if(conn == ((void *)0) ) {
    return -7 ;
  }

  if(conn->type != NETCONN_TCP &&
     conn->recvmbox == ((void *)0)  ) {
    if((conn->recvmbox = sys_mbox_new()) == ((void *)0)  ) {
      return -1 ;
    }
  }
  
  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return (conn->err = -1 );
  }
  msg->type = API_MSG_BIND;
  msg->msg.conn = conn;
  msg->msg.msg.bc.ipaddr = addr;
  msg->msg.msg.bc.port = port;
  api_msg_post(msg);
  sys_mbox_fetch(conn->mbox, ((void *)0) );
  memp_freep(MEMP_API_MSG, msg);
  return conn->err;
}
 
err_t
netconn_connect(struct netconn *conn, struct ip_addr *addr,
		   u16_t port)
{
  struct api_msg *msg;
  
  if(conn == ((void *)0) ) {
    return -7 ;
  }


  if(conn->recvmbox == ((void *)0)  ) {
    if((conn->recvmbox = sys_mbox_new()) == ((void *)0)  ) {
      return -1 ;
    }
  }
  
  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return -1 ;
  }
  msg->type = API_MSG_CONNECT;
  msg->msg.conn = conn;  
  msg->msg.msg.bc.ipaddr = addr;
  msg->msg.msg.bc.port = port;
  api_msg_post(msg);
  sys_mbox_fetch(conn->mbox, ((void *)0) );
  memp_freep(MEMP_API_MSG, msg);
  return conn->err;
}
 
err_t
netconn_listen(struct netconn *conn)
{
  struct api_msg *msg;

  if(conn == ((void *)0) ) {
    return -7 ;
  }

  if(conn->acceptmbox == ((void *)0)  ) {
    conn->acceptmbox = sys_mbox_new();
    if(conn->acceptmbox == ((void *)0)  ) {
      return -1 ;
    }
  }
  
  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return (conn->err = -1 );
  }
  msg->type = API_MSG_LISTEN;
  msg->msg.conn = conn;
  api_msg_post(msg);
  sys_mbox_fetch(conn->mbox, ((void *)0) );
  memp_freep(MEMP_API_MSG, msg);
  return conn->err;
}
 
struct netconn *
netconn_accept(struct netconn *conn)
{
  struct netconn *newconn;
  
  if(conn == ((void *)0) ) {
    return ((void *)0) ;
  }
  
  sys_mbox_fetch(conn->acceptmbox, (void **)&newconn);

  return newconn;
}
 
struct netbuf *
netconn_recv(struct netconn *conn)
{
  struct api_msg *msg;
  struct netbuf *buf;
  struct pbuf *p;
    
  if(conn == ((void *)0) ) {
    return ((void *)0) ;
  }
  
  if(conn->recvmbox == ((void *)0)  ) {
    conn->err = -6 ;
    return ((void *)0) ;
  }

  if(conn->err != 0 ) {
    return ((void *)0) ;
  }

  if(conn->type == NETCONN_TCP) {
    if(conn->pcb.tcp->state == LISTEN) {
      conn->err = -6 ;
      return ((void *)0) ;
    }


    buf = memp_mallocp(MEMP_NETBUF);

    if(buf == ((void *)0) ) {
      conn->err = -1 ;
      return ((void *)0) ;
    }
    
    sys_mbox_fetch(conn->recvmbox, (void **)&p);
    
     

    if(p == ((void *)0) ) {
      memp_freep(MEMP_NETBUF, buf);
      sys_mbox_free(conn->recvmbox);
      conn->recvmbox = ((void *)0)  ;
      return ((void *)0) ;
    }

    buf->p = p;
    buf->ptr = p;
    buf->fromport = 0;
    buf->fromaddr = ((void *)0) ;

     
    if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
      conn->err = -1 ;
      return buf;
    }
    msg->type = API_MSG_RECV;
    msg->msg.conn = conn;
    if(buf != ((void *)0) ) {
      msg->msg.msg.len = buf->p->tot_len;
    } else {
      msg->msg.msg.len = 1;
    }
    api_msg_post(msg);

    sys_mbox_fetch(conn->mbox, ((void *)0) );
    memp_freep(MEMP_API_MSG, msg);
  } else {
    sys_mbox_fetch(conn->recvmbox, (void **)&buf);
  }

  

    
   ;


  return buf;
}
 
err_t
netconn_send(struct netconn *conn, struct netbuf *buf)
{
  struct api_msg *msg;

  if(conn == ((void *)0) ) {
    return -7 ;
  }

  if(conn->err != 0 ) {
    return conn->err;
  }

  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return (conn->err = -1 );
  }

   ;
  msg->type = API_MSG_SEND;
  msg->msg.conn = conn;
  msg->msg.msg.p = buf->p;
  api_msg_post(msg);

  sys_mbox_fetch(conn->mbox, ((void *)0) );
  memp_freep(MEMP_API_MSG, msg);
  return conn->err;
}
 
err_t
netconn_write(struct netconn *conn, void *dataptr, u16_t size, u8_t copy)
{
  struct api_msg *msg;
  u16_t len;
  
  if(conn == ((void *)0) ) {
    return -7 ;
  }

  if(conn->err != 0 ) {
    return conn->err;
  }
  
  if(conn->sem == ((void *)0)  ) {
    conn->sem = sys_sem_new(0);
    if(conn->sem == ((void *)0)  ) {
      return -1 ;
    }
  }

  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return (conn->err = -1 );
  }
  msg->type = API_MSG_WRITE;
  msg->msg.conn = conn;
        

  conn->state = NETCONN_WRITE;
  while(conn->err == 0  && size > 0) {
    msg->msg.msg.w.dataptr = dataptr;
    msg->msg.msg.w.copy = copy;
    
    if(conn->type == NETCONN_TCP) {
      if((( conn->pcb.tcp )->snd_buf)  == 0) {
	sys_sem_wait(conn->sem);
	if(conn->err != 0 ) {
	  goto ret;
	}
      }
      if(size > (( conn->pcb.tcp )->snd_buf) ) {
	 

	len = (( conn->pcb.tcp )->snd_buf) ;
      } else {
	len = size;
      }
    } else {
      len = size;
    }
    
     ;
    msg->msg.msg.w.len = len;
    api_msg_post(msg);
    sys_mbox_fetch(conn->mbox, ((void *)0) );    
    if(conn->err == 0 ) {
      dataptr = (void *)((char *)dataptr + len);
      size -= len;
    } else if(conn->err == -1 ) {
      conn->err = 0 ;
      sys_sem_wait(conn->sem);
    } else {
      goto ret;
    }
  }
 ret:
  memp_freep(MEMP_API_MSG, msg);
  conn->state = NETCONN_NONE;
  if(conn->sem != ((void *)0)  ) {
    sys_sem_free(conn->sem);
    conn->sem = ((void *)0)  ;
  }
  return conn->err;
}
 
err_t
netconn_close(struct netconn *conn)
{
  struct api_msg *msg;

  if(conn == ((void *)0) ) {
    return -7 ;
  }
  if((msg = memp_mallocp(MEMP_API_MSG)) == ((void *)0) ) {
    return (conn->err = -1 );
  }

  conn->state = NETCONN_CLOSE;
 again:
  msg->type = API_MSG_CLOSE;
  msg->msg.conn = conn;
  api_msg_post(msg);
  sys_mbox_fetch(conn->mbox, ((void *)0) );
  if(conn->err == -1  &&
     conn->sem != ((void *)0)  ) {
    sys_sem_wait(conn->sem);
    goto again;
  }
  conn->state = NETCONN_NONE;
  memp_freep(MEMP_API_MSG, msg);
  return conn->err;
}
 
err_t
netconn_err(struct netconn *conn)
{
  return conn->err;
}
 




