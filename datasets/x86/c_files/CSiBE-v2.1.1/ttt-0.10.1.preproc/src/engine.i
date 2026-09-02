# 1 "engine.c"
 




















 




# 1 "../config.h" 1
 
 

 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 


 


 


 
 
# 27 "engine.c" 2


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
















extern int _IO_vfscanf (_IO_FILE * , const char * ,
			__gnuc_va_list , int *)  ;
extern int _IO_vfprintf (_IO_FILE *, const char *,
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









 
extern FILE *fopen (__const char * __filename,
		    __const char * __modes)  ;
 
extern FILE *freopen (__const char * __filename,
		      __const char * __modes,
		      FILE * __stream)  ;
# 220 "/SYS/include/stdio.h" 3










 
extern FILE *fdopen (int __fd, __const char *__modes)  ;


# 249 "/SYS/include/stdio.h" 3



 

extern void setbuf (FILE * __stream, char * __buf)  ;
 


extern int setvbuf (FILE * __stream, char * __buf,
		    int __modes, size_t __n)  ;


 

extern void setbuffer (FILE * __stream, char * __buf,
		       size_t __size)  ;

 
extern void setlinebuf (FILE *__stream)  ;



 
extern int fprintf (FILE * __stream,
		    __const char * __format, ...)  ;
 
extern int printf (__const char * __format, ...)  ;
 
extern int sprintf (char * __s,
		    __const char * __format, ...)  ;

 
extern int vfprintf (FILE * __s, __const char * __format,
		     __gnuc_va_list  __arg)  ;
 
extern int vprintf (__const char * __format, __gnuc_va_list  __arg)
      ;
 
extern int vsprintf (char * __s, __const char * __format,
		     __gnuc_va_list  __arg)  ;


 
extern int snprintf (char * __s, size_t __maxlen,
		     __const char * __format, ...)
       __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char * __s, size_t __maxlen,
		      __const char * __format, __gnuc_va_list  __arg)
       __attribute__ ((__format__ (__printf__, 3, 0)));


# 321 "/SYS/include/stdio.h" 3



 
extern int fscanf (FILE * __stream,
		   __const char * __format, ...)  ;
 
extern int scanf (__const char * __format, ...)  ;
 
extern int sscanf (__const char * __s,
		   __const char * __format, ...)  ;

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



 
extern char *fgets (char * __s, int __n, FILE * __stream)
      ;







 

extern char *gets (char *__s)  ;


# 437 "/SYS/include/stdio.h" 3



 
extern int fputs (__const char * __s, FILE * __stream)
      ;







 
extern int puts (__const char *__s)  ;


 
extern int ungetc (int __c, FILE *__stream)  ;


 
extern size_t fread (void * __ptr, size_t __size,
		     size_t __n, FILE * __stream)  ;
 
extern size_t fwrite (__const void * __ptr, size_t __size,
		      size_t __n, FILE * __s)  ;


 
extern size_t fread_unlocked (void * __ptr, size_t __size,
			      size_t __n, FILE * __stream)  ;
extern size_t fwrite_unlocked (__const void * __ptr, size_t __size,
			       size_t __n, FILE * __stream)  ;



 
extern int fseek (FILE *__stream, long int __off, int __whence)  ;
 
extern long int ftell (FILE *__stream)  ;
 
extern void rewind (FILE *__stream)  ;

 












 
extern int fgetpos (FILE * __stream, fpos_t * __pos)
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










 





 




# 29 "engine.c" 2

# 1 "/SYS/include/stdlib.h" 1 3
 

















 







 





# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


# 188 "/LIB/include/stddef.h" 3





 




 


# 269 "/LIB/include/stddef.h" 3




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


 
extern double strtod (__const char * __nptr,
		      char ** __endptr)  ;










 
extern long int strtol (__const char * __nptr,
			char ** __endptr, int __base)  ;
 
extern unsigned long int strtoul (__const char * __nptr,
				  char ** __endptr, int __base)
      ;


 
