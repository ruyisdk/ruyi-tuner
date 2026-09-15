# 1 "../../src/api/sockets.c"
 


































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 36 "../../src/api/sockets.c" 2

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




# 37 "../../src/api/sockets.c" 2


# 1 "../../src/include/lwip/sockets.h" 1
 






































struct in_addr {
  u32_t s_addr;
};


struct sockaddr_in {
  u8_t sin_len;
  u8_t sin_family;
  u16_t sin_port;
  struct in_addr sin_addr;
  char sin_zero[8];
};

struct sockaddr {
  u8_t sa_len;
  u8_t sa_family;
  char sa_data[14];
};













int lwip_accept(int s, struct sockaddr *addr, int *addrlen);
int lwip_bind(int s, struct sockaddr *name, int namelen);
int lwip_close(int s);
int lwip_connect(int s, struct sockaddr *name, int namelen);
int lwip_listen(int s, int backlog);
int lwip_recv(int s, void *mem, int len, unsigned int flags);
int lwip_read(int s, void *mem, int len);
int lwip_recvfrom(int s, void *mem, int len, unsigned int flags,
		  struct sockaddr *from, int *fromlen);
int lwip_send(int s, void *dataptr, int size, unsigned int flags);
int lwip_sendto(int s, void *dataptr, int size, unsigned int flags,
		struct sockaddr *to, int tolen);
int lwip_socket(int domain, int type, int protocol);
int lwip_write(int s, void *dataptr, int size);

# 99 "../../src/include/lwip/sockets.h"




# 39 "../../src/api/sockets.c" 2




struct lwip_socket {
  struct netconn *conn;
  struct netbuf *lastdata;
  u16_t lastoffset;
};

static struct lwip_socket sockets[10 ];

 
static struct lwip_socket *
get_socket(int s)
{
  struct lwip_socket *sock;
  
  if(s > 10 ) {
     
    return ((void *)0) ;
  }
  
  sock = &sockets[s];

  if(sock->conn == ((void *)0) ) {
     
    return ((void *)0) ;
  }
  return sock;
}
 
static int
alloc_socket(struct netconn *newconn)
{
  int i;
  
   
  for(i = 0; i < 10 ; ++i) {
    if(sockets[i].conn == ((void *)0) ) {
      sockets[i].conn = newconn;
      sockets[i].lastdata = ((void *)0) ;
      sockets[i].lastoffset = 0;
      return i;
    }
  }
  return -1;
}
 
int
lwip_accept(int s, struct sockaddr *addr, int *addrlen)
{
  struct lwip_socket *sock;
  struct netconn *newconn;
  struct ip_addr *naddr;
  u16_t port;
  int newsock;

  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
  
  newconn = netconn_accept(sock->conn);
    
   
  netconn_peer(newconn, &naddr, &port);
  
  ((struct sockaddr_in *)addr)->sin_addr.s_addr = naddr->addr;
  ((struct sockaddr_in *)addr)->sin_port = port;

  newsock = alloc_socket(newconn);
  if(newsock == -1) {  
    netconn_delete(newconn);
     
  }
  return newsock;
}
 
int
lwip_bind(int s, struct sockaddr *name, int namelen)
{
  struct lwip_socket *sock;
  struct ip_addr remote_addr;
  u16_t remote_port;
  err_t err;
  
  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
  
  remote_addr.addr = ((struct sockaddr_in *)name)->sin_addr.s_addr;
  remote_port = ((struct sockaddr_in *)name)->sin_port;
  
  err = netconn_bind(sock->conn, &remote_addr, htons (remote_port));

  if(err != 0 ) {
     
    return -1;
  }

  return 0;
}
 
int
lwip_close(int s)
{
  struct lwip_socket *sock;
  
   ;
  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
  
  
  netconn_delete(sock->conn);
  if(sock->lastdata != ((void *)0) ) {
    netbuf_delete(sock->lastdata);
  }
  sock->lastdata = ((void *)0) ;
  sock->lastoffset = 0;
  sock->conn = ((void *)0) ;
  return 0;
}
 
int
lwip_connect(int s, struct sockaddr *name, int namelen)
{
  struct lwip_socket *sock;
  struct ip_addr remote_addr;
  u16_t remote_port;
  err_t err;

  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
  
  remote_addr.addr = ((struct sockaddr_in *)name)->sin_addr.s_addr;
  remote_port = ((struct sockaddr_in *)name)->sin_port;
  
  err = netconn_connect(sock->conn, &remote_addr, htons (remote_port));

  if(err != 0 ) {
     
    return -1;
  }

  return 0;
}
 
