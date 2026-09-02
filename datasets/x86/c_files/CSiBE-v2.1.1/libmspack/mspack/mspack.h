/* libmspack -- a library for working with Microsoft compression formats.
 * (C) 2003 Stuart Caie <kyzer@4u.net>
 *
 * libmspack is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License (LGPL) version 2.1
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* The purpose of libmspack is to provide compressors and decompressors,
 * archivers and dearchivers for Microsoft compression formats.
 *
 * It is not intended as a generalised "any archiver" interface. That role
 * will be filled by other libraries (such as the Amiga XAD system)
 *
 * The library offers no file IO, metadata translation or other high-level
 * features. These must be handled by the user.
 *
 * The following formats will be supported:
 * - SZDD files, which use LZSS compression
 * - KWAJ files, which use LZSS or deflate compression
 * - .HLP (MS Help) files, which use LZSS compression
 * - .CAB (MS Cabinet) files, which use deflate, LZX or Quantum compression
 * - .CHM (HTML Help) files, which use LZX compression
 * - .LIT (EBook) files, which use LZX compression and DES encryption
 */

#ifndef LIB_MSPACK_H
#define LIB_MSPACK_H 1

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/types.h>
#include <unistd.h>

/* IO / System definitions */

struct mspack_system {
  /* struct mspack_file *open(struct mspack_system *this,
   *                          char *filename, int mode)
   * - must open the given filename for reading, writing or appending
   *   as given by the mode parameter (e.g. MSPACK_SYS_OPEN_READ)
   * - must return a pointer representing the file, or NULL if the file
   *   could not be opened. "struct mspack_file" is an empty structure and
   *   its true contents are entirely up to the mspack_system implementation.
   *   Instead of passing in "this" in all other file I/O functions, "this"
   *   should be stored in the mspack_file structure if required.
   */
  struct mspack_file * (*open)(struct mspack_system *, char *, int);

  /* void close(struct mspack_file *file)
   * - must close the file represented by the given file handle
   * - must free memory used by the mspack_file structure.
   */
  void (*close)(struct mspack_file *);

  /* int read(struct mspack_file *file, void *buffer, int bytes)
   * - must read [bytes] bytes of data from the file into the area of
   *   memory pointed to by [buffer].
   * - must return the number of bytes successfully read, or zero for end
   *   of file, or less than zero for an error in reading
   * - if 200 bytes are requested, and only 100 are available, read the 100
   *   bytes and return 100, instead of returning an error.
   */
  int (*read)(struct mspack_file *, void *, int);

  /* int write(struct mspack_file *file, void *buffer, int bytes)
   * - must write [bytes] bytes of data to the file from the area of
   *   memory pointed to by [buffer].
   * - must return the number of bytes successfully written, or less than
   *   zero for an error in writing
   */
  int (*write)(struct mspack_file *, void *, int);

  /* void seek(struct mspack_file *file, off_t offset, int mode)
   * - moves to the given offset (measured in bytes) in the given file.
   * - the mode parameter is one of MSPACK_SYS_SEEK_START, _CUR or _END
   * - zero should normally be returned.
   * - if a seek error occurs, non-zero should be returned
   * - note that mspack will, if necessary, discover the file-size of a file
   *   by seeking to the end of it, calling tell(), and seeking back. You
   *   may want a special-case for seek(file, 0, MSPACK_SYS_SEEK_END).
   */
  int (*seek)(struct mspack_file *, off_t, int);

  /* off_t tell(struct mspack_file *file) 
   * must return the current position (in bytes) in the given file.
   */
  off_t (*tell)(struct mspack_file *);
  
  /* void message(struct mspack_file *file, char *format, ...)
   * - used to send occasional comments in plain english from the
   *   library to the user, can be ignored if wanted.
   * - file may be NULL if the warning does not pertain to a file
   * - format and any remaining args form a printf() style message, which
   *   DOES NOT include a trailing newline.
   */
  void (*message)(struct mspack_file *, char *, ...);

  /* void *alloc(struct mspack_system *this, size_t bytes)
   * - must allocate [bytes] bytes of memory and return them
   * - must return NULL if the requested memory cannot be allocated
   */
  void * (*alloc)(struct mspack_system *, size_t);
  
  /* void free(void *ptr)
   * - frees memory allocated with the above alloc() function
   * - should do nothing in NULL is passed in
   */
  void (*free)(void *);

  /* void copy(void *src, void *dest, size_t bytes)
   * - should copy [bytes] bytes of memory from src to dest
   * - the specified areas of memory do not overlap
   * - the memory copies made by this library are usually small (< 256 bytes)
   *   and not always aligned.
   */
  void (*copy)(void *, void *, size_t);

