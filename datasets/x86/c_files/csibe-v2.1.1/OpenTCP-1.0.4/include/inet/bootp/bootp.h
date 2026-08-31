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

/** \file bootp.h
 *	\brief OpenTCP BOOTP client interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 * 	
 *	OpenTCP BOOTP client function declarations, constants, etc.
 */

#ifndef INCLUDE_BOOTPC_H
#define INCLUDE_BOOTPC_H

#include<inet/datatypes.h>

#define BOOTP_RETRY_TOUT	5	/**< How many seconds to pass before retrying*/

#define BOOTP_CLIENTPORT	68	/**< Local BOOTP client port that will
								 *	be used for sending requests */
#define BOOTP_SERVERPORT	67	/**< BOOTP server's port */

#define BOOTPC_STATE_DISABLED		0	/**< BOOTP client intentionally disabled */
#define BOOTPC_STATE_ENABLED		1	/**< BOOTP initialized and waiting
										 * 	 to send initial BOOTP request
										 */
#define BOOTPC_STATE_REQUEST_NEEDED	2	/**< New (or first) BOOTP requests
										 *	 must be issued 
										 */
#define BOOTPC_STATE_WAITING_REPLY	3	/**< After issuing the request BOOTP
										 *	 is in this state waiting either
										 *	 for timeout or a response from
										 *	 the BOOTP server
										 */
#define BOOTPC_STATE_REPLY_GET		4	/**< Once we get into this state,
										 *	 proper reply has been received
										 *	 from the BOOTP server
										 */
							

#define BOOTP_OPTION_SUBNETMASK		1	/**< Subnet mask option BOOTP client
										 *   is waiting for in the reply 
										 *	 from the BOOTP server
										 */
#define	BOOTP_OPTION_DEFGW			3	/**< Default gateway option BOOTP client
										 *   is waiting for in the reply 
										 *	 from the BOOTP server
										 */

#define BOOTP_REPLY				2
#define BOOTP_HWLEN_ETHERNET	6
#define BOOTP_HTYPE_ETHERNET	1

INT8 init_bootpc(UINT8);
INT8 bootpc_enable(void);
void bootpc_stop(void);
void bootpc_run(void);
INT32 bootpc_eventlistener(INT8, UINT8, UINT32, UINT16, UINT16, UINT16);

#endif
