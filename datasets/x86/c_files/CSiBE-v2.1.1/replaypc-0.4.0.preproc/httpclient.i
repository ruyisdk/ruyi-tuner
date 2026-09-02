# 1 "httpclient.c"
 













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









typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;







typedef __off64_t off_t;









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

# 15 "httpclient.c" 2


# 1 "/SYS/include/ctype.h" 1 3
 

















 









 


 














enum
{
  _ISupper = (( 0 ) < 8 ? ((1 << ( 0 )) << 8) : ((1 << ( 0 )) >> 8)) ,	 
  _ISlower = (( 1 ) < 8 ? ((1 << ( 1 )) << 8) : ((1 << ( 1 )) >> 8)) ,	 
  _ISalpha = (( 2 ) < 8 ? ((1 << ( 2 )) << 8) : ((1 << ( 2 )) >> 8)) ,	 
  _ISdigit = (( 3 ) < 8 ? ((1 << ( 3 )) << 8) : ((1 << ( 3 )) >> 8)) ,	 
  _ISxdigit = (( 4 ) < 8 ? ((1 << ( 4 )) << 8) : ((1 << ( 4 )) >> 8)) ,	 
  _ISspace = (( 5 ) < 8 ? ((1 << ( 5 )) << 8) : ((1 << ( 5 )) >> 8)) ,	 
  _ISprint = (( 6 ) < 8 ? ((1 << ( 6 )) << 8) : ((1 << ( 6 )) >> 8)) ,	 
  _ISgraph = (( 7 ) < 8 ? ((1 << ( 7 )) << 8) : ((1 << ( 7 )) >> 8)) ,	 
  _ISblank = (( 8 ) < 8 ? ((1 << ( 8 )) << 8) : ((1 << ( 8 )) >> 8)) ,	 
  _IScntrl = (( 9 ) < 8 ? ((1 << ( 9 )) << 8) : ((1 << ( 9 )) >> 8)) ,	 
  _ISpunct = (( 10 ) < 8 ? ((1 << ( 10 )) << 8) : ((1 << ( 10 )) >> 8)) ,	 
  _ISalnum = (( 11 ) < 8 ? ((1 << ( 11 )) << 8) : ((1 << ( 11 )) >> 8)) 	 
};


 










extern __const unsigned short int *__ctype_b;	 
extern __const __int32_t *__ctype_tolower;  
extern __const __int32_t *__ctype_toupper;  









 



extern int  isalnum  (int)   ;
extern int  isalpha  (int)   ;
extern int  iscntrl  (int)   ;
extern int  isdigit  (int)   ;
extern int  islower  (int)   ;
extern int  isgraph  (int)   ;
extern int  isprint  (int)   ;
extern int  ispunct  (int)   ;
extern int  isspace  (int)   ;
extern int  isupper  (int)   ;
extern int  isxdigit  (int)   ;






 
extern int tolower (int __c)  ;

 
extern int toupper (int __c)  ;




 

extern int isascii (int __c)  ;

 

extern int toascii (int __c)  ;

 

extern int  _toupper  (int)   ;
extern int  _tolower  (int)   ;


 

# 148 "/SYS/include/ctype.h" 3


















# 178 "/SYS/include/ctype.h" 3


















# 274 "/SYS/include/ctype.h" 3


 


# 17 "httpclient.c" 2

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





 





 





 






 







 




 








# 1 "/SYS/include/bits/stdio_lim.h" 1 3
 








































# 129 "/SYS/include/stdio.h" 2 3



 
extern FILE *stdin;		 
extern FILE *stdout;		 
extern FILE *stderr;		 
 




 
extern int remove (__const char *__filename)  ;
 
extern int rename (__const char *__old, __const char *__new)  ;


 




extern FILE *  tmpfile    (void)    __asm__ (""     "tmpfile64"    ) ;







 
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










 





 




# 18 "httpclient.c" 2

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



 


# 19 "httpclient.c" 2


struct hc_headers 
{
    char * tag;
    char * value;
    struct hc_headers * next;
};

struct hc 
{
    struct nc * nc;
    char * hostname;
    short port;
    char * localpart;
    char * status;
    struct hc_headers * req_headers;
    struct hc_headers * rsp_headers;
};

static void hc_h_free(struct hc_headers * hh)
{
    free(hh->tag);
    free(hh->value);
    free(hh);
}

static struct hc_headers * hc_h_make(const char * tag, const char * value)
{
    struct hc_headers * h;
    
