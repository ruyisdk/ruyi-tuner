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

/** \file dns.h
 *	\brief OpenTCP DNS interface file
 *	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 10.9.2002
 * 	
 *	OpenTCP DNS protocol function declarations, constants, etc.
 */
#ifndef INCLUDE_DNS_H
#define INCLUDE_DNS_H

#include <inet/datatypes.h>


#define DNS_UDP_PORT	53	/**< DNS client will use this port 
							 *	 for sending and receiving of DNS packets
							 */

#define DNS_SERVER_IP	0xac100201  /**< DNS server's IP address */

#define DNS_RESEND_PERIOD	2			/**< Period in seconds for resending
										 * 	 DNS requests
										 */
#define DNS_NUM_RETRIES		5			/**< Number of retries that DNS
										 *	client will perform before
										 *	aborting name resolving
										 */

/* Events for event listener */
#define DNS_EVENT_ERROR				0	/**< Error event reported by DNS 
										 *	 client to event_listener
										 */
#define DNS_EVENT_SUCCESS			1	/**< Resolving successfull event
										 *	 reported by DNS client to 
										 *	 event_listener
										 */

/* First five errors (from RFC1035) which we transfer to event listener 
	plus a couple of our own
*/
#define DNS_ERROR_FORMAT			1	/**< The name server was unable to 
										 *	 interpret the query (RFC1035)
										 */
#define DNS_ERROR_SERVER_FAILURE	2	/**< The name server was unable to
										 *	 process this query due to a
										 *	 problem with the name server
										 *	 (RFC1035)
										 */
#define DNS_ERROR_NAME_ERROR		3	/**< Meaningful only for responses
										 *	 from an authoritative name
										 *	 server, this code signifies
										 *	 that the domain name referenced
										 *	 in the query does not exist
										 *	 (RFC1035)
										 */
#define DNS_ERROR_NOT_IMPLEMENTED	4	/**< The name server does not
										 *	 support the requested kind of
										 *	 query (RFC1035)
										 */
#define DNS_ERROR_REFUSED			5	/**< The name server refuses to
										 *	 perform the specified operation
										 *	 for policy reasons. (RFC 1035)
										 */
/* code 6-15 reserved for future use */
#define DNS_ERROR_TIMEOUT			16	/**< Timeout occured while DNS
										 *	 was trying to resolve the host
										 *	 name. New request should be
										 *	 issued if the address is needed
										 */
#define DNS_ERROR_GENERAL			17	/**< General (not specific) error
										 *	 occured while resolving host
										 *	 name.
										 */

/* Error codes returned from get_host_by_name(): */
/* Other error codes (besides those listed below) are:		
	-1 - general error
	-2 - arp not ready
	-3 - socket handle error
*/
#define DNS_ERROR_BUSY		-4	/**< Returned from get_host_by_name(): DNS
							     *	 client is currently busy with another
							     *	 request and is unable the process a new
							     *	 one
							     */
#define DNS_ERROR_LABEL		-5	/**< Returned from get_host_by_name(): Part 
								 *	 of the host name (label) consists of
								 *	 more than 63 characters.
								 */
#define DNS_ERROR_NAME		-6	/**< Returned from get_host_by_name(): Host
								 *	 name too long (more than 263 bytes)
								 */
#define DNS_ERROR_OVERFLOW	-7	/**< net_buf too small for the entire 
								 *	 DNS request to be stored in it.
								 */


UINT8 get_host_by_name(UINT8 *host_name_ptr,void (*listener)(UINT8 , UINT32 ));

void dns_init(void);

void dns_run(void);

INT32 dns_eventlistener(INT8 , UINT8 , UINT32 , UINT16 , UINT16 , UINT16);

#endif
