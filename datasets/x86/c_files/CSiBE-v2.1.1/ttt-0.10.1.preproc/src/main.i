# 1 "main.c"
 




















 



# 1 "../config.h" 1
 
 

 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 


 


 


 
 
# 26 "main.c" 2


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










 





 




# 28 "main.c" 2

# 1 "/SYS/include/sys/time.h" 1 3
 
























# 1 "/SYS/include/time.h" 1 3
 

















 














# 51 "/SYS/include/time.h" 3


# 61 "/SYS/include/time.h" 3








 
typedef __time_t time_t;




# 84 "/SYS/include/time.h" 3



# 96 "/SYS/include/time.h" 3




# 112 "/SYS/include/time.h" 3




# 364 "/SYS/include/time.h" 3



# 26 "/SYS/include/sys/time.h" 2 3


# 1 "/SYS/include/bits/time.h" 1 3
 


















 



# 57 "/SYS/include/bits/time.h" 3








 

struct timeval
  {
    __time_t tv_sec;		 
    __suseconds_t tv_usec;	 
  };


# 28 "/SYS/include/sys/time.h" 2 3


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




# 72 "/SYS/include/bits/time.h" 3


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


 


# 30 "/SYS/include/sys/time.h" 2 3








 

# 50 "/SYS/include/sys/time.h" 3




 

struct timezone
  {
    int tz_minuteswest;		 
    int tz_dsttime;		 
  };

typedef struct timezone * __timezone_ptr_t;




 




extern int gettimeofday (struct timeval * __tv,
			 __timezone_ptr_t __tz)  ;


 

extern int settimeofday (__const struct timeval *__tv,
			 __const struct timezone *__tz)  ;

 



extern int adjtime (__const struct timeval *__delta,
		    struct timeval *__olddelta)  ;



 
enum __itimer_which
  {
     
    ITIMER_REAL = 0,

     
    ITIMER_VIRTUAL = 1,

     

    ITIMER_PROF = 2

  };

 

struct itimerval
  {
     
    struct timeval it_interval;
     
    struct timeval it_value;
  };






typedef int __itimer_which_t;


 

extern int getitimer (__itimer_which_t __which,
		      struct itimerval *__value)  ;

 


extern int setitimer (__itimer_which_t __which,
		      __const struct itimerval * __new,
		      struct itimerval * __old)  ;

 

extern int utimes (__const char *__file, __const struct timeval __tvp[2])
      ;



 








# 160 "/SYS/include/sys/time.h" 3

# 169 "/SYS/include/sys/time.h" 3


 


# 29 "main.c" 2

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



 


# 30 "main.c" 2

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



 


# 31 "main.c" 2




# 1 "connect4.h" 1
 




















 





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





# 35 "main.c" 2



# 1 "parse.h" 1
 




















 





 









 
void parse_cmdline (int, char **, bool *, 
		    bool *, int *, int *,
		    int *, int *);
 
int parse_command (char *, char, char, int, int,
		   int *, int *);



# 38 "main.c" 2

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


# 39 "main.c" 2



int
uttt_main (Board *B, bool beep, bool showthink, 
	   int players, int num_threads)
{
  int X,      
              
    turn,     
    winner,   
    coord[3]; 
  struct timeval start, end;
  double overhead=0, totaltime;
  int MyPE = 0;
  char coords[4];







  if (MyPE == 0) {
    gettimeofday (&start, ((void *)0) );
    gettimeofday (&end, ((void *)0) );
    overhead = (end.tv_sec - start.tv_sec) * 1000000.0 +
      (end.tv_usec - start.tv_usec);
  }

  X = turn = B->X_player;   

  if (MyPE == 0 && players == 2) B->display(B);

  while (!B->full(B) && !B->winner(B))  
  {                                     
    switch (turn)
    {
      case 1:       
	if (players <= 1)
	{
	  if (MyPE == 0)
	    gettimeofday (&start, ((void *)0) );
	  
	  make_move_threads (B, 1, B->depth, 1000000 *10, showthink,
			     num_threads, &coord[0]);
	  B->coords (B, coord[0], coords);

	  if (MyPE == 0) {
	    gettimeofday (&end, ((void *)0) );
	    totaltime = (end.tv_sec - start.tv_sec) * 1000000.0 +
	      (end.tv_usec - start.tv_usec) - overhead;
	    if (beep) printf ("\a");
	    printf ("Computer places at %s\n", 
		    coords);
	    printf ("Move made in %g seconds\n", totaltime/1000000.0);
	  }
	  B->move (B, 1, coord[0]);
	  if (!players)
	    B->display(B);
	}
	else
	{
	  if (MyPE == 0)
	    coord[2] = B->getmove (B, 1, &coord[0], &coord[1]);



	  if (coord[2] == 1)  
	  {



	    return 0;
	  }
	  B->move (B, 1, coord[0]*B->rows + coord[1]);
	}
	break;

      case -1:      
      default:
	if (players >= 1) 
	{
	  if (MyPE == 0) {
	    B->display(B);
	    coord[2] = B->getmove (B, -1, &coord[0], &coord[1]);
	  }



	  if (coord[2] == 1)  
	  {



	    return 0;
	  }
	  B->move (B, -1, coord[0] * B->rows + coord[1]);
	  if (MyPE == 0)
	    B->display(B);
	}
	else  
	{
	  if (MyPE == 0)
	    gettimeofday (&start, ((void *)0) );
	  
	  make_move_threads (B, -1, B->depth2, 1000000 *10, showthink,
			     num_threads, &coord[0]);
	  B->coords (B, coord[0], coords);

	  if (MyPE == 0) {
	    gettimeofday (&end, ((void *)0) );
	    totaltime = (end.tv_sec - start.tv_sec) * 1000000.0 +
	      (end.tv_usec - start.tv_usec) - overhead;
	    if (beep) printf ("\a");
	    printf ("Computer places at %s\n", 
		    coords);
	    printf ("Move made in %g sec\n", totaltime/1000000.0);
	  }
	  B->move (B, -1, coord[0]);
	  if (MyPE == 0) B->display(B);

	} 
        break;
    }

    turn *= -1;     
  }
  if (MyPE == 0) {
    B->display(B);
    if ((winner = B->winner(B)))  
      printf ("%c has won!\n", (winner == X ? 'X' : 'O'));
    else                        
    {
      if (B->score)
      {
	int xpoints, opoints;
	B->score(B, &xpoints, &opoints);  
	printf ("X: %d point%s  ---  O: %d point%s\n", 
		xpoints, xpoints == 1 ? "" : "s", 
		opoints, opoints == 1 ? "" : "s");
	if (xpoints > opoints)
	  printf ("X has won by %d point%s!\n",
		  xpoints-opoints, (xpoints-opoints == 1 ? "" : "s"));
	else if (opoints > xpoints)
	  printf ("O has won by %d point%s!\n",
		  opoints-xpoints, (opoints-xpoints == 1 ? "" : "s"));
	else
	  printf ("Draw\n");
      }
      else
	printf ("Draw\n");
    }
  }



  return 0;
}
