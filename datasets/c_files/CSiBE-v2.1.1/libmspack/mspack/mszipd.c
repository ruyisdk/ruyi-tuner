/* This file is part of libmspack.
 * (C) 2003 Stuart Caie.
 *
 * libmspack is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License (LGPL) version 2.1
 *
 * For further details, see the file COPYING.LIB distributed with libmspack
 */

/* MS-ZIP decompression implementation */

#include "mspack.h"
#include "system.h"
#include "mszip.h"

/* based on an implementation by Dirk Stoecker, itself derived from the
 * Info-ZIP sources.
 */

struct mszipd_state *mszipd_init(struct mspack_system *system,
				 struct mspack_file *input,
				 struct mspack_file *output,
				 int cab_frame_align)
{
  return NULL;
}

int mszipd_decompress(struct mszipd_state *state, off_t out_bytes) {
  return MSPACK_ERR_DECRUNCH;
}

void mszipd_free(struct mszipd_state *state) {
  struct mspack_system *sys;
  if (state) {
    sys = state->system;
    sys->free(state);
  }
}
