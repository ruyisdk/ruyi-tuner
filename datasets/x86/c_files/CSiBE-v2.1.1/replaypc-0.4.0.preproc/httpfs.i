# 1 "httpfs.c"
 













# 1 "rtv.h" 1
 


















typedef unsigned char      u8;
typedef unsigned short     u16;
typedef unsigned long      u32;
typedef unsigned long long u64;
typedef          long long s64;




















struct replaytv_version {
    int major, minor, patch, build;
};

extern struct replaytv_version replaytv_version;

extern u16  rtv_to_u16(unsigned char ** pp);
extern u32  rtv_to_u32(unsigned char ** pp);
extern u64  rtv_to_u64(unsigned char ** pp);
extern void rtv_from_u16(unsigned char ** pp, u16 v);
extern void rtv_from_u32(unsigned char ** pp, u32 v);
extern void rtv_from_u64(unsigned char ** pp, u64 v);

extern int rtv_set_replaytv_version(char * version);

extern int rtv_split_lines(char * src, char *** dst);
extern void rtv_free_lines(int num, char ** lines);









# 15 "httpfs.c" 2

# 1 "httpfsclient.h" 1
 















 
































# 1 "httpclient.h" 1
 













 






















































# 1 "netclient.h" 1
 
















# 1 "/SYS/include/stdlib.h" 1 3
 

















 





# 1 "/SYS/include/features.h" 1 3
 




















 






























































 




















 





 



 







 
# 142 "/SYS/include/features.h" 3


 









 








 



























# 208 "/SYS/include/features.h" 3


































 



 


 








 




 
















 


# 1 "/SYS/include/sys/cdefs.h" 1 3
 




















 




 






 





 








 



# 65 "/SYS/include/sys/cdefs.h" 3


 





 




 









 







 

















 















 







 






 








 








 








 











 










 







 




 


















# 283 "/SYS/include/features.h" 2 3



 








 





 

 








# 1 "/SYS/include/gnu/stubs.h" 1 3
 



















# 312 "/SYS/include/features.h" 2 3




# 25 "/SYS/include/stdlib.h" 2 3


 





# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


































typedef unsigned int size_t;






















 




 





























 


























typedef long int wchar_t;

















# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 33 "/SYS/include/stdlib.h" 2 3


 




# 91 "/SYS/include/stdlib.h" 3


 
typedef struct
  {
    int quot;			 
    int rem;			 
  } div_t;

 

typedef struct
  {
    long int quot;		 
    long int rem;		 
  } ldiv_t;



# 118 "/SYS/include/stdlib.h" 3



 



 





 

extern size_t __ctype_get_mb_cur_max (void)  ;


 
extern double atof (__const char *__nptr)    ;
 
extern int atoi (__const char *__nptr)    ;
 
extern long int atol (__const char *__nptr)    ;


 
__extension__ extern long long int atoll (__const char *__nptr)
        ;


 
extern double strtod (__const char *__restrict __nptr,
		      char **__restrict __endptr)  ;










 
extern long int strtol (__const char *__restrict __nptr,
			char **__restrict __endptr, int __base)  ;
 
extern unsigned long int strtoul (__const char *__restrict __nptr,
				  char **__restrict __endptr, int __base)
      ;


 
__extension__
extern long long int strtoq (__const char *__restrict __nptr,
			     char **__restrict __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtouq (__const char *__restrict __nptr,
				       char **__restrict __endptr, int __base)
      ;



 

 
__extension__
extern long long int strtoll (__const char *__restrict __nptr,
			      char **__restrict __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtoull (__const char *__restrict __nptr,
					char **__restrict __endptr, int __base)
      ;



# 244 "/SYS/include/stdlib.h" 3



 


extern double __strtod_internal (__const char *__restrict __nptr,
				 char **__restrict __endptr, int __group)
      ;
extern float __strtof_internal (__const char *__restrict __nptr,
				char **__restrict __endptr, int __group)
      ;
extern long double __strtold_internal (__const char *__restrict __nptr,
				       char **__restrict __endptr,
				       int __group)  ;

extern long int __strtol_internal (__const char *__restrict __nptr,
				   char **__restrict __endptr,
				   int __base, int __group)  ;



extern unsigned long int __strtoul_internal (__const char *__restrict __nptr,
					     char **__restrict __endptr,
					     int __base, int __group)  ;




__extension__
extern long long int __strtoll_internal (__const char *__restrict __nptr,
					 char **__restrict __endptr,
					 int __base, int __group)  ;



__extension__
extern unsigned long long int __strtoull_internal (__const char *
						   __restrict __nptr,
						   char **__restrict __endptr,
						   int __base, int __group)
      ;




# 377 "/SYS/include/stdlib.h" 3




 


extern char *l64a (long int __n)  ;

 
extern long int a64l (__const char *__s)    ;


# 1 "/SYS/include/sys/types.h" 1 3
 

















 








 

# 1 "/SYS/include/bits/types.h" 1 3
 

















 









# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

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




# 30 "/SYS/include/sys/types.h" 2 3




typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;





typedef __ino64_t ino_t;




typedef __ino64_t ino64_t;




typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;







typedef __off64_t off_t;




typedef __off64_t off64_t;




typedef __pid_t pid_t;




typedef __id_t id_t;




typedef __ssize_t ssize_t;





typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;









# 1 "/SYS/include/time.h" 1 3
 

















 














# 51 "/SYS/include/time.h" 3


# 61 "/SYS/include/time.h" 3








 
typedef __time_t time_t;










 
typedef __clockid_t clockid_t;










 
typedef __timer_t timer_t;





# 112 "/SYS/include/time.h" 3




# 364 "/SYS/include/time.h" 3



# 132 "/SYS/include/sys/types.h" 2 3


# 143 "/SYS/include/sys/types.h" 3



# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 146 "/SYS/include/sys/types.h" 2 3



 
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;


 

# 180 "/SYS/include/sys/types.h" 3


 







typedef int int8_t __attribute__ ((__mode__ (  __QI__ ))) ;
typedef int int16_t __attribute__ ((__mode__ (  __HI__ ))) ;
typedef int int32_t __attribute__ ((__mode__ (  __SI__ ))) ;
typedef int int64_t __attribute__ ((__mode__ (  __DI__ ))) ;


typedef unsigned int u_int8_t __attribute__ ((__mode__ (  __QI__ ))) ;
typedef unsigned int u_int16_t __attribute__ ((__mode__ (  __HI__ ))) ;
typedef unsigned int u_int32_t __attribute__ ((__mode__ (  __SI__ ))) ;
typedef unsigned int u_int64_t __attribute__ ((__mode__ (  __DI__ ))) ;

typedef int register_t __attribute__ ((__mode__ (__word__)));


 






 
# 1 "/SYS/include/endian.h" 1 3
 






















 











 
# 1 "/SYS/include/bits/endian.h" 1 3
 






# 37 "/SYS/include/endian.h" 2 3


 



















# 212 "/SYS/include/sys/types.h" 2 3


 
# 1 "/SYS/include/sys/select.h" 1 3
 


















 






 


 
# 1 "/SYS/include/bits/select.h" 1 3
 

























# 36 "/SYS/include/bits/select.h" 3












# 56 "/SYS/include/bits/select.h" 3

# 72 "/SYS/include/bits/select.h" 3

# 31 "/SYS/include/sys/select.h" 2 3


 
# 1 "/SYS/include/bits/sigset.h" 1 3
 





















typedef int __sig_atomic_t;

 


typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int))) ];
  } __sigset_t;




 





# 125 "/SYS/include/bits/sigset.h" 3

# 34 "/SYS/include/sys/select.h" 2 3




typedef __sigset_t sigset_t;


 


# 1 "/SYS/include/time.h" 1 3
 

















 














# 51 "/SYS/include/time.h" 3


# 61 "/SYS/include/time.h" 3



# 72 "/SYS/include/time.h" 3



# 84 "/SYS/include/time.h" 3



# 96 "/SYS/include/time.h" 3








 

struct timespec
  {
    __time_t tv_sec;		 
    long int tv_nsec;		 
  };





# 364 "/SYS/include/time.h" 3



# 44 "/SYS/include/sys/select.h" 2 3


# 1 "/SYS/include/bits/time.h" 1 3
 


















 



# 57 "/SYS/include/bits/time.h" 3








 

struct timeval
  {
    __time_t tv_sec;		 
    __suseconds_t tv_usec;	 
  };


# 46 "/SYS/include/sys/select.h" 2 3



typedef __suseconds_t suseconds_t;




 
typedef long int __fd_mask;

 




 
typedef struct
  {
     





    __fd_mask __fds_bits[1024  / (8 * sizeof (__fd_mask)) ];


  } fd_set;

 



 
typedef __fd_mask fd_mask;

 




 






 

 




extern int select (int __nfds, fd_set *__restrict __readfds,
		   fd_set *__restrict __writefds,
		   fd_set *__restrict __exceptfds,
		   struct timeval *__restrict __timeout)  ;

# 116 "/SYS/include/sys/select.h" 3


 


# 215 "/SYS/include/sys/types.h" 2 3


 
# 1 "/SYS/include/sys/sysmacros.h" 1 3
 





















 








