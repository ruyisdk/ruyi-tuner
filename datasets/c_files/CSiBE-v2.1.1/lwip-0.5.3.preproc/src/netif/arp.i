# 1 "../../src/netif/arp.c"
 



































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 37 "../../src/netif/arp.c" 2

# 1 "../../src/include/ipv4/lwip/inet.h" 1
 




































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















# 38 "../../src/include/ipv4/lwip/inet.h" 2


# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































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









# 38 "../../src/netif/arp.c" 2

# 1 "../../src/include/netif/arp.h" 1
 












































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


# 46 "../../src/include/netif/arp.h" 2


struct eth_addr {
   u8_t addr[6]  __attribute__((packed)) ;
} __attribute__((packed)) ;
  
struct eth_hdr {
   struct eth_addr dest  __attribute__((packed)) ;
   struct eth_addr src  __attribute__((packed)) ;
   u16_t type  __attribute__((packed)) ;
} __attribute__((packed)) ;






 
void arp_init(void);

 


void arp_tmr(void);

 



void arp_ip_input(struct netif *netif, struct pbuf *p);

 



struct pbuf *arp_arp_input(struct netif *netif, struct eth_addr *ethaddr,
			   struct pbuf *p);

 


struct eth_addr *arp_lookup(struct ip_addr *ipaddr);

 


struct pbuf *arp_query(struct netif *netif, struct eth_addr *ethaddr,
		       struct ip_addr *ipaddr);


# 39 "../../src/netif/arp.c" 2

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




























# 40 "../../src/netif/arp.c" 2














 
 
struct arp_hdr {
   struct eth_hdr ethhdr  __attribute__((packed)) ;
   u16_t hwtype  __attribute__((packed)) ;
   u16_t proto  __attribute__((packed)) ;
   u16_t _hwlen_protolen  __attribute__((packed)) ;
   u16_t opcode  __attribute__((packed)) ;
   struct eth_addr shwaddr  __attribute__((packed)) ;
   struct ip_addr sipaddr  __attribute__((packed)) ;
   struct eth_addr dhwaddr  __attribute__((packed)) ;
   struct ip_addr dipaddr  __attribute__((packed)) ;
} __attribute__((packed)) ;
 








 
struct ethip_hdr {
   struct eth_hdr eth  __attribute__((packed)) ;
   struct ip_hdr ip  __attribute__((packed)) ;
};
 

struct arp_entry {
  struct ip_addr ipaddr;
  struct eth_addr ethaddr;
  u8_t ctime;
};

static struct arp_entry arp_table[10 ];
static u8_t ctime;

 
void
arp_init(void)
{
  u8_t i;
  
  for(i = 0; i < 10 ; ++i) {
    ( &(arp_table[i].ipaddr) )->addr = (( 
		0  ) == 0 ? 0 :	((struct ip_addr *)  		0  )->addr) ;
  }
}
 
void
arp_tmr(void)
{
  u8_t i;
  
  ++ctime;
  for(i = 0; i < 10 ; ++i) {
    if(! (( &arp_table[i].ipaddr ) == ((void *)0)  || ( &arp_table[i].ipaddr )->addr == 0)  &&       
       ctime - arp_table[i].ctime >= 2 ) {
       ;
      ( &(arp_table[i].ipaddr) )->addr = (( 
		  0  ) == 0 ? 0 :	((struct ip_addr *)  		  0  )->addr) ;
    }
  }  
}
 
static void
add_arp_entry(struct ip_addr *ipaddr, struct eth_addr *ethaddr)
{
  u8_t i, j, k;
  u8_t maxtime;
  
   


  for(i = 0; i < 10 ; ++i) {
    
     
    if(! (( &arp_table[i].ipaddr ) == ((void *)0)  || ( &arp_table[i].ipaddr )->addr == 0) ) {
       

      if((( ipaddr )->addr == (  &arp_table[i].ipaddr )->addr) ) {
	 
	for(k = 0; k < 6; ++k) {
	  arp_table[i].ethaddr.addr[k] = ethaddr->addr[k];
	}
	arp_table[i].ctime = ctime;
	return;
      }
    }
  }

   


   
  for(i = 0; i < 10 ; ++i) {
    if((( &arp_table[i].ipaddr ) == ((void *)0)  || ( &arp_table[i].ipaddr )->addr == 0) ) {
      break;
    }
  }

   

  if(i == 10 ) {
    maxtime = 0;
    j = 0;
    for(i = 0; i < 10 ; ++i) {
      if(ctime - arp_table[i].ctime > maxtime) {
	maxtime = ctime - arp_table[i].ctime;
	j = i;
      }
    }
    i = j;
  }

   

  ( &arp_table[i].ipaddr )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
  for(k = 0; k < 6; ++k) {
    arp_table[i].ethaddr.addr[k] = ethaddr->addr[k];
  }
  arp_table[i].ctime = ctime;
  return;

}
 