  /* null_ptr
   * - must equal NULL. This way, should this structure extend in the future,
   * this NULL will be caught rather than have an invalid function pointer
   * called.
   */
  void *null_ptr;
};

#define MSPACK_SYS_OPEN_READ   (0) /* open existing file for reading */
#define MSPACK_SYS_OPEN_WRITE  (1) /* open new file for writing */
#define MSPACK_SYS_OPEN_UPDATE (2) /* open existing file for writing */
#define MSPACK_SYS_OPEN_APPEND (3) /* open existing file for writing */

#define MSPACK_SYS_SEEK_START  (0) /* seek relative to start of file */
#define MSPACK_SYS_SEEK_CUR    (1) /* seek relative to current offset */
#define MSPACK_SYS_SEEK_END    (2) /* seek relative to end of file */

struct mspack_file {
  /* contents are entirely up to mspack_system functions */
  int dummy; /* even this doesn't have to exist (it's just to placate gcc) */
};

/* error codes */

#define MSPACK_ERR_OK          (0)  /* no error                  */
#define MSPACK_ERR_ARGS        (1)  /* bad arguments to function */
#define MSPACK_ERR_OPEN        (2)  /* error opening file        */
#define MSPACK_ERR_READ        (3)  /* error reading file        */
#define MSPACK_ERR_WRITE       (4)  /* error writing file        */
#define MSPACK_ERR_SEEK        (5)  /* seek error                */
#define MSPACK_ERR_NOMEMORY    (6)  /* out of memory             */
#define MSPACK_ERR_SIGNATURE   (7)  /* bad "magic id" in file    */
#define MSPACK_ERR_DATAFORMAT  (8)  /* bad/corrupt file format   */
#define MSPACK_ERR_CHECKSUM    (9)  /* bad checksum/CRC          */
#define MSPACK_ERR_CRUNCH      (10) /* error in compression      */
#define MSPACK_ERR_DECRUNCH    (11) /* error in decompression    */

/* functions available in library */

/* general usage (using default system I/O):
 *
 *   struct msXYZ_compressor *XYZc;
 *   if ((XYZc = mspack_create_XYZ_compressor(NULL))) {
 *     XYZc->whatever_function(XYZc, "other arguments", 1, 2, 3);
 *     mspack_destroy_XYZ_compressor(XYZc);
 *   }
 *
 *   struct msXYZ_decompressor *XYZd;
 *   if ((XYZd = mspack_create_XYZ_decompressor(NULL))) {
 *     XYZd->whatever_function(XYZd, "other arguments", 1, 2, 3);
 *     mspack_destroy_XYZ_decompressor(XYZd);
 *   }
 *
 * where XYZ is cab, chm, lit, hlp, szdd or kwaj
 *
 * destroying a compressor or decompressor does not destroy any objects,
 * structures or handles that have been created using that compressor or
 * decompressor. ensure everything that you created or opened using
 * functions in the compressor/decompressor is destroyed or closed before
 * you destroy the compressor/decompressor.
 */

extern struct mscab_compressor *
  mspack_create_cab_compressor(struct mspack_system *);
extern struct mscab_decompressor *
  mspack_create_cab_decompressor(struct mspack_system *);
extern void mspack_destroy_cab_compressor(struct mscab_compressor *);
extern void mspack_destroy_cab_decompressor(struct mscab_decompressor *);

extern struct mschm_compressor *
  mspack_create_chm_compressor(struct mspack_system *);
extern struct mschm_decompressor *
  mspack_create_chm_decompressor(struct mspack_system *);
extern void mspack_destroy_chm_compressor(struct mschm_compressor *);
extern void mspack_destroy_chm_decompressor(struct mschm_decompressor *);

extern struct mslit_compressor *
  mspack_create_lit_compressor(struct mspack_system *);
extern struct mslit_decompressor *
  mspack_create_lit_decompressor(struct mspack_system *);
extern void mspack_destroy_lit_compressor(struct mslit_compressor *);
extern void mspack_destroy_lit_decompressor(struct mslit_decompressor *);

extern struct mshlp_compressor *
  mspack_create_hlp_compressor(struct mspack_system *);
extern struct mshlp_decompressor *
  mspack_create_hlp_decompressor(struct mspack_system *);
extern void mspack_destroy_hlp_compressor(struct mshlp_compressor *);
extern void mspack_destroy_hlp_decompressor(struct mshlp_decompressor *);

