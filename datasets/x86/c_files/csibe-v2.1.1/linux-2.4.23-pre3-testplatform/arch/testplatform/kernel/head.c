/*
 *  arch/s390/kernel/head.S
 *
 *  S390 version
 *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
 *    Author(s): Hartmut Penner (hp@de.ibm.com),
 *               Martin Schwidefsky (schwidefsky@de.ibm.com),
 *               Rob van der Heij (rvdhei@iae.nl)
 *
 * There are 5 different IPL methods
 *  1) load the image directly into ram at address 0 and do an PSW restart
 *  2) linload will load the image from address 0x10000 to memory 0x10000
 *     and start the code thru LPSW 0x0008000080010000 (VM only, deprecated)
 *  3) generate the tape ipl header, store the generated image on a tape
 *     and ipl from it
 *     In case of SL tape you need to IPL 5 times to get past VOL1 etc
 *  4) generate the vm reader ipl header, move the generated image to the
 *     VM reader (use option NOH!) and do a ipl from reader (VM only)
 *  5) direct call of start by the SALIPL loader
 *  We use the cpuid to distinguish between VM and native ipl
 *  params for kernel are pushed to 0x10400 (see setup.h)

    Changes: 
    Okt 25 2000 <rvdheij@iae.nl>
	added code to skip HDR and EOF to allow SL tape IPL (5 retries)
	changed first CCW from rewind to backspace block

 */

void dummy_head(void)
{
}

