# 1 "apps/shell.c"
 


































# 1 "/SYS/include/string.h" 1 3
 

















 






# 1 "/SYS/include/features.h" 1 3
 




















 






























































 




















 





 



 







 
# 142 "/SYS/include/features.h" 3


 









 








 



























# 208 "/SYS/include/features.h" 3


































 



 


 








 




 
















 


# 1 "/SYS/include/sys/cdefs.h" 1 3
 




















 




 






 





 








 



# 65 "/SYS/include/sys/cdefs.h" 3


 





 




 









 







 

















 















 







 






 








 








 








 











 










 







 




 


















# 283 "/SYS/include/features.h" 2 3



 








 





 

 








# 1 "/SYS/include/gnu/stubs.h" 1 3
 



















# 312 "/SYS/include/features.h" 2 3




# 26 "/SYS/include/string.h" 2 3


 

 


# 1 "/LIB/include/stddef.h" 1 3






 


# 19 "/LIB/include/stddef.h" 3



 


 





 


# 61 "/LIB/include/stddef.h" 3


 





 


















 





 

 

# 131 "/LIB/include/stddef.h" 3


 

 


































typedef unsigned int size_t;






















 




 

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



 


# 36 "apps/shell.c" 2

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










 





 




# 37 "apps/shell.c" 2


# 1 "../../src/include/lwip/mem.h" 1
 




































# 1 "../../src/include/lwip/debug.h" 1
 




































# 87 "../../src/include/lwip/debug.h"


 




 













































# 38 "../../src/include/lwip/mem.h" 2

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













# 39 "apps/shell.c" 2


# 1 "../../src/include/lwip/def.h" 1
 










































# 1 "../../src/arch/unix/include/arch/lib.h" 1
 














































# 44 "../../src/include/lwip/def.h" 2




# 41 "apps/shell.c" 2

# 1 "../../src/include/lwip/api.h" 1
 





































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


# 39 "../../src/include/lwip/api.h" 2

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


# 40 "../../src/include/lwip/api.h" 2


# 1 "../../src/include/ipv4/lwip/ip.h" 1
 








































# 1 "../../src/include/ipv4/lwip/ip_addr.h" 1
 










































 
struct ip_addr {
   u32_t addr  __attribute__((packed)) ;
} __attribute__((packed)) ;
 

extern struct ip_addr ip_addr_broadcast;






















				   



















# 42 "../../src/include/ipv4/lwip/ip.h" 2

# 1 "../../src/include/lwip/netif.h" 1
 






































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




























# 42 "../../src/include/lwip/api.h" 2


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





# 44 "../../src/include/lwip/api.h" 2

# 1 "../../src/include/lwip/tcp.h" 1
 










































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





# 45 "../../src/include/lwip/api.h" 2







enum netconn_type {
  NETCONN_TCP,
  NETCONN_UDP,
  NETCONN_UDPLITE,
  NETCONN_UDPNOCHKSUM
};

enum netconn_state {
  NETCONN_NONE,
  NETCONN_WRITE,
  NETCONN_ACCEPT,
  NETCONN_RECV,
  NETCONN_CONNECT,
  NETCONN_CLOSE
};

struct netbuf {
  struct pbuf *p, *ptr;
  struct ip_addr *fromaddr;
  u16_t fromport;
  err_t err;
};

struct netconn {
  enum netconn_type type;
  enum netconn_state state;
  union {
    struct tcp_pcb *tcp;
    struct udp_pcb *udp;
  } pcb;
  err_t err;
  sys_mbox_t mbox;
  sys_mbox_t recvmbox;
  sys_mbox_t acceptmbox;
  sys_sem_t sem;
};

 
struct netbuf *   netbuf_new      (void);
void              netbuf_delete   (struct netbuf *buf);
void *            netbuf_alloc    (struct netbuf *buf, u16_t size);
void              netbuf_free     (struct netbuf *buf);
void              netbuf_ref      (struct netbuf *buf,
				   void *dataptr, u16_t size);
void              netbuf_chain    (struct netbuf *head,
				   struct netbuf *tail);