extern struct msszdd_compressor *
  mspack_create_szdd_compressor(struct mspack_system *);
extern struct msszdd_decompressor *
  mspack_create_szdd_decompressor(struct mspack_system *);
extern void mspack_destroy_szdd_compressor(struct msszdd_compressor *);
extern void mspack_destroy_szdd_decompressor(struct msszdd_decompressor *);

extern struct mskwaj_compressor *
  mspack_create_kwaj_compressor(struct mspack_system *);
extern struct mskwaj_decompressor *
  mspack_create_kwaj_decompressor(struct mspack_system *);
extern void mspack_destroy_kwaj_compressor(struct mskwaj_compressor *);
extern void mspack_destroy_kwaj_decompressor(struct mskwaj_decompressor *);

/* Support for .CAB (MS Cabinet) file format */

struct mscabd_cabinet {
  struct mscabd_cabinet *next;             /* for making a list of cabinets  */
  char *filename;                          /* filename of cabinet            */
  off_t base_offset;                       /* offset of cabinet within file  */
  unsigned int length;                     /* length of cabinet file         */
  struct mscabd_cabinet *prevcab,*nextcab; /* multipart cabinet chains       */
  char *prevname, *nextname;               /* and their filenames            */
  char *previnfo, *nextinfo;               /* and their visible names        */
  struct mscabd_file *files;               /* first file in this cabinet     */
  struct mscabd_folder *folders;           /* first folder in this cabinet   */
  unsigned short set_id;                   /* all cabs in set have same ID   */
  unsigned short set_index;                /* cab number within the set      */
  unsigned short header_resv;              /* space reserved after header    */
  int flags;                               /* header flags                   */
};

struct mscabd_folder {
  struct mscabd_folder *next;
  int comp_type;                           /* compression format/window size */
  unsigned int num_blocks;                 /* total number of 32k datablocks */
};

struct mscabd_file {
  struct mscabd_file *next;                /* next file in sequence          */
  char *filename;                          /* filename of file               */
  unsigned int length;                     /* uncompressed length of file    */
  int attribs;                             /* file attributes                */
  char time_h, time_m, time_s;             /* last modified time hour/min/sec*/
  char date_d, date_m;                     /* last modified date day/month   */
  int date_y;                              /* last modified date year        */

  struct mscabd_folder *folder;            /* folder that contains this file */
  unsigned int offset;                     /* uncompressed offset in folder  */
};

/* if mscab_cabinet.header_resv is more than zero, the reserved
 * (application private) part of the header can be read by seeking to
 * offset mscab_cabinet.base_offset + MSCAB_HDR_RESV_OFFSET and reading
 * mscab_cabinet.header_resv bytes of data
*/
#define MSCAB_HDR_RESV_OFFSET (0x28)

/* mscab_cabinet.flags bitmasks (not bit values) */
#define MSCAB_HDR_PREVCAB (0x01) /* cabinet has a multipart predecessor */
#define MSCAB_HDR_NEXTCAB (0x02) /* cabinet has a multipart successor   */
#define MSCAV_HDR_RESV    (0x04) /* cabinet has reserved header space   */

/* mscab_file.attribs bitmasks */

#define MSCAB_ATTRIB_RDONLY   (0x01)    /* file is read-only                 */
#define MSCAB_ATTRIB_HIDDEN   (0x02)    /* file is hidden                    */
#define MSCAB_ATTRIB_SYSTEM   (0x04)    /* file is a system file             */
#define MSCAB_ATTRIB_ARCH     (0x20)    /* file unmodified since last backup */
#define MSCAB_ATTRIB_EXEC     (0x40)    /* file is executable                */
#define MSCAB_ATTRIB_UTF_NAME (0x80)    /* filename is UTF-8, not ASCII      */

/* parameter IDs for set_param() */
#define MSCABD_PARAM_SEARCHBUF (0)
#define MSCABD_PARAM_FIXMSZIP  (1)
#define MSCABD_PARAM_DECOMPBUF (2)

/* folder compression types */
#define MSCAB_COMP_NONE       (0x0000)  /* no compression                    */
#define MSCAB_COMP_MSZIP      (0x0001)  /* MSZIP compression                 */
#define MSCAB_COMP_QUANTUM    (0x0002)  /* Quantum compression               */
#define MSCAB_COMP_LZX        (0x0003)  /* LZX compression                   */

