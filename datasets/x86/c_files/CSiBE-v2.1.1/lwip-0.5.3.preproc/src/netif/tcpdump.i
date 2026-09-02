# 1 "../../src/netif/tcpdump.c"
 


































# 1 "/SYS/include/stdio.h" 1 3
 


















 







# 1 "/SYS/include/features.h" 1 3
 




















 






























































 




















 





 



 







 
# 142 "/SYS/include/features.h" 3


 









 








 



























# 208 "/SYS/include/features.h" 3


































 



 


 








 




 
















 


# 1 "/SYS/include/sys/cdefs.h" 1 3
 




















 




 






 





 








 



# 65 "/SYS/include/sys/cdefs.h" 3


 





 




 









 







 

















 















 







 






 








 








 








 











 










 







 




 


















# 283 "/SYS/include/features.h" 2 3



 








 





 

 








# 1 "/SYS/include/gnu/stubs.h" 1 3
 



















# 312 "/SYS/include/features.h" 2 3




# 28 "/SYS/include/stdio.h" 2 3


 



# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


































typedef unsigned int size_t;






















 




 

# 271 "/LIB/include/stddef.h" 3


# 283 "/LIB/include/stddef.h" 3


 

 

# 317 "/LIB/include/stddef.h" 3




 





















# 34 "/SYS/include/stdio.h" 2 3


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




# 36 "/SYS/include/stdio.h" 2 3








 
typedef struct _IO_FILE FILE;








 
typedef struct _IO_FILE __FILE;









# 1 "/SYS/include/libio.h" 1 3
 






























# 1 "/SYS/include/_G_config.h" 1 3
 





 






# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 





























 


























typedef long int wchar_t;
























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


 

typedef _G_fpos_t fpos_t;







 





 





 






 







 




 








# 1 "/SYS/include/bits/stdio_lim.h" 1 3
 








































# 129 "/SYS/include/stdio.h" 2 3



 
extern FILE *stdin;		 
extern FILE *stdout;		 
extern FILE *stderr;		 
 




 
extern int remove (__const char *__filename)  ;
 
extern int rename (__const char *__old, __const char *__new)  ;


 

extern FILE *tmpfile (void)  ;










 
extern char *tmpnam (char *__s)  ;


 

extern char *tmpnam_r (char *__s)  ;




 






extern char *tempnam (__const char *__dir, __const char *__pfx)
        ;



 
extern int fclose (FILE *__stream)  ;
 
extern int fflush (FILE *__stream)  ;


 
extern int fflush_unlocked (FILE *__stream)  ;









 
extern FILE *fopen (__const char *__restrict __filename,
		    __const char *__restrict __modes)  ;
 
extern FILE *freopen (__const char *__restrict __filename,
		      __const char *__restrict __modes,
		      FILE *__restrict __stream)  ;
# 220 "/SYS/include/stdio.h" 3










 
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

 












 
extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos)
      ;
 
extern int fsetpos (FILE *__stream, __const fpos_t *__pos)  ;
# 520 "/SYS/include/stdio.h" 3










 
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










 





 




# 36 "../../src/netif/tcpdump.c" 2

  
# 1 "../../src/include/netif/tcpdump.h" 1
 




































# 1 "../../src/include/lwip/pbuf.h" 1
 

































 



# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 39 "../../src/include/lwip/pbuf.h" 2

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


# 38 "../../src/include/netif/tcpdump.h" 2


void tcpdump_init(void);
void tcpdump(struct pbuf *p);


# 38 "../../src/netif/tcpdump.c" 2

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
 




































# 1 "../../src/include/lwip/opt.h" 1
 




































# 1 "lwipopts.h" 1
 




































 
 




 



 



 


 


 


 


 




 

 

 

 



 




 




 
 


 


 



 



 



 


 


 



 


 


 


 


 
 




 



 



 
 




 



 




 















# 38 "../../src/include/lwip/opt.h" 2


 

























































# 38 "../../src/include/lwip/netif.h" 2


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




























# 39 "../../src/netif/tcpdump.c" 2

# 1 "../../src/include/lwip/tcp.h" 1
 




































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


# 38 "../../src/include/lwip/tcp.h" 2

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





# 40 "../../src/netif/tcpdump.c" 2

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