# 47 "/SYS/include/sys/sysmacros.h" 3



# 218 "/SYS/include/sys/types.h" 2 3









 
# 241 "/SYS/include/sys/types.h" 3


typedef __blkcnt64_t blkcnt_t;	    



typedef __fsblkcnt64_t fsblkcnt_t;  



typedef __fsfilcnt64_t fsfilcnt_t;  





typedef __blkcnt64_t blkcnt64_t;      
typedef __fsblkcnt64_t fsblkcnt64_t;  
typedef __fsfilcnt64_t fsfilcnt64_t;  


 


# 390 "/SYS/include/stdlib.h" 2 3


 



 
extern long int random (void)  ;

 
extern void srandom (unsigned int __seed)  ;

 



extern char *initstate (unsigned int __seed, char *__statebuf,
			size_t __statelen)  ;

 

extern char *setstate (char *__statebuf)  ;



 



struct random_data
  {
    int32_t *fptr;		 
    int32_t *rptr;		 
    int32_t *state;		 
    int rand_type;		 
    int rand_deg;		 
    int rand_sep;		 
    int32_t *end_ptr;		 
  };

extern int random_r (struct random_data *__restrict __buf,
		     int32_t *__restrict __result)  ;

extern int srandom_r (unsigned int __seed, struct random_data *__buf)  ;

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
			size_t __statelen,
			struct random_data *__restrict __buf)  ;

extern int setstate_r (char *__restrict __statebuf,
		       struct random_data *__restrict __buf)  ;




 
extern int rand (void)  ;
 
extern void srand (unsigned int __seed)  ;


 
extern int rand_r (unsigned int *__seed)  ;




 

 
extern double drand48 (void)  ;
extern double erand48 (unsigned short int __xsubi[3])  ;

 
extern long int lrand48 (void)  ;
extern long int nrand48 (unsigned short int __xsubi[3])  ;

 
extern long int mrand48 (void)  ;
extern long int jrand48 (unsigned short int __xsubi[3])  ;

 
extern void srand48 (long int __seedval)  ;
extern unsigned short int *seed48 (unsigned short int __seed16v[3])  ;
extern void lcong48 (unsigned short int __param[7])  ;


 


struct drand48_data
  {
    unsigned short int __x[3];	 
    unsigned short int __old_x[3];  
    unsigned short int __c;	 
    unsigned short int __init;	 
    unsigned long long int __a;	 
  };

 
extern int drand48_r (struct drand48_data *__restrict __buffer,
		      double *__restrict __result)  ;
extern int erand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      double *__restrict __result)  ;

 
extern int lrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;
extern int nrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;

 
extern int mrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;
extern int jrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;

 
extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
      ;

extern int seed48_r (unsigned short int __seed16v[3],
		     struct drand48_data *__buffer)  ;

extern int lcong48_r (unsigned short int __param[7],
		      struct drand48_data *__buffer)  ;







 
extern void *malloc (size_t __size)    ;
 
extern void *calloc (size_t __nmemb, size_t __size)
        ;



 

extern void *realloc (void *__ptr, size_t __size)    ;
 
extern void free (void *__ptr)  ;


 
extern void cfree (void *__ptr)  ;



# 1 "/SYS/include/alloca.h" 1 3
 























# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 25 "/SYS/include/alloca.h" 2 3


 

 


 
extern void *alloca (size_t __size)  ;





 


# 546 "/SYS/include/stdlib.h" 2 3




 
extern void *valloc (size_t __size)    ;








 
extern void abort (void)   __attribute__ ((__noreturn__));


 
extern int atexit (void (*__func) (void))  ;


 

extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
      ;


 


extern void exit (int __status)   __attribute__ ((__noreturn__));








 
extern char *getenv (__const char *__name)  ;

 

extern char *__secure_getenv (__const char *__name)  ;


 
 

extern int putenv (char *__string)  ;



 

extern int setenv (__const char *__name, __const char *__value, int __replace)
      ;

 
extern int unsetenv (__const char *__name)  ;



 


extern int clearenv (void)  ;




 



extern char *mktemp (char *__template)  ;

 








extern int  mkstemp    (char *__template)    __asm__ (""     "mkstemp64"    ) ;





extern int mkstemp64 (char *__template)  ;




 




extern char *mkdtemp (char *__template)  ;



 
extern int system (__const char *__command)  ;










 





extern char *realpath (__const char *__restrict __name,
		       char *__restrict __resolved)  ;



 


typedef int (*__compar_fn_t) (__const void *, __const void *);






 

extern void *bsearch (__const void *__key, __const void *__base,
		      size_t __nmemb, size_t __size, __compar_fn_t __compar);

 

extern void qsort (void *__base, size_t __nmemb, size_t __size,
		   __compar_fn_t __compar);


 
extern int abs (int __x)   __attribute__ ((__const__));
extern long int labs (long int __x)   __attribute__ ((__const__));






 

 
extern div_t div (int __numer, int __denom)
       __attribute__ ((__const__));
extern ldiv_t ldiv (long int __numer, long int __denom)
       __attribute__ ((__const__));








 


 


extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign)  ;

 


extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign)  ;

 


extern char *gcvt (double __value, int __ndigit, char *__buf)  ;



 
extern char *qecvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)  ;
extern char *qfcvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)  ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)  ;


 

extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len)  ;
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len)  ;

extern int qecvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)  ;
extern int qfcvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)  ;




 

extern int mblen (__const char *__s, size_t __n)  ;
 

extern int mbtowc (wchar_t *__restrict __pwc,
		   __const char *__restrict __s, size_t __n)  ;
 

extern int wctomb (char *__s, wchar_t __wchar)  ;


 
extern size_t mbstowcs (wchar_t *__restrict  __pwcs,
			__const char *__restrict __s, size_t __n)  ;
 
extern size_t wcstombs (char *__restrict __s,
			__const wchar_t *__restrict __pwcs, size_t __n)
      ;



 



extern int rpmatch (__const char *__response)  ;



# 811 "/SYS/include/stdlib.h" 3









 






# 842 "/SYS/include/stdlib.h" 3


# 852 "/SYS/include/stdlib.h" 3



 


extern int getloadavg (double __loadavg[], int __nelem)  ;





 


# 18 "netclient.h" 2


struct nc;

extern void        nc_error(char * where);
extern struct nc * nc_open(char * address, short port);
extern int         nc_close(struct nc * nc);
extern int         nc_read(struct nc * nc, unsigned char * buf, size_t len);
extern int         nc_read_line(struct nc * nc, unsigned char * buf, size_t maxlen);
extern int         nc_write(struct nc * nc, unsigned char * buf, size_t len);


# 70 "httpclient.h" 2






struct hc;

extern struct hc *     hc_start_request(char * url);
extern int             hc_add_req_header(struct hc * hc, const char * tag, const char * value);
extern int             hc_send_request(struct hc * hc);
extern int             hc_post_request(struct hc * hc,
                                       int (*callback)(unsigned char *, size_t, void *),
                                       void * v);
extern int             hc_get_status(struct hc * hc);
extern char *          hc_lookup_rsp_header(struct hc * hc, const char * tag);
extern unsigned char * hc_read_all(struct hc * hc);
extern int             hc_read_pieces(struct hc * hc,
                                      void (*)(unsigned char *, size_t, void *),
                                      void *);
extern void            hc_free(struct hc * hc);

# 50 "httpfsclient.h" 2





extern unsigned long hfs_do_simple(char ** presult,
                                   const char * address, const char * command,
                                   ...);
extern unsigned long hfs_do_chunked(void (*)(unsigned char *, size_t, void *),
                                    void *,
                                    const char * address, u16 msec_delay,
                                    const char * command,
                                    ...);
extern unsigned long hfs_do_post_simple(char ** presult, const char * address,
                                        int (*fn)(unsigned char *, size_t, void *),
                                        void *v,
                                        unsigned long size,
                                        const char * command,
                                        ...);





# 16 "httpfs.c" 2

# 1 "bigfile.h" 1
 

















# 1 "/SYS/include/stdio.h" 1 3
 


















 









 



# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 34 "/SYS/include/stdio.h" 2 3










 
typedef struct _IO_FILE FILE;








 
typedef struct _IO_FILE __FILE;









# 1 "/SYS/include/libio.h" 1 3
 






























# 1 "/SYS/include/_G_config.h" 1 3
 





 






# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 


# 269 "/LIB/include/stddef.h" 3











typedef unsigned int  wint_t;




 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 14 "/SYS/include/_G_config.h" 2 3










# 1 "/SYS/include/wchar.h" 1 3
 

















 











# 46 "/SYS/include/wchar.h" 3


# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 

# 190 "/LIB/include/stddef.h" 3



 




 

# 271 "/LIB/include/stddef.h" 3














 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 48 "/SYS/include/wchar.h" 2 3


# 1 "/SYS/include/bits/wchar.h" 1 3
 

























# 50 "/SYS/include/wchar.h" 2 3


 













 
typedef struct
{
  int __count;
  union
  {
    wint_t __wch;
    char __wchb[4];
  } __value;		 
} __mbstate_t;




 

# 682 "/SYS/include/wchar.h" 3