/* macros for cabd_folder.comp_types:
 * use MSCABD_COMP_METHOD(fol->comp_type) to get the algorithm used by
 * that folder: one of MSCAB_COMP_NONE, MSZIP, QUANTUM or LZX. For
 * QUANTUM and LZX, a "compression level" parameter also exists in the
 * comp_type, which can be accessed with MSCABD_COMP_LEVEL(fol->comp_type)
 */
#define MSCABD_COMP_METHOD(x) ((x) & 0xF)
#define MSCABD_COMP_LEVEL(x) (((x) >> 8) & 0x1f)

struct mscab_compressor {
  /* todo */
  int dummy; 
};

struct mscab_decompressor {
  /* struct mscabd_cabinet *open(struct mscab_decompressor *this,
   *                            char *filename);
   * - opens a cabinet file with the given filename.
   * - if the file begins with a valid cabinet file, all headers will be read
   *   and parsed, and a mscabd_cabinet structure will be returned, replete
   *   with a linked list of mscabd_file entries.
   * - all fields in all structures returned must be considered read-only.
   * - in the case of an error occuring, NULL is returned and the error code
   *   is available from last_error()
   * - the filename pointer should be considered in use until close() is
   *   called on the cabinet.
   */
  struct mscabd_cabinet * (*open) (struct mscab_decompressor *, char *);

  /* void close(struct mscab_decompressor *this, struct mscabd_cabinet *cab);
   * - closes a previously opened cabinet (or cabinets) and frees all memory
   *   associated with it.
   * - the cabinet pointer is now invalid and cannot be used again
   * - if the cabinet pointer given was created using search(), it MUST be
   *   the cabinet pointer returned by search() and not one of the 
   *   later cabinet pointers further along the "->next" chain.
   * - if extra cabinets have been added using append() or prepend(), these
   *   will all be freed, even if the cabinet pointer given is not the first
   *   cabinet in the set. do NOT close() more than one cabinet in the set.
   */
  void (*close)(struct mscab_decompressor *, struct mscabd_cabinet *);

  /* struct mscabd_cabinet *search(struct mscab_decompressor *this,
   *                               char *filename);
   * - opens a normal file with the given filename and will search the
   *   entire file for embedded cabinet files
   * - if any cabinet files are found, all headers will be read
   *   and parsed and complete mscabd_cabinet structures will be created,
   *   just like open(). The first cabinet found will be returned directly
   *   as the result of this function. Any further cabinets found will be
   *   chained in a list using the "next" structure member in the
   *   mscabd_cabinet structure.
   * - all fields in all structures returned must be considered read-only.
   * - in the case of an error occuring, NULL is returned and the error code
   *   is available from last_error()
   * - if no error occurs, but no cabinets can be found in the file, NULL
   *   is returned and last_error() returns MSPACK_ERR_OK.
   * - the filename pointer should be considered in use until close() is
   *   called on the cabinet.
   * - you should call close() on the result of search(), not any subsequent
   *   cabinets in the "next" chain.
   */
  struct mscabd_cabinet * (*search) (struct mscab_decompressor *, char *);

  /* int append(struct mscab_decompressor *this,
   *            struct mscabd_cabinet *cab,
   *            struct mscabd_cabinet *nextcab);
   * - will attempt to append one cabinet to another, such that
   *   cab->nextcab == nextcab && nextcab->prevcab == cab, and any folders
   *   split between the two cabinets are merged.
   * - the cabinets MUST be part of a cabinet set (a cabinet set is a cabinet
   *   that spans more than one physical cabinet file on disk), and must be
   *   appropriately matched.
   * - you can tell if a cabinet has further parts to load by examining
   *   the mscabd_cabinet.flags member:
   *   - if (mscabd_cabinet.flags & MSCAB_HDR_PREVCAB) is non-zero, there is a 
   *     predecessor cabinet to load, its MS-DOS case-insensitive filename is
   *     stored in mscabd_cabinet.prevname
   *   - if (mscabd_cabinet.flags & MSCAB_HDR_NEXTCAB) is non-zero, there is a
   *     successor cabinet to load, its MS-DOS case-insensitive filename is
   *     stored in mscabd_cabinet.nextname
   * - if the cabinets do not match, an error code will be returned.
   *   this does not affect either cabinet.
   * - files and folders in a cabinet set are a single entity. all cabinets
   *   in a set point to the same file list, which is updated as cabinets in
   *   the set are added. all pointers to mscabd_folder and mscabd_file
   *   structures in either cabinet must be discarded, and re-obtained after
   *   merging.
   */
  int (*append) (struct mscab_decompressor *,
		 struct mscabd_cabinet *, struct mscabd_cabinet *);

