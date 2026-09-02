# 1 "guide.c"
 
















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









# 18 "guide.c" 2

# 1 "guide.h" 1
 



















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





 


# 21 "guide.h" 2

# 1 "dump.h" 1
 

















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










 





 




# 19 "dump.h" 2


struct mapping 
{
    u32 value;
    char * name;
};

void dump_set_file(FILE * out);
void dump_group_start(char const * groupname);
void dump_group_end(void);
void dump_mapping(char const * tag, u32 value, struct mapping * map);
void dump_bitmapping(char const * tag, u32 value, struct mapping * map);
void dump_time(char const * tag, u32 value);
void dump_string(char const * tag, char const * value);
void dump_u8(char const * tag, u8 value);
void dump_u16(char const * tag, u16 value);
void dump_u32(char const * tag, u32 value);
void dump_u64(char const * tag, u64 value);
void dump_buffer(char const * tag, u8 const * buffer, size_t len);

char const * lookup_mapping(u32 value, struct mapping * map);


# 22 "guide.h" 2

# 1 "headend.h" 1
 


















extern struct mapping device_mapping[];
extern struct mapping device_bitmapping[];
extern struct mapping service_tier_mapping[];

struct headend_header {
  u32 device_bitmap;
  u8  max_tier[32];
};  

struct headend_channel {
  u32 tmsid;
  u16 tuning;
  u8  device;
  u8  service_tier;
  u8  name[16];
  u8  description[32];
};  

int parse_headend_header(unsigned char ** p, struct headend_header * h);
int parse_headend_channel(unsigned char ** p, struct headend_channel * hc);

void dump_headend_header(struct headend_header * h);
void dump_headend_channel(struct headend_channel * hc);


# 23 "guide.h" 2

# 1 "program.h" 1
 
















# 1 "cg.h" 1
 
















struct movie 
{
  u16 mpaa;
  u16 stars;
  u16 year;
  u16 runtime;
};

struct parts
{
  u16 part;
  u16 of;
};

struct fixed_program_record      
{
  u32 flags;               
  u32 event_time;         
  u32 tmsid;              
  u16 minutes;
  u8  genre1;
  u8  genre2;
  u8  genre3;
  u8  genre4;
  u16 record_len;
  u8  title_len;
  u8  episode_len;
  u8  description_len;
  u8  actor_len;
  u8  guest_len;
  u8  suzuki_len;
  u8  producer_len;
  u8  director_len;
  u8  datablock[228];

     

    struct parts parts;          
    struct movie movie;          
    u8   title_offset;
    u8   episode_offset;
    u8   description_offset;
    u8   actor_offset;
    u8   guest_offset;
    u8   suzuki_offset;
    u8   producer_offset;
    u8   director_offset;
};  

struct cg2_channel
{
  u32 mod_time;
  u32 tmsid;
  u32 data_len;

     
    int num_programs;
    struct fixed_program_record * programs;
};  

int parse_parts(unsigned char **p, struct parts * parts);
int parse_movie(unsigned char **p, struct movie * movie);
int parse_fixed_program_record(unsigned char **pp, struct fixed_program_record * prog, int varsize);
int parse_cg2_channel(unsigned char **pp, struct cg2_channel * chan);
int parse_cg2_programlist(unsigned char **pp, struct cg2_channel * chan);

void dump_parts(struct parts * p);
void dump_movie(struct movie * p);
void dump_fixed_program_record(struct fixed_program_record * prog);
void dump_cg2_channel(struct cg2_channel * chan);


# 18 "program.h" 2


extern struct mapping program_flags_mapping[];
extern struct mapping mpaa_mapping[];
extern struct mapping genre_mapping[];

struct program                   
{
  u32 struct_size;        
  u32 unknown1;           
  u32 isvalid;            


  u32 tuning;             
  struct fixed_program_record fixed_program_record;
};  

int parse_program(unsigned char **pp, struct program * prog);

void dump_program(struct program * p);


# 24 "guide.h" 2


extern struct mapping replay_channel_type_mapping[];
extern struct mapping quality_mapping[];
extern struct mapping input_source_mapping[];
extern struct mapping show_flags_bitmapping[];
extern struct mapping record_show_flags_bitmapping[];
extern struct mapping channel_flags_bitmapping[];
extern struct mapping day_of_week_bitmapping[];
extern struct mapping theme_flags_bitmapping[];
extern struct mapping guide_flags_bitmapping[];

