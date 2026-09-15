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

/** \file arp.h
 *	\brief OpenTCP ARP interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 * 	
 *	OpenTCP ARP protocol function declarations, constants, etc.
 */
#ifndef INCLUDE_ARP_H
#define INCLUDE_ARP_H

#include <inet/datatypes.h>
#include <inet/system.h>
#include <inet/ethernet.h>
#include <inet/ip.h>

/* User Allowed to modify	*/


#define	MAXHWALEN		6		/**< Maximum HW address Length (6=Eth)*/
#define MAXPRALEN		4		/**< Maximum Protocol adr.len (4=IPv4)*/

/** \def ARP_TSIZE
 * 	\ingroup opentcp_config
 *	\brief ARP cache size (number of entries)
 *
 *	Change this number to change ARP cache size (number of cached 
 *	ARP:IP address pairs).
 *
 *	Changing this values affects memory consumption as well as processing
 *	power needed to manage the ARP cache. If a device communicates with 
 *	a limited number of hosts, this cache size may be smaller, thus 
 *	reducing memory requirements. Small cache size may, however, reduce
 *	performance when communicating with more hosts than there are cache
 *	entries available.
 */
#define ARP_TSIZE		10	

/** \def ARP_TIMEOUT
 * 	\ingroup opentcp_config
 *	\brief ARP cache entry refresh period (in seconds)
 *
 *	Change this number to change refresh period of ARP cache entries.
 *
 *	Changing this values changes the amount of ARP refreshes performed 
 *	and thus can change processing power used when refreshing the entries.
 */
#define ARP_TIMEOUT		60

/** \def ARP_RESEND
 * 	\ingroup opentcp_config
 *	\brief ARP Request resend period (in seconds)
 *
 *	Change this number to determine how quickly will ARP module issue
 *	ARP requests.
 *
 *	Changing this values changes the amount time that will elapse before
 *	ARP module resends it's ARP request in case no response has been
 *	received. Change this number according to expected network latency and
 *	desired resolving speed.
 */

#define ARP_RESEND		2	

/** \def ARP_MAXRETRY
 * 	\ingroup opentcp_config
 *	\brief Number of IP address resolving retires
 *
 *	Change this number to change number of times ARP module will resend
 *	ARP requests before giving up (if no ARP reply is received).
 */	
#define ARP_MAXRETRY	5		/**< Give up after x times			*/


/* System constants, don't modify	*/

#define AR_HARDWARE		0x0001	/* Ethernet hardware type code		*/
#define ARP_ETHCODE		0x0806	/* ARP over Ethernet				*/

#define ARP_REQUEST		1		/* ARP Request to resolve address	*/
#define ARP_REPLY		2		/* Reply to resolve request			*/

#define	ARP_MANG_TOUT	1		/* Interval between ARP cache mngmt. */

/** \struct arp_entry arp.h 
 *	\brief ARP packet header fields
 *
 *	This structure contains various fields used for managing ARP cache.
 *
 *
 */
struct arp_entry
{
	/** \brief State of this ARP cache entry
	 *
	 *	Holds information about the state of this ARP cache entry. Can
	 *	hold one of the following values:
	 *		\li ARP_FREE - entry unused and available
	 *		\li	ARP_RESERVED - entry reserved by arp_alloc call
	 *		\li ARP_PENDING - waiting for ARP reply to get the HW address
	 *		\li ARP_RESOLVED - entry resolved and HW address available
	 */
	UINT8	state;
	
	/** \brief Type of this ARP cache entry
	 *
	 *	Type of the entry defines what the ARP cache manager will do 
	 *	after the TTL period. Can be one of the following:
	 *		\li ARP_FIXED_IP - ARP cache entry is refreshed after TTL
	 *		\li ARP_TEMP_IP	- ARP cache entry is deleted after TTL
	 */				
	 
	UINT8	type;				
	UINT8	retries;			/**< Number of retries left (how many
								 *	ARP requests more will be sent in order
								 *	to try to resolve the IP address)
								 */
	UINT8	ttl;				/**< Time To Live value for this cache 
								 *	entry
								 */
	UINT8	hwadr[MAXHWALEN];	/**< Hardware Address that is received either
								 * 	as an ARP reply or by caching the
								 *	address of a received IP packet
								 */
	UINT32	pradr;				/**< Protocol Address (IP protocol assumed)	*/

};

/* Arp Entry States	*/

#define	ARP_FREE		0		/**< Entry is Unused (initial value)	*/
#define ARP_RESERVED	1		/**< Entry is reserved (allocated)	*/
#define ARP_PENDING		2		/**< Entry is used but incomplete		*/
#define	ARP_RESOLVED	3		/**< Entry has been resolved			*/
#define ARP_REFRESHING	4		/**< Entry is being refreshed			*/



/* Arp Entry Types	*/

#define	ARP_FIXED_IP	0		/**< For Fixed addresses like GW. Entry is refreshed after ttl	*/
#define	ARP_TEMP_IP		1		/**< For Temporary addresses. Entry is removed after ttl		*/
								
								

/* ARP Functions	*/
void arp_init(void);
struct arp_entry* arpfind(LWORD, struct netif*, UINT8);
INT8 arp_alloc(UINT8);
void arp_send_req(UINT8);
struct arp_entry* arp_find (LWORD , struct netif *, UINT8 );
void arp_manage(void);
BYTE is_subnet(LWORD, struct netif*);
BYTE process_arp(struct ethernet_frame*);
void arp_send_response(void);
void arp_get_response(void);
void arp_send_request(void);
INT8 arp_add(UINT32, UINT8*, UINT8);

#endif

