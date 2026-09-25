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

/** \file dhcpc.h
 *	\brief OpenTCP DHCP client interface file
 *	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 23.5.2003
 * 	
 *	OpenTCP DHCP protocol function declarations, constants, etc.
 */

#ifndef INCLUDE_DHCPC_H
#define INCLUDE_DHCPC_H

#include <inet/datatypes.h>

#define DHCP_SERVER_PORT	67
#define DHCP_CLIENT_PORT	68

#define BOOT_REQUEST	1
#define BOOT_REPLY		2

/* DHCP client states */
#define DHCP_STATE_INIT_REBOOT	0
#define DHCP_STATE_REBOOTING	1
#define DHCP_STATE_INIT			2
#define DHCP_STATE_SELECTING	3
#define DHCP_STATE_REQUESTING	4
#define DHCP_STATE_BOUND		5
#define DHCP_STATE_RENEWING		6
#define DHCP_STATE_REBINDING	7

/* DHCP messages */
#define DHCP_DISCOVER	1
#define DHCP_OFFER		2
#define DHCP_REQUEST	3
#define DHCP_DECLINE	4
#define DHCP_ACK		5
#define DHCP_NAK		6
#define DHCP_RELEASE	7
#define DHCP_INFORM		8

/* DHCP options */
#define DHCP_OPT_PAD			0
#define DHCP_OPT_END			255
#define DHCP_OPT_SUBNET_MASK	1
#define DHCP_OPT_TIME_OFFSET	2
#define DHCP_OPT_ROUTER			3
#define DHCP_OPT_TIME_SERVER	4
#define DHCP_OPT_NAME_SERVER	5
#define DHCP_OPT_DNS_SERVER		6
#define DHCP_OPT_HOST_NAME		12
#define DHCP_OPT_POP3_SERVER	70
#define DHCP_OPT_REQUESTED_IP	50
#define DHCP_OPT_LEASE_TIME		51
#define DHCP_OPT_OVERLOAD		52
#define DHCP_OPT_MSG_TYPE		53
#define DHCP_OPT_SERV_IDENT		54
#define DHCP_OPT_PARAM_REQUEST	55
#define DHCP_OPT_T1_VALUE		58
#define DHCP_OPT_T2_VALUE		59

INT8 dhcpc_init(void);
void dhcpc_run(void);

#endif