struct guide_header {                 
  u32 version;                 
  u32 struct_size;                
  u32 num_channels_1;          
  u32 num_channels_2;          
  u32 group_data_offset;       
  u32 channel_offset;          
  u32 show_offset;             
  u32 flags;                   

};  

struct group_data {                   
  u32 struct_size;             
  u32 num_categories;          
  u32 index[32];
  u32 name_offset[32];
  u8  name_block[512];

     
    struct mapping category_bitmapping[32];

}; 

struct channel {                      
  u32 struct_size;             
  u32 unknown1;                
  u32 isvalid;                 


  struct headend_channel headend_channel;
  u8  headend[8];
  u32 guide_index;             
};  

struct replay_show {                  
  u32 channel_id;              
  u32 show_id;                 
  u32 input_source;            
  u32 quality;                 
  u32 guaranteed;              
  u32 flags;                   
  struct channel channel;
  struct program program;
  u32 ivs_status;              
  u32 remote_guide_id;         
  u32 download_id;
  u32 times_sent;
  u32 seconds;                 
  u32 gop_count;        
  u32 gop_highest_seen;
  u32 gop_last_seen;
  u32 checkpointed;            

  u32 intact;                  
  u32 upgrade_flag;            
  u32 instance;
  u16 unused1;                 
  u8  before_padding;
  u8  after_padding;
  u64 index_size;
  u64 mpeg_size;
};  

 






















struct replay_theme {                
  u32 flags;                  
  u32 suzuki_id;
  u32 minutes;
  u8  keywords[52];           
};  

struct replay_channel {               
  u32 channel_type;            
  u32 quality;                 
  u64 space_allocated;
  u32 keep;                    
  u32 stored;                  
  u8  days_of_week;            
  u8  after_padding;
  u8  before_padding;
  u8  flags;                   
  u32 category;                
  u32 channel_id;              
  u32 unknown1;
  u32 unknown2;
  u32 unknown3;
  u32 unknown4;
  u32 unknown5;
  u32 unknown6;
  u32 unknown7;
  u32 seconds_reserved;
  u8  label[48];          
  struct replay_show replay_show;
  struct replay_theme replay_theme;
};  

struct replay_guide_snapshot {
    struct guide_header     guide_header;
    struct group_data       group_data;
    struct replay_channel * replay_channels;
    struct replay_show *    replay_shows;
    unsigned int num_shows;
    int stage;
};
    

int parse_guide_header(unsigned char ** pp, struct guide_header * h);
int parse_group_data(unsigned char ** pp, struct group_data * gd);
int parse_channel(unsigned char **pp, struct channel * c);
int parse_replay_show(unsigned char **pp, struct replay_show * rs);
int parse_replay_theme(unsigned char **pp, struct replay_theme * rt);
int parse_replay_channel(unsigned char **pp, struct replay_channel * rc);
int parse_replay_guide_snapshot(unsigned char **pp, struct replay_guide_snapshot * ss);
int parse_replay_guide_snapshot_staged(unsigned char **pp, struct replay_guide_snapshot * ss);

void free_replay_guide_snapshot(struct replay_guide_snapshot * ss);

void dump_guide_header(struct guide_header * h);
void dump_group_data(struct group_data * gd);
void dump_channel(struct channel * c);
void dump_replay_show(struct replay_show * rs);
void dump_replay_theme(struct replay_theme * rt);
void dump_replay_channel(struct replay_channel * rc, struct mapping * category_bitmapping);
void dump_replay_guide_snapshot(struct replay_guide_snapshot * ss);


# 19 "guide.c" 2





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


 


# 24 "guide.c" 2


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



 


# 26 "guide.c" 2



 






static unsigned char lots_of_zeros[8192] = {0};

