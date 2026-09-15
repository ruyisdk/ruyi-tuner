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

/** \file http_server.h
 *	\brief OpenTCP HTTP interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 13.10.2002
 * 	
 *	OpenTCP HTTP function declarations, constants, etc.
 */
#ifndef INCLUDE_HTTP_SERVER_H
#define INCLUDE_HTTP_SERVER_H

#include <inet/datatypes.h>

/**	\def NO_OF_HTTP_SESSIONS
 *	\brief Defines number of simultaneous HTTP sessions
 *
 *	Change this define to change how many simultaneous HTTP sessions will
 *	be possible at any given time. Note that this will require at least
 *	as much TCP sockets, so change #NO_OF_TCPSOCKETS also!
 */
#define NO_OF_HTTP_SESSIONS		3

/**	\def HTTPS_SERVERPORT
 *	\brief HTTP server port on which we'll listen
 *
 *	This defines on what TCP port the HTTP server will listen for incoming
 *	connections/requests. For HTTP standard port is 80.
 */
#define HTTPS_SERVERPORT		80


#define HTTPS_STATE_FREE		1	/**< HTTP Server state: session entry free
									 *	and available
									 */
#define HTTPS_STATE_RESERVED	2	/**< HTTP Server state: session entry is
									 *	reserved and therefore not available
									 */
#define HTTPS_STATE_ACTIVE		3	/**< HTTP Server state: session entry (and
									 *	the session itself) are active.
									 */
									 
/** \struct http_server_state http_server.h
 *	\brief Structure that holds all the necessary state information for 
 *		session management
 *
 *	All the necessary information for HTTP session state management by the
 *	HTTP server is stored here. See individual field documentation for more
 *	info.
 */
struct http_server_state{
	/**	\brief Session state
	 *
	 *	This variable holds current sessions' state which can be one of the
	 *	following:
	 *		\li #HTTPS_STATE_FREE
	 *		\li	#HTTPS_STATE_RESERVED
	 *		\li #HTTPS_STATE_ACTIVE
	 */
	UINT8 state;
	
	/**	\brief TCP socket used for TCP communication
	 *
	 *	This variable holds a handle to TCP socket that is used to achieve
	 *	data transfer.
	 */
	UINT8 ownersocket;
	
	/**	\brief File start
	 *
	 *	This variable holds information about the file start address. This 
	 * 	is highlyconfiguration-dependant (file system chosen, etc..)
	 *
	 *	<b> File address can not start from zero!!! (Data won't be sent
	 *	by HTTP server in this case) </b>
	 */
	UINT32 fstart;

	/**	\brief File length
	 *
	 *	This variable holds file length information. It is used by the HTTP
	 *	server to determine when the entire file has been sent.
	 */
	UINT32 flen;

	/**	\brief File pointer
	 *
	 *	Pointer to a current position inside the file that is beeing sent 
	 *	over the appropriate HTTP session.
	 */	
	UINT32 fpoint;
	
	/**	\brief Number of unacknowledged HTTP bytes previously sent
	 *
	 *	This variable holds information about the number of previously sent
	 *	and still unacknowledged bytes. This is needed to reliably determine,
	 *	in case data needs to be regenerated, how much bytes to regenerate or,
	 *	in case data has been acknowledged, how much to advance the fpoint
	 *	variable.
	 */	
	UINT16 funacked;

};

extern struct http_server_state https[];

INT32 https_eventlistener(INT8, UINT8, UINT32, UINT32);
INT8 https_init(void);
void https_run(void);
void https_deletesession(UINT8);
INT16 https_searchsession(UINT8);
INT16 https_bindsession(UINT8);
void https_activatesession(UINT8);
INT16 https_calculatehash(UINT32);
INT16 https_findfile(UINT8, UINT8);
INT16 https_loadbuffer(UINT8, UINT8*, UINT16);

#endif
