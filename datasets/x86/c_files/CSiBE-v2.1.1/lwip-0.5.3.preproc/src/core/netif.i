# 1 "../../src/core/netif.c"
 


































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 36 "../../src/core/netif.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 38 "../../src/core/netif.c" 2

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













# 39 "../../src/core/netif.c" 2

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


# 40 "../../src/core/netif.c" 2


struct netif *netif_list = ((void *)0) ;
struct netif *netif_default = ((void *)0) ;

 
struct netif *
netif_add(struct ip_addr *ipaddr, struct ip_addr *netmask,
	  struct ip_addr *gw,
	  void (* init)(struct netif *netif),
	  err_t (* input)(struct pbuf *p, struct netif *netif))
{
  struct netif *netif;
  static int netifnum = 0;
  
  netif = mem_malloc(sizeof(struct netif));

  if(netif == ((void *)0) ) {
    return ((void *)0) ;
  }
  
  netif->num = netifnum++;
  netif->input = input;
  ( &(netif->ip_addr) )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
  ( &(netif->netmask) )->addr = ((  netmask ) == 0 ? 0 :	((struct ip_addr *)  netmask )->addr) ;
  ( &(netif->gw) )->addr = ((  gw ) == 0 ? 0 :	((struct ip_addr *)  gw )->addr) ;

  init(netif);
  
  netif->next = netif_list;
  netif_list = netif;
# 80 "../../src/core/netif.c"

  return netif;
}
 
struct netif *
netif_find(char *name)
{
  struct netif *netif;
  u8_t num;
  
  if(name == ((void *)0) ) {
    return ((void *)0) ;
  }

  num = name[2] - '0';
 
  for(netif = netif_list; netif != ((void *)0) ; netif = netif->next) {
    if(num == netif->num &&
       name[0] == netif->name[0] &&
       name[1] == netif->name[1]) {
       ;
      return netif;
    }    
  }
   ;
  return ((void *)0) ;
}
 
void
netif_set_ipaddr(struct netif *netif, struct ip_addr *ipaddr)
{
  ( &(netif->ip_addr) )->addr = ((  ipaddr ) == 0 ? 0 :	((struct ip_addr *)  ipaddr )->addr) ;
   ;





}
 
void
netif_set_gw(struct netif *netif, struct ip_addr *gw)
{
  ( &(netif->gw) )->addr = ((  gw ) == 0 ? 0 :	((struct ip_addr *)  gw )->addr) ;
}
 
void
netif_set_netmask(struct netif *netif, struct ip_addr *netmask)
{
  ( &(netif->netmask) )->addr = ((  netmask ) == 0 ? 0 :	((struct ip_addr *)  netmask )->addr) ;
}
 
void
netif_set_default(struct netif *netif)
{
  netif_default = netif;
   ;

}
 
void
netif_init(void)
{
  netif_list = netif_default = ((void *)0) ;
}
 