int parse_guide_header(unsigned char ** pp, struct guide_header * h) 
{
    unsigned char * p;
    
    p = *pp;
    h->version                   = rtv_to_u32(&p);
    h->struct_size               = rtv_to_u32(&p);
    h->num_channels_1            = rtv_to_u32(&p);
    h->num_channels_2            = rtv_to_u32(&p);
    h->group_data_offset         = rtv_to_u32(&p);
    h->channel_offset            = rtv_to_u32(&p);
    h->show_offset               = rtv_to_u32(&p);
    h->flags                     = rtv_to_u32(&p);

    *pp = p;

     



    h->flags &= 1;
    
    do { if (!( h->version == 0x00030001 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->version == 0x00030001", "guide.c", 60); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( h->struct_size == 32 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->struct_size == 32", "guide.c", 61); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( h->num_channels_1 == h->num_channels_2 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->num_channels_1 == h->num_channels_2", "guide.c", 62); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( h->group_data_offset == 32 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->group_data_offset == 32", "guide.c", 63); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( h->channel_offset == h->group_data_offset + 776 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->channel_offset == h->group_data_offset + 776", "guide.c", 64); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( h->show_offset ==
           h->group_data_offset + 776 + 624 * h->num_channels_1 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "h->show_offset == h->group_data_offset + 776 + 624 * h->num_channels_1", "guide.c", 66); if (0 ) (exit(-1)); } } while(0) ;

    return 0;
}

int parse_group_data(unsigned char ** pp, struct group_data * gd) 
{
    unsigned char * p = *pp;
    unsigned int i;
    
    gd->struct_size               = rtv_to_u32(&p);
    gd->num_categories            = rtv_to_u32(&p);
    for (i = 0; i < 32; i++)
        gd->index[i]              = rtv_to_u32(&p);
    for (i = 0; i < 32; i++)
        gd->name_offset[i]        = rtv_to_u32(&p);
    memcpy(gd->name_block, p, sizeof gd->name_block);
    p += sizeof gd->name_block;

    *pp = p;

    do { if (!( gd->struct_size == 776 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "gd->struct_size == 776", "guide.c", 87); if (0 ) (exit(-1)); } } while(0) ;
    do { if (!( gd->num_categories <= 32 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "gd->num_categories <= 32", "guide.c", 88); if (0 ) (exit(-1)); } } while(0) ;

    for (i = 0; i < gd->num_categories; i++) {
        gd->category_bitmapping[i].value = 1 << gd->index[i];
        gd->category_bitmapping[i].name  =
            gd->name_block + gd->name_offset[i];
    }
    gd->category_bitmapping[gd->num_categories].value   = 1 << 16;
    gd->category_bitmapping[gd->num_categories].name    = "Received";
    gd->category_bitmapping[gd->num_categories+1].value = -1;
    gd->category_bitmapping[gd->num_categories+1].name  = ((void *)0) ;

    return 0;
}

int parse_channel(unsigned char **pp, struct channel * c)
{
    unsigned char * p = *pp;
    
    c->struct_size    = rtv_to_u32(&p);
    c->unknown1       = rtv_to_u32(&p);
    c->isvalid        = rtv_to_u32(&p);
    parse_headend_channel(&p, &c->headend_channel);
    memcpy(c->headend, p, sizeof c->headend);         p += sizeof c->headend;
    c->guide_index    = rtv_to_u32(&p);

    if (c->struct_size) {
        do { if (!( c->struct_size == 80 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "c->struct_size == 80", "guide.c", 115); if (0 ) (exit(-1)); } } while(0) ;
        do { if (!( c->unknown1 == 1 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "c->unknown1 == 1", "guide.c", 116); if (0 ) (exit(-1)); } } while(0) ;
        do { if (!( c->isvalid == 1 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "c->isvalid == 1", "guide.c", 117); if (0 ) (exit(-1)); } } while(0) ;
    } else {
        if (!c->isvalid) {
            do { if (!( memcmp(c, lots_of_zeros, sizeof *c) == 0 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "memcmp(c, lots_of_zeros, sizeof *c) == 0", "guide.c", 120); if (0 ) (exit(-1)); } } while(0) ;
        }
    }
    
    *pp = p;
    
    return 0;
}

