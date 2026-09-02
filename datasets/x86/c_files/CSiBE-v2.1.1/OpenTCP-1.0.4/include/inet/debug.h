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

/** \file debug.h
 *	\ingroup opentcp_config
 *	\brief OpenTCP file for debug options
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasytems.com)
 *	\version 1.0
 *	\date 10.9.2002
 * 	
 *	This file contains debug settings for OpenTCP and it's modules.
 *	Debugging in this case only assumes a function (named mputs) that 
 * 	sends a null-terminated string over a serial port.
 *
 *	In order for the debugging to work this function <b>must be</b> 
 *	implemented separately (this greately depends on your applications
 *	and hardware configuration so it was not implemented here). Empty
 *	mputs function is provided in system.c (not much help ;-)
 */
#ifndef	INCLUDE_DEBUG_H
#define INCLUDE_DEBUG_H

#include <inet/datatypes.h>
#include <inet/system.h>

/* User Settings									*/

#define DEBUG 	0		/**< Controls debugging on a global level and also
						 *	enables DEBUGOUT. Possible values are:
						 *		\li	0 - debugging messages disabled globally
						 *		\li 1 - debugging messages enabled globally.
						 *		DEBUGOUT will print messages. TCP/IP layers
						 *		that will print message are chosen
						 *		separately.
						 */


/* Choose modules that will be debugged 
 * works only if ((DEBUG == 1)&&(xxx_DEBUG==1))
 */
#define ETHERNET_DEBUG	0	/**< enable/disable Ethernet-level debug messages */
#define IP_DEBUG		0	/**< enable/disable IP-level debug messages */
#define ICMP_DEBUG		0	/**< enable/disable ICMP-level debug messages */
#define ARP_DEBUG		0	/**< enable/disable ARP-level debug messages */
#define TCP_DEBUG		0	/**< enable/disable TCP-level debug messages */
#define UDP_DEBUG		0	/**< enable/disable UDP-level debug messages */
#define TIMERS_DEBUG	0	/**< enable/disable Timer-level debug messages */

/****************************************************/
/* Do not modify if not needed						*/
/****************************************************/

#if DEBUG == 1

#define	DEBUGOUT(c);		mputs(c);

#if ETHERNET_DEBUG == 1
#define	ETH_DEBUGOUT(c);		mputs(c);
#else
#define ETH_DEBUGOUT(c);		{};
#endif

#if IP_DEBUG == 1
#define	IP_DEBUGOUT(c);			mputs(c);
#else
#define IP_DEBUGOUT(c);			{};
#endif

#if ICMP_DEBUG == 1
#define	ICMP_DEBUGOUT(c);		mputs(c);
#else
#define ICMP_DEBUGOUT(c);		{};
#endif

#if ARP_DEBUG == 1
#define	ARP_DEBUGOUT(c);		mputs(c);
#else
#define ARP_DEBUGOUT(c);		{};
#endif

#if TCP_DEBUG == 1
#define	TCP_DEBUGOUT(c);		mputs(c);
#else
#define TCP_DEBUGOUT(c);		{};
#endif

#if UDP_DEBUG == 1
#define	UDP_DEBUGOUT(c);		mputs(c);
#else
#define UDP_DEBUGOUT(c);		{};
#endif

#if TIMERS_DEBUG == 1
#define	TMR_DEBUGOUT(c);		mputs(c);
#else
#define	TMR_DEBUGOUT(c);		{};
#endif

#else
/* everything turned off because DEBUG == 0*/
#define DEBUGOUT(c);		{};

#define ETH_DEBUGOUT(c);		{};
#define IP_DEBUGOUT(c);			{};
#define ICMP_DEBUGOUT(c);		{};
#define ARP_DEBUGOUT(c);		{};
#define TCP_DEBUGOUT(c);		{};
#define UDP_DEBUGOUT(c);		{};
#define	TMR_DEBUGOUT(c);		{};

#endif

#endif		/* Include	*/

