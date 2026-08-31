# 1 "connect4.c"
 




















 



# 1 "../config.h" 1
 
 

 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 


 


 


 
 
# 26 "connect4.c" 2


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










 





 




# 28 "connect4.c" 2

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





 


# 29 "connect4.c" 2

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



 
extern void *memcpy (void * __dest,
		     __const void * __src, size_t __n)  ;
 

extern void *memmove (void *__dest, __const void *__src, size_t __n)
      ;

 



extern void *memccpy (void * __dest, __const void * __src,
		      int __c, size_t __n)
      ;



 
extern void *memset (void *__s, int __c, size_t __n)  ;

 
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
        ;

 
extern void *memchr (__const void *__s, int __c, size_t __n)
         ;

# 73 "/SYS/include/string.h" 3



 
extern char *strcpy (char * __dest, __const char * __src)
      ;
 
extern char *strncpy (char * __dest,
		      __const char * __src, size_t __n)  ;

 
extern char *strcat (char * __dest, __const char * __src)
      ;
 
extern char *strncat (char * __dest, __const char * __src,
		      size_t __n)  ;

 
extern int strcmp (__const char *__s1, __const char *__s2)
        ;
 
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
        ;

 
extern int strcoll (__const char *__s1, __const char *__s2)
        ;
 
extern size_t strxfrm (char * __dest,
		       __const char * __src, size_t __n)  ;

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







 
extern char *strtok (char * __s, __const char * __delim)
      ;

 

extern char *__strtok_r (char * __s,
			 __const char * __delim,
			 char ** __save_ptr)  ;

extern char *strtok_r (char * __s, __const char * __delim,
		       char ** __save_ptr)  ;


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



 

extern char *strsep (char ** __stringp,
		     __const char * __delim)  ;


# 332 "/SYS/include/string.h" 3




# 361 "/SYS/include/string.h" 3



 


# 30 "connect4.c" 2

# 1 "/SYS/include/signal.h" 1 3
 

















 











 

# 1 "/SYS/include/bits/sigset.h" 1 3
 


















# 33 "/SYS/include/bits/sigset.h" 3



 












 



 














# 97 "/SYS/include/bits/sigset.h" 3



 


extern int __sigismember (__const __sigset_t *, int);
extern int __sigaddset (__sigset_t *, int);
extern int __sigdelset (__sigset_t *, int);

# 122 "/SYS/include/bits/sigset.h" 3




# 33 "/SYS/include/signal.h" 2 3


 




typedef __sig_atomic_t sig_atomic_t;















# 1 "/SYS/include/bits/signum.h" 1 3
 




















 









 










































 





# 56 "/SYS/include/signal.h" 2 3


# 67 "/SYS/include/signal.h" 3



 
typedef void (*__sighandler_t) (int);

 


extern __sighandler_t __sysv_signal (int __sig, __sighandler_t __handler)
      ;





 



extern __sighandler_t signal (int __sig, __sighandler_t __handler)  ;
# 98 "/SYS/include/signal.h" 3








 



extern int kill (__pid_t __pid, int __sig)  ;



 


extern int killpg (__pid_t __pgrp, int __sig)  ;


 
extern int raise (int __sig)  ;


 
extern __sighandler_t ssignal (int __sig, __sighandler_t __handler)  ;
extern int gsignal (int __sig)  ;



 
extern void psignal (int __sig, __const char *__s)  ;



 




extern int __sigpause (int __sig_or_mask, int __is_sig)  ;


 

extern int sigpause (int __mask)  ;

# 155 "/SYS/include/signal.h" 3




 




 


 
extern int sigblock (int __mask)  ;

 
extern int sigsetmask (int __mask)  ;

 
extern int siggetmask (void)  ;











 

typedef __sighandler_t sig_t;





 

# 1 "/SYS/include/time.h" 1 3
 

















 














# 51 "/SYS/include/time.h" 3


# 61 "/SYS/include/time.h" 3