    h = malloc(sizeof *h);
    if (!h)
        goto error;
    memset(h, 0, sizeof *h);
    
    h->tag = strdup(tag);
    if (!h->tag)
        goto error;
    
    h->value = strdup(value);
    if (!h->value)
        goto error;
    
    return h;
error:
    if (h)
        hc_h_free(h);
    return ((void *)0) ;
}

void hc_free(struct hc * hc)
{
    struct hc_headers * n;

    if (hc) {
        free(hc->hostname);
        free(hc->localpart);
        free(hc->status);
        while (hc->req_headers) {
            n = hc->req_headers->next;
            hc_h_free(hc->req_headers);
            hc->req_headers = n;
        }
        while (hc->rsp_headers) {
            n = hc->rsp_headers->next;
            hc_h_free(hc->rsp_headers);
            hc->rsp_headers = n;
        }
        if (hc->nc)
            nc_close(hc->nc);
        free(hc);
    }
}

int hc_add_req_header(struct hc * hc, const char * tag, const char * value)
{
    struct hc_headers * h;

    h = hc_h_make(tag, value);
    if (!h)
        goto error;
    h->next = hc->req_headers;
    hc->req_headers = h;
    return 0;
error:
    return -1;
}

struct hc * hc_start_request(char * url)
{
    struct hc * hc;
    char * e;

    hc = malloc(sizeof *hc);
    memset(hc, 0, sizeof *hc);
    
    if (strncmp(url, "http://", 7) != 0) {
        goto error;
    }
    url += 7;
    e = strchr(url, '/');
    if (!e) {
        hc->hostname = strdup(url);
        hc->localpart = strdup("/");
    } else {
        hc->hostname        = malloc(e - url + 1);
        if (!hc->hostname) goto error;
        memcpy(hc->hostname, url, e - url);
        hc->hostname[e-url] = '\0';
        hc->localpart       = strdup(e);
        if (!hc->localpart) goto error;
    }

    if (hc_add_req_header(hc, "Host", hc->hostname) < 0)
        goto error;

    e = strchr(hc->hostname, ':');
    if (e) {
        *e = '\0';
        hc->port = (short)strtoul(e+1, ((void *)0) , 10);
    } else {
        hc->port = 80;
    }

    hc->nc = nc_open(hc->hostname, hc->port);
    if (!hc->nc)
        goto error;
    
    return hc;
error:
    if (hc)
        hc_free(hc);
    return ((void *)0) ;
}

int hc_send_request(struct hc * hc)
{
    char buffer[1024];
    size_t l;
    struct hc_headers * h;

    l = strlen(hc->localpart) + strlen("GET  HTTP/1.1\r\n");
    for (h = hc->req_headers; h; h = h->next)
        l += strlen(h->tag) + strlen(h->value) + 4;
    l += 3;
    if (l > sizeof buffer) {
        fprintf(stderr , "ERROR: hc_send_request: buffer too small; need %lu\n",
                (unsigned long)l);
        return -1;
    }

    l = sprintf(buffer, "GET %s HTTP/1.1\r\n", hc->localpart);
    for (h = hc->req_headers; h; h = h->next)
        l += sprintf(buffer+l, "%s: %s\r\n", h->tag, h->value);
    l += sprintf(buffer+l, "\r\n");
    nc_write(hc->nc, buffer, l);

    if (nc_read_line(hc->nc, buffer, sizeof buffer) <= 0) {
        perror("ERROR: hc_send_request nc_read_line");
        return -1;
    }
    
    hc->status = strdup(buffer);
    while (nc_read_line(hc->nc, buffer, sizeof buffer) > 0) {
        char * e;
        e = strchr(buffer, ':');
        if (e) {
            *e = '\0';
            e++;
            while ((__ctype_b[(int) ( ( *e ) )] & (unsigned short int)   _ISspace )  )
                e++;
            h = hc_h_make(buffer, e);
            h->next = hc->rsp_headers;
            hc->rsp_headers = h;
        } else {
            fprintf(stderr , "ERROR: hc_send_request got invalid header line :%s:\n", buffer);
        }
    }
    
    return 0;
}