# 24 "/SYS/include/_G_config.h" 2 3


typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;








# 1 "/SYS/include/gconv.h" 1 3
 

















 








# 1 "/SYS/include/wchar.h" 1 3
 

















 











# 46 "/SYS/include/wchar.h" 3


# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 

# 190 "/LIB/include/stddef.h" 3



 




 

# 271 "/LIB/include/stddef.h" 3














 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 48 "/SYS/include/wchar.h" 2 3




 











# 76 "/SYS/include/wchar.h" 3




 

# 682 "/SYS/include/wchar.h" 3



# 28 "/SYS/include/gconv.h" 2 3



# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 


# 269 "/LIB/include/stddef.h" 3




# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 31 "/SYS/include/gconv.h" 2 3


 


 
enum
{
  __GCONV_OK = 0,
  __GCONV_NOCONV,
  __GCONV_NODB,
  __GCONV_NOMEM,

  __GCONV_EMPTY_INPUT,
  __GCONV_FULL_OUTPUT,
  __GCONV_ILLEGAL_INPUT,
  __GCONV_INCOMPLETE_INPUT,

  __GCONV_ILLEGAL_DESCRIPTOR,
  __GCONV_INTERNAL_ERROR
};


 
enum
{
  __GCONV_IS_LAST = 0x0001,
  __GCONV_IGNORE_ERRORS = 0x0002
};


 
struct __gconv_step;
struct __gconv_step_data;
struct __gconv_loaded_object;
struct __gconv_trans_data;


 
typedef int (*__gconv_fct) (struct __gconv_step *, struct __gconv_step_data *,
			    __const unsigned char **, __const unsigned char *,
			    unsigned char **, size_t *, int, int);

 
typedef int (*__gconv_init_fct) (struct __gconv_step *);
typedef void (*__gconv_end_fct) (struct __gconv_step *);


 
typedef int (*__gconv_trans_fct) (struct __gconv_step *,
				  struct __gconv_step_data *, void *,
				  __const unsigned char *,
				  __const unsigned char **,
				  __const unsigned char *, unsigned char **,
				  size_t *);

 
typedef int (*__gconv_trans_context_fct) (void *, __const unsigned char *,
					  __const unsigned char *,
					  unsigned char *, unsigned char *);

 
typedef int (*__gconv_trans_query_fct) (__const char *, __const char ***,
					size_t *);

 
typedef int (*__gconv_trans_init_fct) (void **, const char *);
typedef void (*__gconv_trans_end_fct) (void *);

struct __gconv_trans_data
{
   
  __gconv_trans_fct __trans_fct;
  __gconv_trans_context_fct __trans_context_fct;
  __gconv_trans_end_fct __trans_end_fct;
  void *__data;
  struct __gconv_trans_data *__next;
};


 
struct __gconv_step
{
  struct __gconv_loaded_object *__shlib_handle;
  __const char *__modname;

  int __counter;

  char *__from_name;
  char *__to_name;

  __gconv_fct __fct;
  __gconv_init_fct __init_fct;
  __gconv_end_fct __end_fct;

   

  int __min_needed_from;
  int __max_needed_from;
  int __min_needed_to;
  int __max_needed_to;

   
  int __stateful;

  void *__data;		 
};

 

struct __gconv_step_data
{
  unsigned char *__outbuf;     
  unsigned char *__outbufend;  


   
  int __flags;

   

  int __invocation_counter;

   

  int __internal_use;

  __mbstate_t *__statep;
  __mbstate_t __state;	 


   
  struct __gconv_trans_data *__trans;
};


 
typedef struct __gconv_info
{
  size_t __nsteps;
  struct __gconv_step *__steps;
  __extension__ struct __gconv_step_data __data [0] ;
} *__gconv_t;


# 44 "/SYS/include/_G_config.h" 2 3

typedef union
{
  struct __gconv_info __cd;
  struct
  {
    struct __gconv_info __cd;
    struct __gconv_step_data __data;
  } __combined;
} _G_iconv_t;

typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));




 


















 




 














# 32 "/SYS/include/libio.h" 2 3

 

















 

# 1 "/LIB/include/stdarg.h" 1 3
 
































































 






typedef void *__gnuc_va_list;



 

# 122 "/LIB/include/stdarg.h" 3




















# 209 "/LIB/include/stdarg.h" 3




# 53 "/SYS/include/libio.h" 2 3







# 72 "/SYS/include/libio.h" 3


 

















# 103 "/SYS/include/libio.h" 3











 

























 



















struct _IO_jump_t;  struct _IO_FILE;

 







typedef void _IO_lock_t;



 

struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
   

   
  int _pos;
# 192 "/SYS/include/libio.h" 3

};

 
enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};

# 259 "/SYS/include/libio.h" 3


struct _IO_FILE {
  int _flags;		 


   
   
  char* _IO_read_ptr;	 
  char* _IO_read_end;	 
  char* _IO_read_base;	 
  char* _IO_write_base;	 
  char* _IO_write_ptr;	 
  char* _IO_write_end;	 
  char* _IO_buf_base;	 
  char* _IO_buf_end;	 
   
  char *_IO_save_base;  
  char *_IO_backup_base;   
  char *_IO_save_end;  

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;
  int _blksize;
  __off_t   _old_offset;  


   
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];

   

  _IO_lock_t *_lock;








  __off64_t   _offset;





  void *__pad1;
  void *__pad2;

  int _mode;
   
  char _unused2[15 * sizeof (int) - 2 * sizeof (void *)];

};


typedef struct _IO_FILE _IO_FILE;


struct _IO_FILE_plus;

extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;











 

 

typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);

 





typedef __ssize_t __io_write_fn (void *__cookie, __const char *__buf,
				 size_t __n);

 





typedef int __io_seek_fn (void *__cookie, __off64_t   *__pos, int __w);

 
typedef int __io_close_fn (void *__cookie);


# 389 "/SYS/include/libio.h" 3







extern int __underflow (_IO_FILE *)  ;
extern int __uflow (_IO_FILE *)  ;
extern int __overflow (_IO_FILE *, int)  ;
extern wint_t   __wunderflow (_IO_FILE *)  ;
extern wint_t   __wuflow (_IO_FILE *)  ;
extern wint_t   __woverflow (_IO_FILE *, wint_t  )  ;
























extern int _IO_getc (_IO_FILE *__fp)  ;
extern int _IO_putc (int __c, _IO_FILE *__fp)  ;
extern int _IO_feof (_IO_FILE *__fp)  ;
extern int _IO_ferror (_IO_FILE *__fp)  ;

extern int _IO_peekc_locked (_IO_FILE *__fp)  ;

 



extern void _IO_flockfile (_IO_FILE *)  ;
extern void _IO_funlockfile (_IO_FILE *)  ;
extern int _IO_ftrylockfile (_IO_FILE *)  ;
















extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
			__gnuc_va_list , int *__restrict)  ;
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
			 __gnuc_va_list )  ;
extern __ssize_t   _IO_padn (_IO_FILE *, int, __ssize_t  )  ;
extern size_t   _IO_sgetn (_IO_FILE *, void *, size_t  )  ;

extern __off64_t   _IO_seekoff (_IO_FILE *, __off64_t  , int, int)  ;
extern __off64_t   _IO_seekpos (_IO_FILE *, __off64_t  , int)  ;

extern void _IO_free_backup_area (_IO_FILE *)  ;

# 511 "/SYS/include/libio.h" 3







# 65 "/SYS/include/stdio.h" 2 3


# 76 "/SYS/include/stdio.h" 3


 



typedef _G_fpos64_t fpos_t;


typedef _G_fpos64_t fpos64_t;


 





 





 






 







 




 








# 1 "/SYS/include/bits/stdio_lim.h" 1 3
 








































# 129 "/SYS/include/stdio.h" 2 3



 
extern FILE *stdin;		 
extern FILE *stdout;		 
extern FILE *stderr;		 
 




 
extern int remove (__const char *__filename)  ;
 
extern int rename (__const char *__old, __const char *__new)  ;


 




extern FILE *  tmpfile    (void)    __asm__ (""     "tmpfile64"    ) ;





extern FILE *tmpfile64 (void)  ;

 
extern char *tmpnam (char *__s)  ;


 

extern char *tmpnam_r (char *__s)  ;




 






extern char *tempnam (__const char *__dir, __const char *__pfx)
        ;



 
extern int fclose (FILE *__stream)  ;
 
extern int fflush (FILE *__stream)  ;


 
extern int fflush_unlocked (FILE *__stream)  ;








# 207 "/SYS/include/stdio.h" 3


extern FILE *  fopen    (__const char *__restrict __filename,
				 __const char *__restrict __modes)    __asm__ (""     "fopen64"    ) ;

extern FILE *  freopen    (__const char *__restrict __filename,
				   __const char *__restrict __modes,
				   FILE *__restrict __stream)    __asm__ (""     "freopen64"    ) ;







extern FILE *fopen64 (__const char *__restrict __filename,
		      __const char *__restrict __modes)  ;
extern FILE *freopen64 (__const char *__restrict __filename,
			__const char *__restrict __modes,
			FILE *__restrict __stream)  ;



 