__extension__
extern long long int strtoq (__const char * __nptr,
			     char ** __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtouq (__const char * __nptr,
				       char ** __endptr, int __base)
      ;



 

 
__extension__
extern long long int strtoll (__const char * __nptr,
			      char ** __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtoull (__const char * __nptr,
					char ** __endptr, int __base)
      ;



# 244 "/SYS/include/stdlib.h" 3



 


extern double __strtod_internal (__const char * __nptr,
				 char ** __endptr, int __group)
      ;
extern float __strtof_internal (__const char * __nptr,
				char ** __endptr, int __group)
      ;
extern long double __strtold_internal (__const char * __nptr,
				       char ** __endptr,
				       int __group)  ;

extern long int __strtol_internal (__const char * __nptr,
				   char ** __endptr,
				   int __base, int __group)  ;



extern unsigned long int __strtoul_internal (__const char * __nptr,
					     char ** __endptr,
					     int __base, int __group)  ;




__extension__
extern long long int __strtoll_internal (__const char * __nptr,
					 char ** __endptr,
					 int __base, int __group)  ;



__extension__
extern unsigned long long int __strtoull_internal (__const char *
						    __nptr,
						   char ** __endptr,
						   int __base, int __group)
      ;




# 377 "/SYS/include/stdlib.h" 3




 


extern char *l64a (long int __n)  ;

 
extern long int a64l (__const char *__s)    ;


# 1 "/SYS/include/sys/types.h" 1 3
 

















 








 





typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;



typedef __ino_t ino_t;











typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;





typedef __off_t off_t;











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

 




 






 

 




extern int select (int __nfds, fd_set * __readfds,
		   fd_set * __writefds,
		   fd_set * __exceptfds,
		   struct timeval * __timeout)  ;

# 116 "/SYS/include/sys/select.h" 3


 


# 215 "/SYS/include/sys/types.h" 2 3


 
# 1 "/SYS/include/sys/sysmacros.h" 1 3
 





















 








# 47 "/SYS/include/sys/sysmacros.h" 3



# 218 "/SYS/include/sys/types.h" 2 3









 


typedef __blkcnt_t blkcnt_t;	  



typedef __fsblkcnt_t fsblkcnt_t;  



typedef __fsfilcnt_t fsfilcnt_t;  


# 254 "/SYS/include/sys/types.h" 3








 


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

extern int random_r (struct random_data * __buf,
		     int32_t * __result)  ;

extern int srandom_r (unsigned int __seed, struct random_data *__buf)  ;

extern int initstate_r (unsigned int __seed, char * __statebuf,
			size_t __statelen,
			struct random_data * __buf)  ;

extern int setstate_r (char * __statebuf,
		       struct random_data * __buf)  ;




 
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

 
extern int drand48_r (struct drand48_data * __buffer,
		      double * __result)  ;
extern int erand48_r (unsigned short int __xsubi[3],
		      struct drand48_data * __buffer,
		      double * __result)  ;

 
extern int lrand48_r (struct drand48_data * __buffer,
		      long int * __result)  ;
extern int nrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data * __buffer,
		      long int * __result)  ;

 
extern int mrand48_r (struct drand48_data * __buffer,
		      long int * __result)  ;
extern int jrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data * __buffer,
		      long int * __result)  ;

 
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

 





extern int mkstemp (char *__template)  ;













 




extern char *mkdtemp (char *__template)  ;



 
extern int system (__const char *__command)  ;










 





extern char *realpath (__const char * __name,
		       char * __resolved)  ;



 


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








 


 


extern char *ecvt (double __value, int __ndigit, int * __decpt,
		   int * __sign)  ;

 


extern char *fcvt (double __value, int __ndigit, int * __decpt,
		   int * __sign)  ;

 


extern char *gcvt (double __value, int __ndigit, char *__buf)  ;



 
extern char *qecvt (long double __value, int __ndigit,
		    int * __decpt, int * __sign)  ;
extern char *qfcvt (long double __value, int __ndigit,
		    int * __decpt, int * __sign)  ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)  ;


 

extern int ecvt_r (double __value, int __ndigit, int * __decpt,
		   int * __sign, char * __buf,
		   size_t __len)  ;