# 72 "/SYS/include/time.h" 3



# 84 "/SYS/include/time.h" 3



# 96 "/SYS/include/time.h" 3




# 112 "/SYS/include/time.h" 3




# 364 "/SYS/include/time.h" 3



# 196 "/SYS/include/signal.h" 2 3


 
# 1 "/SYS/include/bits/siginfo.h" 1 3
 























# 1 "/SYS/include/bits/wordsize.h" 1 3
 


















# 25 "/SYS/include/bits/siginfo.h" 2 3







 
typedef union sigval
  {
    int sival_int;
    void *sival_ptr;
  } sigval_t;













typedef struct siginfo
  {
    int si_signo;		 
    int si_errno;		 

    int si_code;		 

    union
      {
	int _pad[((128  / sizeof (int)) - 3) ];

	  
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	  } _kill;

	 
	struct
	  {
	    unsigned int _timer1;
	    unsigned int _timer2;
	  } _timer;

	 
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	    sigval_t si_sigval;	 
	  } _rt;

	 
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	    int si_status;	 
	    __clock_t si_utime;
	    __clock_t si_stime;
	  } _sigchld;

	 
	struct
	  {
	    void *si_addr;	 
	  } _sigfault;

	 
	struct
	  {
	    long int si_band;	 
	    int si_fd;
	  } _sigpoll;
      } _sifields;
  } siginfo_t;


 















 

enum
{
  SI_ASYNCNL = -6,		 

  SI_SIGIO,			 

  SI_ASYNCIO,			 

  SI_MESGQ,			 

  SI_TIMER,			 

  SI_QUEUE,			 

  SI_USER,			 

  SI_KERNEL = 0x80		 

};


 
enum
{
  ILL_ILLOPC = 1,		 

  ILL_ILLOPN,			 

  ILL_ILLADR,			 

  ILL_ILLTRP,			 

  ILL_PRVOPC,			 

  ILL_PRVREG,			 

  ILL_COPROC,			 

  ILL_BADSTK			 

};

 
enum
{
  FPE_INTDIV = 1,		 

  FPE_INTOVF,			 

  FPE_FLTDIV,			 

  FPE_FLTOVF,			 

  FPE_FLTUND,			 

  FPE_FLTRES,			 

  FPE_FLTINV,			 

  FPE_FLTSUB			 

};

 
enum
{
  SEGV_MAPERR = 1,		 

  SEGV_ACCERR			 

};

 
enum
{
  BUS_ADRALN = 1,		 

  BUS_ADRERR,			 

  BUS_OBJERR			 

};

 
enum
{
  TRAP_BRKPT = 1,		 

  TRAP_TRACE			 

};

 
enum
{
  CLD_EXITED = 1,		 

  CLD_KILLED,			 

  CLD_DUMPED,			 

  CLD_TRAPPED,			 

  CLD_STOPPED,			 

  CLD_CONTINUED			 

};

 
enum
{
  POLL_IN = 1,			 

  POLL_OUT,			 

  POLL_MSG,			 

  POLL_ERR,			 

  POLL_PRI,			 

  POLL_HUP			 

};









 







 
struct __pthread_attr_s;

typedef struct sigevent
  {
    sigval_t sigev_value;
    int sigev_signo;
    int sigev_notify;

    union
      {
	int _pad[((64  / sizeof (int)) - 3) ];

	struct
	  {
	    void (*_function) (sigval_t);	   
	    struct __pthread_attr_s *_attribute;   
	  } _sigev_thread;
      } _sigev_un;
  } sigevent_t;

 



 
enum
{
  SIGEV_SIGNAL = 0,		 

  SIGEV_NONE,			 

  SIGEV_THREAD			 

};