int
lwip_listen(int s, int backlog)
{
  struct lwip_socket *sock;    
  err_t err;
  
  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
 
  err = netconn_listen(sock->conn);

  if(err != 0 ) {
     
    return -1;
  }

  return 0;
}
 
int
lwip_recvfrom(int s, void *mem, int len, unsigned int flags,
	      struct sockaddr *from, int *fromlen)
{
  struct lwip_socket *sock;
  struct netbuf *buf;
  u16_t buflen, copylen;
  struct ip_addr *addr;
  u16_t port;

  
  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }

   
  if(sock->lastdata != ((void *)0) ) {    
    buf = sock->lastdata;
  } else {
     

    buf = netconn_recv(sock->conn);
    
    if(buf == ((void *)0) ) {
       
      return 0;
    }
  }
  
  buflen = netbuf_len(buf);

  buflen -= sock->lastoffset;
  
  if(len > buflen) {
    copylen = buflen;
  } else {
    copylen = len;
  }
  
   

  netbuf_copy_partial(buf, mem, copylen, sock->lastoffset);

   


  if(netconn_type(sock->conn) == NETCONN_TCP && buflen - copylen > 0) {
    sock->lastdata = buf;
    sock->lastoffset = buflen - copylen;
  } else {
    sock->lastdata = ((void *)0) ;
    sock->lastoffset = 0;
    netbuf_delete(buf);
  }

   
  if(from != ((void *)0)  && fromlen != ((void *)0) ) {
    addr = netbuf_fromaddr(buf);
    port = htons(netbuf_fromport(buf));  
    ((struct sockaddr_in *)from)->sin_addr.s_addr = addr->addr;
    ((struct sockaddr_in *)from)->sin_port = port;
    *fromlen = sizeof(struct sockaddr_in);
  }

  
   



  if(len > copylen) {
    return copylen;
  } else {
    return len;
  }
}
 
int
lwip_read(int s, void *mem, int len)
{
  return lwip_recv(s, mem, len, 0);
}
 
int
lwip_recv(int s, void *mem, int len, unsigned int flags)
{
  return lwip_recvfrom(s, mem, len, flags, ((void *)0) , ((void *)0) );
}
 
int
lwip_send(int s, void *data, int size, unsigned int flags)
{
  struct lwip_socket *sock;
  struct netbuf *buf;
  err_t err;

   ;

  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }  
  
  switch(netconn_type(sock->conn)) {
  case NETCONN_UDP:
     
    buf = netbuf_new();

    if(buf == ((void *)0) ) {
       
      return -1;
    }
    
     

    netbuf_ref(buf, data, size);

     
    err = netconn_send(sock->conn, buf);

     
    netbuf_delete(buf);
    break;
  case NETCONN_TCP:
    err = netconn_write(sock->conn, data, size, 0x01 );
    break;
  default:
    err = -8 ;
    break;
  }
  if(err != 0 ) {
     
    return -1;    
  }
    
  return size;
}
 
int
lwip_sendto(int s, void *data, int size, unsigned int flags,
       struct sockaddr *to, int tolen)
{
  struct lwip_socket *sock;
  struct ip_addr remote_addr, *addr;
  u16_t remote_port, port;
  int ret;

  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
  
   
  netconn_peer(sock->conn, &addr, &port);
  
  remote_addr.addr = ((struct sockaddr_in *)to)->sin_addr.s_addr;
  remote_port = ((struct sockaddr_in *)to)->sin_port;
  netconn_connect(sock->conn, &remote_addr, remote_port);
  
  ret = lwip_send(s, data, size, flags);

   

  netconn_connect(sock->conn, addr, port);
  return ret;
}
 
int
lwip_socket(int domain, int type, int protocol)
{
  struct netconn *conn;
  int i;

   
  switch(type) {
  case 2 :
    conn = netconn_new(NETCONN_UDP);
    break;
  case 1 :
    conn = netconn_new(NETCONN_TCP);
    break;
  default:
     
    return -1;
  }

  if(conn == ((void *)0) ) {
     ;
     
    return -1;
  }

  i = alloc_socket(conn);

  if(i == -1) {
     
    netconn_delete(conn);
  }
  return i;
}
 
int
lwip_write(int s, void *data, int size)
{
  struct lwip_socket *sock;
  err_t err;

   ;

  sock = get_socket(s);
  if(sock == ((void *)0) ) {
    return -1;
  }
    
  switch(netconn_type(sock->conn)) {
  case NETCONN_UDP:
    return lwip_send(s, data, size, 0);

  case NETCONN_TCP:
    err = netconn_write(sock->conn, data, size, 0x01 );
    break;
  default:
    err = -8 ;
    break;
  }
  if(err != 0 ) {
     
    return -1;
  }
  return size;
}
 