extern int fcvt_r (double __value, int __ndigit, int * __decpt,
		   int * __sign, char * __buf,
		   size_t __len)  ;

extern int qecvt_r (long double __value, int __ndigit,
		    int * __decpt, int * __sign,
		    char * __buf, size_t __len)  ;
extern int qfcvt_r (long double __value, int __ndigit,
		    int * __decpt, int * __sign,
		    char * __buf, size_t __len)  ;




 

extern int mblen (__const char *__s, size_t __n)  ;
 

extern int mbtowc (wchar_t * __pwc,
		   __const char * __s, size_t __n)  ;
 

extern int wctomb (char *__s, wchar_t __wchar)  ;


 
extern size_t mbstowcs (wchar_t *  __pwcs,
			__const char * __s, size_t __n)  ;
 
extern size_t wcstombs (char * __s,
			__const wchar_t * __pwcs, size_t __n)
      ;



 



extern int rpmatch (__const char *__response)  ;



# 811 "/SYS/include/stdlib.h" 3









 






# 842 "/SYS/include/stdlib.h" 3


# 852 "/SYS/include/stdlib.h" 3



 


extern int getloadavg (double __loadavg[], int __nelem)  ;





 


# 30 "engine.c" 2

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


 


extern size_t strftime (char * __s, size_t __maxsize,
			__const char * __format,
			__const struct tm * __tp)  ;










 

extern struct tm *gmtime (__const time_t *__timer)  ;

 

extern struct tm *localtime (__const time_t *__timer)  ;


 

extern struct tm *gmtime_r (__const time_t * __timer,
			    struct tm * __tp)  ;

 

extern struct tm *localtime_r (__const time_t * __timer,
			       struct tm * __tp)  ;


 

extern char *asctime (__const struct tm *__tp)  ;

 
extern char *ctime (__const time_t *__timer)  ;


 

 

extern char *asctime_r (__const struct tm * __tp,
			char * __buf)  ;

 
extern char *ctime_r (__const time_t * __timer,
		      char * __buf)  ;



 
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
			 struct sigevent * __evp,
			 timer_t * __timerid)  ;

 
extern int timer_delete (timer_t __timerid)  ;

 
extern int timer_settime (timer_t __timerid, int __flags,
			  __const struct itimerspec * __value,
			  struct itimerspec * __ovalue)  ;

 
extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
      ;

 
extern int timer_getoverrun (timer_t __timerid)  ;



# 349 "/SYS/include/time.h" 3


# 359 "/SYS/include/time.h" 3



 




# 31 "engine.c" 2


# 1 "/SYS/include/pthread.h" 1 3
 
 
 
 
 
 
 
 
 
 
 
 
 






# 1 "/SYS/include/sched.h" 1 3
 























 





 
# 1 "/SYS/include/bits/sched.h" 1 3
 


























 





 











 
struct sched_param
  {
    int __sched_priority;
  };

 

 

extern int clone (int (*__fn) (void *__arg), void *__child_stack,
		  int __flags, void *__arg)  ;


 



# 73 "/SYS/include/bits/sched.h" 3

# 32 "/SYS/include/sched.h" 2 3

 



 

 
extern int sched_setparam (__pid_t __pid, __const struct sched_param *__param)
      ;

 
extern int sched_getparam (__pid_t __pid, struct sched_param *__param)  ;

 
extern int sched_setscheduler (__pid_t __pid, int __policy,
			       __const struct sched_param *__param)  ;

 
extern int sched_getscheduler (__pid_t __pid)  ;

 
extern int sched_yield (void)  ;

 
extern int sched_get_priority_max (int __algorithm)  ;

 
extern int sched_get_priority_min (int __algorithm)  ;

 
extern int sched_rr_get_interval (__pid_t __pid, struct timespec *__t)  ;

 


# 20 "/SYS/include/pthread.h" 2 3




# 1 "/SYS/include/signal.h" 1 3
 

















 











 

# 1 "/SYS/include/bits/sigset.h" 1 3
 


















# 33 "/SYS/include/bits/sigset.h" 3



 





# 125 "/SYS/include/bits/sigset.h" 3

# 33 "/SYS/include/signal.h" 2 3


 

