# 199 "/SYS/include/signal.h" 2 3



 
extern int sigemptyset (sigset_t *__set)  ;

 
extern int sigfillset (sigset_t *__set)  ;

 
extern int sigaddset (sigset_t *__set, int __signo)  ;

 
extern int sigdelset (sigset_t *__set, int __signo)  ;

 
extern int sigismember (__const sigset_t *__set, int __signo)  ;

# 228 "/SYS/include/signal.h" 3


 

# 1 "/SYS/include/bits/sigaction.h" 1 3
 






















 
struct sigaction
  {
     

    union
      {
	 
	__sighandler_t sa_handler;
	 
	void (*sa_sigaction) (int, siginfo_t *, void *);
      }
    __sigaction_handler;






     
    __sigset_t sa_mask;

     
    int sa_flags;

     
    void (*sa_restorer) (void);
  };

 














 





 



# 232 "/SYS/include/signal.h" 2 3


 
extern int sigprocmask (int __how, __const sigset_t * __set,
			sigset_t * __oset)  ;

 

extern int sigsuspend (__const sigset_t *__set)  ;

 
extern int sigaction (int __sig, __const struct sigaction * __act,
		      struct sigaction * __oact)  ;

 
extern int sigpending (sigset_t *__set)  ;


 
extern int sigwait (__const sigset_t * __set, int * __sig)
      ;


 
extern int sigwaitinfo (__const sigset_t * __set,
			siginfo_t * __info)  ;

 

extern int sigtimedwait (__const sigset_t * __set,
			 siginfo_t * __info,
			 __const struct timespec * __timeout)
      ;

 

extern int sigqueue (__pid_t __pid, int __sig, __const union sigval __val)
      ;






 

extern __const char *__const _sys_siglist[64 ];
extern __const char *__const sys_siglist[64 ];

 
struct sigvec
  {
    __sighandler_t sv_handler;	 
    int sv_mask;		 

    int sv_flags;		 

  };

 





 




extern int sigvec (int __sig, __const struct sigvec *__vec,
		   struct sigvec *__ovec)  ;


 
# 1 "/SYS/include/bits/sigcontext.h" 1 3
 






















 



# 1 "/SYS/include/asm/sigcontext.h" 1 3



 













struct _fpreg {
	unsigned short significand[4];
	unsigned short exponent;
};

struct _fpxreg {
	unsigned short significand[4];
	unsigned short exponent;
	unsigned short padding[3];
};

struct _xmmreg {
	unsigned long element[4];
};

struct _fpstate {
	 
	unsigned long 	cw;
	unsigned long	sw;
	unsigned long	tag;
	unsigned long	ipoff;
	unsigned long	cssel;
	unsigned long	dataoff;
	unsigned long	datasel;
	struct _fpreg	_st[8];
	unsigned short	status;
	unsigned short	magic;		 

	 
	unsigned long	_fxsr_env[6];	 
	unsigned long	mxcsr;
	unsigned long	reserved;
	struct _fpxreg	_fxsr_st[8];	 
	struct _xmmreg	_xmm[8];
	unsigned long	padding[56];
};



struct sigcontext {
	unsigned short gs, __gsh;
	unsigned short fs, __fsh;
	unsigned short es, __esh;
	unsigned short ds, __dsh;
	unsigned long edi;
	unsigned long esi;
	unsigned long ebp;
	unsigned long esp;
	unsigned long ebx;
	unsigned long edx;
	unsigned long ecx;
	unsigned long eax;
	unsigned long trapno;
	unsigned long err;
	unsigned long eip;
	unsigned short cs, __csh;
	unsigned long eflags;
	unsigned long esp_at_signal;
	unsigned short ss, __ssh;
	struct _fpstate * fpstate;
	unsigned long oldmask;
	unsigned long cr2;
};



# 28 "/SYS/include/bits/sigcontext.h" 2 3


# 307 "/SYS/include/signal.h" 2 3


 
extern int sigreturn (struct sigcontext *__scp)  ;






 


extern int siginterrupt (int __sig, int __interrupt)  ;

