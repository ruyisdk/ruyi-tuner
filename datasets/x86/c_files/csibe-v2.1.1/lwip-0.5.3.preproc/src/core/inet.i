# 1 "../../src/core/inet.c"
 


































 
 





 

# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 45 "../../src/core/inet.c" 2


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















# 47 "../../src/core/inet.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 






































int strlen(const char *str);
int strncmp(const char *str1, const char *str2, int len);
void bcopy(const void *src, void *dest, int len);
void bzero(void *data, int n);




# 44 "../../src/include/lwip/def.h" 2




# 49 "../../src/core/inet.c" 2

# 1 "../../src/include/ipv4/lwip/inet.h" 1
 






































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









# 50 "../../src/core/inet.c" 2



 
 







 
static u32_t 
chksum(void *dataptr, int len)
{
  u32_t acc;
    
  for(acc = 0; len > 1; len -= 2) {
    u16_t *typecast=(u16_t *)dataptr;
    acc += *(typecast++);
    dataptr=(void *)typecast;
  }

   
  if(len == 1) {
    acc += htons((u16_t)((*(u8_t *)dataptr) & 0xff) << 8);
     ;
  }

  return acc;
}
 
 



 
u16_t
inet_chksum_pseudo(struct pbuf *p,
		   struct ip_addr *src, struct ip_addr *dest,
		   u8_t proto, u16_t proto_len)
{
  u32_t acc;
  struct pbuf *q;
  u8_t swapped;

  acc = 0;
  swapped = 0;
  for(q = p; q != ((void *)0) ; q = q->next) {    
    acc += chksum(q->payload, q->len);
    while(acc >> 16) {
      acc = (acc & 0xffff) + (acc >> 16);
    }
    if(q->len % 2 != 0) {
      swapped = 1 - swapped;
      acc = ((acc & 0xff) << 8) | ((acc & 0xff00) >> 8);
    }
  }

  if(swapped) {
    acc = ((acc & 0xff) << 8) | ((acc & 0xff00) >> 8);
  }
  acc += (src->addr & 0xffff);
  acc += ((src->addr >> 16) & 0xffff);
  acc += (dest->addr & 0xffff);
  acc += ((dest->addr >> 16) & 0xffff);
  acc += (u32_t)htons((u16_t)proto);
  acc += (u32_t)htons(proto_len);  
  
  while(acc >> 16) {
    acc = (acc & 0xffff) + (acc >> 16);
  }    
  return ~(acc & 0xffff);
}
 
 




 
u16_t
inet_chksum(void *dataptr, u16_t len)
{
  u32_t acc;

  acc = chksum(dataptr, len);
  while(acc >> 16) {
    acc = (acc & 0xffff) + (acc >> 16);
  }    
  return ~(acc & 0xffff);
}
 
u16_t
inet_chksum_pbuf(struct pbuf *p)
{
  u32_t acc;
  struct pbuf *q;
  u8_t swapped;
  
  acc = 0;
  swapped = 0;
  for(q = p; q != ((void *)0) ; q = q->next) {
    acc += chksum(q->payload, q->len);
    while(acc >> 16) {
      acc = (acc & 0xffff) + (acc >> 16);
    }    
    if(q->len % 2 != 0) {
      swapped = 1 - swapped;
      acc = (acc & 0xff << 8) | (acc & 0xff00 >> 8);
    }
  }
 
  if(swapped) {
    acc = ((acc & 0xff) << 8) | ((acc & 0xff00) >> 8);
  }
  return ~(acc & 0xffff);
}


 
