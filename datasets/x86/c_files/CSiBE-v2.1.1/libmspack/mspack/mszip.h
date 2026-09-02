/* This file is part of libmspack.
 * (C) 2003 Stuart Caie.
 *
 * libmspack is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License (LGPL) version 2.1
 *
 * For further details, see the file COPYING.LIB distributed with libmspack
 */

#ifndef MSPACK_MSZIP_H
#define MSPACK_MSZIP_H 1

/* MSZIP (deflate) compression / decompression definitions */

#define ZIPWSIZE 	0x8000  /* window size */
#define ZIPLBITS	9	/* bits in base literal/length lookup table */
#define ZIPDBITS	6	/* bits in base distance lookup table */
#define ZIPBMAX		16      /* maximum bit length of any code */
#define ZIPN_MAX	288     /* maximum number of codes in any set */

struct Ziphuft {
  unsigned char e;                /* number of extra bits or operation */
  unsigned char b;                /* number of bits in this code or subcode */
  union {
    unsigned short n;              /* literal, length base, or distance base */
    struct Ziphuft *t;    /* pointer to next level of table */
  } v;
};

struct mszipd_state {
  struct mspack_system *system;   /* I/O routines                            */
  struct mspack_file   *input;    /* input file handle                       */
  struct mspack_file   *output;   /* output file handle                      */

  unsigned int window_posn;       /* offset within window (also MSZIP) */

  unsigned int bb;              /* bit buffer */
  unsigned int bk;              /* bits in bit buffer */
  unsigned int ll[288+32];	  /* literal/length and distance code lengths*/
  unsigned int c[ZIPBMAX+1];    /* bit length count table */
  int lx[ZIPBMAX+1];            /* memory for l[-1..ZIPBMAX-1] */
  struct Ziphuft *u[ZIPBMAX];   /* table stack */
  unsigned int v[ZIPN_MAX];     /* values in order of bit length */
  unsigned int x[ZIPBMAX+1];    /* bit offsets, then code stack */
  unsigned char *inpos;
};

/* allocates MS-ZIP decompression state for decoding the given stream.
 *
 * - uses system->alloc() to allocate memory
 *
 * - returns NULL if not enough memory
 *
 * - if cab_frame_align is non-zero, the decompressor will re-align its
 *   INPUT bit buffer after every 32kb of OUTPUT data is decompressed.
 */
extern struct mszipd_state *mszipd_init(struct mspack_system *system,
					struct mspack_file *input,
					struct mspack_file *output,
					int cab_frame_align);

/* decompresses, or decompresses more of, an MS-ZIP stream.
 *
 * - out_bytes of data will be decompressed and the function will return
 *   with an MSPACK_ERR_OK return code.
 *
 * - decompressing will stop as soon as out_bytes is reached. if the true
 *   amount of bytes decoded spills over that amount, they will be kept for
 *   a later invocation of mszipd_decompress().
 *
 * - the output bytes will be passed to the system->write() function given in
 *   mszipd_init(), using the output file handle given in mszipd_init(). More
 *   than one call may be made to system->write()
 *
 * - MS-ZIP will read input bytes as necessary using the system->read()
 *   function given in mszipd_init(), using the input file handle given in
 *   mszipd_init(). This will continue until system->read() returns 0 bytes,
 *   or an error.
 */
extern int mszipd_decompress(struct mszipd_state *state,
			     off_t out_bytes);

/* frees all state associated with an MS-ZIP data stream
 *
 * - calls system->free() using the system pointer given in mszipd_init()
 */
void mszipd_free(struct mszipd_state *state);

#endif