int parse_replay_show(unsigned char **pp, struct replay_show * rs)
{
    unsigned char * p = *pp;

    rs->channel_id       = rtv_to_u32(&p);
    rs->show_id          = rtv_to_u32(&p);
    rs->input_source     = rtv_to_u32(&p);
    rs->quality          = rtv_to_u32(&p);
    rs->guaranteed       = rtv_to_u32(&p);
    rs->flags            = rtv_to_u32(&p);
    parse_channel(&p, &rs->channel);
    parse_program(&p, &rs->program);
    rs->ivs_status       = rtv_to_u32(&p);
    rs->remote_guide_id  = rtv_to_u32(&p);
    rs->download_id      = rtv_to_u32(&p);
    rs->times_sent       = rtv_to_u32(&p);
    rs->seconds          = rtv_to_u32(&p);
    rs->gop_count        = rtv_to_u32(&p);
    rs->gop_highest_seen = rtv_to_u32(&p);
    rs->gop_last_seen    = rtv_to_u32(&p);
    rs->checkpointed     = rtv_to_u32(&p);
    rs->intact           = rtv_to_u32(&p);
    rs->upgrade_flag     = rtv_to_u32(&p);
    rs->instance         = rtv_to_u32(&p);
    rs->unused1          = rtv_to_u16(&p);
    rs->before_padding   = *p++;
    rs->after_padding    = *p++;
    rs->index_size       = rtv_to_u64(&p);
    rs->mpeg_size        = rtv_to_u64(&p);

    do { if (!( rs->program.fixed_program_record.tmsid ==
           rs->channel.headend_channel.tmsid )) { fprintf(stderr , "Unexpected %s %s:%d\n", "rs->program.fixed_program_record.tmsid == rs->channel.headend_channel.tmsid", "guide.c", 160); if (0 ) (exit(-1)); } } while(0) ;

    *pp = p;

    return 0;
}

int parse_replay_theme(unsigned char **pp, struct replay_theme * rt)
{
    unsigned char * p = *pp;
    
    rt->flags            = rtv_to_u32(&p);
    rt->suzuki_id        = rtv_to_u32(&p);
    rt->minutes          = rtv_to_u32(&p);
    memcpy(rt->keywords, p, sizeof rt->keywords);
    p += sizeof rt->keywords;

    *pp = p;

    return 0;
}

int parse_replay_channel(unsigned char **pp, struct replay_channel * rc)
{
    unsigned char * p = *pp;
    
    rc->channel_type     = rtv_to_u32(&p);
    rc->quality          = rtv_to_u32(&p);
    rc->space_allocated  = rtv_to_u64(&p);
    rc->keep             = rtv_to_u32(&p);
    rc->stored           = rtv_to_u32(&p);
    rc->days_of_week     = *p++;
    rc->after_padding    = *p++;
    rc->before_padding   = *p++;
    rc->flags            = *p++;
    rc->category         = rtv_to_u32(&p);
    rc->channel_id       = rtv_to_u32(&p);
    rc->unknown1         = rtv_to_u32(&p);
    rc->unknown2         = rtv_to_u32(&p);
    rc->unknown3         = rtv_to_u32(&p);
    rc->unknown4         = rtv_to_u32(&p);
    rc->unknown5         = rtv_to_u32(&p);
    rc->unknown6         = rtv_to_u32(&p);
    rc->unknown7         = rtv_to_u32(&p);
    rc->seconds_reserved = rtv_to_u32(&p);
    memcpy(rc->label, p, sizeof rc->label); p += sizeof rc->label;
    parse_replay_show(&p, &rc->replay_show);
    parse_replay_theme(&p, &rc->replay_theme);

    *pp = p;

    return 0;
}

int parse_replay_guide_snapshot(unsigned char **pp,
                                struct replay_guide_snapshot * ss)
{
    unsigned int i;
    unsigned char * p = *pp;
    unsigned char * start = p;
    
    if (parse_guide_header(&p, &ss->guide_header) < 0) {
        fprintf(stderr , "Error parsing guide header\n");
        return -1;
    }
    do { if (!( p == start + ss->guide_header.group_data_offset )) { fprintf(stderr , "Unexpected %s %s:%d\n", "p == start + ss->guide_header.group_data_offset", "guide.c", 225); if (0 ) (exit(-1)); } } while(0) ;

    if (parse_group_data(&p, &ss->group_data) < 0) {
        fprintf(stderr , "Error parsing group data\n");
        return -1;
    }
    do { if (!( p == start + ss->guide_header.channel_offset )) { fprintf(stderr , "Unexpected %s %s:%d\n", "p == start + ss->guide_header.channel_offset", "guide.c", 231); if (0 ) (exit(-1)); } } while(0) ;