# 369 "/SYS/include/signal.h" 3


 


# 24 "/SYS/include/pthread.h" 2 3

# 1 "/SYS/include/bits/pthreadtypes.h" 1 3
 
 
 
 
 
 
 
 
 
 
 
 
 





# 144 "/SYS/include/bits/pthreadtypes.h" 3

# 25 "/SYS/include/pthread.h" 2 3

# 1 "/SYS/include/bits/initspin.h" 1 3
 


















 




 


# 26 "/SYS/include/pthread.h" 2 3



 

 

























 

enum
{
  PTHREAD_CREATE_JOINABLE,

  PTHREAD_CREATE_DETACHED

};

enum
{
  PTHREAD_INHERIT_SCHED,

  PTHREAD_EXPLICIT_SCHED

};

enum
{
  PTHREAD_SCOPE_SYSTEM,

  PTHREAD_SCOPE_PROCESS

};

enum
{
  PTHREAD_MUTEX_TIMED_NP,
  PTHREAD_MUTEX_RECURSIVE_NP,
  PTHREAD_MUTEX_ERRORCHECK_NP,
  PTHREAD_MUTEX_ADAPTIVE_NP











};

enum
{
  PTHREAD_PROCESS_PRIVATE,

  PTHREAD_PROCESS_SHARED

};

# 118 "/SYS/include/pthread.h" 3




 






 

struct _pthread_cleanup_buffer
{
  void (*__routine) (void *);		   
  void *__arg;				   
  int __canceltype;			   
  struct _pthread_cleanup_buffer *__prev;  
};

 

enum
{
  PTHREAD_CANCEL_ENABLE,

  PTHREAD_CANCEL_DISABLE

};
enum
{
  PTHREAD_CANCEL_DEFERRED,

  PTHREAD_CANCEL_ASYNCHRONOUS

};



 

 


extern int pthread_create (pthread_t * ,
			   __const pthread_attr_t * __attr,
			   void *(*__start_routine) (void *),
			   void * __arg)  ;

 
extern pthread_t pthread_self (void)  ;

 
extern int pthread_equal (pthread_t __thread1, pthread_t __thread2)  ;

 
extern void pthread_exit (void *__retval)
       __attribute__ ((__noreturn__));

 


extern int pthread_join (pthread_t __th, void **__thread_return)  ;

 



extern int pthread_detach (pthread_t __th)  ;


 

 


extern int pthread_attr_init (pthread_attr_t *__attr)  ;

 
extern int pthread_attr_destroy (pthread_attr_t *__attr)  ;

 
extern int pthread_attr_setdetachstate (pthread_attr_t *__attr,
					int __detachstate)  ;

 
extern int pthread_attr_getdetachstate (__const pthread_attr_t *__attr,
					int *__detachstate)  ;

 
extern int pthread_attr_setschedparam (pthread_attr_t * __attr,
				       __const struct sched_param *
				       __param)  ;

 
extern int pthread_attr_getschedparam (__const pthread_attr_t *
				       __attr,
				       struct sched_param * __param)
      ;

 
extern int pthread_attr_setschedpolicy (pthread_attr_t *__attr, int __policy)
      ;

 
extern int pthread_attr_getschedpolicy (__const pthread_attr_t *
					__attr, int * __policy)
      ;

 
extern int pthread_attr_setinheritsched (pthread_attr_t *__attr,
					 int __inherit)  ;

 
extern int pthread_attr_getinheritsched (__const pthread_attr_t *
					 __attr, int * __inherit)
      ;

 
extern int pthread_attr_setscope (pthread_attr_t *__attr, int __scope)
      ;

 
extern int pthread_attr_getscope (__const pthread_attr_t * __attr,
				  int * __scope)  ;

# 254 "/SYS/include/pthread.h" 3


 



extern int pthread_attr_setstackaddr (pthread_attr_t *__attr,
				      void *__stackaddr)  ;

 
extern int pthread_attr_getstackaddr (__const pthread_attr_t *
				      __attr, void ** __stackaddr)
      ;

# 279 "/SYS/include/pthread.h" 3


 