extern FILE *fdopen (int __fd, __const char *__modes)  ;


# 249 "/SYS/include/stdio.h" 3



 

extern void setbuf (FILE *__restrict __stream, char *__restrict __buf)  ;
 


extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
		    int __modes, size_t __n)  ;


 

extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
		       size_t __size)  ;

 
extern void setlinebuf (FILE *__stream)  ;



 
extern int fprintf (FILE *__restrict __stream,
		    __const char *__restrict __format, ...)  ;
 
extern int printf (__const char *__restrict __format, ...)  ;
 
extern int sprintf (char *__restrict __s,
		    __const char *__restrict __format, ...)  ;

 
extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
		     __gnuc_va_list  __arg)  ;
 
extern int vprintf (__const char *__restrict __format, __gnuc_va_list  __arg)
      ;
 
extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
		     __gnuc_va_list  __arg)  ;


 
extern int snprintf (char *__restrict __s, size_t __maxlen,
		     __const char *__restrict __format, ...)
       __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char *__restrict __s, size_t __maxlen,
		      __const char *__restrict __format, __gnuc_va_list  __arg)
       __attribute__ ((__format__ (__printf__, 3, 0)));


# 321 "/SYS/include/stdio.h" 3



 
extern int fscanf (FILE *__restrict __stream,
		   __const char *__restrict __format, ...)  ;
 
extern int scanf (__const char *__restrict __format, ...)  ;
 
extern int sscanf (__const char *__restrict __s,
		   __const char *__restrict __format, ...)  ;

# 347 "/SYS/include/stdio.h" 3



 
extern int fgetc (FILE *__stream)  ;
extern int getc (FILE *__stream)  ;

 
extern int getchar (void)  ;

 




 
extern int getc_unlocked (FILE *__stream)  ;
extern int getchar_unlocked (void)  ;



 
extern int fgetc_unlocked (FILE *__stream)  ;



 
extern int fputc (int __c, FILE *__stream)  ;
extern int putc (int __c, FILE *__stream)  ;

 
extern int putchar (int __c)  ;

 




 
extern int fputc_unlocked (int __c, FILE *__stream)  ;



 
extern int putc_unlocked (int __c, FILE *__stream)  ;
extern int putchar_unlocked (int __c)  ;




 
extern int getw (FILE *__stream)  ;

 
extern int putw (int __w, FILE *__stream)  ;



 
extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
      ;







 

extern char *gets (char *__s)  ;


# 437 "/SYS/include/stdio.h" 3



 
extern int fputs (__const char *__restrict __s, FILE *__restrict __stream)
      ;







 
extern int puts (__const char *__s)  ;


 
extern int ungetc (int __c, FILE *__stream)  ;


 
extern size_t fread (void *__restrict __ptr, size_t __size,
		     size_t __n, FILE *__restrict __stream)  ;
 
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
		      size_t __n, FILE *__restrict __s)  ;


 
extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
			      size_t __n, FILE *__restrict __stream)  ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
			       size_t __n, FILE *__restrict __stream)  ;



 
extern int fseek (FILE *__stream, long int __off, int __whence)  ;
 
extern long int ftell (FILE *__stream)  ;
 
extern void rewind (FILE *__stream)  ;

 




# 499 "/SYS/include/stdio.h" 3



extern int  fseeko   
		       (FILE *__stream, __off64_t __off, int __whence)    __asm__ (""     "fseeko64"    ) ;

extern __off64_t  ftello    (FILE *__stream)    __asm__ (""     "ftello64"    ) ;

extern int  fgetpos    (FILE *__restrict __stream,
				 fpos_t *__restrict __pos)    __asm__ (""     "fgetpos64"    ) ;
extern int  fsetpos   
		       (FILE *__stream, __const fpos_t *__pos)    __asm__ (""     "fsetpos64"    ) ;












extern int fseeko64 (FILE *__stream, __off64_t __off, int __whence)  ;
extern __off64_t ftello64 (FILE *__stream)  ;
extern int fgetpos64 (FILE *__restrict __stream, fpos64_t *__restrict __pos)
      ;
extern int fsetpos64 (FILE *__stream, __const fpos64_t *__pos)  ;


 
extern void clearerr (FILE *__stream)  ;
 
extern int feof (FILE *__stream)  ;
 
extern int ferror (FILE *__stream)  ;


 
extern void clearerr_unlocked (FILE *__stream)  ;
extern int feof_unlocked (FILE *__stream)  ;
extern int ferror_unlocked (FILE *__stream)  ;



 
extern void perror (__const char *__s)  ;

 


extern int sys_nerr;
extern __const char *__const sys_errlist[];








 
extern int fileno (FILE *__stream)  ;



 
extern int fileno_unlocked (FILE *__stream)  ;





 
extern FILE *popen (__const char *__command, __const char *__modes)  ;

 
extern int pclose (FILE *__stream)  ;




 
extern char *ctermid (char *__s)  ;









# 602 "/SYS/include/stdio.h" 3




 

 
extern void flockfile (FILE *__stream)  ;

 

extern int ftrylockfile (FILE *__stream)  ;

 
extern void funlockfile (FILE *__stream)  ;










 





 




# 19 "bigfile.h" 2


struct big_file;
typedef struct big_file BIGFILE;
BIGFILE * bfopen(const char * filename, const char * mode);
BIGFILE * bfreopen(FILE *fp);
int       bfseek(BIGFILE * stream, s64 offset, int whence);
u64       bftell(BIGFILE * stream);
size_t    bfread(void * ptr, size_t size, size_t nmemb, BIGFILE * stream);
size_t    bfwrite(const void * ptr, size_t size, size_t nmemb, BIGFILE * stream);
int       bfclose(BIGFILE *stream);

# 17 "httpfs.c" 2







# 1 "/SYS/include/unistd.h" 1 3
 

















 








 

 


 



 


 


 


 



 



 



 



 






 


 




 


 


 



 



 



















































































# 1 "/SYS/include/bits/posix_opt.h" 1 3
 





















 


 


 


 


 


 


 


 


 


 


 


 


 



 


 


 


 


 


 



 


 


 


 


 


 


 


 


 




 


 


 


 


 


 


 


 


 


 


 


 



# 175 "/SYS/include/unistd.h" 2 3


 




 





 










# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 199 "/SYS/include/unistd.h" 2 3


# 236 "/SYS/include/unistd.h" 3




typedef __intptr_t intptr_t;






typedef __socklen_t socklen_t;




 






 
extern int access (__const char *__name, int __type)  ;








 







 






 








extern __off64_t  lseek   
			     (int __fd, __off64_t __offset, int __whence)
			        __asm__ (""     "lseek64"    ) ;






extern __off64_t lseek64 (int __fd, __off64_t __offset, int __whence)  ;


 
extern int close (int __fd)  ;

 

extern ssize_t read (int __fd, void *__buf, size_t __nbytes)  ;

 
extern ssize_t write (int __fd, __const void *__buf, size_t __n)  ;

# 347 "/SYS/include/unistd.h" 3


 



extern int pipe (int __pipedes[2])  ;

 






extern unsigned int alarm (unsigned int __seconds)  ;

 






extern unsigned int sleep (unsigned int __seconds)  ;


 



extern __useconds_t ualarm (__useconds_t __value, __useconds_t __interval)
      ;

 

extern int usleep (__useconds_t __useconds)  ;



 

extern int pause (void)  ;


 
extern int chown (__const char *__file, __uid_t __owner, __gid_t __group)
      ;


 
extern int fchown (int __fd, __uid_t __owner, __gid_t __group)  ;


 

extern int lchown (__const char *__file, __uid_t __owner, __gid_t __group)
      ;



 
extern int chdir (__const char *__path)  ;


 
extern int fchdir (int __fd)  ;


 






extern char *getcwd (char *__buf, size_t __size)  ;









 


extern char *getwd (char *__buf)  ;



 
extern int dup (int __fd)  ;

 
extern int dup2 (int __fd, int __fd2)  ;

 
extern char **__environ;





 

extern int execve (__const char *__path, char *__const __argv[],
		   char *__const __envp[])  ;









 
extern int execv (__const char *__path, char *__const __argv[])  ;

 

extern int execle (__const char *__path, __const char *__arg, ...)  ;

 

extern int execl (__const char *__path, __const char *__arg, ...)  ;

 

extern int execvp (__const char *__file, char *__const __argv[])  ;

 


extern int execlp (__const char *__file, __const char *__arg, ...)  ;



 
extern int nice (int __inc)  ;



 
extern void _exit (int __status) __attribute__ ((__noreturn__));


 


# 1 "/SYS/include/bits/confname.h" 1 3
 






















 
enum
  {
    _PC_LINK_MAX,

    _PC_MAX_CANON,

    _PC_MAX_INPUT,

    _PC_NAME_MAX,

    _PC_PATH_MAX,

    _PC_PIPE_BUF,

    _PC_CHOWN_RESTRICTED,

    _PC_NO_TRUNC,

    _PC_VDISABLE,

    _PC_SYNC_IO,

    _PC_ASYNC_IO,

    _PC_PRIO_IO,

    _PC_SOCK_MAXBUF,

    _PC_FILESIZEBITS,

    _PC_REC_INCR_XFER_SIZE,

    _PC_REC_MAX_XFER_SIZE,

    _PC_REC_MIN_XFER_SIZE,

    _PC_REC_XFER_ALIGN,

    _PC_ALLOC_SIZE_MIN,

    _PC_SYMLINK_MAX

  };

 