# 1 "/SYS/include/bits/sigstack.h" 1 3
 























 
struct sigstack
  {
    void *ss_sp;		 
    int ss_onstack;		 
  };


 
enum
{
  SS_ONSTACK = 1,

  SS_DISABLE

};

 


 



 
typedef struct sigaltstack
  {
    void *ss_sp;
    int ss_flags;
    size_t ss_size;
  } stack_t;
# 322 "/SYS/include/signal.h" 2 3





 


extern int sigstack (struct sigstack *__ss, struct sigstack *__oss)  ;

 

extern int sigaltstack (__const struct sigaltstack * __ss,
			struct sigaltstack * __oss)  ;



# 353 "/SYS/include/signal.h" 3



 

# 1 "/SYS/include/bits/sigthread.h" 1 3
 

























 

 

extern int pthread_sigmask (int __how,
			    __const __sigset_t * __newmask,
			    __sigset_t * __oldmask) ;

 
extern int pthread_kill (pthread_t , int __signo)  ;


# 358 "/SYS/include/signal.h" 2 3



 


 
extern int __libc_current_sigrtmin (void)  ;
 
extern int __libc_current_sigrtmax (void)  ;



 


# 31 "connect4.c" 2

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


 


# 32 "connect4.c" 2

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


# 33 "connect4.c" 2

# 1 "connect4.h" 1
 




















 





# 1 "engine.h" 1
 




















 




# 1 "ttt.h" 1
 




















 





# 1 "engine.h" 1
 




















 

# 52 "engine.h"

# 28 "ttt.h" 2




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



# 28 "connect4.h" 2




typedef struct {
  Board b;
   



























} CFOUR;


Board *c4_new (int, int, int);
Board *c4_copy (const Board *);
void c4_setup (Board *, int, int, int);
void c4_display (Board *);
int c4_eval (Board *);
inline bool c4_full (Board *);
int c4_winner (Board *);
bool c4_valid_move (Board *, int);
bool c4_move (Board *, int, int);
void c4_unmove (Board *);
int c4_getmove (Board *, int, int *, int *);
void c4_help (void);
char c4_symbol (Board *, int, int);
void c4_coords (Board *, int, char *);
inline int c4_incrvalue (int, int, int, int, int);





# 34 "connect4.c" 2

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


# 35 "connect4.c" 2

# 1 "parse.h" 1
 




















 





 









 
void parse_cmdline (int, char **, bool *, 
		    bool *, int *, int *,
		    int *, int *);
 
int parse_command (char *, char, char, int, int,
		   int *, int *);



# 36 "connect4.c" 2






 
int
main (int argc, char **argv)
{
  Board *B;
  bool beep, showthink;
  int players = 1, num_threads, size, depth;





  signal (2 , sig_handler);

  parse_cmdline (argc, argv, &beep, &showthink, &players, &num_threads,
		 &size, &depth);

   
  B = (Board *) c4_new (players, size, depth);

  return uttt_main (B, beep, showthink, players, num_threads);

}



 