# 41 "../../src/netif/tcpdump.c" 2



static FILE *file = ((void *)0) ;

 
void
tcpdump_init(void)
{
  char *fname;

  fname = "/tmp/tcpdump";
  file = fopen(fname, "w");
  if(file == ((void *)0) ) {
    perror("tcpdump_init: fopen");
  }
   ;
}
 
void
tcpdump(struct pbuf *p)
{
  struct ip_hdr *iphdr;
  struct tcp_hdr *tcphdr;
  struct udp_hdr *udphdr;
  char flags[5];
  int i;
  int len;
  int offset;

  if(file == ((void *)0) ) {
    return;
  }

  iphdr = p->payload;
  switch(((((((u16_t)( ( iphdr )->_ttl_proto ) & 0xff)) << 8) | (((u16_t)( ( iphdr )->_ttl_proto ) & 0xff00) >> 8))  & 0xff) ) {
  case 6 :    
    tcphdr = (struct tcp_hdr *)((char *)iphdr + 20 );
    
    pbuf_header(p, - 20 );
    if(inet_chksum_pseudo(p, (struct ip_addr *)&(iphdr->src),
			  (struct ip_addr *)&(iphdr->dest),
			  6 , p->tot_len) != 0) {
       ;
       




      fprintf(file, "!chksum ");
    }
    
    i = 0;
    if(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x02 ) {
      flags[i++] = 'S';
    }
    if(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x08 ) {
      flags[i++] = 'P';
    }
    if(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x01 ) {
      flags[i++] = 'F';
    }
    if(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x04 ) {
      flags[i++] = 'R';
    }
    if(i == 0) {
      flags[i++] = '.';
    }
    flags[i++] = 0;    

    
    
    fprintf(file, "%d.%d.%d.%d.%u > %d.%d.%d.%d.%u: ",
	    (int)(htonl (iphdr->src.addr) >> 24) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 16) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 8) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 0) & 0xff,
	    htons (tcphdr->src),
	  (int)(htonl (iphdr->dest.addr) >> 24) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 16) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 8) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 0) & 0xff,
	    htons (tcphdr->dest));
    offset = ((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  >> 8)  >> 4;
    
    len = htons ((( iphdr )->_len) ) - offset * 4 - 20 ;
    if(len != 0 || flags[0] != '.') {
      fprintf(file, "%s %lu:%lu(%u) ",
	      flags,
	      htonl (tcphdr->seqno),
	      htonl (tcphdr->seqno) + len,
	      len);
    }
    if(((((((u16_t)( ( tcphdr )->_offset_flags ) & 0xff)) << 8) | (((u16_t)( ( tcphdr )->_offset_flags ) & 0xff00) >> 8))  & 0xff)  & 0x10 ) {
      fprintf(file, "ack %lu ",
	      htonl (tcphdr->ackno));
    }
    fprintf(file, "wnd %u\n",
	    htons (tcphdr->wnd));
    
    fflush(file);
    
    pbuf_header(p, 20 );
    break;
    
  case 17 :    
    udphdr = (struct udp_hdr *)((char *)iphdr + 20 );
    
    pbuf_header(p, - 20 );
    if(inet_chksum_pseudo(p, (struct ip_addr *)&(iphdr->src),
			  (struct ip_addr *)&(iphdr->dest),
			  17 , p->tot_len) != 0) {
       ;
       




      fprintf(file, "!chksum ");
    }
    
    fprintf(file, "%d.%d.%d.%d.%u > %d.%d.%d.%d.%u: ",
	    (int)(htonl (iphdr->src.addr) >> 24) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 16) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 8) & 0xff,
	    (int)(htonl (iphdr->src.addr) >> 0) & 0xff,
	    htons (udphdr->src),
	  (int)(htonl (iphdr->dest.addr) >> 24) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 16) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 8) & 0xff,
	    (int)(htonl (iphdr->dest.addr) >> 0) & 0xff,
	    htons (udphdr->dest));
    fprintf(file, "U ");
    len = htons ((( iphdr )->_len) ) - sizeof(struct udp_hdr) - 20 ;
    fprintf(file, " %d\n", len);
    
    fflush(file);
    
    pbuf_header(p, 20 );
    break;

  }

}
 