enum
  {
    _SC_ARG_MAX,

    _SC_CHILD_MAX,

    _SC_CLK_TCK,

    _SC_NGROUPS_MAX,

    _SC_OPEN_MAX,

    _SC_STREAM_MAX,

    _SC_TZNAME_MAX,

    _SC_JOB_CONTROL,

    _SC_SAVED_IDS,

    _SC_REALTIME_SIGNALS,

    _SC_PRIORITY_SCHEDULING,

    _SC_TIMERS,

    _SC_ASYNCHRONOUS_IO,

    _SC_PRIORITIZED_IO,

    _SC_SYNCHRONIZED_IO,

    _SC_FSYNC,

    _SC_MAPPED_FILES,

    _SC_MEMLOCK,

    _SC_MEMLOCK_RANGE,

    _SC_MEMORY_PROTECTION,

    _SC_MESSAGE_PASSING,

    _SC_SEMAPHORES,

    _SC_SHARED_MEMORY_OBJECTS,

    _SC_AIO_LISTIO_MAX,

    _SC_AIO_MAX,

    _SC_AIO_PRIO_DELTA_MAX,

    _SC_DELAYTIMER_MAX,

    _SC_MQ_OPEN_MAX,

    _SC_MQ_PRIO_MAX,

    _SC_VERSION,

    _SC_PAGESIZE,


    _SC_RTSIG_MAX,

    _SC_SEM_NSEMS_MAX,

    _SC_SEM_VALUE_MAX,

    _SC_SIGQUEUE_MAX,

    _SC_TIMER_MAX,


     

    _SC_BC_BASE_MAX,

    _SC_BC_DIM_MAX,

    _SC_BC_SCALE_MAX,

    _SC_BC_STRING_MAX,

    _SC_COLL_WEIGHTS_MAX,

    _SC_EQUIV_CLASS_MAX,

    _SC_EXPR_NEST_MAX,

    _SC_LINE_MAX,

    _SC_RE_DUP_MAX,

    _SC_CHARCLASS_NAME_MAX,


    _SC_2_VERSION,

    _SC_2_C_BIND,

    _SC_2_C_DEV,

    _SC_2_FORT_DEV,

    _SC_2_FORT_RUN,

    _SC_2_SW_DEV,

    _SC_2_LOCALEDEF,


    _SC_PII,

    _SC_PII_XTI,

    _SC_PII_SOCKET,

    _SC_PII_INTERNET,

    _SC_PII_OSI,

    _SC_POLL,

    _SC_SELECT,

    _SC_UIO_MAXIOV,

    _SC_IOV_MAX = _SC_UIO_MAXIOV ,

    _SC_PII_INTERNET_STREAM,

    _SC_PII_INTERNET_DGRAM,

    _SC_PII_OSI_COTS,

    _SC_PII_OSI_CLTS,

    _SC_PII_OSI_M,

    _SC_T_IOV_MAX,


     
    _SC_THREADS,

    _SC_THREAD_SAFE_FUNCTIONS,

    _SC_GETGR_R_SIZE_MAX,

    _SC_GETPW_R_SIZE_MAX,

    _SC_LOGIN_NAME_MAX,

    _SC_TTY_NAME_MAX,

    _SC_THREAD_DESTRUCTOR_ITERATIONS,

    _SC_THREAD_KEYS_MAX,

    _SC_THREAD_STACK_MIN,

    _SC_THREAD_THREADS_MAX,

    _SC_THREAD_ATTR_STACKADDR,

    _SC_THREAD_ATTR_STACKSIZE,

    _SC_THREAD_PRIORITY_SCHEDULING,

    _SC_THREAD_PRIO_INHERIT,

    _SC_THREAD_PRIO_PROTECT,

    _SC_THREAD_PROCESS_SHARED,


    _SC_NPROCESSORS_CONF,

    _SC_NPROCESSORS_ONLN,

    _SC_PHYS_PAGES,

    _SC_AVPHYS_PAGES,

    _SC_ATEXIT_MAX,

    _SC_PASS_MAX,


    _SC_XOPEN_VERSION,

    _SC_XOPEN_XCU_VERSION,

    _SC_XOPEN_UNIX,

    _SC_XOPEN_CRYPT,

    _SC_XOPEN_ENH_I18N,

    _SC_XOPEN_SHM,


    _SC_2_CHAR_TERM,

    _SC_2_C_VERSION,

    _SC_2_UPE,


    _SC_XOPEN_XPG2,

    _SC_XOPEN_XPG3,

    _SC_XOPEN_XPG4,


    _SC_CHAR_BIT,

    _SC_CHAR_MAX,

    _SC_CHAR_MIN,

    _SC_INT_MAX,

    _SC_INT_MIN,

    _SC_LONG_BIT,

    _SC_WORD_BIT,

    _SC_MB_LEN_MAX,

    _SC_NZERO,

    _SC_SSIZE_MAX,

    _SC_SCHAR_MAX,

    _SC_SCHAR_MIN,

    _SC_SHRT_MAX,

    _SC_SHRT_MIN,

    _SC_UCHAR_MAX,

    _SC_UINT_MAX,

    _SC_ULONG_MAX,

    _SC_USHRT_MAX,


    _SC_NL_ARGMAX,

    _SC_NL_LANGMAX,

    _SC_NL_MSGMAX,

    _SC_NL_NMAX,

    _SC_NL_SETMAX,

    _SC_NL_TEXTMAX,


    _SC_XBS5_ILP32_OFF32,

    _SC_XBS5_ILP32_OFFBIG,

    _SC_XBS5_LP64_OFF64,

    _SC_XBS5_LPBIG_OFFBIG,


    _SC_XOPEN_LEGACY,

    _SC_XOPEN_REALTIME,

    _SC_XOPEN_REALTIME_THREADS,


    _SC_ADVISORY_INFO,

    _SC_BARRIERS,

    _SC_BASE,

    _SC_C_LANG_SUPPORT,

    _SC_C_LANG_SUPPORT_R,

    _SC_CLOCK_SELECTION,

    _SC_CPUTIME,

    _SC_THREAD_CPUTIME,

    _SC_DEVICE_IO,

    _SC_DEVICE_SPECIFIC,

    _SC_DEVICE_SPECIFIC_R,

    _SC_FD_MGMT,

    _SC_FIFO,

    _SC_PIPE,

    _SC_FILE_ATTRIBUTES,

    _SC_FILE_LOCKING,

    _SC_FILE_SYSTEM,

    _SC_MONOTONIC_CLOCK,

    _SC_MULTI_PROCESS,

    _SC_SINGLE_PROCESS,

    _SC_NETWORKING,

    _SC_READER_WRITER_LOCKS,

    _SC_SPIN_LOCKS,

    _SC_REGEXP,

    _SC_REGEX_VERSION,

    _SC_SHELL,

    _SC_SIGNALS,

    _SC_SPAWN,

    _SC_SPORADIC_SERVER,

    _SC_THREAD_SPORADIC_SERVER,

    _SC_SYSTEM_DATABASE,

    _SC_SYSTEM_DATABASE_R,

    _SC_TIMEOUTS,

    _SC_TYPED_MEMORY_OBJECTS,

    _SC_USER_GROUPS,

    _SC_USER_GROUPS_R,

    _SC_2_PBS,

    _SC_2_PBS_ACCOUNTING,

    _SC_2_PBS_LOCATE,

    _SC_2_PBS_MESSAGE,

    _SC_2_PBS_TRACK,

    _SC_SYMLOOP_MAX,

    _SC_STREAMS,

    _SC_2_PBS_CHECKPOINT,


    _SC_V6_ILP32_OFF32,

    _SC_V6_ILP32_OFFBIG,

    _SC_V6_LP64_OFF64,

    _SC_V6_LPBIG_OFFBIG,


    _SC_HOST_NAME_MAX,

    _SC_TRACE,

    _SC_TRACE_EVENT_FILTER,

    _SC_TRACE_INHERIT,

    _SC_TRACE_LOG

  };




 
enum
  {
    _CS_PATH,			 




    _CS_LFS_CFLAGS = 1000,

    _CS_LFS_LDFLAGS,

    _CS_LFS_LIBS,

    _CS_LFS_LINTFLAGS,

    _CS_LFS64_CFLAGS,

    _CS_LFS64_LDFLAGS,

    _CS_LFS64_LIBS,

    _CS_LFS64_LINTFLAGS,



# 527 "/SYS/include/bits/confname.h" 3

# 561 "/SYS/include/bits/confname.h" 3


    _CS_V6_WIDTH_RESTRICTED_ENVS

  };

# 500 "/SYS/include/unistd.h" 2 3


 
extern long int pathconf (__const char *__path, int __name)  ;

 
extern long int fpathconf (int __fd, int __name)  ;

 
extern long int sysconf (int __name)   __attribute__ ((__const__));


 
extern size_t confstr (int __name, char *__buf, size_t __len)  ;



 
extern __pid_t getpid (void)  ;

 
extern __pid_t getppid (void)  ;

 