extern int pthread_attr_setstacksize (pthread_attr_t *__attr,
				      size_t __stacksize)  ;

 
extern int pthread_attr_getstacksize (__const pthread_attr_t *
				      __attr, size_t * __stacksize)
      ;






 

 

extern int pthread_setschedparam (pthread_t __target_thread, int __policy,
				  __const struct sched_param *__param)
      ;

 
extern int pthread_getschedparam (pthread_t __target_thread,
				  int * __policy,
				  struct sched_param * __param)
      ;

















 

 

extern int pthread_mutex_init (pthread_mutex_t * __mutex,
			       __const pthread_mutexattr_t *
			       __mutex_attr)  ;

 
extern int pthread_mutex_destroy (pthread_mutex_t *__mutex)  ;

 
extern int pthread_mutex_trylock (pthread_mutex_t *__mutex)  ;

 
extern int pthread_mutex_lock (pthread_mutex_t *__mutex)  ;








 
extern int pthread_mutex_unlock (pthread_mutex_t *__mutex)  ;


 

 

extern int pthread_mutexattr_init (pthread_mutexattr_t *__attr)  ;

 
extern int pthread_mutexattr_destroy (pthread_mutexattr_t *__attr)  ;

 
extern int pthread_mutexattr_getpshared (__const pthread_mutexattr_t *
					  __attr,
					 int * __pshared)  ;

 
extern int pthread_mutexattr_setpshared (pthread_mutexattr_t *__attr,
					 int __pshared)  ;

# 383 "/SYS/include/pthread.h" 3



 

 

extern int pthread_cond_init (pthread_cond_t * __cond,
			      __const pthread_condattr_t *
			      __cond_attr)  ;

 
extern int pthread_cond_destroy (pthread_cond_t *__cond)  ;

 
extern int pthread_cond_signal (pthread_cond_t *__cond)  ;

 
extern int pthread_cond_broadcast (pthread_cond_t *__cond)  ;

 

extern int pthread_cond_wait (pthread_cond_t * __cond,
			      pthread_mutex_t * __mutex)  ;

 



extern int pthread_cond_timedwait (pthread_cond_t * __cond,
				   pthread_mutex_t * __mutex,
				   __const struct timespec *
				   __abstime)  ;

 

 
extern int pthread_condattr_init (pthread_condattr_t *__attr)  ;

 
extern int pthread_condattr_destroy (pthread_condattr_t *__attr)  ;

 
extern int pthread_condattr_getpshared (__const pthread_condattr_t *
					 __attr,
					int * __pshared)  ;

 
extern int pthread_condattr_setpshared (pthread_condattr_t *__attr,
					int __pshared)  ;


# 501 "/SYS/include/pthread.h" 3


# 545 "/SYS/include/pthread.h" 3



 

 





extern int pthread_key_create (pthread_key_t *__key,
			       void (*__destr_function) (void *))  ;

 
extern int pthread_key_delete (pthread_key_t __key)  ;

 
extern int pthread_setspecific (pthread_key_t __key,
				__const void *__pointer)  ;

 
extern void *pthread_getspecific (pthread_key_t __key)  ;


 

 



extern int pthread_once (pthread_once_t *__once_control,
			 void (*__init_routine) (void))  ;


 

 

extern int pthread_setcancelstate (int __state, int *__oldstate)  ;

 

extern int pthread_setcanceltype (int __type, int *__oldtype)  ;

 
extern int pthread_cancel (pthread_t )  ;

 


extern void pthread_testcancel (void)  ;


 










extern void _pthread_cleanup_push (struct _pthread_cleanup_buffer *__buffer,
				   void (*__routine) (void *),
				   void *__arg)  ;

 





extern void _pthread_cleanup_pop (struct _pthread_cleanup_buffer *__buffer,
				  int __execute)  ;

 


# 644 "/SYS/include/pthread.h" 3










 
# 1 "/SYS/include/bits/sigthread.h" 1 3
 

























 

 

extern int pthread_sigmask (int __how,
			    __const __sigset_t * __newmask,
			    __sigset_t * __oldmask) ;

 