u16_t             netbuf_len      (struct netbuf *buf);
err_t             netbuf_data     (struct netbuf *buf,
				   void **dataptr, u16_t *len);
s8_t              netbuf_next     (struct netbuf *buf);
void              netbuf_first    (struct netbuf *buf);

void              netbuf_copy     (struct netbuf *buf,
				   void *dataptr, u16_t len);
struct ip_addr *  netbuf_fromaddr (struct netbuf *buf);
u16_t             netbuf_fromport (struct netbuf *buf);

 
struct netconn *  netconn_new     (enum netconn_type type);
err_t             netconn_delete  (struct netconn *conn);
enum netconn_type netconn_type    (struct netconn *conn);
err_t             netconn_peer    (struct netconn *conn,
				   struct ip_addr **addr,
				   u16_t *port);
err_t             netconn_addr    (struct netconn *conn,
				   struct ip_addr **addr,
				   u16_t *port);
err_t             netconn_bind    (struct netconn *conn,
				   struct ip_addr *addr,
				   u16_t port);
err_t             netconn_connect (struct netconn *conn,
				   struct ip_addr *addr,
				   u16_t port);
err_t             netconn_listen  (struct netconn *conn);
struct netconn *  netconn_accept  (struct netconn *conn);
struct netbuf *   netconn_recv    (struct netconn *conn);
err_t             netconn_send    (struct netconn *conn,
				   struct netbuf *buf);
err_t             netconn_write   (struct netconn *conn,
				   void *dataptr, u16_t size,
				   u8_t copy);
err_t             netconn_close   (struct netconn *conn);

err_t             netconn_err     (struct netconn *conn);




# 42 "apps/shell.c" 2

# 1 "../../src/include/lwip/stats.h" 1
 







































# 1 "../../src/include/lwip/memp.h" 1
 









































typedef enum {
  MEMP_PBUF,
  MEMP_UDP_PCB,
  MEMP_TCP_PCB,
  MEMP_TCP_PCB_LISTEN,
  MEMP_TCP_SEG,

  MEMP_NETBUF,
  MEMP_NETCONN,
  MEMP_API_MSG,
  MEMP_TCPIP_MSG,

  MEMP_SYS_TIMEOUT,
  
  MEMP_MAX
} memp_t;

void memp_init(void);

void *memp_malloc(memp_t type);
void *memp_mallocp(memp_t type);
void *memp_malloc2(memp_t type);
void *memp_realloc(memp_t fromtype, memp_t totype, void *mem);
void memp_free(memp_t type, void *mem);
void memp_freep(memp_t type, void *mem);


typedef u8_t (*memp_reclaim_func)(void *arg, memp_t type);
void memp_register_reclaim(memp_t type, memp_reclaim_func f, void *arg);





	  
# 41 "../../src/include/lwip/stats.h" 2




struct stats_proto {
  u16_t xmit;     
  u16_t rexmit;   
  u16_t recv;     
  u16_t fw;       
  u16_t drop;     
  u16_t chkerr;   
  u16_t lenerr;   
  u16_t memerr;   
  u16_t rterr;    
  u16_t proterr;  
  u16_t opterr;   
  u16_t err;      
  u16_t cachehit;
};

struct stats_mem {
  u16_t avail;
  u16_t used;
  u16_t max;  
  u16_t err;
  u16_t reclaimed;
};

struct stats_pbuf {
  u16_t avail;
  u16_t used;
  u16_t max;  
  u16_t err;
  u16_t reclaimed;

  u16_t alloc_locked;
  u16_t refresh_locked;
};

struct stats_syselem {
  u16_t used;
  u16_t max;
  u16_t err;
};

struct stats_sys {
  struct stats_syselem sem;
  struct stats_syselem mbox;
};

struct stats_ {
  struct stats_proto link;
  struct stats_proto ip;
  struct stats_proto icmp;
  struct stats_proto udp;
  struct stats_proto tcp;
  struct stats_pbuf pbuf;
  struct stats_mem mem;
  struct stats_mem memp[MEMP_MAX];
  struct stats_sys sys;
};

extern struct stats_ stats;



void stats_init(void);





# 43 "apps/shell.c" 2


static unsigned char buffer[1024];