extern __pid_t getpgrp (void)  ;








 
extern __pid_t __getpgid (__pid_t __pid)  ;





 


extern int setpgid (__pid_t __pid, __pid_t __pgid)  ;


 











 

extern int setpgrp (void)  ;

# 574 "/SYS/include/unistd.h" 3



 


extern __pid_t setsid (void)  ;






 
extern __uid_t getuid (void)  ;

 
extern __uid_t geteuid (void)  ;

 
extern __gid_t getgid (void)  ;

 
extern __gid_t getegid (void)  ;

 


extern int getgroups (int __size, __gid_t __list[])  ;






 



extern int setuid (__uid_t __uid)  ;


 

extern int setreuid (__uid_t __ruid, __uid_t __euid)  ;



 
extern int seteuid (__uid_t __uid)  ;


 



extern int setgid (__gid_t __gid)  ;


 

extern int setregid (__gid_t __rgid, __gid_t __egid)  ;



 
extern int setegid (__gid_t __gid)  ;



 


extern __pid_t fork (void)  ;


 



extern __pid_t vfork (void)  ;



 

extern char *ttyname (int __fd)  ;

 

extern int ttyname_r (int __fd, char *__buf, size_t __buflen)  ;

 

extern int isatty (int __fd)  ;



 

extern int ttyslot (void)  ;



 
extern int link (__const char *__from, __const char *__to)  ;


 
extern int symlink (__const char *__from, __const char *__to)  ;

 


extern int readlink (__const char *__restrict __path, char *__restrict __buf,
		     size_t __len)  ;


 
extern int unlink (__const char *__name)  ;

 
extern int rmdir (__const char *__path)  ;


 
extern __pid_t tcgetpgrp (int __fd)  ;

 
extern int tcsetpgrp (int __fd, __pid_t __pgrp_id)  ;


 
extern char *getlogin (void)  ;








 
extern int setlogin (__const char *__name)  ;




 



# 1 "../include/getopt.h" 1
 




























 





	extern char *optarg;

 











	extern int optind;

 


	extern int opterr;

 

	extern int optopt;

 




















	struct option
	{

		const char *name;



		 

		int has_arg;
		int *flag;
		int val;
	};

 







 


	extern int getopt(int argc, char *const *argv, const char *shortopts);



	extern int getopt_long(int argc, char *const *argv, const char *shortopts,
			       const struct option *longopts, int *longind);
	extern int getopt_long_only(int argc, char *const *argv,
				    const char *shortopts,
			       const struct option *longopts, int *longind);

 
	extern int _getopt_internal(int argc, char *const *argv,
				    const char *shortopts,
				const struct option *longopts, int *longind,
				    int long_only);













# 726 "/SYS/include/unistd.h" 2 3





 


extern int gethostname (char *__name, size_t __len)  ;




 

extern int sethostname (__const char *__name, size_t __len)  ;

 

extern int sethostid (long int __id)  ;


 


extern int getdomainname (char *__name, size_t __len)  ;
extern int setdomainname (__const char *__name, size_t __len)  ;


 


extern int vhangup (void)  ;

 
extern int revoke (__const char *__file)  ;


 




extern int profil (unsigned short int *__sample_buffer, size_t __size,
		   size_t __offset, unsigned int __scale)  ;


 


extern int acct (__const char *__name)  ;


 
extern char *getusershell (void)  ;
extern void endusershell (void)  ;  
extern void setusershell (void)  ;  


 


extern int daemon (int __nochdir, int __noclose)  ;




 

extern int chroot (__const char *__path)  ;

 

extern char *getpass (__const char *__prompt)  ;




 
extern int fsync (int __fd)  ;





 
extern long int gethostid (void)  ;

 
extern void sync (void)  ;


 

extern int getpagesize (void)    __attribute__ ((__const__));


 




extern int  truncate   
		       (__const char *__file, __off64_t __length)    __asm__ (""     "truncate64"    ) ;






extern int truncate64 (__const char *__file, __off64_t __length)  ;


 




extern int  ftruncate    (int __fd, __off64_t __length)    __asm__ (""     "ftruncate64"    ) ;






extern int ftruncate64 (int __fd, __off64_t __length)  ;



 

extern int getdtablesize (void)  ;






 

extern int brk (void *__addr)  ;

 



extern void *sbrk (intptr_t __delta)  ;




 









extern long int syscall (long int __sysno, ...)  ;





 



 












extern int  lockf    (int __fd, int __cmd, __off64_t __len)    __asm__ (""     "lockf64"    ) ;






extern int lockf64 (int __fd, int __cmd, __off64_t __len)  ;




# 933 "/SYS/include/unistd.h" 3



 

extern int fdatasync (int __fildes)  ;



 

# 959 "/SYS/include/unistd.h" 3



 








 

 









extern int pthread_atfork (void (*__prepare) (void),
			   void (*__parent) (void),
			   void (*__child) (void))  ;


 


# 24 "httpfs.c" 2





# 1 "/SYS/include/string.h" 1 3
 

















 








 

 


# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 33 "/SYS/include/string.h" 2 3



 
extern void *memcpy (void *__restrict __dest,
		     __const void *__restrict __src, size_t __n)  ;
 

extern void *memmove (void *__dest, __const void *__src, size_t __n)
      ;

 



extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
		      int __c, size_t __n)
      ;



 
extern void *memset (void *__s, int __c, size_t __n)  ;

 
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
        ;

 
extern void *memchr (__const void *__s, int __c, size_t __n)
         ;

# 73 "/SYS/include/string.h" 3



 
extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
      ;
 
extern char *strncpy (char *__restrict __dest,
		      __const char *__restrict __src, size_t __n)  ;

 
extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
      ;
 
extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
		      size_t __n)  ;

 
extern int strcmp (__const char *__s1, __const char *__s2)
        ;
 
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
        ;

 
extern int strcoll (__const char *__s1, __const char *__s2)
        ;
 
extern size_t strxfrm (char *__restrict __dest,
		       __const char *__restrict __src, size_t __n)  ;

# 116 "/SYS/include/string.h" 3



 
extern char *strdup (__const char *__s)    ;


 







# 152 "/SYS/include/string.h" 3


 
extern char *strchr (__const char *__s, int __c)    ;
 
extern char *strrchr (__const char *__s, int __c)    ;







 

extern size_t strcspn (__const char *__s, __const char *__reject)
        ;
 

extern size_t strspn (__const char *__s, __const char *__accept)
        ;
 
extern char *strpbrk (__const char *__s, __const char *__accept)
        ;
 
extern char *strstr (__const char *__haystack, __const char *__needle)
        ;







 
extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
      ;

 

extern char *__strtok_r (char *__restrict __s,
			 __const char *__restrict __delim,
			 char **__restrict __save_ptr)  ;

extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
		       char **__restrict __save_ptr)  ;


# 214 "/SYS/include/string.h" 3



 
extern size_t strlen (__const char *__s)    ;









 
extern char *strerror (int __errnum)  ;

 

extern char *strerror_r (int __errnum, char *__buf, size_t __buflen)  ;


 

extern void __bzero (void *__s, size_t __n)  ;


 
extern void bcopy (__const void *__src, void *__dest, size_t __n)  ;

 
extern void bzero (void *__s, size_t __n)  ;

 
extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
        ;

 
extern char *index (__const char *__s, int __c)    ;

 
extern char *rindex (__const char *__s, int __c)    ;

 

extern int ffs (int __i)   __attribute__ ((__const__));

 









 
extern int strcasecmp (__const char *__s1, __const char *__s2)
        ;

 
extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
        ;


# 289 "/SYS/include/string.h" 3



 

extern char *strsep (char **__restrict __stringp,
		     __const char *__restrict __delim)  ;


# 332 "/SYS/include/string.h" 3




# 361 "/SYS/include/string.h" 3



 


# 29 "httpfs.c" 2

# 1 "/SYS/include/time.h" 1 3
 

















 










 




 


# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 38 "/SYS/include/time.h" 2 3


 

# 1 "/SYS/include/bits/time.h" 1 3
 


















 







 


 





 


extern long int __sysconf (int);




 

 

 


 






# 73 "/SYS/include/bits/time.h" 3

# 42 "/SYS/include/time.h" 2 3


 













 
typedef __clock_t clock_t;




# 72 "/SYS/include/time.h" 3



# 84 "/SYS/include/time.h" 3



# 96 "/SYS/include/time.h" 3




# 112 "/SYS/include/time.h" 3





 
struct tm
{
  int tm_sec;			 
  int tm_min;			 
  int tm_hour;			 
  int tm_mday;			 
  int tm_mon;			 
  int tm_year;			 
  int tm_wday;			 
  int tm_yday;			 
  int tm_isdst;			 


  long int tm_gmtoff;		 
  __const char *tm_zone;	 




};



 
struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };

 
struct sigevent;











 

extern clock_t clock (void)  ;

 
extern time_t time (time_t *__timer)  ;

 
extern double difftime (time_t __time1, time_t __time0)
       __attribute__ ((__const__));

 