Board *c4_new (int players, int size, int depth)
{
  Board *T = (Board *) malloc (sizeof (Board));
  Board *B = (Board *)T;
  int **points;
  int *board;
  int i, j, point = 0;
  int MyPE = 0;
  int rows, cols;






  B->copy = c4_copy;
  B->setup = c4_setup;
  B->display = c4_display;
  B->eval = c4_eval;
  B->full = c4_full;
  B->winner = c4_winner;
  B->valid_move = c4_valid_move;
  B->move = c4_move;
  B->unmove = c4_unmove;
  B->getmove = c4_getmove;
  B->help = c4_help;
  B->symbol = c4_symbol;
  B->coords = c4_coords;
  B->score = ((void *)0) ;

  rows = B->rows = 6;
  cols = B->cols = 7;
  B->squares = 7;  

   
  if (MyPE == 0)
    c4_setup ((Board *)T, players, depth, 0);






  B->board = (int *) malloc (rows*cols * sizeof(int));

  B->moves = (int *) malloc (rows*cols * sizeof(int));
  B->nummoves = 0;

  for (i = 0; i < rows*cols; i++)
    B->board[i] = B->moves[i] = 0;

  B->numpoints = rows*(cols-3) + cols*(rows-3) + 2*(rows-3)*(cols-3);
  points = (int **) malloc (B->numpoints * 4 * sizeof(int *));
  board = B->board;

   
  for (j = 0; j < rows - 3; j++) {
    for (i = 0; i < cols; i++, point++) {
      points[point*4+0] = board + i*rows + 0 + j;
      points[point*4+1] = board + i*rows + 1 + j;
      points[point*4+2] = board + i*rows + 2 + j;
      points[point*4+3] = board + i*rows + 3 + j;
    }
  }
  
   
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows; i++, point++) {
      points[point*4+0] = board + i + 0*rows + j*rows;
      points[point*4+1] = board + i + 1*rows + j*rows;
      points[point*4+2] = board + i + 2*rows + j*rows;
      points[point*4+3] = board + i + 3*rows + j*rows;
    }
  }

   
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows - 3; i++, point++) {
      points[point*4+0] = board + j*rows + i + 0*rows + 0;
      points[point*4+1] = board + j*rows + i + 1*rows + 1;
      points[point*4+2] = board + j*rows + i + 2*rows + 2;
      points[point*4+3] = board + j*rows + i + 3*rows + 3;
    }
  }
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows - 3; i++, point++) {
      points[point*4+0] = board + j*rows + i + 0*rows + 3;
      points[point*4+1] = board + j*rows + i + 1*rows + 2;
      points[point*4+2] = board + j*rows + i + 2*rows + 1;
      points[point*4+3] = board + j*rows + i + 3*rows + 0;
    }
  }

  B->points = points;

  return T;
}


 
Board *c4_copy (const Board *b)
{
  const Board *old = b;
  int i, j, point = 0;
  int **points;
  Board *T = (Board *) malloc (sizeof (Board));
  Board *B = (Board *)T;
  int *board;
  int rows = old->rows;
  int cols = old->cols;

  B->rows = old->rows;
  B->cols = old->cols;
  B->squares = old->squares;
  B->nummoves = old->nummoves;
  B->X_player = old->X_player;

  B->board = (int *) malloc (rows*cols * sizeof(int));
  B->moves = (int *) malloc (rows*cols * sizeof(int));

  B->copy = old->copy;
  B->setup = old->setup;
  B->display = old->display;
  B->eval = old->eval;
  B->full = old->full;
  B->winner = old->winner;
  B->valid_move = old->valid_move;
  B->move = old->move;
  B->unmove = old->unmove;
  B->getmove = old->getmove;
  B->help = old->help;
  B->symbol = old->symbol;
  B->coords = old->coords;

  for (i = 0; i < rows*cols; i++)
    B->board[i] = old->board[i];

  for (i = 0; i < B->nummoves; i++)
    B->moves[i] = old->moves[i];


  B->numpoints = rows*(cols-3) + cols*(rows-3) + 2*(rows-3)*(cols-3);
  points = (int **) malloc (B->numpoints * 4 * sizeof(int *));
  board = B->board;

   
  for (j = 0; j < rows - 3; j++) {
    for (i = 0; i < cols; i++, point++) {
      points[point*4+0] = board + i*rows + 0 + j;
      points[point*4+1] = board + i*rows + 1 + j;
      points[point*4+2] = board + i*rows + 2 + j;
      points[point*4+3] = board + i*rows + 3 + j;
    }
  }
  
   
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows; i++, point++) {
      points[point*4+0] = board + i + 0*rows + j*rows;
      points[point*4+1] = board + i + 1*rows + j*rows;
      points[point*4+2] = board + i + 2*rows + j*rows;
      points[point*4+3] = board + i + 3*rows + j*rows;
    }
  }

   
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows - 3; i++, point++) {
      points[point*4+0] = board + j*rows + i + 0*rows + 0;
      points[point*4+1] = board + j*rows + i + 1*rows + 1;
      points[point*4+2] = board + j*rows + i + 2*rows + 2;
      points[point*4+3] = board + j*rows + i + 3*rows + 3;
    }
  }
  for (j = 0; j < cols - 3; j++) {
    for (i = 0; i < rows - 3; i++, point++) {
      points[point*4+0] = board + j*rows + i + 0*rows + 3;
      points[point*4+1] = board + j*rows + i + 1*rows + 2;
      points[point*4+2] = board + j*rows + i + 2*rows + 1;
      points[point*4+3] = board + j*rows + i + 3*rows + 0;
    }
  }

  B->points = points;

  return (Board *)T;
}


 

