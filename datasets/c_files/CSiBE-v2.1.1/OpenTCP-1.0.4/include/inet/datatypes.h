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

/** \file datatypes.h
 *	\ingroup opentcp_config
 *	\brief OpenTCP definitions of datatypes of certain length
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 * 	
 *	This file holds #defines of data types used in the OpenTCP
 *	sources so that recompiling for another MCU is easier even
 *	when the other MCU is using different size default values.
 *
 *	Constants that need to be defined in this file for every 
 *	microcontroller and/or compiler are:
 *		\li BYTE	- unsigned 8 bit value
 *		\li WORD	- unsigned 16 bit value
 *		\li LWORD 	- unsigned 32 bit value
 *		\li UINT8	- unsigned 8 bit value
 *		\li INT8	- signed 8 bit value
 *		\li UINT16	- unsigned 16 bit value
 *		\li INT16	- signed 16 bit value
 *		\li UINT32	- unsigned 32 bit value
 *		\li INT32	- signed 32 bit value
 */
#ifndef INCLUDE_DATATYPES_H
#define INCLUDE_DATATYPES_H

#include<inet/arch/config.h>

#ifdef MB90F553A

#define BYTE 	char				
#define WORD 	unsigned short		/**< 16 bit unsigned */
#define LWORD	unsigned long		/**< 32 bit unsigned */

#define UINT8	char				/**< 8 bit unsigned */
#define INT8	signed char			/**< 8 bit signed */
#define	UINT16	unsigned short		/**< 16 bit unsigned */
#define INT16	short				/**< 16 bit signed */
#define UINT32	unsigned long		/**< 32 bit unsigned */
#define INT32 	long				/**< 32 bit signed */

#endif MB90F553A

#endif