    ss->num_shows = 0;
    ss->replay_channels = calloc(ss->guide_header.num_channels_1,
                                 sizeof(struct replay_channel));
    for (i = 0; i < ss->guide_header.num_channels_1; i++) {
        if (parse_replay_channel(&p, &ss->replay_channels[i]) < 0) {
            fprintf(stderr , "Error parsing replay channel %d\n", i);
            return -1;
        }
        ss->num_shows += ss->replay_channels[i].stored;
    }
    do { if (!( p == start + ss->guide_header.show_offset )) { fprintf(stderr , "Unexpected %s %s:%d\n", "p == start + ss->guide_header.show_offset", "guide.c", 243); if (0 ) (exit(-1)); } } while(0) ;

    ss->replay_shows = calloc(ss->num_shows, sizeof(struct replay_show));
    for (i = 0; i < ss->num_shows; i++) {
        if (parse_replay_show(&p, &ss->replay_shows[i]) < 0) {
            fprintf(stderr , "Error parsing replay show %d\n", i);
            return -1;
        }
    }
    
    return 0;
}

int parse_replay_guide_snapshot_staged(unsigned char **pp,
                                       struct replay_guide_snapshot * ss)
{
    unsigned int i;
    int num_shows = 0;
    
    switch(ss->stage) {
      case 0:                    

        ss->stage = 1;
        return 32;
      case 1:                    

        if (parse_guide_header(pp, &ss->guide_header) < 0) {
            fprintf(stderr , "Error parsing guide header\n");
            return -1;
        }
        ss->guide_header.num_channels_2 = 0;
        ss->num_shows = 0;
        ss->stage = 2;
        return 776;
      case 2:                    

        if (parse_group_data(pp, &ss->group_data) < 0) {
            fprintf(stderr , "Error parsing group data\n");
            return -1;
        }
        ss->stage = 3;
        return ss->guide_header.num_channels_1 * 624;
      case 3:                    


        ss->replay_channels = calloc(ss->guide_header.num_channels_1,
                                     sizeof(struct replay_channel));
        for (i = 0; i < ss->guide_header.num_channels_1; i++) {
            if (parse_replay_channel(pp, &ss->replay_channels[i]) < 0) {
                fprintf(stderr , "Error parsing replay channel %d\n", i);
                return -1;
            }
            num_shows += ss->replay_channels[i].stored;
        }
        ss->replay_shows = calloc(num_shows, sizeof(struct replay_show));
        for (i = 0; i < ss->guide_header.num_channels_1; i++) {
            if (ss->replay_channels[i].stored) {
                ss->stage = 4;
                ss->guide_header.num_channels_2 = i;
                return ss->replay_channels[i].stored * 444;
            } else {
                fprintf(stderr , "Skipping channel %d: %ld\n",
                        i, ss->replay_channels[i].stored);
            }
        }
        ss->stage = 5;
        ss->guide_header.num_channels_2 = i;
        return 0;
      case 4:                    



        for (i = 0;
             i < ss->replay_channels[ss->guide_header.num_channels_2].stored;
             i++) {
            if (parse_replay_show(pp, &ss->replay_shows[ss->num_shows]) < 0) {
                fprintf(stderr , "Error parsing replay show %d\n", i);
                return -1;
            }
            ss->num_shows++;
        }
        for (i = ss->guide_header.num_channels_2+1;
             i < ss->guide_header.num_channels_1;
             i++) {
            if (ss->replay_channels[i].stored) {
                ss->guide_header.num_channels_2 = i;
                return ss->replay_channels[i].stored * 444;
            }
        }
        ss->stage = 5;
        ss->guide_header.num_channels_2 = i;
        return 0;
      default:
        do { if (!( 0 )) { fprintf(stderr , "Unexpected %s %s:%d\n", "0", "guide.c", 336); if (0 ) (exit(-1)); } } while(0) ;
        return 0;
    }
}

void free_replay_guide_snapshot(struct replay_guide_snapshot * ss)
{
    free(ss->replay_channels); ss->replay_channels = ((void *)0) ;
    free(ss->replay_shows);    ss->replay_shows    = ((void *)0) ;
}

struct mapping replay_channel_type_mapping[] = {
    {1, "Recurring"},
    {2, "Theme"},                
    {3, "Single"},
    {4, "Zone"},                 
    {-1, ((void *)0) }
};

struct mapping quality_mapping[] = {
    {0, "High"},
    {1, "Medium"},
    {2, "Standard"},
    {-1, ((void *)0) }
};