extern int pthread_kill (pthread_t , int __signo)  ;


# 655 "/SYS/include/pthread.h" 2 3



 

 










extern int pthread_atfork (void (*__prepare) (void),
			   void (*__parent) (void),
			   void (*__child) (void))  ;

 


extern void pthread_kill_other_threads_np (void)  ;

 


# 33 "engine.c" 2

# 1 "/SYS/include/semaphore.h" 1 3
 
 
 
 
 
 
 
 
 
 
 
 
 

















 
typedef struct
{
  struct _pthread_fastlock __sem_lock;
  int __sem_value;
  _pthread_descr __sem_waiting;
} sem_t;



 


 



 

 

extern int sem_init (sem_t *__sem, int __pshared, unsigned int __value)  ;

 
extern int sem_destroy (sem_t *__sem)  ;

 
extern sem_t *sem_open (__const char *__name, int __oflag, ...)  ;

 
extern int sem_close (sem_t *__sem)  ;

 
extern int sem_unlink (__const char *__name)  ;

 
extern int sem_wait (sem_t *__sem)  ;








 
extern int sem_trywait (sem_t *__sem)  ;

 
extern int sem_post (sem_t *__sem)  ;

 
extern int sem_getvalue (sem_t * __sem, int * __sval)
      ;

 


# 34 "engine.c" 2





# 1 "engine.h" 1
 




















 




# 1 "ttt.h" 1
 




















 





# 1 "engine.h" 1
 




















 

# 52 "engine.h"

# 28 "ttt.h" 2

# 1 "board.h" 1
 























typedef char bool;










typedef struct _Board {
  struct _Board *(*copy) (const struct _Board *);  
  void (*setup) (struct _Board *, int, int, int);
  void (*display) (struct _Board *);  
  int (*eval) (struct _Board *);
  void (*score) (struct _Board *, int *, int *);  
  bool (*full) (struct _Board *);      
  int (*winner) (struct _Board *);     
  			 
  bool (*valid_move) (struct _Board *, int);  
  bool (*move) (struct _Board *, int, int);   
  void (*unmove) (struct _Board *);           
  int (*getmove) (struct _Board *, int, 
                int *, int *);  
  void (*help) (void);      
  char (*symbol) (struct _Board *, int, int);   
  void (*coords) (struct _Board *, int, char *);  
  int rows, cols;    
  int squares;	     
  int *moves;  
  int nummoves;  
  int X_player;      
  int *board;       
  int **points;	 
  int numpoints;
  int depth, depth2;   
  int *center;  
} Board;


# 29 "ttt.h" 2



typedef struct {
  Board b;
   



























  int *center;  
} TTT;


Board *ttt_new (int, int, int);
Board *ttt_copy (const Board *);
void ttt_setup (Board *, int, int, int);
void ttt_display (Board *);
int ttt_eval_3 (Board *);
int ttt_eval_5 (Board *);
int ttt_eval_default (Board *);
void ttt_score (Board *, int *, int *);
inline bool ttt_full (Board *);
int ttt_winner (Board *);
bool ttt_valid_move (Board *, int);
bool ttt_move (Board *, int, int);
void ttt_unmove (Board *);
int ttt_getmove (Board *, int, int *, int *);
void ttt_help (void);
char ttt_symbol (Board *, int, int);
void ttt_coords (Board *, int, char *);
inline int ttt_incrvalue (int, int, int, int, int);





# 27 "engine.h" 2





typedef struct {
  Board *b;
  int player;
  int depth;
  bool showthink;
  int *next_pos;
  int *best_value;
  int *ret_val;
  int *ret_pos;
} move_args;


 
void make_move_threads (Board *, int, int, int,	bool, int, int *);
void make_move (Board *, int, int, int, int *, int *);
int make_move_rec (Board *, int, int, int);

void *make_move_worker (void *);



# 39 "engine.c" 2


# 1 "util.h" 1
 




















 




struct Board;

 
int uttt_main (Board *, bool, bool, int, int);

 
void cmdline_help(char *);

 
void usage(char *);

 
void version(char *);

 
void get_setup (int, int *, int *, int *, int *);

 
void setup_help (int, int);

 
void sig_handler (int);

 
void pos2coords (int, int, int *, int *);