struct command {
  struct netconn *conn;
  s8_t (* exec)(struct command *);
  u8_t nargs;
  char *args[10];
};


# 1 "/SYS/include/errno.h" 1 3
 

















 





 






 

 

# 1 "/SYS/include/bits/errno.h" 1 3
 























# 1 "/SYS/include/linux/errno.h" 1 3



# 1 "/SYS/include/asm/errno.h" 1 3




































































































































# 4 "/SYS/include/linux/errno.h" 2 3


# 24 "/SYS/include/linux/errno.h" 3



# 25 "/SYS/include/bits/errno.h" 2 3


 


 




 
extern int errno;

 
extern int *__errno_location (void)   __attribute__ ((__const__));







 













# 36 "/SYS/include/errno.h" 2 3





 

















 



 










# 55 "apps/shell.c" 2









static struct netconn *conns[10 ];

static char help_msg[] = "Avaliable commands:\nopen [IP address] [TCP port]: opens a TCP connection to the specified address.\nlstn [TCP port]: sets up a server on the specified port.\nacpt [connection #]: waits for an incoming connection request.\nsend [connection #] [message]: sends a message on a TCP connection.\nudpc [local UDP port] [IP address] [remote port]: opens a UDP \"connection\".\nudpl [local UDP port] [IP address] [remote port]: opens a UDP-Lite \"connection\".\nudpn [local UDP port] [IP address] [remote port]: opens a UDP \"connection\" without checksums.\nudpb [local port] [remote port]: opens a UDP broadcast \"connection\".\nusnd [connection #] [message]: sends a message on a UDP connection.\nrecv [connection #]: recieves data on a TCP or UDP connection.\nclos [connection #]: closes a TCP or UDP connection.\nstat: prints out lwIP statistics.\nquit: quits.\n";
# 80 "apps/shell.c"

static char *stat_msgs[] = {
  "Link level * transmitted ",
  "             retransmitted ",
  "           * received ",
  "             forwarded ",
  "           * dropped ",
  "           * checksum errors ",
  "           * length errors ",
  "           * memory errors ",
  "             routing errors ",
  "             protocol errors ",
  "             option errors ",
  "           * misc errors ",
  "             cache hits ",  
  "IP         * transmitted ",
  "             retransmitted ",
  "           * received ",
  "           * forwarded ",
  "           * dropped ",
  "           * checksum errors ",
  "           * length errors ",
  "           * memory errors ",
  "           * routing errors ",
  "           * protocol errors ",
  "           * option errors ",
  "           * misc errors ",
  "             cache hits ",
  "ICMP       * transmitted ",
  "             retransmitted ",
  "           * received ",
  "             forwarded ",
  "           * dropped ",
  "           * checksum errors ",
  "             length errors ",
  "           * memory errors ",
  "             routing errors ",
  "           * protocol errors ",
  "             option errors ",
  "           * misc errors ",
  "             cache hits ",  
  "UDP        * transmitted ",
  "             retransmitted ",
  "           * received ",
  "             forwarded ",
  "           * dropped ",
  "           * checksum errors ",
  "           * length errors ",
  "           * memory errors ",
  "           * routing errors ",
  "           * protocol errors ",
  "             option errors ",
  "           * misc errors ",
  "             cache hits ",  
  "TCP        * transmitted ",
  "           * retransmitted ",
  "           * received ",
  "             forwarded ",
  "           * dropped ",
  "           * checksum errors ",
  "           * length errors ",
  "           * memory errors ",
  "           * routing errors ",
  "           * protocol errors ",
  "           * option errors ",
  "           * misc errors ",
  "           * cache hits ",  
  "Pbufs      * avaiable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "             reclaimed ",
  "             pbuf_alloc() locked ",
  "             pbuf_refresh() locked ",
  "Memory     * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "Memp PBUF  * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "UDP PCB    * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "TCP PCB    * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "TCP LISTEN * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "TCP SEG    * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "Netbufs    * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "Netconns   * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "API msgs   * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "TCPIP msgs * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "Timeouts   * avaliable ",
  "           * used ",
  "           * high water mark ",
  "           * errors ",
  "           * reclaimed ",
  "Semaphores * used ",
  "           * high water mark ",
  "           * errors ",
  "Mailboxes  * used ",
  "           * high water mark ",
  "           * errors "
};
 
