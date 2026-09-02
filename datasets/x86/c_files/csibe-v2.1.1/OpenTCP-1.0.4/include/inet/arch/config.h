/*
 *Copyright (c) 2000-2002 Viola Systems Ltd.
 *All rights reserved.
 *
 *Redistribution and use in source and binary forms, with or without 
 *modification, are permitted provided that the following conditions 
 *are met:
 *
 *1. Redistributions of source code must retain the above copyright 
 *notice, this list of conditions and the following disclaimer.
 *
 *2. Redistributions in binary form must reproduce the above copyright 
 *notice, this list of conditions and the following disclaimer in the 
 *documentation and/or other materials provided with the distribution.
 *
 *3. The end-user documentation included with the redistribution, if 
 *any, must include the following acknowledgment:
 *	"This product includes software developed by Viola 
 *	Systems (http://www.violasystems.com/)."
 *
 *Alternately, this acknowledgment may appear in the software itself, 
 *if and wherever such third-party acknowledgments normally appear.
 *
 *4. The names "OpenTCP" and "Viola Systems" must not be used to 
 *endorse or promote products derived from this software without prior 
 *written permission. For written permission, please contact 
 *opentcp@opentcp.org.
 *
 *5. Products derived from this software may not be called "OpenTCP", 
 *nor may "OpenTCP" appear in their name, without prior written 
 *permission of the Viola Systems Ltd.
 *
 *THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED 
 *WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 *MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 *IN NO EVENT SHALL VIOLA SYSTEMS LTD. OR ITS CONTRIBUTORS BE LIABLE 
 *FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 *CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 *SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
 *BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 *OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 *EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *====================================================================
 *
 *OpenTCP is the unified open source TCP/IP stack available on a series 
 *of 8/16-bit microcontrollers, please see <http://www.opentcp.org>.
 *
 *For more information on how to network-enable your devices, or how to 
 *obtain commercial technical support for OpenTCP, please see 
 *<http://www.violasystems.com/>.
 */

/** \file config.h
 *	\ingroup opentcp_config
 *	\brief OpenTCP hardware configuration file
 *	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 20.9.2002
 * 	
 *	Various MCU and hardware-dependant configuration stuff is located here.
 */
#ifndef INCLUDE_CONFIG_H	/* USED TO CHECK THAT THERE IS SOME CHIP DEFINED */
#define INCLUDE_CONFIG_H

#define MB90F553A	/**<Define this for Fujitsu's MB90F553A MCU */



/*	Based on chip information, define certain constants here.
	These are used mostly in ethernet.c to make it as 
	platform independent as possible. For now only one */
	
/* what to include ? */
#ifdef MB90F553A

#include <inet/arch/mb90f553a/mb90550.h>

/* what to put to data direction registers to make them in/out */

#define DDR_OUT	0xFF	/**< Value for data direction register so that pins
						 *	 are configured as outputs
						 */
#define DDR_IN	0x00	/**< Value for data direction register so that pins
						 *	 are configured as inputs
						 */

/* ISA & Chip Specific bus signals	*/

#define 	DATABUS			PDR1		/**< Port used as databus towards
										 * 	 the Ethernet controller
										 */
#define		DATADIR			DDR1		/**< Data direction register for the 
										 *	data bus
										 */	
#define		ADRBUS			PDR2		/**< Port used as address bus towards
										 *	 the Ethernet controller
										 */									
#define		IOW				PDR2_P26	/**< Write pin */
#define		IOR				PDR2_P25	/**< Read pin */
#define		IOCHRDY			PDR0_P05	/**< IOCHRDY pin */

#define 	RESETPIN_NE2000	PDR2_P27	/**< Reset pin */

#endif	/* mb90f553a */


#endif
