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
 
/** \file ip.h
 *	\brief OpenTCP IP interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 11.6.2002
 * 	
 *	OpenTCP IP function declarations, constants, etc.
 */

#ifndef INCLUDE_IP_H
#define INCLUDE_IP_H

#include<inet/datatypes.h>
#include<inet/ethernet.h>

#define PHY_ADR_LEN			ETH_ADDRESS_LEN	/**<Lower-layer physical address length */

#define IP_ICMP				0x01	/**< ICMP over IP */
#define IP_UDP				17		/**< UDP over IP */
#define IP_TCP  			6		/**< TCP over IP */

#define IP_HLEN				20				/* IP Header Length in bytes			*/
#define IP_MIN_HLEN			20		
#define IP_DEF_VIHL			0x45
#define IP_DEF_TTL			100
#define MAX_IP_OPTLEN		40				/* Max IP Header option field length	*/
#define IP_MAX_HLEN			IP_MIN_HLEN + MAX_IP_OPTLEN

#define IP_DONT_FRAGMENT 	0x4000			/* Don't Fragment Flag			*/
#define IP_FRAGOFF		 	0x1FFF			/* Fragment offset mask			*/
#define IP_MOREFRAGS	 	0x2000			/* More fragments bit			*/

#define	IP_GOOD_CS			0

/* IP Option control commands	*/

#define IPO_COPY		 	0x80			/* Copy on fragment mask		*/
#define IPO_NOP			 	0x01			/* No operation					*/
#define IPO_EOOP		 	0x00			/* End of options				*/

/* Reserved addresses		*/

#define	IP_BROADCAST_ADDRESS	0xFFFFFFFF	/* 255.255.255.255	*/

/** \struct ip_frame ip.h
 *	\brief IP datagram header fields
 *
 *	This structure is used for holding information about various fields
 *	of the IPv4 header. In addition to standard IP header, buf_index
 *	variable has been added to store the information about the buffer
 *	address in the Ethernet controller from where upper layer protocols (
 *	such as TCP, UDP or some other) can start reading their data. This
 *	is initialized by invoking NETWORK_RECEIVED_INITIALIZE macro with 
 *	appropriate buf_index value.
 *
 *	For detailed explanation of the IPv4 header fields refer to RFC791.
 */

struct ip_frame
{
	UINT8	vihl;					/**< Version & Header Length field	*/
	UINT8	tos;					/**< Type Of Service				*/
	UINT16  tlen;					/**< Total Length					*/
	UINT16	id;						/**< IP Identification number		*/
	UINT16  frags;					/**< Flags & Fragment offsett		*/
	UINT8	ttl;					/**< Time to live					*/
	UINT8	protocol;				/**< Protocol over IP				*/
	UINT16 	checksum;				/**< Header Checksum				*/
	UINT32	sip;					/**< Source IP address				*/
	UINT32	dip;					/**< Destination IP address			*/
	UINT8	opt[MAX_IP_OPTLEN + 1]; /**< Option field					*/
	UINT16	buf_index;				/**< Next offset from the start of
									 * 	 network buffer				
									 */
	
};

/* IP function prototypes	*/

INT16 process_ip_in(struct ethernet_frame*);
INT16 process_ip_out(UINT32, UINT8, UINT8, UINT8, UINT8*, UINT16);
UINT8 ip_check_cs(struct ip_frame*);
UINT16 ip_checksum(UINT16, UINT8, UINT8);
UINT32 ip_checksum_buf (UINT16 cs, UINT8* buf, UINT16 len);
UINT32 ip_construct_cs(struct ip_frame*);

#endif