struct mapping input_source_mapping[] = {
    {0, "Raw RF"},
    {1, "Line 1 Direct"},
    {2, "Line 2 Direct"},
    {3, "Tuner"},
    {-1, ((void *)0) }
};

struct mapping show_flags_bitmapping[] = {
    { 1 << 0, "Manual record"},
    { 1 << 1, "AutoSkip on"},
    { 1 << 2, "AutoSkip explicitely set"},
    { 1 << 4, "Manual record of Pay-Per-View"},
    { -1, ((void *)0) }
};

struct mapping ivs_status_mapping[] = {
    {0, "Local"},                                
    {1, "LAN"},                                  
    {2, "Internet Downloadable"},                
    {3, "Internet Download Failed"},             
    {4, "Internet Index Download Restart"},      
    {5, "Internet Index Downloading"},           
    {6, "Internet Index Download Complete"},     
    {7, "Internet MPEG Download Restart"},       
    {8, "Internet MPEG Downloading"},            
    {9, "Internet MPEG Download Complete"},      
    {10, "Internet File Not Found"},             
    { -1, ((void *)0) }
};

struct mapping channel_flags_bitmapping[] = {
    {1 << 0, "Raw Mode"},
    {1 << 1, "IVS"},
    {1 << 2, "Exported"},
    {-1, ((void *)0) }
};

struct mapping day_of_week_bitmapping[] = {
    {1 << 0, "Sun"},
    {1 << 1, "Mon"},
    {1 << 2, "Tue"},
    {1 << 3, "Wed"},
    {1 << 4, "Thu"},
    {1 << 5, "Fri"},
    {1 << 6, "Sat"},
    {-1, ((void *)0) }
};

struct mapping theme_flags_bitmapping[] = {
    {1 << 0, "Actor search"},
    {1 << 1, "Director search"},
    {1 << 2, "Title search"},
    {1 << 3, "Title match"},
    {1 << 4, "Description search"},
    {1 << 5, "Random"},
    {-1, ((void *)0) },
};

struct mapping guide_flags_bitmapping[] = {
    {1 << 0, "AutoSkip defaults to on"},
    {-1, ((void *)0) },
};


void dump_guide_header(struct guide_header * h) 
{
    dump_group_start    ("Replay Guide Header");
    dump_u32            ("Version",                 h->version);
    dump_u32            ("Struct Size",             h->struct_size);
    dump_u32            ("Num Channels #1",         h->num_channels_1);
    dump_u32            ("Num Channels #2",         h->num_channels_2);
    dump_u32            ("Group Data Offset",       h->group_data_offset);
    dump_u32            ("Channel Offset",          h->channel_offset);
    dump_u32            ("Show Offset",             h->show_offset);
    dump_bitmapping     ("Flags",                   h->flags, guide_flags_bitmapping);
    dump_group_end      ();
}

void dump_group_data(struct group_data * gd)
{
    unsigned int i;
    char buffer[32];

    dump_group_start    ("Group Data");
    dump_u32            ("Struct Size",             gd->struct_size);
    dump_u32            ("Num Categories",          gd->num_categories);
    for (i = 0; i < gd->num_categories; i++) {
        sprintf         (buffer, "Category Index %d", i);
        dump_u32        (buffer,                    gd->index[i]);
    }
    for (i = 0; i < gd->num_categories; i++) {
        sprintf(buffer, "Category Name %d", i);
        dump_string     (buffer,                    gd->name_block + gd->name_offset[i]);
    }
    dump_group_end      ();
}

void dump_channel(struct channel * c)
{
    if (!c->isvalid)
        return;

    dump_group_start    ("Channel");
    dump_u32            ("Struct Size",          c->struct_size);
    dump_u32            ("Unknown1",             c->unknown1);
    dump_u32            ("Is Valid",             c->isvalid);
    dump_headend_channel(                       &c->headend_channel);
    dump_string         ("Headend",              c->headend);
    dump_u32            ("Guide Index",          c->guide_index);
    dump_group_end      ();
}

