# 1 "../../src/api/api_msg.c"
 


































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 36 "../../src/api/api_msg.c" 2

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















# 37 "../../src/api/api_msg.c" 2

# 1 "../../src/include/lwip/api_msg.h" 1
 




































# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 38 "../../src/include/lwip/api_msg.h" 2

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


# 39 "../../src/include/lwip/api_msg.h" 2

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


# 40 "../../src/include/lwip/api_msg.h" 2


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




























# 42 "../../src/include/lwip/api_msg.h" 2


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





# 44 "../../src/include/lwip/api_msg.h" 2

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





# 45 "../../src/include/lwip/api_msg.h" 2


# 1 "../../src/include/lwip/api.h" 1
 


















































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




# 47 "../../src/include/lwip/api_msg.h" 2


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



# 38 "../../src/api/api_msg.c" 2

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





	  
# 39 "../../src/api/api_msg.c" 2


# 1 "../../src/include/lwip/tcpip.h" 1
 







































void tcpip_init(void (* tcpip_init_done)(void *), void *arg);
void tcpip_apimsg(struct api_msg *apimsg);
err_t tcpip_input(struct pbuf *p, struct netif *inp);

enum tcpip_msg_type {
  TCPIP_MSG_API,
  TCPIP_MSG_INPUT
};

struct tcpip_msg {
  enum tcpip_msg_type type;
  sys_sem_t *sem;
  union {
    struct api_msg *apimsg;
    struct {
      struct pbuf *p;
      struct netif *netif;
    } inp;
  } msg;
};



# 41 "../../src/api/api_msg.c" 2


 
static err_t
recv_tcp(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err)
{
  struct netconn *conn;

  conn = arg;

  if(conn == ((void *)0) ) {
    pbuf_free(p);
    return -7 ;
  }
  
  if(conn->recvmbox != ((void *)0)  ) {
    conn->err = err;
    sys_mbox_post(conn->recvmbox, p);
  }  
  return 0 ;
}
 
static void
recv_udp(void *arg, struct udp_pcb *pcb, struct pbuf *p,
	 struct ip_addr *addr, u16_t port)
{
  struct netbuf *buf;
  struct netconn *conn;

  conn = arg;
  
  if(conn == ((void *)0) ) {
    pbuf_free(p);
    return;
  }

  if(conn->recvmbox != ((void *)0)  ) {
    buf = memp_mallocp(MEMP_NETBUF);
    if(buf == ((void *)0) ) {
      pbuf_free(p);
      return;
    } else {
      buf->p = p;
      buf->ptr = p;
      buf->fromaddr = addr;
      buf->fromport = port;
    }
    
    sys_mbox_post(conn->recvmbox, buf);
  }
}
 
static err_t
poll_tcp(void *arg, struct tcp_pcb *pcb)
{
  struct netconn *conn;

  conn = arg;
  if(conn != ((void *)0)  &&
     (conn->state == NETCONN_WRITE || conn->state == NETCONN_CLOSE) &&
     conn->sem != ((void *)0)  ) {
    sys_sem_signal(conn->sem);
  }
  return 0 ;
}
 
static err_t
sent_tcp(void *arg, struct tcp_pcb *pcb, u16_t len)
{
  struct netconn *conn;

  conn = arg;
  if(conn != ((void *)0)  && conn->sem != ((void *)0)  ) {
    sys_sem_signal(conn->sem);
  }
  return 0 ;
}
 
static void
err_tcp(void *arg, err_t err)
{
  struct netconn *conn;

  conn = arg;

  conn->pcb.tcp = ((void *)0) ;

  
  conn->err = err;
  if(conn->recvmbox != ((void *)0)  ) {
    sys_mbox_post(conn->recvmbox, ((void *)0) );
  }
  if(conn->mbox != ((void *)0)  ) {
    sys_mbox_post(conn->mbox, ((void *)0) );
  }
  if(conn->acceptmbox != ((void *)0)  ) {
    sys_mbox_post(conn->acceptmbox, ((void *)0) );
  }
  if(conn->sem != ((void *)0)  ) {
    sys_sem_signal(conn->sem);
  }
}
 
static void
setup_tcp(struct netconn *conn)
{
  struct tcp_pcb *pcb;
  
  pcb = conn->pcb.tcp;
  tcp_arg(pcb, conn);
  tcp_recv(pcb, recv_tcp);
  tcp_sent(pcb, sent_tcp);
  tcp_poll(pcb, poll_tcp, 4);
  tcp_err(pcb, err_tcp);
}
 
