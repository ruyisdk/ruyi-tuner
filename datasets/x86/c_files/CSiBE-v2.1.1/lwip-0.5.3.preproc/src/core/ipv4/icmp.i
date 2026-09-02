# 1 "../../src/core/ipv4/icmp.c"
 


































 


# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 39 "../../src/core/ipv4/icmp.c" 2


# 1 "../../src/include/ipv4/lwip/icmp.h" 1
 




































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















# 38 "../../src/include/ipv4/lwip/icmp.h" 2


# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 40 "../../src/include/ipv4/lwip/icmp.h" 2

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


# 41 "../../src/include/ipv4/lwip/icmp.h" 2


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


# 43 "../../src/include/ipv4/lwip/icmp.h" 2














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








	  
# 41 "../../src/core/ipv4/icmp.c" 2


# 1 "../../src/include/ipv4/lwip/ip.h" 1
 






































# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 40 "../../src/include/ipv4/lwip/ip.h" 2







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




























# 43 "../../src/core/ipv4/icmp.c" 2



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





# 46 "../../src/core/ipv4/icmp.c" 2


 
void
icmp_input(struct pbuf *p, struct netif *inp)
{
  unsigned char type;
  struct icmp_echo_hdr *iecho;
  struct ip_hdr *iphdr;
  struct ip_addr tmpaddr;
  u16_t hlen;
  

  ++stats.icmp.recv;


  
  iphdr = p->payload;
  hlen = (((((((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_v_hl_tos ) & 0xff00) >> 8))  >> 8) & 0x0f)  * 4/sizeof(u8_t);
  pbuf_header(p, -hlen);

  type = *((u8_t *)p->payload);

  switch(type) {
  case 8 :
    if(((((( &iphdr->dest )->addr) & ~((  &inp->netmask )->addr)) == (0xffffffff & ~((  &inp->netmask )->addr))) || (( &iphdr->dest )->addr == 0xffffffff) || (( &iphdr->dest )->addr == 0x00000000))  ||
       ((( &iphdr->dest )->addr & htonl (0xf0000000)) == htonl (0xe0000000)) ) {
       ;

      ++stats.icmp.err;

      pbuf_free(p);
      return;
    }
     ;
     ;
    if(p->tot_len < sizeof(struct icmp_echo_hdr)) {
       ;
      pbuf_free(p);

      ++stats.icmp.lenerr;


      return;      
    }
    iecho = p->payload;    
    if(inet_chksum_pbuf(p) != 0) {
       ;
      pbuf_free(p);

      ++stats.icmp.chkerr;

      return;
    }
    tmpaddr.addr = iphdr->src.addr;
    iphdr->src.addr = iphdr->dest.addr;
    iphdr->dest.addr = tmpaddr.addr;
    (( iecho )->_type_code = (((((u16_t)( ((((((u16_t)( (  iecho  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  iecho  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  0  ) << 8) ) & 0xff)) << 8) | (((u16_t)( ((((((u16_t)( (  iecho  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  iecho  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  0  ) << 8) ) & 0xff00) >> 8)) ) ;
     
    if(iecho->chksum >= htons(0xffff - (8  << 8))) {
      iecho->chksum += htons(8  << 8) + 1;
    } else {
      iecho->chksum += htons(8  << 8);
    }

    ++stats.icmp.xmit;


    pbuf_header(p, hlen);
    ip_output_if(p, &(iphdr->src), ((void *)0)  ,
		 ((((((u16_t)( ( iphdr )->_ttl_proto ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_ttl_proto ) & 0xff00) >> 8))  >> 8) , 1 , inp);
    break; 
  default:
     ;

    ++stats.icmp.proterr;
    ++stats.icmp.drop;

  }
  pbuf_free(p);
}
 
void
icmp_dest_unreach(struct pbuf *p, enum icmp_dur_type t)
{
  struct pbuf *q;
  struct ip_hdr *iphdr;
  struct icmp_dur_hdr *idur;
  
  q = pbuf_alloc(PBUF_TRANSPORT, 8 + 20  + 8, PBUF_RAM);
   

  iphdr = p->payload;
  
  idur = q->payload;
  (( idur )->_type_code = (((((u16_t)( ((((((u16_t)( (  idur  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  idur  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  3  ) << 8) ) & 0xff)) << 8) | (((u16_t)( ((((((u16_t)( (  idur  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  idur  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  3  ) << 8) ) & 0xff00) >> 8)) ) ;
  (( idur )->_type_code = (((((u16_t)( (  t ) | (((((((u16_t)( (  idur  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  idur  )->_type_code ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff)) << 8) | (((u16_t)( (  t ) | (((((((u16_t)( (  idur  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  idur  )->_type_code ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff00) >> 8)) ) ;

  bcopy(p->payload, (char *)q->payload + 8, 20  + 8);
  
   
  idur->chksum = 0;
  idur->chksum = inet_chksum(idur, q->len);

  ++stats.icmp.xmit;


  ip_output(q, ((void *)0) , &(iphdr->src),
	    255 , 1 );
  pbuf_free(q);
}
 
void
icmp_time_exceeded(struct pbuf *p, enum icmp_te_type t)
{
  struct pbuf *q;
  struct ip_hdr *iphdr;
  struct icmp_te_hdr *tehdr;

  q = pbuf_alloc(PBUF_TRANSPORT, 8 + 20  + 8, PBUF_RAM);

  iphdr = p->payload;








  tehdr = q->payload;
  (( tehdr )->_type_code = (((((u16_t)( ((((((u16_t)( (  tehdr  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  tehdr  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  11  ) << 8) ) & 0xff)) << 8) | (((u16_t)( ((((((u16_t)( (  tehdr  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  tehdr  )->_type_code ) & 0xff00) >> 8))  & 0xff)  | ((  11  ) << 8) ) & 0xff00) >> 8)) ) ;
  (( tehdr )->_type_code = (((((u16_t)( (  t ) | (((((((u16_t)( (  tehdr  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  tehdr  )->_type_code ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff)) << 8) | (((u16_t)( (  t ) | (((((((u16_t)( (  tehdr  )->_type_code ) & 0xff)) << 8) | (((u16_t)( (  tehdr  )->_type_code ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff00) >> 8)) ) ;

   
  bcopy((char *)p->payload, (char *)q->payload + 8, 20  + 8);
  
   
  tehdr->chksum = 0;
  tehdr->chksum = inet_chksum(tehdr, q->len);

  ++stats.icmp.xmit;

  ip_output(q, ((void *)0) , &(iphdr->src),
	    255 , 1 );
  pbuf_free(q);
}








