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

/** \file globalvariables.h
 *	\brief OpenTCP global variables declarations
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 * 	
 *	Here are declarations of global variables that are commonly used in
 *	other OpenTCP modules as well as OpenTCP applications in general. 
 *	Basically just a bunch of externs.
 */

#ifndef INCLUDE_GLOBALVARIABLES_H
#define INCLUDE_GLOBALVARIABLES_H

#include <inet/datatypes.h>
#include <inet/ethernet.h>
#include <inet/ip.h>
#include <inet/tcp_ip.h>

extern UINT8	NE2000NextPktPtr;			/* Start address of next packet */
extern UINT8 	NE2000CurrPktPtr;			/* Start address of current packet */

extern UINT32 	base_timer;					/* System 1 msec timer	*/

/* Buffers					*/
extern UINT8 	net_buf[];	/**< See system.c */

/* May the send & receive frames use the same structure?	*/

extern struct ethernet_frame received_frame;	/**< See ethernet.c */
extern struct ethernet_frame send_frame;		/**< See ethernet.c */
extern struct netif localmachine;				/**< <b> MUST BE PUT SOMEWHERE </b> */ 
extern struct ip_frame received_ip_packet;		/**< See ip.c */
extern struct ip_frame send_ip_packet;			/**< See ip.c */
extern struct udp_frame received_udp_packet;	/**< See udp.c */
extern struct tcp_frame received_tcp_packet;	/**< see tcp.c */

#endif