void c4_setup (Board *B, int players, int depth, int dummy)
{
  Board *C = B;
  const int SIZE = 20;
  char *input = (char *) malloc (SIZE * sizeof(char));
  int input_i, depth1=0, i=0;
  int squares;

  printf ("Connect Four %s\n",
	  "0.10.1" );
  if (players == 1) 
  {
    printf ("Do you want to go first? (y/n/?) ");
    while (1 )
    {
      fgets (input, SIZE, stdin );
      if (input[0] == 'y' || input[0] == 'Y')
      {
	C->X_player = -1;   
	break;
      }
      else if (input[0] == 'n' || input[0] == 'N')
      {
	C->X_player = 1;    
	break;
      }
      else if (input[0] == '?')
	setup_help (1, 0);

      else
	printf ("Please enter \"y\" or \"n\", or \"?\" for help: ");
    }
  }
  else
    C->X_player = 1;

  squares = C->rows*C->cols;

  if (players == 1)
  {
    if (depth < 1 || depth > squares) {
    get_moves:
      printf ("How many moves of look-ahead? (1-%d/?) ", squares);
      while (1 )
      {
	fgets (input, SIZE, stdin );
	input_i = atoi (input);
	if (input_i >= 1 && input_i <= squares)
	{
	  C->depth = input_i;
	  break;
	}
	else if (strcmp (input, "?") == 0)
	  setup_help (3, squares);
	
	else
	  printf ("Please enter an integer from 1 to %d, or \"?\" for help: ",
		  squares);
      }
      if (players == 0) goto next;
    } else {
      C->depth = depth;
    }
  }
  else if (players == 0)
  {
    if (depth < 1 || depth > squares) {
      for (i = 0; i < 2; i++)
      {
	printf ("%c computer: ",
		i == 0 ? 'X' : 'O');
	goto get_moves;
      next:
	if (i == 0)
	  depth1 = C->depth;
	else
	  C->depth2 = C->depth;
      }
      C->depth = depth1;
    } else {
      C->depth = C->depth2 = depth;
    }
  }

  return;
}


 

void c4_display (Board *b)
{
  int i, j;
  char *line = (char *) malloc ((4*b->cols+5) * sizeof(char));

  sprintf (line, "  ");
  for (i = 0; i < b->cols; i++)
    strcat (line, "+---");
  strcat (line, "+");

  printf ("\n%s\n", line);

  for (i = b->rows-1; i >= 0; i--)
  {
    printf ("  |");
    for (j = 0; j < b->cols; j++)
      printf (" %c |", b->symbol(b, j, i));
    printf ("\n%s\n", line);
  }
  
  printf ("    ");
  for (i = 0; i < b->cols; i++)
  {
    int a = 'a' + i;
    printf ("%c   ", (char)a);
  }
  printf ("\n");

  return;
}



 