static void
sendstr(const char *str, struct netconn *conn)
{
  netconn_write(conn, (void *)str, strlen(str), 0x00 );
}
 
static s8_t
com_open(struct command *com)
{
  struct ip_addr ipaddr;
  u16_t port;
  int i;
  err_t err;

  if(inet_aton(com->args[0], &ipaddr) == -1) {
    sendstr(strerror((*__errno_location ()) ), com->conn);
    return -1 ;
  }
  port = strtol(com->args[1], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Opening connection to ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr(":", com->conn);
  netconn_write(com->conn, com->args[1], strlen(com->args[1]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_TCP);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }
  err = netconn_connect(conns[i], &ipaddr, port);
  if(err != 0 ) {
    fprintf(stderr , "error %s\n", "" );
    sendstr("Could not connect to remote host: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    return 0 ;
  }

  sendstr("Opened connection, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
static s8_t
com_lstn(struct command *com)
{
  u16_t port;
  int i;
  err_t err;

  port = strtol(com->args[0], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Opening a listening connection on port ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_TCP);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }
  
  err = netconn_bind(conns[i], 0 , port);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not bind: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }
  
  err = netconn_listen(conns[i]);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not listen: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Opened connection, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
 
static s8_t
com_clos(struct command *com)
{
  int i;
  err_t err;
  
  i = strtol(com->args[0], ((void *)0) , 10);

  if(i > 10 ) {
    sendstr("Connection identifier too high.\n", com->conn);
    return 0 ;
  }
  if(conns[i] == ((void *)0) ) {
    sendstr("Connection identifier not in use.\n", com->conn);
    return 0 ;
  }

  err = netconn_close(conns[i]);
  if(err != 0 ) {
    sendstr("Could not close connection: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Connection closed.\n", com->conn);
  netconn_delete(conns[i]);
  conns[i] = ((void *)0) ;
  return 0 ;
}
 
static s8_t
com_acpt(struct command *com)
{
  int i, j;

   
  for(j = 0; j < 10  && conns[j] != ((void *)0) ; j++);

  if(j == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  i = strtol(com->args[0], ((void *)0) , 10);

  if(i > 10 ) {
    sendstr("Connection identifier too high.\n", com->conn);
    return 0 ;
  }
  if(conns[i] == ((void *)0) ) {
    sendstr("Connection identifier not in use.\n", com->conn);
    return 0 ;
  }

  conns[j] = netconn_accept(conns[i]);
  
  if(conns[j] == ((void *)0) ) {
    sendstr("Could not accept connection: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Accepted connection, connection identifier for new connection is ", com->conn);
  sprintf(buffer, "%d\n", j);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );

  return 0 ;
}
 
static s8_t
com_stat(struct command *com)
{
  int i;
  char buf[100];
  u16_t len;
  
  for(i = 0; i < sizeof(struct stats_) / 2; i++) {
    len = sprintf(buf, "%d", ((u16_t *)&stats)[i]);
    sendstr(stat_msgs[i], com->conn);
    netconn_write(com->conn, buf, len, 0x01 );
    sendstr("\n", com->conn);
  }

  
  return 0 ;
}
 
static s8_t
com_send(struct command *com)
{
  int i;
  err_t err;
  int len;
  
  i = strtol(com->args[0], ((void *)0) , 10);

  if(i > 10 ) {
    sendstr("Connection identifier too high.\n", com->conn);
    return 0 ;
  }

  if(conns[i] == ((void *)0) ) {
    sendstr("Connection identifier not in use.\n", com->conn);
    return 0 ;
  }

  len = strlen(com->args[1]);
  com->args[1][len] = '\r';
  com->args[1][len + 1] = '\n';
  com->args[1][len + 2] = 0;
  
  err = netconn_write(conns[i], com->args[1], len + 3, 0x01 );
  if(err != 0 ) {
    sendstr("Could not send data: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }
  
  sendstr("Data enqueued for sending.\n", com->conn);
  return 0 ;
}
 
static s8_t
com_recv(struct command *com)
{
  int i;
  err_t err;
  struct netbuf *buf;
  u16_t len;
  
  i = strtol(com->args[0], ((void *)0) , 10);

  if(i > 10 ) {
    sendstr("Connection identifier too high.\n", com->conn);
    return 0 ;
  }

  if(conns[i] == ((void *)0) ) {
    sendstr("Connection identifier not in use.\n", com->conn);
    return 0 ;
  }

  buf = netconn_recv(conns[i]);
  if(buf != ((void *)0) ) {
      
    netbuf_copy(buf, buffer, 1024);
    len = netbuf_len(buf);
    sendstr("Reading from connection:\n", com->conn);
    netconn_write(com->conn, buffer, len, 0x01 );
    netbuf_delete(buf);
  } else {
    sendstr("EOF.\n", com->conn); 
  }
  err = netconn_err(conns[i]);
  if(err != 0 ) {
    sendstr("Could not receive data: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }
  return 0 ;
}
 
static s8_t
com_udpc(struct command *com)
{
  struct ip_addr ipaddr;
  u16_t lport, rport;
  int i;
  err_t err;

  lport = strtol(com->args[0], ((void *)0) , 10);
  if(inet_aton(com->args[1], &ipaddr) == -1) {
    sendstr(strerror((*__errno_location ()) ), com->conn);
    return -1 ;
  }
  rport = strtol(com->args[2], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Setting up UDP connection from port ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr(" to ", com->conn);
  netconn_write(com->conn, com->args[1], strlen(com->args[1]), 0x01 );
  sendstr(":", com->conn);
  netconn_write(com->conn, com->args[2], strlen(com->args[2]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_UDP);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }

  err = netconn_connect(conns[i], &ipaddr, rport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not connect to remote host: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  err = netconn_bind(conns[i], 0 , lport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not bind: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Connection set up, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
static s8_t
com_udpl(struct command *com)
{
  struct ip_addr ipaddr;
  u16_t lport, rport;
  int i;
  err_t err;

  lport = strtol(com->args[0], ((void *)0) , 10);
  if(inet_aton(com->args[1], &ipaddr) == -1) {
    sendstr(strerror((*__errno_location ()) ), com->conn);
    return -1 ;
  }
  rport = strtol(com->args[2], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Setting up UDP-Lite connection from port ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr(" to ", com->conn);
  netconn_write(com->conn, com->args[1], strlen(com->args[1]), 0x01 );
  sendstr(":", com->conn);
  netconn_write(com->conn, com->args[2], strlen(com->args[2]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_UDPLITE);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }

  err = netconn_connect(conns[i], &ipaddr, rport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not connect to remote host: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  err = netconn_bind(conns[i], 0 , lport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not bind: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Connection set up, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
static s8_t
com_udpn(struct command *com)
{
  struct ip_addr ipaddr;
  u16_t lport, rport;
  int i;
  err_t err;

  lport = strtol(com->args[0], ((void *)0) , 10);
  if(inet_aton(com->args[1], &ipaddr) == -1) {
    sendstr(strerror((*__errno_location ()) ), com->conn);
    return -1 ;
  }
  rport = strtol(com->args[2], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Setting up UDP connection without checksums from port ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr(" to ", com->conn);
  netconn_write(com->conn, com->args[1], strlen(com->args[1]), 0x01 );
  sendstr(":", com->conn);
  netconn_write(com->conn, com->args[2], strlen(com->args[2]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_UDPNOCHKSUM);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }

  err = netconn_connect(conns[i], &ipaddr, rport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not connect to remote host: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  err = netconn_bind(conns[i], 0 , lport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not bind: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Connection set up, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
static s8_t
com_udpb(struct command *com)
{
  struct ip_addr ipaddr;
  u16_t lport, rport;
  int i;
  err_t err;
  struct ip_addr bcaddr;

  lport = strtol(com->args[0], ((void *)0) , 10);
  if(inet_aton(com->args[1], &ipaddr) == -1) {
    sendstr(strerror((*__errno_location ()) ), com->conn);
    return -1 ;
  }
  rport = strtol(com->args[2], ((void *)0) , 10);

   
  for(i = 0; i < 10  && conns[i] != ((void *)0) ; i++);

  if(i == 10 ) {
    sendstr("No more connections avaliable, sorry.\n", com->conn);
    return 0 ;
  }

  sendstr("Setting up UDP broadcast connection from port ", com->conn);
  netconn_write(com->conn, com->args[0], strlen(com->args[0]), 0x01 );
  sendstr(" to ", com->conn);
  netconn_write(com->conn, com->args[1], strlen(com->args[1]), 0x01 );
  sendstr("\n", com->conn);

  conns[i] = netconn_new(NETCONN_UDP);
  if(conns[i] == ((void *)0) ) {    
    sendstr("Could not create connection identifier (out of memory).\n", com->conn); 
    return 0 ;
  }

  err = netconn_connect(conns[i], &ipaddr, rport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not connect to remote host: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  ( &bcaddr )->addr = htonl(((u32_t)(  255  & 0xff) << 24) | ((u32_t)( 255  & 0xff) << 16) | ((u32_t)( 255  & 0xff) << 8) | (u32_t)( 255  & 0xff)) ;
  err = netconn_bind(conns[i], &bcaddr, lport);
  if(err != 0 ) {
    netconn_delete(conns[i]);
    conns[i] = ((void *)0) ;
    sendstr("Could not bind: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }

  sendstr("Connection set up, connection identifier is ", com->conn);
  sprintf(buffer, "%d\n", i);
  netconn_write(com->conn, buffer, strlen(buffer), 0x01 );
  
  return 0 ;
}
 
static s8_t
com_usnd(struct command *com)
{
  int i;
  err_t err;
  struct netbuf *buf;
  char *mem;
  
  i = strtol(com->args[0], ((void *)0) , 10);

  if(i > 10 ) {
    sendstr("Connection identifier too high.\n", com->conn);
    return 0 ;
  }

  if(conns[i] == ((void *)0) ) {
    sendstr("Connection identifier not in use.\n", com->conn);
    return 0 ;
  }

  buf = netbuf_new();
  mem = netbuf_alloc(buf, strlen(com->args[1]) + 1);
  if(mem == ((void *)0) ) {
    sendstr("Could not allocate memory for sending.\n", com->conn);
    return 0 ;
  }
  strncpy(mem, com->args[1], strlen(com->args[1]) + 1);
  err = netconn_send(conns[i], buf);
  netbuf_delete(buf);
  if(err != 0 ) {
    sendstr("Could not send data: ", com->conn);



    sendstr("(debugging must be turned on for error message to appear)", com->conn);

    sendstr("\n", com->conn);
    return 0 ;
  }
  
  sendstr("Data sent.\n", com->conn);
  return 0 ;
}
 
static s8_t
com_help(struct command *com)
{
  sendstr(help_msg, com->conn);
  return 0 ;
}
 
static s8_t
parse_command(struct command *com, u32_t len)
{
  u16_t i;
  u16_t bufp;
  
  if(strncmp(buffer, "open", 4) == 0) {
    com->exec = com_open;
    com->nargs = 2;
  } else if(strncmp(buffer, "lstn", 4) == 0) {
    com->exec = com_lstn;
    com->nargs = 1;
  } else if(strncmp(buffer, "acpt", 4) == 0) {
    com->exec = com_acpt;
    com->nargs = 1;
  } else if(strncmp(buffer, "clos", 4) == 0) {
    com->exec = com_clos;
    com->nargs = 1;
  } else if(strncmp(buffer, "stat", 4) == 0) {
    com->exec = com_stat;
    com->nargs = 0;
  } else if(strncmp(buffer, "send", 4) == 0) {
    com->exec = com_send;
    com->nargs = 2;
  } else if(strncmp(buffer, "recv", 4) == 0) {
    com->exec = com_recv;
    com->nargs = 1;
  } else if(strncmp(buffer, "udpc", 4) == 0) {
    com->exec = com_udpc;
    com->nargs = 3;
  } else if(strncmp(buffer, "udpb", 4) == 0) {
    com->exec = com_udpb;
    com->nargs = 2;
  } else if(strncmp(buffer, "udpl", 4) == 0) {
    com->exec = com_udpl;
    com->nargs = 3;
  } else if(strncmp(buffer, "udpn", 4) == 0) {
    com->exec = com_udpn;
    com->nargs = 3;
  } else if(strncmp(buffer, "usnd", 4) == 0) {
    com->exec = com_usnd;
    com->nargs = 2;
  } else if(strncmp(buffer, "help", 4) == 0) {
    com->exec = com_help;
    com->nargs = 0;
  } else if(strncmp(buffer, "quit", 4) == 0) {
    printf("quit\n");
    return -4 ;
  } else {
    return -1 ;
  }

  if(com->nargs == 0) {
    return 0 ;
  }
  bufp = 0;
  for(; bufp < len && buffer[bufp] != ' '; bufp++);
  for(i = 0; i < 10; i++) {
    for(; bufp < len && buffer[bufp] == ' '; bufp++);
    if(buffer[bufp] == '\r' ||
       buffer[bufp] == '\n') {
      buffer[bufp] = 0;
      if(i < com->nargs - 1) {
	return -2 ;
      }
      if(i > com->nargs - 1) {
	return -3 ;
      }
      break;
    }    
    if(bufp > len) {
      return -2 ;
    }    
    com->args[i] = &buffer[bufp];
    for(; bufp < len && buffer[bufp] != ' ' && buffer[bufp] != '\r' &&
	  buffer[bufp] != '\n'; bufp++) {
      if(buffer[bufp] == '\\') {
	buffer[bufp] = ' ';
      }
    }
    if(bufp > len) {
      return -1 ;
    }
    buffer[bufp] = 0;
    bufp++;
    if(i == com->nargs - 1) {
      break;
    }

  }

  return 0 ;
}
 
static void
error(s8_t err, struct netconn *conn)
{
  switch(err) {
  case -1 :
    sendstr("## Syntax error\n", conn);
    break;
  case -2 :
    sendstr("## Too few arguments to command given\n", conn);
    break;
  case -3 :
    sendstr("## Too many arguments to command given\n", conn);
    break;
  }
}
 
static void
prompt(struct netconn *conn)
{
  sendstr("> ", conn);
}  
 
static void
shell_main(struct netconn *conn)
{
  struct netbuf *buf;
  u32_t len;
  struct command com;
  s8_t err;
  int i;
  
  do {
    buf = netconn_recv(conn);
    if(buf != ((void *)0) ) {
      netbuf_copy(buf, buffer, 1024);
      len = netbuf_len(buf);
      netbuf_delete(buf);
      if(len >= 4) {
	if(buffer[0] != 0xff && 
	   buffer[1] != 0xfe) {
	  err = parse_command(&com, len);
	  if(err == 0 ) {	
	    com.conn = conn;
	    err = com.exec(&com);
	  }
	  if(err != 0 ) {
	    error(err, conn);
	  }
	  if(err == -4 ) {
	    printf("Closed\n");
	    error(err, conn);
	    goto close;
	  }
	} else {
	  sendstr("\n\n"
	          "lwIP simple interactive shell.\n"
	          "(c) Copyright 2001, Swedish Institute of Computer Science.\n"
	          "Written by Adam Dunkels.\n"
	          "For help, try the \"help\" command.\n", conn);
	}
      }
    }
    if(buf != ((void *)0) ) {
      prompt(conn);
    }
  } while(buf != ((void *)0) );
  printf("buf == NULL err %s\n", "" );
 close:  
  netconn_close(conn);
  
  for(i = 0; i < 10 ; i++) {
    if(conns[i] != ((void *)0) ) {
      netconn_delete(conns[i]);
    }
    conns[i] = ((void *)0) ;
  }
  
}
 
static void 
shell_thread(void *arg)
{
  struct netconn *conn, *newconn;
  
  conn = netconn_new(NETCONN_TCP);
  netconn_bind(conn, ((void *)0) , 23);
  netconn_listen(conn);

  while(1) {
    newconn = netconn_accept(conn);
    shell_main(newconn);
    netconn_delete(newconn);
  }
}
 
void
shell_init(void)     
{
  sys_thread_new(shell_thread, ((void *)0) );
}