void dump_replay_show(struct replay_show * rs)
{
    dump_group_start    ("Replay Show");
    dump_time           ("Channel ID",          rs->channel_id);
    dump_time           ("Show ID",             rs->show_id);
    dump_mapping        ("Input Source",        rs->input_source,       input_source_mapping);
    dump_mapping        ("Quality",             rs->quality,            quality_mapping);
    dump_u32            ("Guaranteed",          rs->guaranteed);
    dump_bitmapping     ("Flags",               rs->flags, show_flags_bitmapping);
    dump_channel        (                      &rs->channel);
    dump_program        (                      &rs->program);
    dump_mapping        ("IVS Status",          rs->ivs_status,         ivs_status_mapping);
    dump_u32            ("Remote Guide ID",     rs->remote_guide_id);
    dump_u32            ("Download ID",         rs->download_id);
    dump_u32            ("Times Sent",          rs->times_sent);
    dump_u32            ("Seconds",             rs->seconds);
    dump_u32            ("GOP Count",           rs->gop_count);
    dump_u32            ("GOP Highest Seen",    rs->gop_highest_seen);
    dump_u32            ("GOP Last Seen",       rs->gop_last_seen);
    dump_u32            ("Checkpointed",        rs->checkpointed);
    dump_u32            ("Intact",              rs->intact);
    dump_u32            ("Upgrade Flag",        rs->upgrade_flag);
    dump_u32            ("Instance",            rs->instance);
    dump_u16            ("Unused1",             rs->unused1);
    dump_u8             ("Padding Before",      rs->before_padding);
    dump_u8             ("Padding After",       rs->after_padding);
    dump_u64            ("Index Size",          rs->index_size);
    dump_u64            ("MPEG Size",           rs->mpeg_size);
    dump_group_end      ();
}

void dump_replay_theme(struct replay_theme * rt)
{
    dump_group_start    ("Replay Theme");
    dump_bitmapping     ("Flags",                rt->flags, theme_flags_bitmapping);
    dump_u32            ("Suzuki ID",            rt->suzuki_id);
    dump_u32            ("Minutes",              rt->minutes);
    dump_string         ("Keywrods",             rt->keywords);
    dump_group_end      ();
}

void dump_replay_channel(struct replay_channel * rc, struct mapping * category_bitmapping)
{
    dump_group_start    ("Guide Channel");
    dump_mapping        ("Guide Channel Type",   rc->channel_type, replay_channel_type_mapping);
    dump_mapping        ("quality",              rc->quality, quality_mapping);
    dump_u64            ("space_allocated",      rc->space_allocated);
    dump_u32            ("keep",                 rc->keep);
    dump_u32            ("stored",               rc->stored);
    dump_bitmapping     ("days_of_week",         rc->days_of_week, day_of_week_bitmapping);
    dump_u8             ("after_padding",        rc->after_padding);
    dump_u8             ("before_padding",       rc->before_padding);
    dump_bitmapping     ("flags",                rc->flags, channel_flags_bitmapping);
    dump_bitmapping     ("category",             rc->category, category_bitmapping);
    dump_time           ("Channel ID",           rc->channel_id);
    dump_time           ("unknown1"     ,        rc->unknown1);
    dump_u32            ("unknown2",             rc->unknown2);
    dump_u32            ("unknown3",             rc->unknown3);
    dump_u32            ("unknown4",             rc->unknown4);
    dump_u32            ("unknown5",             rc->unknown5);
    dump_u32            ("unknown6",             rc->unknown6);
    dump_u32            ("unknown7",             rc->unknown7);
    dump_u32            ("seconds_reserved",     rc->seconds_reserved);
    dump_string         ("label",                rc->label);
    dump_replay_show    (                       &rc->replay_show);
    dump_replay_theme   (                       &rc->replay_theme);
    dump_group_end      ();
}

void dump_replay_guide_snapshot(struct replay_guide_snapshot * ss)
{
    unsigned int i;
    
    dump_group_start            ("Replay Guide Snapshot");
    dump_guide_header           (&ss->guide_header);
    dump_group_data             (&ss->group_data);
    dump_group_start            ("Replay Channels");
    for (i = 0; i < ss->guide_header.num_channels_1; i++) {
        dump_replay_channel     (&ss->replay_channels[i], ss->group_data.category_bitmapping);
    }
    dump_group_end              ();
    dump_group_start            ("Replay Shows");
    for (i = 0; i < ss->num_shows; i++) {
        dump_replay_show        (&ss->replay_shows[i]);
    }
    dump_group_end              ();
    dump_group_end              ();
}