# 41 "engine.c" 2




 
static int *get_random_moves (Board *, int, int);
static int *get_moves_seq (Board *, int, int);


 










 
static sem_t sem_ready, sem_done;





 


void make_move_threads (Board *b, int player, int depth, int parent_value,
			bool showthink, int np, int *pos)
{
  int i, e;
  move_args *args;
  int best_value;
  pthread_t *threads;
  pthread_attr_t attr;
  int position;
  int value;
  int next;
  int *moves;

  srand (time(((void *)0) ));

  best_value = (player == 1 ? - 100000000  : 100000000 );

  args = (move_args *) malloc (np * sizeof(move_args));
  threads = (pthread_t *) malloc (np * sizeof(pthread_t));

  pthread_attr_init (&attr);
  pthread_attr_setscope (&attr, PTHREAD_SCOPE_SYSTEM );

  sem_init (&sem_done, 0, 1);  
  sem_init (&sem_ready, 0, 0);

   
  for (i = 0; i < np; i++) {
    args[i].b = b->copy (b);
    args[i].player = player;
    args[i].depth = depth;
    args[i].showthink = showthink;
    args[i].next_pos = &next;
    args[i].best_value = &best_value;
    args[i].ret_val = &value;
    args[i].ret_pos = &position;
    
    if ((e = pthread_create (&threads[i], &attr, 
			     make_move_worker, &args[i])) != 0)
      fprintf (stderr , "pthread_create returned %d\n", e);
  }

   
  moves = get_random_moves (b, depth, player);

  for (i = 0; moves[i] != -1 && i < b->squares; i++) {
    next = moves[i];
    sem_wait (&sem_done);
    sem_post (&sem_ready);  
     
    sem_wait (&sem_done);
    sem_post (&sem_done);  

     
    if ((player == 1 && value > best_value) ||
	(player == -1 && value < best_value)) {
      *pos = position;
      best_value = value;
    }
  }

   

  next = -1;
  for (i = 0; i < np; i++) {
    sem_wait (&sem_done);
    sem_post (&sem_ready);  
     
    sem_wait (&sem_done);
    sem_post (&sem_done);  

     
    if ((player == 1 && value > best_value) ||
	(player == -1 && value < best_value)) {
      *pos = position;
      best_value = value;
    }
  }

   
  for (i = 0; i < np; i++) {
    pthread_join (threads[i], ((void *)0) );
  }

  free (moves);
  free (threads);
  free (args);
  sem_destroy (&sem_ready);
  sem_destroy (&sem_done);
}


 
void *make_move_worker (void *argsp)
{
  move_args *args = (move_args *)argsp;
  Board *b = args->b;
  int player = args->player;
  int depth = args->depth;
  int showthink = args->showthink;
  int *ret_val = args->ret_val;
  int *ret_pos = args->ret_pos;

  char coords[4];
  int next_pos = 0;
  int best_pos = -1;
  int best_value = (player == 1 ? - 100000000  : 100000000 );
  int this_value = best_value;

  while (1 ) {
    sem_wait (&sem_ready);       
     
    next_pos = *args->next_pos;  
    best_value = *args->best_value;
    *ret_val = this_value;
    *ret_pos = best_pos;
     
    sem_post (&sem_done);        
    if (next_pos == -1)
       
      break;

     
    b->move (b, player, next_pos);
    this_value = make_move_rec (b, -player, depth-1, best_value);

    if ((player == 1 && this_value > best_value) || 
	(player == -1 && this_value < best_value))
    {
      best_pos = next_pos;
      best_value = this_value;
    }
    b->unmove(b);
    if (showthink) {
      b->coords (b, next_pos, coords);
      printf ("Finished analyzing position %s, value = %d\n", 
	      coords, this_value);
    }
  }

  pthread_exit(((void *)0) );
  return ((void *)0) ;
}


# 297 "engine.c"




 