int c4_eval (Board *b)
{
  int value = 0;      		 
  register int i;                
  register int sum1, sum2;       
  				 
  int *board = b->board;
  int **points = b->points;
  
  sum1 = sum2 = 0;

  for (i = 0; i < b->numpoints; i++)
  {
    sum1 = *(points[i*4+0]) + *(points[i*4+1]) + 
      *(points[i*4+2]) + *(points[i*4+3]);
    if (sum1 > 2) {
      if (sum1 == 4)
	value += 10000 ;
      else
	value += 100 ;
    } else if (sum1 < -2) {
      if (sum1 == -4)
	value -= 10000 ;
      else
	value -= 100 ;
    }
  }

   
  if (board[18]) {
    value += 1 *(board[18]);
  }

  return value;
}



 

inline int c4_incrvalue (int sum1, int sum2, int n, int incr, int value)
{
  if (sum1 == n) value += incr;
  else if (sum1 == -n) value -= incr;
  if (sum2 == n) value += incr;
  else if (sum2 == -n) value -= incr;
  return value;
}




 

inline bool c4_full (Board *b)
{
  return (b->nummoves == b->rows*b->cols);
}



 

int c4_winner (Board *b)
{
  int val = c4_eval(b);
  return (val == 1000000  ? 1 : (val == - 1000000  ? -1 : 0));
}



 

bool c4_valid_move (Board *b, int pos)
{
  if (b->board[pos*6 + 5])
    return 0 ;

  if (pos >= 7)
    return 0 ;

  return 1 ;
}


 

bool c4_move (Board *b, int player, int pos)
{
  int i, start, end;
  start = pos*6;
  end = start + 6;
  for (i = start; i < end; i++) {
    if (b->board[i] == 0) {
      b->board[i] = player;
      b->moves[(b->nummoves)++] = i;
      return 1 ;
    }
  }
  return 0 ;
}


 

void c4_unmove (Board *b)
{
  b->board[b->moves[--(b->nummoves)]] = 0;
}


 




int c4_getmove (Board *b, int player, int *x, int *y)
{
  bool moved = 0 ;
  const int SIZE = 200;
  char *input;
  int cmd = 0;

  *y = -1;
  *x = 0;

  if (player != b->X_player && player != -b->X_player)
    return 0;     

  input = (char *) malloc (SIZE * sizeof(char));

  while (!moved)
  {
    printf ("%c player, input move> ",
	    (player == b->X_player ? 'X' : 'O'));

    *x = 0;
    *y = -1;
    fgets (input, SIZE, stdin );

    cmd = parse_command (input, 'a', 'a'+b->cols-1, 1, 1, x, y);
    if (cmd == 0 )
      continue;
    if (cmd == 1 ) {
      moved = c4_valid_move (b, (*x) * b->rows + (*y));
      if (!moved)                          
	fprintf (stderr , "Invalid move.\n");   
    } else if (cmd == 2 ) {
       
      switch (*x) {
      case 0 :
	c4_help();
	break;
      case 1 :
	c4_display(b);
	break;
      case 2 :
	printf ("Thanks for playing!\n");
	free (input);
	return 1; break;
      default:
	 
	break;
      }
      continue;
    }
  }
    
# 625 "connect4.c"


  free (input);
  return 0;
}


 
void c4_help (void)
{
  printf ("\nHelp for Connect Four:\n"
	  "To make a move, enter the letter or number of the row in "
	  "which you\n  wish to place a piece.  For example, to place a "
	  "piece in the center\n  row, type \"c\" or \"3\".\n"
	  "To redisplay the board, type \"r\".\n"
	  "To quit the game, type \"q\" or hit CTRL-C.\n"
	  "To display this help text, type \"?\" or \"h\".\n\n");
  return;
}


 

char c4_symbol (Board *b, int x, int y)
{
  int rows = b->rows;
  return b->board[x*rows+y] == b->X_player ? 'X' : 
           (b->board[x*rows+y] == -b->X_player ? 'O' :
	    ' ');
}


 

void c4_coords (Board *b, int pos, char *buf)
{
   
  sprintf (buf, "%c", (pos)+'a');
}