static err_t
accept_function(void *arg, struct tcp_pcb *newpcb, err_t err)
{
  sys_mbox_t *mbox;
  struct netconn *newconn;
  





  mbox = (sys_mbox_t *)arg;
  newconn = memp_mallocp(MEMP_NETCONN);
  if(newconn == ((void *)0) ) {
    return -1 ;
  }
  newconn->type = NETCONN_TCP;
  newconn->pcb.tcp = newpcb;
  setup_tcp(newconn);
  newconn->recvmbox = sys_mbox_new();
  if(newconn->recvmbox == ((void *)0)  ) {
    memp_free(MEMP_NETCONN, newconn);
    return -1 ;
  }
  newconn->mbox = sys_mbox_new();
  if(newconn->mbox == ((void *)0)  ) {
    sys_mbox_free(newconn->recvmbox);
    memp_free(MEMP_NETCONN, newconn);
    return -1 ;
  }
  newconn->sem = sys_sem_new(0);
  if(newconn->sem == ((void *)0)  ) {
    sys_mbox_free(newconn->recvmbox);
    sys_mbox_free(newconn->mbox);
    memp_free(MEMP_NETCONN, newconn);
    return -1 ;
  }
  newconn->acceptmbox = ((void *)0)  ;
  newconn->err = err;
  sys_mbox_post(*mbox, newconn);
  return 0 ;
}
 
static void
do_newconn(struct api_msg_msg *msg)
{
}
 
static void
do_delconn(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:
      msg->conn->pcb.udp->recv_arg = ((void *)0) ;
      udp_remove(msg->conn->pcb.udp);
      break;
    case NETCONN_TCP:
      tcp_arg(msg->conn->pcb.tcp, ((void *)0) );
      tcp_sent(msg->conn->pcb.tcp, ((void *)0) );
      tcp_recv(msg->conn->pcb.tcp, ((void *)0) );
      tcp_accept(msg->conn->pcb.tcp, ((void *)0) );
      tcp_poll(msg->conn->pcb.tcp, ((void *)0) , 0);
      tcp_err(msg->conn->pcb.tcp, ((void *)0) );
      if(msg->conn->pcb.tcp->state == LISTEN) {
	tcp_close(msg->conn->pcb.tcp);
      } else {
	if(tcp_close(msg->conn->pcb.tcp) != 0 ) {
	  tcp_abort(msg->conn->pcb.tcp);
	}
      }
    break;
    }
  }
  if(msg->conn->mbox != ((void *)0)  ) {
    sys_mbox_post(msg->conn->mbox, ((void *)0) );
  }
}
 
static void
do_bind(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp == ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      msg->conn->pcb.udp = udp_new();
      (( msg->conn->pcb.udp )->flags = (  0x02  )) ;
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDPNOCHKSUM:
      msg->conn->pcb.udp = udp_new();
      (( msg->conn->pcb.udp )->flags = (  0x01  )) ;
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDP:
      msg->conn->pcb.udp = udp_new();
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_new();
      setup_tcp(msg->conn);
      break;
    }
  }
  switch(msg->conn->type) {
  case NETCONN_UDPLITE:
     
  case NETCONN_UDPNOCHKSUM:
     
  case NETCONN_UDP:
    udp_bind(msg->conn->pcb.udp, msg->msg.bc.ipaddr, msg->msg.bc.port);
    break;
  case NETCONN_TCP:
    msg->conn->err = tcp_bind(msg->conn->pcb.tcp,
			      msg->msg.bc.ipaddr, msg->msg.bc.port);
    break;
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
static err_t
do_connected(void *arg, struct tcp_pcb *pcb, err_t err)
{
  struct netconn *conn;

  conn = arg;

  if(conn == ((void *)0) ) {
    return -7 ;
  }
  
  conn->err = err;

  if(conn->type == NETCONN_TCP && err == 0 ) {
    setup_tcp(conn);
  }    
  
  sys_mbox_post(conn->mbox, ((void *)0) );
  return 0 ;
}
 
static void
do_connect(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp == ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == ((void *)0) ) {
	msg->conn->err = -1 ;
	sys_mbox_post(msg->conn->mbox, ((void *)0) );
	return;
      }
      (( msg->conn->pcb.udp )->flags = (  0x02  )) ;
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDPNOCHKSUM:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == ((void *)0) ) {
	msg->conn->err = -1 ;
	sys_mbox_post(msg->conn->mbox, ((void *)0) );
	return;
      }
      (( msg->conn->pcb.udp )->flags = (  0x01  )) ;
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_UDP:
      msg->conn->pcb.udp = udp_new();
      if(msg->conn->pcb.udp == ((void *)0) ) {
	msg->conn->err = -1 ;
	sys_mbox_post(msg->conn->mbox, ((void *)0) );
	return;
      }
      udp_recv(msg->conn->pcb.udp, recv_udp, msg->conn);
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_new();      
      if(msg->conn->pcb.tcp == ((void *)0) ) {
	msg->conn->err = -1 ;
	sys_mbox_post(msg->conn->mbox, ((void *)0) );
	return;
      }
      break;
    }
  }
  switch(msg->conn->type) {
  case NETCONN_UDPLITE:
     
  case NETCONN_UDPNOCHKSUM:
     
  case NETCONN_UDP:
    udp_connect(msg->conn->pcb.udp, msg->msg.bc.ipaddr, msg->msg.bc.port);
    sys_mbox_post(msg->conn->mbox, ((void *)0) );
    break;
  case NETCONN_TCP:
     
    setup_tcp(msg->conn);
    tcp_connect(msg->conn->pcb.tcp, msg->msg.bc.ipaddr, msg->msg.bc.port,
		do_connected);
     
    break;
  }
}
 