  /* int prepend(struct mscab_decompressor *this,
   *             struct mscabd_cabinet *cab,
   *             struct mscabd_cabinet *prevcab);
   * - will attempt to append one cabinet to another, such that
   *   cab->prevcab == prevcab, and any files merged between the two cabinets
   *   can be extracted.
   * - in all other respects, it is identical to append()
   */
  int (*prepend) (struct mscab_decompressor *,
		  struct mscabd_cabinet *, struct mscabd_cabinet *);

  /* int extract(struct mscab_decompressor *this,
   *             struct mscabd_file *file, char *filename);
   * - extracts a compressed file in a cabinet and writes it to the given
   *   filename.
   * - the MS-DOS filename of the file, "file.filename", is NOT USED by
   *   extract(), you must examine this MS-DOS filename, copy and tweak it
   *   as necessary, create directories as necessary, and provide the
   *   ready-to-use filename as a parameter, which will be passed unchanged
   *   to the decompressor's system->open()
   * - if the file belongs to a multi-part cabinet that has not bee
   * - if all is successful, 0 is returned, otherwise an error code is
   *   returned
   */
  int (*extract)(struct mscab_decompressor *, struct mscabd_file *, char *);

  /* int set_param(struct mscab_decompressor *this, int param, int value);
   *
   * - sets a parameter of the CAB decompression engine
   * - the following parameters are defined:
   *   - MSCABD_PARAM_SEARCHBUF: value is how many bytes should be allocated
   *     as a buffer when using search(). values of 0 or less will be ignored.
   *     the default value is 32768
   *   - MSCABD_PARAM_FIXMSZIP: if value is non-zero, extract() will ignore
   *     bad checksums and recover from decompression errors in MS-ZIP
   *     compressed folders. the default value is 0 (don't recover)
   *   - MSCABD_PARAM_DECOMPBUF: value is how many bytes should be used as
   *     an input bit buffer by decompressors. the default value is 4096.
   *   - returns MSPACK_ERR_OK if all is OK, or MSPACK_ERR_ARGS if there
   *     is a problem with the parameter or value.
   */
  int (*set_param)(struct mscab_decompressor *, int param, int value);

  /* int last_error(struct mscab_decompressor *this)
   * - returns the error code of the most recent error
   * - error codes are the MSPACK_ERR_* defines in "mspack.h"
   */
  int (*last_error)(struct mscab_decompressor *);
};

/* Support for .CHM (HTMLHelp) file format */

/* This is a preliminary, basic implementation which has not been designed
 * with all details of the CHM format in mind.
 */
struct mschmd_section {
  struct mschmd_header *chm; /* self-referential pointer */
  unsigned int id; /* either 0 (uncompressed) or 1 (mscompressed) */
};
struct mschmd_sec_uncompressed {
  struct mschmd_section base;
  off_t offset;
};
struct mschmd_sec_mscompressed {
  struct mschmd_section base;
  struct mschmd_file *content;
  struct mschmd_file *control;
  struct mschmd_file *rtable;
};

struct mschmd_header {
  unsigned int version;
  unsigned int timestamp;
  unsigned int language;
  char *filename;
  off_t length;
  struct mschmd_file *files;
  struct mschmd_file *sysfiles; /* files beginning with '::' */
  struct mschmd_sec_uncompressed sec0;
  struct mschmd_sec_mscompressed sec1;
};

struct mschmd_file {
  struct mschmd_file *next;
  struct mschmd_section *section;
  off_t offset;
  off_t length;
  char *filename;
};

struct mschm_compressor {
  int dummy;
};

struct mschm_decompressor {
  struct mschmd_header *(*open)(struct mschm_decompressor *, char *filename);
  void (*close)(struct mschm_decompressor *, struct mschmd_header *);
  int (*extract)(struct mschm_decompressor *,
		 struct mschmd_file *,
		 char *filename);
  int (*last_error)(struct mschm_decompressor *);
};

/* Support for .LIT (EBook) file format */

struct mslit_compressor {
  int dummy; 
};

struct mslit_decompressor {
  int dummy; 
};


/* Support for .HLP (MS Help) file format */

struct mshlp_compressor {
  int dummy; 
};

struct mshlp_decompressor {
  int dummy; 
};


/* Support for .??_ (SZDD) file format */

struct msszdd_compressor {
  int dummy; 
};

struct msszdd_decompressor {
  int dummy; 
};

/* Support for .??_ (KWAJ) file format */

struct mskwaj_compressor {
  int dummy; 
};

struct mskwaj_decompressor {
  int dummy; 
};

#ifdef __cplusplus
};
#endif

#endif