int hc_post_request(struct hc * hc,
                    int (*callback)(unsigned char *, size_t, void *),
                    void * v)
{
    char buffer[1024];
    size_t l;
    struct hc_headers * h;

    l = strlen(hc->localpart) + strlen("POST  HTTP/1.0\r\n");
    for (h = hc->req_headers; h; h = h->next)
        l += strlen(h->tag) + strlen(h->value) + 4;
    l += 3;
    if (l > sizeof buffer) {
        fprintf(stderr , "ERROR: hc_post_request: buffer too small; need %lu\n",
                (unsigned long)l);
        return -1;
    }

    l = sprintf(buffer, "POST %s HTTP/1.0\r\n", hc->localpart);
    for (h = hc->req_headers; h; h = h->next)
        l += sprintf(buffer+l, "%s: %s\r\n", h->tag, h->value);
    l += sprintf(buffer+l, "\r\n");
    nc_write(hc->nc, buffer, l);

    while ((l = callback(buffer, sizeof buffer, v)) != 0) {
        int r;
        r = nc_write(hc->nc, buffer, l);
 
        
    }
  
    if (nc_read_line(hc->nc, buffer, sizeof buffer) <= 0) {
        perror("ERROR: hc_post_request nc_read_line");
        return -1;
    }
    hc->status = strdup(buffer);
    while (nc_read_line(hc->nc, buffer, sizeof buffer) > 0) {
        char * e;
        e = strchr(buffer, ':');
        if (e) {
            *e = '\0';
            e++;
            while ((__ctype_b[(int) ( ( *e ) )] & (unsigned short int)   _ISspace )  )
                e++;
            h = hc_h_make(buffer, e);
            h->next = hc->rsp_headers;
            hc->rsp_headers = h;
        } else {
            fprintf(stderr , "ERROR: hc_post_request got invalid header line :%s:\n", buffer);
        }
    }
    
    return 0;
}

int hc_get_status(struct hc * hc)
{
    return strtoul(hc->status + 9, ((void *)0) , 10);
}

char * hc_lookup_rsp_header(struct hc * hc, const char * tag)
{
    struct hc_headers * h;
    
    for (h = hc->rsp_headers; h; h = h->next)
        if (strcasecmp(tag, h->tag) == 0)
            return h->value;
    return ((void *)0) ;
}

extern int hc_read_pieces(struct hc * hc,
                          void (*callback)(unsigned char *, size_t, void *),
                          void * v)
{
    char * te;
    int chunked = 0;
    int done = 0;
    char * buf;
    size_t len, len_read;
    
    te = hc_lookup_rsp_header(hc, "Transfer-Encoding");
    if (te && strcmp(te, "chunked") == 0) {
        chunked = 1;
    }

    while (!done) {
        if (chunked) {
            char lenstr[32];

            nc_read_line(hc->nc, lenstr, sizeof lenstr);
            len = strtoul(lenstr, ((void *)0) , 16);
        } else {
            len = 4096;
        }
        if (len) {
            buf = malloc(len+1);
            len_read = nc_read(hc->nc, buf, len);
            if (len_read < len)
                done = 1;
            buf[len_read] = '\0';
            callback(buf, len_read, v);
        } else {
            done = 1;
        }
        if (chunked) {
            char linebuf[80];
             





            while (nc_read_line(hc->nc, linebuf, sizeof linebuf) > 0)
                ;
        }
    }
    return 0;
}

struct chunk
{
    char * buf;
    size_t len;
    struct chunk * next;
};

struct read_all_data 
{
    struct chunk * start;
    struct chunk * end;
    size_t total;
};

static void read_all_callback(unsigned char * buf, size_t len, void * vd)
{
    struct read_all_data * data = vd;
    struct chunk * chunk;

    chunk = malloc(sizeof *chunk);
    chunk->buf = buf;
    chunk->len = len;
    chunk->next = ((void *)0) ;
    
    if (data->end) {
        data->end->next = chunk;
        data->end = chunk;
    } else {
        data->start = data->end = chunk;
    }

    data->total += len;
}

unsigned char * hc_read_all(struct hc * hc)
{
    struct read_all_data data;
    struct chunk * chunk, * next;
    size_t cur;
    unsigned char * r;
    
    data.start = data.end = ((void *)0) ;
    data.total = 0;
    
    hc_read_pieces(hc, read_all_callback, &data);
    
    r = malloc(data.total + 1);
    cur = 0;
    for (chunk = data.start; chunk; chunk = next) {
        memcpy(r+cur, chunk->buf, chunk->len);
        cur += chunk->len;
        free(chunk->buf);
        next = chunk->next;
        free(chunk);
    }

    r[data.total] = '\0';
    return r;
}