static void
do_listen(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:
       ;
      break;
    case NETCONN_TCP:
      msg->conn->pcb.tcp = tcp_listen(msg->conn->pcb.tcp);
      if(msg->conn->pcb.tcp == ((void *)0) ) {
	msg->conn->err = -1 ;
      } else {
	if(msg->conn->acceptmbox == ((void *)0)  ) {
	  msg->conn->acceptmbox = sys_mbox_new();
	  if(msg->conn->acceptmbox == ((void *)0)  ) {
	    msg->conn->err = -1 ;
	    break;
	  }
	}
	tcp_arg(msg->conn->pcb.tcp, (void *)&(msg->conn->acceptmbox));
	tcp_accept(msg->conn->pcb.tcp, accept_function);
      }
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
static void
do_accept(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:    
       ;
      break;
    case NETCONN_TCP:
      break;
    }
  }
}
 
static void
do_send(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:
      udp_send(msg->conn->pcb.udp, msg->msg.p);
      break;
    case NETCONN_TCP:
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
static void
do_recv(struct api_msg_msg *msg)
{
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    if(msg->conn->type == NETCONN_TCP) {
      tcp_recved(msg->conn->pcb.tcp, msg->msg.len);
    }
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
static void
do_write(struct api_msg_msg *msg)
{
  err_t err;
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:
      msg->conn->err = -7 ;
      break;
    case NETCONN_TCP:      
      err = tcp_write(msg->conn->pcb.tcp, msg->msg.w.dataptr,
                      msg->msg.w.len, msg->msg.w.copy);
       



      if(err == 0  && msg->conn->pcb.tcp->unacked == ((void *)0) ) {
	tcp_output(msg->conn->pcb.tcp);
      }
      msg->conn->err = err;
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
static void
do_close(struct api_msg_msg *msg)
{
  err_t err;
  if(msg->conn->pcb.tcp != ((void *)0) ) {
    switch(msg->conn->type) {
    case NETCONN_UDPLITE:
       
    case NETCONN_UDPNOCHKSUM:
       
    case NETCONN_UDP:
      break;
    case NETCONN_TCP:
      if(msg->conn->pcb.tcp->state == LISTEN) {
	err = tcp_close(msg->conn->pcb.tcp);
      } else {
	err = tcp_close(msg->conn->pcb.tcp);
      }
      msg->conn->err = err;      
      break;
    }
  }
  sys_mbox_post(msg->conn->mbox, ((void *)0) );
}
 
typedef void (* api_msg_decode)(struct api_msg_msg *msg);
static api_msg_decode decode[API_MSG_MAX] = {
  do_newconn,
  do_delconn,
  do_bind,
  do_connect,
  do_listen,
  do_accept,
  do_send,
  do_recv,
  do_write,
  do_close
  };
void
api_msg_input(struct api_msg *msg)
{  
  decode[msg->type](&(msg->msg));
}
 
void
api_msg_post(struct api_msg *msg)
{
  tcpip_apimsg(msg);
}
 