void
arp_ip_input(struct netif *netif, struct pbuf *p)
{
  struct ethip_hdr *hdr;
  
  hdr = p->payload;
  
   

  if(! ((( &(hdr->ip.src) )->addr & (  &(netif->netmask) )->addr) == ((  &(netif->ip_addr) )->addr & (  &(netif->netmask) )->addr)) ) {
    return;
  }
   ;
  add_arp_entry(&(hdr->ip.src), &(hdr->eth.src));
}
 
struct pbuf *
arp_arp_input(struct netif *netif, struct eth_addr *ethaddr, struct pbuf *p)
{
  struct arp_hdr *hdr;
  u8_t i;
  
  if(p->tot_len < sizeof(struct arp_hdr)) {
     ;
    pbuf_free(p);
    return ((void *)0) ;
  }

  hdr = p->payload;
  
  switch(htons(hdr->opcode)) {
  case 1 :
     

     ;
    if((( &(hdr->dipaddr) )->addr == (  &(netif->ip_addr) )->addr) ) {
      hdr->opcode = htons(2 );

      ( &(hdr->dipaddr) )->addr = ((  &(hdr->sipaddr) ) == 0 ? 0 :	((struct ip_addr *)  &(hdr->sipaddr) )->addr) ;
      ( &(hdr->sipaddr) )->addr = ((  &(netif->ip_addr) ) == 0 ? 0 :	((struct ip_addr *)  &(netif->ip_addr) )->addr) ;

      for(i = 0; i < 6; ++i) {
	hdr->dhwaddr.addr[i] = hdr->shwaddr.addr[i];
	hdr->shwaddr.addr[i] = ethaddr->addr[i];
	hdr->ethhdr.dest.addr[i] = hdr->dhwaddr.addr[i];
	hdr->ethhdr.src.addr[i] = ethaddr->addr[i];
      }

      hdr->hwtype = htons(1 );
      ( hdr )->_hwlen_protolen = (((((u16_t)( ((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  & 0xff)  | ((  6 ) << 8) ) & 0xff)) << 8) | (((u16_t)( ((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  & 0xff)  | ((  6 ) << 8) ) & 0xff00) >> 8))  ;
      
      hdr->proto = htons(0x0800 );
      ( hdr )->_hwlen_protolen = (((((u16_t)( (  sizeof(struct ip_addr) ) | (((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff)) << 8) | (((u16_t)( (  sizeof(struct ip_addr) ) | (((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff00) >> 8))  ;      
      
      hdr->ethhdr.type = htons(0x0806 );      
      return p;
    }
    break;
  case 2 :    
     
     ;
    if((( &(hdr->dipaddr) )->addr == (  &(netif->ip_addr) )->addr) ) {
      add_arp_entry(&(hdr->sipaddr), &(hdr->shwaddr));



    }
    break;
  default:
     ;
    break;
  }

  pbuf_free(p);
  return ((void *)0) ;
}
 
struct eth_addr *
arp_lookup(struct ip_addr *ipaddr)
{
  u8_t i;
  
  for(i = 0; i < 10 ; ++i) {
    if((( ipaddr )->addr == (  &arp_table[i].ipaddr )->addr) ) {
      return &arp_table[i].ethaddr;
    }
  }
  return ((void *)0) ;  
}
 
struct pbuf *
arp_query(struct netif *netif, struct eth_addr *ethaddr, struct ip_addr *ipaddr)
{
  struct arp_hdr *hdr;
  struct pbuf *p;
  u8_t i;

  p = pbuf_alloc(PBUF_LINK, sizeof(struct arp_hdr), PBUF_RAM);
  if(p == ((void *)0) ) {
    return ((void *)0) ;
  }

  hdr = p->payload;
  
  hdr->opcode = htons(1 );

  for(i = 0; i < 6; ++i) {
    hdr->dhwaddr.addr[i] = 0x00;
    hdr->shwaddr.addr[i] = ethaddr->addr[i];
  }
  
  ( &(hdr->dipaddr) )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
  ( &(hdr->sipaddr) )->addr = ((  &(netif->ip_addr) ) == 0 ? 0 :	((struct ip_addr *)  &(netif->ip_addr) )->addr) ;

  hdr->hwtype = htons(1 );
  ( hdr )->_hwlen_protolen = (((((u16_t)( ((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  & 0xff)  | ((  6 ) << 8) ) & 0xff)) << 8) | (((u16_t)( ((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  & 0xff)  | ((  6 ) << 8) ) & 0xff00) >> 8))  ;

  hdr->proto = htons(0x0800 );
  ( hdr )->_hwlen_protolen = (((((u16_t)( (  sizeof(struct ip_addr) ) | (((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff)) << 8) | (((u16_t)( (  sizeof(struct ip_addr) ) | (((((((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff)) << 8) | (((u16_t)( (  hdr  )->_hwlen_protolen ) & 0xff00) >> 8))  >> 8)  << 8) ) & 0xff00) >> 8))  ;

  for(i = 0; i < 6; ++i) {
    hdr->ethhdr.dest.addr[i] = 0xff;
    hdr->ethhdr.src.addr[i] = ethaddr->addr[i];
  }
  
  hdr->ethhdr.type = htons(0x0806 );      
  return p;
}
 