extern time_t mktime (struct tm *__tp)  ;


 


extern size_t strftime (char *__restrict __s, size_t __maxsize,
			__const char *__restrict __format,
			__const struct tm *__restrict __tp)  ;










 

extern struct tm *gmtime (__const time_t *__timer)  ;

 

extern struct tm *localtime (__const time_t *__timer)  ;


 

extern struct tm *gmtime_r (__const time_t *__restrict __timer,
			    struct tm *__restrict __tp)  ;

 

extern struct tm *localtime_r (__const time_t *__restrict __timer,
			       struct tm *__restrict __tp)  ;


 

extern char *asctime (__const struct tm *__tp)  ;

 
extern char *ctime (__const time_t *__timer)  ;


 

 

extern char *asctime_r (__const struct tm *__restrict __tp,
			char *__restrict __buf)  ;

 
extern char *ctime_r (__const time_t *__restrict __timer,
		      char *__restrict __buf)  ;



 
extern char *__tzname[2];	 
extern int __daylight;		 
extern long int __timezone;	 



 
extern char *tzname[2];

 

extern void tzset (void)  ;



extern int daylight;
extern long int timezone;



 

extern int stime (__const time_t *__when)  ;



 






 


 
extern time_t timegm (struct tm *__tp)  ;

 
extern time_t timelocal (struct tm *__tp)  ;

 
extern int dysize (int __year)    __attribute__ ((__const__));




 
extern int nanosleep (__const struct timespec *__requested_time,
		      struct timespec *__remaining)  ;


 
extern int clock_getres (clockid_t __clock_id, struct timespec *__res)  ;

 
extern int clock_gettime (clockid_t __clock_id, struct timespec *__tp)  ;

 
extern int clock_settime (clockid_t __clock_id, __const struct timespec *__tp)
      ;

# 305 "/SYS/include/time.h" 3



 
extern int timer_create (clockid_t __clock_id,
			 struct sigevent *__restrict __evp,
			 timer_t *__restrict __timerid)  ;

 
extern int timer_delete (timer_t __timerid)  ;

 
extern int timer_settime (timer_t __timerid, int __flags,
			  __const struct itimerspec *__restrict __value,
			  struct itimerspec *__restrict __ovalue)  ;

 
extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
      ;

 
extern int timer_getoverrun (timer_t __timerid)  ;



# 349 "/SYS/include/time.h" 3


# 359 "/SYS/include/time.h" 3



 




# 30 "httpfs.c" 2








static void usage(const char * err)
{
    if (err)
        fprintf(stderr , "*** ERROR: %s\n\n", err);

    fprintf(stderr ,
"Usage: httpfs [-a address] [-s software_version] [command <args...>]\n"
"Commands:\n"
"  ls [-l] [path]\n"
"  fstat <name>\n"
"  volinfo <name>\n"
"  cp <src> <dst>\n"
"  mv <from> <to>\n"
"  rm <name>\n"
"  create <name>\n"
"  mkdir <name>\n"
"  readfile [-d <msec>] [-f <dst>] [-s <size>] [-p <pos>] [-v <level>] <name>\n"
"  writefile [-f <src>|-s <size>] [-p <pos>] [-v <level>]<name>\n"
"\n"
"Verboseness levels (only implemented for readfile, currently):\n"
"     0: no extraneous output\n"
"     1: succinct status information suitable for parsing, but nothing that\n"
"        requires optional network traffic\n"
"     2: like 1, but adds information that may require additional network\n"
"        traffic\n"
"     3: pretty-printed status graphs for humans to look at (default)\n"
"\n"
"Address defaults to $RTV4K_ADDRESS, if that's set; if not, -a must be used\n"
"Software version defaults to 4.3.0 (230); can be set with $RTV4K_VERSION\n"
"or -s; format should be like '520411140' or '4.1.1.140'\n"
        );

    exit(err ? 1 : 0);
}

static void print_status_bar(FILE * fp, u64 done, u64 total) 
{
    int   percent;
    char  buf[100];
    int   i;
    char *p;
    
    percent = (done*100)/total;
    p = buf;
    *p++ = '[';
    for (i = 0; i < 50; i++) {
        if (i*2 < percent)
            *p++ = '#';
        else
            *p++ = ' ';
    }
    *p++ = ']';
    sprintf(p, "  %""ll" "d/%""ll" "d (%d%%)\r", done, total, percent);
    fprintf(fp, "%s", buf);
}
    

static int hfs_cp(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 3)
        usage("cp needs two arguments");
    
    status = hfs_do_simple(&data, address,
                           "cp",
                           "src", argv[1],
                           "dest", argv[2],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    free(data);
    return status;
}

static int hfs_create(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 2)
        usage("create needs one argument");
    
    status = hfs_do_simple(&data, address,
                           "create",
                           "name", argv[1],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    free(data);
    return status;
}

static int hfs_fstat(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 2)
        usage("fstat needs one argument");
    
    status = hfs_do_simple(&data, address,
                           "fstat",
                           "name", argv[1],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    printf("%s", data);
    free(data);
    return status;
}

static int vstrcmp(const void * v1, const void * v2)
{
    return (strcmp(*(char **)v1, *(char **)v2));
}

static const char * format_type(char type) 
{
    switch(type) {
        case 'f': return "-";
        case 'd': return "d";
        default:  return "?";
    }
}

static char * format_perm(char * perm) 
{
    static char rtn[4];
    char * p;

    strcpy(rtn, "-- ");

    if (strlen(perm) > 3) {
        fprintf(stderr , "ERROR: format_perm: unexpectedly long permission string :%s:\n", perm);
        strcpy(rtn, "ERR");
        return rtn;
    }
    
    for (p = perm; *p; p++) {
        switch(*p) {
            case 'r':
                rtn[0] = 'r';
                break;
            case 'w':
                rtn[1] = 'w';
                break;
            default:
                rtn[2] = *p;
                break;
        }
    }
    return rtn;
}

static char * format_time(u64 ttk) 
{
    static char results[256];
    
    time_t tt;
    int msec;
    struct tm * tm;
    
    tt = ttk / 1000;
    msec = ttk % 1000;

    tm = localtime(&tt);

    strftime(results, sizeof results, "%Y-%m-%d %H:%M:%S", tm);

    sprintf(results + 19, ".%03d", msec);

    return results;
}

static int ls_l(const char * address, const char * dir, const char * filename)
{
    char          pathname[256];
    unsigned long status;
    char *        data;
    char **       lines;
    int           num_lines;
    int           i;
    char          type = '?';
    char *        perm = (char *)"";
    u64           size = 0;
    u64           filetime = 0;
    
    if (strlen(dir) + strlen(filename) + 2 > sizeof pathname) {
        fprintf(stderr , "ERROR: ls_l: dir + filename too long: %s/%s\n",
                dir, filename);
        return -1;
    }
    
    sprintf(pathname, "%s/%s", dir, filename);
    status = hfs_do_simple(&data, address,
                           "fstat",
                           "name", pathname,
                           ((void *)0) );
    if (status != 0) {
        fprintf(stderr , "ls_l %s: Error %ld\n", filename, status);
        return status;
    }

     

    num_lines = rtv_split_lines(data, &lines);
    for (i = 0; i < num_lines; i++) {
        if (strncmp(lines[i], "type=", 5) == 0) {
            type = lines[i][5];
        } else if (strncmp(lines[i], "size=", 5) == 0) {
            sscanf(lines[i]+5, "%""ll" "d", &size);
        } else if (strncmp(lines[i], "ctime=", 6) == 0) {
            sscanf(lines[i]+6, "%""ll" "d", &filetime);
        } else if (strncmp(lines[i], "perm=", 5) == 0) {
            perm = lines[i] + 5;
        }
    }
    
    printf("%s%s\t%12""ll" "d %s %s\n",
           format_type(type),
           format_perm(perm),
           size,
           format_time(filetime),
           filename);

    rtv_free_lines(num_lines, lines);
    free(data);

    return 0;
}

static int hfs_ls(const char * address, int argc, char ** argv)
{
    char *        dir;
    char *        data;
    char **       files;
    int           ch;
    int           i;
    int           num_files;
    int           opt_l = 0;
    unsigned long status;
    
    while ((ch = getopt(argc, argv, "l")) != (-1) ) {
        switch(ch) {
            case 'l':
                opt_l = 1;
                break;
            default:
                usage("Invalid argument to ls");
        }
    }

    if (optind < argc) {
        if (opt_l) {
            status = hfs_do_simple(&data, address,
                                   "fstat",
                                   "name", argv[optind],
                                   ((void *)0) );
            if (status == 0 && strncmp(data, "type=f", 6) == 0) {
                free(data);
                ls_l(address, "", argv[optind]);
                return 0;
            }
            free(data);
        }
        dir = argv[optind];
    } else {
        dir = (char *)"/";
    }

        
    status = hfs_do_simple(&data, address,
                           "ls",
                           "name", dir,
                           ((void *)0) );
    if (status != 0) {
        fprintf(stderr , "Error %ld\n", status);
        return status;
    }

    num_files = rtv_split_lines(data, &files);
    qsort(files, num_files, sizeof(char *), vstrcmp);
    for (i = 0; i < num_files; i++) {
        if (opt_l) {
            ls_l(address, dir, files[i]);
        } else {
            fprintf(stdout , "%s\n", files[i]);
        }
    }

    rtv_free_lines(num_files, files);
    free(data);
    return 0;
}

