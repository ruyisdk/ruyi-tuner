#ifndef _DIRENT_H_
#define _DIRENT_H_

#include <inttypes.h>
#include <sys/types.h>

#ifdef __cplusplus
extern "C"
{
#endif





/* structure describing an open directory*/


  typedef struct __dirstream DIR;


/* File types for `d_type'*/



/* structure describing a directory entry*/


  struct dirent
  {
    long d_ino;
    off_t d_off;
    unsigned short d_reclen;
    unsigned char d_type;
    char d_name[256];
  }
   ;

  struct dirent64
  {
    uint64_t d_ino;
    int64_t d_off;
    unsigned short d_reclen;
    unsigned char d_type;
    char d_name[256];
  }
   ;


  extern void rewinddir (DIR *);
  extern void seekdir (DIR *, long);
  extern long telldir (DIR *);
  extern int closedir (DIR *);
  extern DIR *opendir (const char *);
  extern struct dirent *readdir (DIR *);
  extern struct dirent64 *readdir64 (DIR *);
  extern int readdir_r (DIR *, struct dirent *, struct dirent **);
#ifdef __cplusplus
}
#endif
#endif