int make_move_rec (Board *b, int player, int depth, int parent_value)
{
  int i, 
    best_value, value = 0;
  int val = 100000000 ;
  int squares = b->squares;
  int *moves = ((void *)0) ;
  int move;

  best_value = (player == 1 ? - 100000000  : 100000000 );
  
  if (depth == 0 || b->full(b))
    return b->eval(b);
  if ((val = b->winner(b)))
    return (val == 1 ? 1000000  : - 1000000 );

  if (depth > 2 )
    moves = get_moves_seq (b, depth, player);

  for (i = 0; i < squares; i++) {
    if (moves)
      move = moves[i];
    else
      move = i;
    if (b->valid_move (b, move)) {
      b->move (b, player, move);

       




      value = make_move_rec(b, -player, depth-1, best_value);

      if (player == 1) {
	 

	if (value >= parent_value) {
	  b->unmove(b);
	  if (moves) free (moves);
	  return value;
	}
	if (value > best_value) {
	  best_value = value;
	}
      } else {
	if (value <= parent_value) {
	  b->unmove(b);
	  if (moves) free (moves);
	  return value;
	}
	if (value < best_value) {
	  best_value = value;
	}
      }
      b->unmove(b);
    }
  }

  if (moves) free (moves);
  return best_value;
}


 

static int *get_random_moves (Board *b, int depth, int player)
{
  int i, j, nummoves;
  int *moves = (int *) malloc (b->squares * sizeof(int));
  int *values = (int *) malloc (b->squares * sizeof(int));
  int best_value = (player == 1 ? - 100000000  : 100000000 );
   
  int *buffy = (int *) malloc (b->squares * sizeof(int));
  int *spike = (int *) malloc (b->squares * sizeof(int));

  for (i = 0, nummoves = 0; i < b->squares; i++) {
    if (b->valid_move (b, i)) {
      buffy[nummoves] = i;
      nummoves++;
      b->move (b, player, i);
      if (depth >= 3)
	values[i] = make_move_rec (b, -player, depth-3, best_value);
      else
	values[i] = b->eval(b);
      b->unmove (b);
    }
  }

   
   
   







  for (i = 0; i < nummoves; i++)
    spike[i] = buffy[i];
   
  for (i = 0; i < nummoves; i++) {
    int loc = 0, val = best_value;
    for (j = 0; j < nummoves; j++) {
      if ((player == 1 && values[spike[j]] > val) ||
	  (player == -1 && values[spike[j]] < val)) {
	val = values[spike[j]];
	loc = j;
      }
    }
    moves[i] = spike[loc];
    values[spike[loc]] = best_value;
  }

   
  for (i = nummoves; i < b->squares; i++)
    moves[i] = -1;

  free (buffy);
  free (spike);
  free (values);
  return moves;
}


 
static int *get_moves_seq (Board *b, int depth, int player)
{
  int i, j, nummoves;
   
  int *moves = (int *) malloc (b->squares * sizeof(int));
  int *values = (int *) malloc (b->squares * sizeof(int));
  int best_value = (player == 1 ? - 100000000  : 100000000 );
   
  int *buffy = (int *) malloc (b->squares * sizeof(int));

  for (i = 0, nummoves = 0; i < b->squares; i++) {
    if (b->valid_move (b, i)) {
      buffy[nummoves] = i;
      b->move (b, player, i);
       




      values[nummoves] = b->eval (b);
      b->unmove (b);
      nummoves++;
    }
  }

   
  if (player == 1) {
     

    for (i = 0; i < nummoves; i++) {
      int loc = 0, val = best_value;
      for (j = 0; j < nummoves; j++) {
	if (values[j] > val) {
	  val = values[j];
	  loc = j;
	}
      }
      moves[i] = buffy[loc];
      values[loc] = best_value;
    }
  } else {  
    for (i = 0; i < nummoves; i++) {
      int loc = 0, val = best_value;
      for (j = 0; j < nummoves; j++) {
	if (values[j] < val) {
	  val = values[j];
	  loc = j;
	}
      }
      moves[i] = buffy[loc];
      values[loc] = best_value;
    }
  }

   
  for (i = nummoves; i < b->squares; i++)
    moves[i] = -1;

  free (buffy);
  free (values);
  return moves;
}