static int hfs_mkdir(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 2)
        usage("mkdir needs one argument");
    
    status = hfs_do_simple(&data, address,
                           "mkdir",
                           "name", argv[1],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    free(data);
    return status;
}

static int hfs_mv(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 3)
        usage("mv needs two arguments");
    
    status = hfs_do_simple(&data, address,
                           "mv",
                           "old", argv[1],
                           "new", argv[2],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    free(data);
    return status;
}

static u64 get_filesize(const char * address, const char * name)
{
    char * data = ((void *)0) ;
    char ** lines;
    int num_lines;
    int i;
    u64 size;
    unsigned long status;

    status = hfs_do_simple(&data, address,
                           "fstat",
                           "name", name,
                           ((void *)0) );
    if (status != 0) {
        fprintf(stderr , "Error fstat %ld\n", status);
        free(data);
        return -1;
    }

    num_lines = rtv_split_lines(data, &lines);
    for (i = 0; i < num_lines; i++) {
        if (strncmp(lines[i], "size=", 5) == 0) {
            sscanf(lines[i]+5, "%""ll" "d", &size);
            rtv_free_lines(num_lines, lines);
            free(data);
            return size;
        }
    }
    rtv_free_lines(num_lines, lines);
    free(data);
    return -1;
}

struct read_data
{
    BIGFILE * dstfile;
    u64 bytes;
    u64 fullsize;
    int verbose;
};

static void hfs_rf_callback(unsigned char * buf, size_t len, void * vd)
{
    struct read_data * rd = vd;

    bfwrite(buf, len, 1, rd->dstfile);
    rd->bytes += len;
    switch(rd->verbose) {
        case 2:
            fprintf(stderr , "Total: %""ll" "d\n", rd->fullsize);
            rd->verbose--;
             
        case 1:
            fprintf(stderr , "Read: %""ll" "d\n", rd->bytes);
            break;
        case 3:
            print_status_bar(stderr , rd->bytes, rd->fullsize);
            break;
    }
}

static int hfs_readfile(const char * address, int argc, char ** argv)
{
    struct read_data data;
    unsigned long status;
    const char * pos  = ((void *)0) ;
    const char * size = ((void *)0) ;
    const char * file = ((void *)0) ;
    const char * name;
    int ch;
    u32 delay = 75;

    memset(&data, 0, sizeof data);
    data.verbose = 3;
    
    while ((ch = getopt(argc, argv, "d:f:p:s:v:")) != (-1) ) {
        switch(ch) {
            case 'f':
                file = optarg;
                break;
            case 'p':
                pos = optarg;
                break;
            case 's':
                size = optarg;
                break;
            case 'd':
                delay = atoi(optarg);
                break;
            case 'v':
                data.verbose = atoi(optarg);
                break;
            default:
                usage("Invalid argument to readfile");
        }
    }

    if (argc - optind != 1)
        usage("Need to specify exactly one filename for readfile");

    name = argv[optind];
    
    if (!pos)
        pos = "0";

    if (file) {
        data.dstfile = bfopen(file, "w");
        if (!data.dstfile) {
            perror("bfopen dstfile");
            return -1;
        }
    } else {
        data.dstfile = bfreopen(stdout );
    }

    if (data.verbose > 1) {
        data.fullsize = get_filesize(address, name);
    }
    
    status = hfs_do_chunked(hfs_rf_callback, &data, address, delay,
                            "readfile",
                            "pos",  pos,
                            "size", size,
                            "name", name,
                            ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error: %ld\n", status);

    return status;
}

static int hfs_rm(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 2)
        usage("rm needs one arguments");
    
    status = hfs_do_simple(&data, address,
                           "rm",
                           "name", argv[1],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    free(data);
    return status;
}

static int hfs_volinfo(const char * address, int argc, char ** argv)
{
    char * data = ((void *)0) ;
    unsigned long status;

    if (argc != 2)
        usage("volinfo needs one arguments");
    
    status = hfs_do_simple(&data, address,
                           "volinfo",
                           "name", argv[1],
                           ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error %ld\n", status);
    printf("%s", data);
    free(data);
    return status;
}

struct write_data 
{
    BIGFILE * srcfile;
    u64 bytes;
    u64 fullsize;
    int verbose;
};

static int hfs_wf_callback(unsigned char * buf, size_t len, void * vd)
{
    struct write_data * wd = vd;
    int r = 0;
    size_t l;
    u64 bytes_to_go;

    bytes_to_go = wd->fullsize - wd->bytes;
    l = (( len )<(  bytes_to_go ) ? ( len ) : (  bytes_to_go )) ;
    if (l) {
        r = bfread(buf, l, 1, wd->srcfile);
    }
    wd->bytes += r * l;

    switch(wd->verbose) {
        case 2:
            fprintf(stderr , "Total: %""ll" "d\n", wd->fullsize);
            wd->verbose--;
             
        case 1:
            fprintf(stderr , "Written: %""ll" "d\n", wd->bytes);
            break;
        case 3:
            print_status_bar(stderr , wd->bytes, wd->fullsize);
            break;
    }
    
    return r * l;
}

static int hfs_writefile(const char * address, int argc, char ** argv)
{
    struct write_data wd;
    unsigned long status;
    const char * pos = ((void *)0) ;
    const char * size = ((void *)0) ;
    const char * name = ((void *)0) ;
    const char * file = ((void *)0) ;
    char * data = ((void *)0) ;
    int ch;
    u64 size_num;

    memset(&data, 0, sizeof data);
    wd.verbose = 3;
    
    while ((ch = getopt(argc, argv, "f:p:s:v:")) != (-1) ) {
        switch(ch) {
            case 'f':
                file = optarg;
                break;
            case 'p':
                pos = optarg;
                break;
            case 's':
                size = optarg;
                break;
            case 'v':
                wd.verbose = atoi(optarg);
                break;
            default:
                usage("Invalid argument to readfile");
        }
    }

    if (argc - optind != 1)
        usage("Need to specify exactly one filename for writefile");

    name = argv[optind];

    if (!size && !file)
        usage("Either a file or a size must be given for writefile");
    
    if (!pos)
        pos = "0";

    if (file) {
        char sizebuf[32];
        wd.srcfile = bfopen(file, "r");
        if (!wd.srcfile) {
            perror("open srcfile");
            return -1;
        }
        bfseek(wd.srcfile, 0, 2 );
        size_num = bftell(wd.srcfile);
        bfseek(wd.srcfile, 0, 0 );
        sprintf(sizebuf, "%""ll" "d", size_num);
        size = sizebuf;
    } else {
        wd.srcfile = bfreopen(stdin );
        sscanf(size, "%""ll" "d", &size_num);
    }
    wd.fullsize = size_num;
    wd.bytes = 0;
    
    status = hfs_do_simple(&data, address,
                           "create",
                           "name", name,
                           ((void *)0) );
    free(data);
    if (status != 0 && status != 80820018 )
        fprintf(stderr , "Error create: %ld\n", status);
    
    status = hfs_do_post_simple(&data, address,
                                hfs_wf_callback, &wd, size_num,
                                "writefile",
                                "pos",  pos,
                                "name", name,
                                "size", size,
                                ((void *)0) );
    if (status != 0)
        fprintf(stderr , "Error: %ld\n", status);
    free(data);
    return status;
}

static struct {
    const char * command;
    int (*fn)(const char *, int, char **);
} commands[] = {
    { "cp",             hfs_cp          },
    { "create",         hfs_create      },
    { "fstat",          hfs_fstat       },
    { "ls",             hfs_ls          },
    { "mkdir",          hfs_mkdir       },
    { "mv",             hfs_mv          },
    { "readfile",       hfs_readfile    },
    { "rm",             hfs_rm          },
    { "volinfo",        hfs_volinfo     },
    { "writefile",      hfs_writefile   }
};

int main(int argc, char ** argv)
{
    char * address;
    char * version;
    int    num_commands = sizeof(commands)/sizeof(commands[0]);
    int    ch;
    int    r            = -1;
    int    i;
    int    my_optind;
    
    address = getenv("RTV4K_ADDRESS");
    version = getenv("RTV4K_VERSION");
    
    while ((ch = getopt(argc, argv, "+a:s:")) != (-1) ) {
        switch(ch) {
            case 'a':
                address = optarg;
                break;
            case 's':
                version = optarg;
                break;
            default:
                usage("Invalid argument");
        }
    }
    if (optind == argc || address == ((void *)0) )
        usage(((void *)0) );

    if (version)
        if (rtv_set_replaytv_version(version) != 0)
            usage("Invalid software version");

    my_optind = optind;
    optind    = 1;
    
    for (i = 0; i < num_commands; i++) {
        if (strcmp(argv[my_optind], commands[i].command) == 0) {
            r = commands[i].fn(address, argc - my_optind, argv + my_optind);
            break;
        }
    }
    if (i == num_commands) {
        usage("Invalid command");
    }

    return r;
}
