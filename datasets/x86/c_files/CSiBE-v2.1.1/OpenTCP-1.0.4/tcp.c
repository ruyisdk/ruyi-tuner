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

/** \file tcp.c
 *	\brief OpenTCP TCP implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Check if tcp_tempbuf can be thrown out and net_buf
 *		used instead. Application normally don't use the first part
 *		of tcp_tempbuf anyway and there shouldn't be any overlapping
 *		with other applications (TCP/UDP) either.
 *		\li	There's probably no need for that <b>+1</b> for determining
 *		the size of tcp_tempbuf. But if previous TODO is possible,
 *		this isn't important anyway.
 *		\li Implement per-socket window size (just add API function)
 *
 *	OpenTCP TCP implementation. All functions necessary for TCP
 *	processing are present here. Note that only a small subset
 *	of these functions must be used for "normal" applications that
 *	are using the TCP for communciation. For function declarations and
 *	lots of other usefull stuff see inet/tcp_ip.h.
 *
 *	For examples how to use TCP and write applications that communicate
 *	using TCP see inet/demo/main_demo.c, inet/demo/tcp_client_demo.c and
 *	inet/demo/tcp_server_demo.c.
 *
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/timers.h>
#include <inet/ethernet.h>
#include <inet/ip.h>
#include <inet/tcp_ip.h>
#include <inet/system.h>

/**	\brief Used for storing field information about the received TCP packet
 *	
 *	Various fields from the TCP packet are stored in this variable. These
 *	values are then used to perform the necessary actions as defined 
 *	by the TCP specification: correctnes of the received TCP packet is
 *	checked by analyzing these fields, appropriate socket data is adjusted
 *	and/or control packet is sent based on it. See tcp_frame definition 
 * 	for struct information.
 */
struct tcp_frame received_tcp_packet;

/** \brief TCP table holding connection parameters for every TCP socket 
 *
 *	TCP table is an array of tcp_socket structures holding all of the 
 * necessary information about the state, timers, timeouts and sequence
 *	and port numbers of the TCP sockets opened. Number of TCP sockets
 *	that can be opened at any given time is defined by the #NO_OF_TCPSOCKETS
 *	and may be changed in order to change the amount of used RAM memory.
 *	See tcb definition for more information about the structure itself.
 *
 *	\note As seen in the code, an array size is actually bigger for one
 *	than the #NO_OF_TCPSOCKETS defines. The last entry is used for sending
 *	control packets as answers to incoming TCP packets that do not map 
 *	to any existing TCP sockets.
 */
struct tcb tcp_socket[NO_OF_TCPSOCKETS + 1]; 

UINT8 tcp_tempbuf[MIN_TCP_HLEN + 1]; /**< Temporary buffer used for sending TCP control packets */


/***********************************************************************/
/*******	TCP API functions									********/
/***********************************************************************/

/** \brief Allocate a free socket in TCP socket pool
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param soctype type of socket wanted. Can take one of the following
 *		values:
 *		\li #TCP_TYPE_NONE
 *		\li #TCP_TYPE_SERVER
 *		\li #TCP_TYPE_CLIENT
 *		\li #TCP_TYPE_CLIENT_SERVER
 *	\param tos type of service for socket. For now only #TCP_TOS_NORMAL.
 *	\param tout Timeout of socket in seconds. Defines after how many seconds
 *		of inactivity (application not sending and/or receiving any data
 *		over TCP connection) will the TCP socket automatically be closed.
 *	\param listener pointer to callback function that will be invoked by
 *		the TCP/IP stack to inform socket application of certain events. See
 *		tcpc_demo_eventlistener() and tcps_demo_eventlistener() for more
 *		information on events and possible actions.
 *	\return 
 *		\li -1 - Error getting requested socket
 *		\li >=0 - Handle to reserved socket
 *
 *	Invoke this function to try to obtain a free socket from TCP socket pool.
 *	Function returns a handle to the free socket that is later used for 
 *	accessing the allocated socket (opening, connecting, sending data,
 *	closing, aborting, etc.).
 */
INT8 tcp_getsocket (UINT8 soctype, UINT8 tos, UINT16 tout, INT32 (*listener)(INT8, UINT8, UINT32, UINT32) )
{
	INT8 i;
	struct tcb* soc;
	
	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( (soctype != TCP_TYPE_SERVER) &&
		(soctype != TCP_TYPE_CLIENT) &&
		(soctype != TCP_TYPE_CLIENT_SERVER) &&
		(soctype != TCP_TYPE_NONE)				) {
		TCP_DEBUGOUT("Invalid socket type requested\r\n");
		return(-1);
	}
	
	if(listener == 0) {
		TCP_DEBUGOUT("ERROR:Event listener function not specified\r\n");
		return(-1);
	}
	
	TCP_DEBUGOUT("Searching for free TCP socket...\r\n");
	
	for(i=0; i < NO_OF_TCPSOCKETS; i++)	{
		soc = &tcp_socket[i];			/* Get Socket	*/
	
		if(soc->state == TCP_STATE_FREE) {
			/* We found it	*/
			
			TCP_DEBUGOUT("Free socket found\r\n");
			
			soc->state = TCP_STATE_RESERVED;
			soc->type = soctype;
			soc->tos = tos;
			soc->event_listener = listener;
			soc->rem_ip = 0;
			soc->remport = 0;
			soc->locport = 0;
			soc->flags = 0;
			soc->tout = tout*TIMERTIC;
			
			return(i);
		}
	
	}
	
	/* We are there so no socket found	*/
	
	TCP_DEBUGOUT("No socket found\r\n");
	return(-1);

}

/** \brief Release a TCP socket
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to socket to be released
 *	\return 
 *		\li -1 - Error releasing the socket (Wrong socket handle or socket
 *		not in proper state to be released)
 *		\li >=0 - handle of the released socket (can not be used any more
 *		untill allocated again with tcp_getsocket()).
 *
 *	Once the application does not need the TCP socket any more it can invoke
 *	this function in order to release it. This is usefull if there is a very
 *	limited number of sockets (in order to save some memory) shared among
 *	several applications.
 */
INT8 tcp_releasesocket (INT8 sochandle)
{
	struct tcb* soc;
	
	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/
	
	if( (soc->state != TCP_STATE_FREE) &&
		(soc->state != TCP_STATE_RESERVED) &&
		(soc->state != TCP_STATE_CLOSED)		) {
		TCP_DEBUGOUT("Socket is not on valid state to be released\r\n");
		return(-1);
	}
	
	/* We are there so all OK	*/
	
	soc->state = TCP_STATE_FREE;
	soc->type = TCP_TYPE_NONE;
	soc->tos = 0;
	soc->event_listener = 0;
	soc->rem_ip = 0;
	soc->remport = 0;
	soc->locport = 0;
	soc->flags = 0;
	
	return(sochandle);

}

/** \brief Put TCP socket to listen on a given port
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to socket to be placed to listen state
 *	\param port TCP port number on which it should listen
 *	\return
 *		\li -1 - Error
 *		\li >=0 - OK (Socket put to listening state. Handle to 
 *		socket returned)
 *
 *	This function will attempt to put socket to listening state. This
 *	is only possible if socket was defined as either #TCP_TYPE_SERVER or
 *	#TCP_TYPE_CLIENT_SERVER. If basic correctness checks pass, socket is 
 *	put to listening mode and corresponding tcb entry is initialized.
 *
 */
INT8 tcp_listen (INT8 sochandle, UINT16 port)
{
	struct tcb* soc;

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/
		
	if( (soc->type & TCP_TYPE_SERVER) == 0 ) {
		TCP_DEBUGOUT("Socket has no server properties\r\n");
		return(-1);
	}
	
	if( soc->event_listener == 0) {
		TCP_DEBUGOUT("ERROR:No event listener function specified\r\n");
		return(-1);
	}
	
	
	if( (soc->state != TCP_STATE_RESERVED) &&
		(soc->state != TCP_STATE_LISTENING)	&&
		(soc->state != TCP_STATE_CLOSED) &&		
		(soc->state != TCP_STATE_TIMED_WAIT)		) {
		TCP_DEBUGOUT("Not possible to listen, socket on connected state\r\n");
		return(-1);
	
	}
	
			
	/* Init socket		*/
				
	soc->state = TCP_STATE_LISTENING;
	/*soc->type = TCP_TYPE_SERVER;*/
	soc->flags = 0;
	soc->rem_ip = 0;
	soc->remport = 0;
	soc->locport = port;
	soc->send_unacked = 0;
	soc->myflags = 0;
	soc->send_next = 0xFFFFFFFF;
	soc->send_mtu = TCP_DEF_MTU;
	soc->receive_next = 0;
	soc->retries_left = 0;
			
	TCP_DEBUGOUT("TCP listening socket created\r\n");
			
	return(sochandle);

}


/** \brief Initialize connection establishment towards remote IP&port
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to socket to be used for connection establishment
 *	\param ip remote IP address to connect to 
 *	\param rport remote port number to connect to
 *	\param myport local port to use for connection. This value can be
 *		specified directly or, if a value of 0 is given, TCP module will
 *		determine local TCP port automatically.
 *	\return 
 *		\li -1 - Error
 *		\li >=0 - OK (Connection establishment procedure started. Socket handle
 *			returned.)
 *
 *	Invoke this function to start connection establishment procedure towards
 *	remote host over some socket. This is only possible if socket was
 *	defined as either #TCP_TYPE_CLIENT or #TCP_TYPE_CLIENT_SERVER. Function 
 *	will make some basic checks and if everything is OK, corresponding tcb
 *	socket entry will be initialized and connection procedure started.
 */
INT8 tcp_connect (INT8 sochandle, UINT32 ip, UINT16 rport, UINT16 myport )
{
	struct tcb* soc;
	
	TCP_DEBUGOUT("FUNCTION: tcp_connect\r\n");

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	/* Is the local port defined	*/
	
	if( myport == 0 )
		myport = tcp_getfreeport();
	
	if( myport == 0 )
		return(-1);
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/
	
	/* Do we have client properties?	*/
	
	if( (soc->type & TCP_TYPE_CLIENT) == 0 ) {
		TCP_DEBUGOUT("Socket has no client properties\r\n");
		return(-1);
	}
	
	if( soc->event_listener == 0) {
		TCP_DEBUGOUT("ERROR:No event listener function specified\r\n");
		return(-1);
	}
	
	/* Are we on LISTENING, RESERVED or CLOSED state	*/
	
	if( (soc->state != TCP_STATE_RESERVED) &&
		(soc->state != TCP_STATE_LISTENING) &&
		(soc->state != TCP_STATE_CLOSED)		) {
		TCP_DEBUGOUT("Socket on unvalid state to initialize CONNECT\r\n");
		return(-1);
	}
	
	/* Then just set parameters and send SYN	*/
	
	soc->rem_ip = ip;
	soc->remport = rport;
	soc->locport = myport;
	soc->flags = 0;
	soc->send_mtu = TCP_DEF_MTU;
	
	/* get initial sequence number	*/
	
	soc->send_unacked = tcp_initseq(); 
	soc->send_next = soc->send_unacked + 1;
	soc->myflags = TCP_FLAG_SYN;
	tcp_sendcontrol(sochandle);
	tcp_newstate(soc, TCP_STATE_SYN_SENT);
	
	return(sochandle);
}



/** \brief Send user data over TCP using given TCP socket
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 25.07.2002
 *	\param sockethandle handle to TCP socket to be used for sending data
 *	\param buf pointer to data buffer (start of user data)
 *	\param blen buffer length in bytes (without space reserved at the
 *		beginning of buffer for headers)
 *	\param dlen length of user data to be sent (in bytes)
 *	\return 
 *		\li -1 - Error
 *		\li >0 - OK (number represents number of bytes actually sent)
 *
 *	\warning
 *		\li <i>buf</i> parameter is a pointer to data to be sent in 
 *		user buffer. But note that there <b>MUST</b> be sufficient
 *		free buffer space before that data for TCP header (of #MIN_TCP_HLEN
 *		size). 
 *
 *	Invoke this function to initiate data sending over TCP connection
 *	established over a TCP socket. Since data is not buffered (in order
 *	to reduce RAM memory consumption) new data can not be sent until
 *	data that was previously sent is acknowledged. So, application knows when
 *	it can send new data either by:
 *		\li waiting for TCP_EVENT_ACK in event_listener function
 *		\li invoking tcp_check_send() function to check if it is possible
 *			to send data
 *
 */
INT16 tcp_send (INT8 sockethandle, UINT8* buf, UINT16 blen, UINT16 dlen)
{
	struct tcb* soc;
	UINT8 i;

	
	TCP_DEBUGOUT("Entering to send TCP data packet\r\n");
	
	kick_WD();
	
	if( sockethandle < 0 ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (<0)\r\n");
		return(-1);
	}
	
	if( sockethandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (>NO_OF_TCPSOCKETS)\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sockethandle];				/* Get socket	*/
	
	if(soc->state != TCP_STATE_CONNECTED) {
		TCP_DEBUGOUT("TCP is not connected!!\r\n");
		return(-1);
	}
	
	if(soc->send_unacked != soc->send_next) {
		TCP_DEBUGOUT("TCP contains unacked data, cannot send more\r\n");
		return(-1);
	}
	
	if( dlen > blen )
		dlen = blen;
	
	if(dlen + MIN_TCP_HLEN > soc->send_mtu) {
		if(soc->send_mtu > MIN_TCP_HLEN)
			dlen = soc->send_mtu - MIN_TCP_HLEN;
		else
			return(-1);
	}
	
	soc->send_next += dlen;
	
	soc->myflags = TCP_FLAG_ACK | TCP_FLAG_PUSH;
	process_tcp_out(sockethandle, buf - MIN_TCP_HLEN, blen + MIN_TCP_HLEN + 1, dlen);
	
	return(dlen);
}


/** \brief Initiate TCP connection closing procedure
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to socket on which TCP connection is to be closed
 *	\return 
 *		\li -2 - there is unacked data on this socket. Try again later.
 *		\li -1 - Error
 *		\li >=0 - OK (connection closing procedure started. Handle to socket
 *			returned)
 *
 *	Invoke this function to start connetion closing procedure over a given
 *	socket. Note that connection is not immediately closed. It may take some
 *	time for that to happen. Event_listener function will be invoked with 
 *	appropriate event when that really happens.
 */
INT8 tcp_close (INT8 sochandle)
{
	struct tcb* soc;
	
	TCP_DEBUGOUT("FUNCTION: tcp_close\r\n");

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/	
	
	switch(soc->state) {
		case TCP_STATE_LISTENING:
			tcp_newstate(soc, TCP_STATE_CLOSED);
			break;
		
		case TCP_STATE_SYN_RECEIVED:
			soc->myflags = TCP_FLAG_ACK | TCP_FLAG_FIN;
			soc->send_unacked++;
			soc->send_next++;
			tcp_sendcontrol(sochandle);
			tcp_newstate(soc, TCP_STATE_FINW1);
			break;
		
		case TCP_STATE_SYN_SENT:
		
			tcp_newstate(soc, TCP_STATE_CLOSED);
		
			break;
		
		case TCP_STATE_FINW1:
		case TCP_STATE_FINW2:
		case TCP_STATE_CLOSING:
		case TCP_STATE_TIMED_WAIT:
		case TCP_STATE_LAST_ACK:
		
			/* We are closing already	*/
			
			break;
		
		case TCP_STATE_CONNECTED:
		
			/* Is there unacked data?	*/
			
			if(soc->send_unacked == soc->send_next ) {
				/* There is no unacked data	*/
				
				soc->myflags = TCP_FLAG_ACK | TCP_FLAG_FIN;
				soc->send_next++;
				tcp_sendcontrol(sochandle);
				tcp_newstate(soc, TCP_STATE_FINW1);				
			} else {
				/* Can't do much but raise pollable flag to soc->flags		*/
				/* and process it on tcp_poll								*/
				
				soc->flags |= TCP_INTFLAGS_CLOSEPENDING;
				
				
				return(sochandle);
			}
		
			break;
	
		default:
			return(-1);
	}
	
	return(sochandle);

}



/** \brief Get current state of the socket
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to the socket to be queried
 *	\return
 *		\li -1 - Error
 *		\li >0 - Socket state
 *
 *	Use this function for querying socket state. This is usually not needed
 *	directly, but could be usefull for some special purposes.
 */
INT8 tcp_getstate (INT8 sochandle)
{
	struct tcb* soc;

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/	

	return(soc->state);

}


/** \brief Checks if it's possible to send data using given socket
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 23.07.2002
 *	\param sochandle handle to the socket to be inspected
 *	\return
 *		\li -1 - not possible to send over a socket (previously sent data is
 *		still not akcnowledged)
 *		\li >0 - it is possible to send data over a socket
 *
 *	Invoke this function to get information whether it is possible to send
 *	data or not. This may, sometimes, be preffered way of getting this type
 *	of information to waiting for #TCP_EVENT_ACK in event_listener function.
 */
INT16 tcp_checksend (INT8 sochandle)
{
	struct tcb* soc;

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/	
	
	if(soc->state != TCP_STATE_CONNECTED)
		return(-1);

	if(soc->send_unacked == soc->send_next)
		return(soc->send_mtu);
	
	return(-1);


}



/** \brief Reset connection and place socket to closed state
 *  \ingroup tcp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\param sochandle handle to socket to be aborted
 *	\return
 *		\li -1 - error
 *		\li >=0 - OK (value represents handle to aborted socket)
 *
 *	Use this function in cases when TCP connection must be immediately closed.
 *	Note that the preffered (more elegant) way of closing the TCP connection
 *	is to invoke tcp_close() which starts a proper closing procedure.
 *	tcp_abort should be used only in cases when it is really necessary to 
 *	immediately and quickly close the connection.
 */
INT8 tcp_abort (INT8 sochandle)
{
	struct tcb* soc;
	
	TCP_DEBUGOUT("FUNCTION: tcp_abort\r\n");

	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		TCP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &tcp_socket[sochandle];		/* Get referense	*/	

	switch (soc->state)	{
		case TCP_STATE_FREE:
			return(-1);
			
		case TCP_STATE_RESERVED:
		case TCP_STATE_CLOSED:
			return(sochandle);
		
		case TCP_STATE_TIMED_WAIT:
		case TCP_STATE_LISTENING:
			tcp_newstate(soc, TCP_STATE_CLOSED);
			return(sochandle);
		
		case TCP_STATE_SYN_SENT:
		case TCP_STATE_SYN_RECEIVED:
		case TCP_STATE_CONNECTED:
		case TCP_STATE_FINW1:
		case TCP_STATE_FINW2:
		case TCP_STATE_CLOSING:
		case TCP_STATE_LAST_ACK:
		
			soc->myflags = TCP_FLAG_RESET;
			tcp_sendcontrol(sochandle);
			tcp_newstate(soc, TCP_STATE_CLOSED);
			return(sochandle);
			
		default:
			return(-1);
	}
	

}



/** \brief Poll TCP sockets periodically
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.07.2002
 *	\warning
 *		\li This function <b>must be</b> invoked periodically from 
 *		the main loop. See main_demo.c for an example.
 *
 *	This function checks all TCP sockets and performs various actions 
 * 	if timeouts occur. What kind of action is performed is defined by the
 *	state of the TCP socket.
 */
void tcp_poll (void)
{
	struct tcb* soc;
	static UINT8 handle = 0;
	UINT8 i;
	INT32 temp;
	UINT8 old_retries;
	
	for(i=0; i < NO_OF_TCPSOCKETS; i++ ) {
		
		if(handle > NO_OF_TCPSOCKETS)
			handle = 0;

		soc = &tcp_socket[handle];
		
		switch(soc->state) {
			case TCP_STATE_FREE:
			case TCP_STATE_RESERVED:
			case TCP_STATE_CLOSED:
			case TCP_STATE_LISTENING:
				
				break;
				
			case TCP_STATE_CONNECTED:
			
				/* In CONNECTED State we have					*/ 
				/* something to do only if we have unacked data	*/
				/* or if connection has been IDLE too long or 	*/
				/* unserved close is isuued by user				*/
				
				/*if(soc->send_next > soc->send_unacked)
					temp = soc->send_next - soc->send_unacked;
				else
					temp = soc->send_unacked - soc->send_next;
				*/
				
				temp = soc->send_next - soc->send_unacked;
				
				/* Unserved Close?			*/
				
				if(soc->flags & TCP_INTFLAGS_CLOSEPENDING) {
					/* Can we send the close now	*/
					
					if(temp == 0) {
						soc->myflags = TCP_FLAG_ACK | TCP_FLAG_FIN;
						soc->send_next++;
						tcp_sendcontrol(handle);
						tcp_newstate(soc, TCP_STATE_FINW1);	
						soc->flags ^= TCP_INTFLAGS_CLOSEPENDING;
						
						handle++;
						
						return;		
						
					}
				}
				
				/* Socket timeout?			*/
				
				if(check_timer(soc->persist_timerh) == 0) {
				
					soc->myflags = TCP_FLAG_ACK | TCP_FLAG_FIN;
					soc->send_next++;
					tcp_sendcontrol(handle);
					tcp_newstate(soc, TCP_STATE_FINW1);	
					
					/* Inform application	*/
					
					soc->event_listener(handle, TCP_EVENT_CLOSE, soc->rem_ip, soc->remport);
					
					handle++;
		
					return;			
				}	
				
				/* Is there unacked data?	*/
				
				if(temp == 0)
					break;
				
				/* Is there timeout?					*/
				
				if( check_timer(soc->retransmit_timerh) != 0 )
					break;
				
				/* De we have retries left				*/
				
				if(soc->retries_left == 0) {
					/* No retries, must reset	*/
					
					TCP_DEBUGOUT("Retries used up, resetting\r\n");
					
					soc->myflags = TCP_FLAG_RESET;
					tcp_sendcontrol(handle);
					
					/* Inform application	*/

					soc->event_listener(handle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
				
					if(soc->type & TCP_TYPE_SERVER )
						tcp_newstate(soc, TCP_STATE_LISTENING);
					else
						tcp_newstate(soc, TCP_STATE_CLOSED);
					
					handle++;
		
					return;										
				}
				
				soc->retries_left--;
				init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);
								
				/* Yep, there is unacked data			*/
				/* Application should send the old data	*/
				
				if(temp>soc->send_mtu)
					temp = soc->send_mtu;
				
				/* Rewind Send Next because the send process will adjust it			*/
				/* So cheat the tcp_send to think there is no unacked data			*/
				
				soc->send_next = soc->send_unacked;
				
				/* tcp_send will set the retiries_left to maximum but this is		*/
				/* retransmitting already so we need to retain it in order to 		*/
				/* avoid dead-lock													*/
				
				old_retries = soc->retries_left;
				
				temp = soc->event_listener(handle, TCP_EVENT_REGENERATE, (UINT32)temp, 0);
			
				soc->retries_left = old_retries;
			
				if(temp <= 0) {
					
					/* No data by application, must be something wrong	*/
					soc->myflags = TCP_FLAG_RESET;
					tcp_sendcontrol(handle);
					
					/* Inform application	*/

					soc->event_listener(handle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
									
					if(soc->type & TCP_TYPE_SERVER )
						tcp_newstate(soc, TCP_STATE_LISTENING);
					else
						tcp_newstate(soc, TCP_STATE_CLOSED);
					
					handle++;
		
					return;					
					
				}
				
				/* Application has send data	*/
				
				handle++;
		
				return;
				
			
			case TCP_STATE_SYN_SENT:
			case TCP_STATE_SYN_RECEIVED:
			
				/* Is there timeout?	*/
				if( check_timer(soc->retransmit_timerh) != 0 )
					break;
					
				TCP_DEBUGOUT("Timeout\r\n");
					
				/* Yep, timeout. Is there reties left?	*/
				if( soc->retries_left ) {
					soc->retries_left--;
					if(soc->state == TCP_STATE_SYN_SENT)
						init_timer(soc->retransmit_timerh, TCP_SYN_RETRY_TOUT*TIMERTIC);
					else
						init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);

					tcp_sendcontrol(handle);
					
					handle++;
		
					return;				
				} else {
					/* Retries used up	*/
					TCP_DEBUGOUT("Retries used up, resetting\r\n");
					
					if(soc->type & TCP_TYPE_SERVER )
						tcp_newstate(soc, TCP_STATE_LISTENING);
					else
						tcp_newstate(soc, TCP_STATE_CLOSED);
					
					soc->myflags = TCP_FLAG_RESET;
					tcp_sendcontrol(handle);
					
					/* Inform application	*/

					soc->event_listener(handle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
					
					handle++;
		
					return;
				}
				
				break;
				
			case TCP_STATE_TIMED_WAIT:
				
				/* Is there timeout?	*/
				
				if( check_timer(soc->retransmit_timerh) != 0 )
					break;
					
				TCP_DEBUGOUT("Timeout\r\n");
				
				if(soc->retries_left) {
					soc->retries_left--;
					init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);
					break;
				}
				
				if(soc->type & TCP_TYPE_SERVER )
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				break;
			
			case TCP_STATE_LAST_ACK:
			case TCP_STATE_FINW1:
			case TCP_STATE_CLOSING:
			
				/* Is there timeout?	*/
				
				if( check_timer(soc->retransmit_timerh) != 0 )
					break;
					
				TCP_DEBUGOUT("Timeout\r\n");		
						
				/* Yep, timeout. Is there reties left?	*/
				
				if( soc->retries_left ) {
					soc->retries_left--;
					init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);
					soc->myflags = TCP_FLAG_FIN | TCP_FLAG_ACK;
					tcp_sendcontrol(handle);
					
					handle++;
		

					return;				
				} else {
					/* Retries used up	*/
					TCP_DEBUGOUT("Retries used up, resetting\r\n");
					
					if(soc->type & TCP_TYPE_SERVER )
						tcp_newstate(soc, TCP_STATE_LISTENING);
					else
						tcp_newstate(soc, TCP_STATE_CLOSED);
					
					soc->myflags = TCP_FLAG_RESET;
					tcp_sendcontrol(handle);
					
					/* Inform application	*/

					soc->event_listener(handle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
					
					handle++;
		
					return;
				}			
				
				break;
			
			case TCP_STATE_FINW2:
			
				/* Is there timeout?	*/
				
				if( check_timer(soc->retransmit_timerh) != 0 )
					break;
					
				TCP_DEBUGOUT("Timeout\r\n");		
						
				/* Yep, timeout. Is there reties left?	*/
				
				if( soc->retries_left )	{
					/* Still keep waiting for FIN	*/
				
					soc->retries_left--;
					init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);
					break;			
				} else {
					/* Retries used up	*/
					TCP_DEBUGOUT("Retries used up, resetting\r\n");
					
					if(soc->type & TCP_TYPE_SERVER )
						tcp_newstate(soc, TCP_STATE_LISTENING);
					else
						tcp_newstate(soc, TCP_STATE_CLOSED);
					
					soc->myflags = TCP_FLAG_RESET;
					tcp_sendcontrol(handle);
					
					/* Inform application	*/

					soc->event_listener(handle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
				
					handle++;
		
					return;
				}	
				
				break;
			
			default:
				break;	
			
		}
		
		/* Go to next socket if there was no event	*/
		
		handle++;
		
	}
	
}



/** \brief Initialize TCP module
 *	\ingroup core_initializer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\return
 *		\li -1 - error
 *		\li >0 - number of sockets initialized
 *	\warning 
 *		\li This function <b>must</b> be invoked at startup before any
 *		other TCP functions are invoked.
 *
 *	This function initializes all sockets and corresponding tcbs to known
 *	state. Timers are also allocated for each socket and everything is
 *	brought to a predefined state.
 *
 */
INT8 tcp_init (void)
{
	UINT16 i;
	INT16 h;
	struct tcb* soc;
	
	if( NO_OF_TCPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_TCPSOCKETS == 0 )
		return(0);
	
	TCP_DEBUGOUT("Initializing TCP");
	
	for(i=0; i < NO_OF_TCPSOCKETS; i++) {
		soc = &tcp_socket[i];			/* Get Socket	*/
		h = -1;
		
		soc->state = TCP_STATE_FREE;
		soc->type = TCP_TYPE_NONE;
		soc->flags = 0;
		soc->rem_ip = 0;
		soc->remport = 0;
		soc->locport = 0;
		soc->myflags = 0;
		soc->send_mtu = TCP_DEF_MTU;
		soc->tos = 0;
		soc->tout = 0;
		soc->event_listener = 0;
		
		/* Reserve Timers	*/
		
		h = get_timer();
		
		/*
		if( h < 0 ) {
			TCP_DEBUGOUT("\n\rERROR:Error getting timer for TCP Socket!\n\r");
			return(-1);
		}
		*/
		
		init_timer(h,0);					/* No timeout	*/
		
		soc->persist_timerh = h;
		
		h = get_timer();
		
		/*
		if( h < 0 ) {
			TCP_DEBUGOUT("\n\rERROR:Error getting timer for TCP Socket!\n\r");
			return(-1);
		}
		*/
		
		init_timer(h,0);					/* No timeout	*/
		
		soc->retransmit_timerh = h;
		
		soc->retries_left = 0;		 
		
		TCP_DEBUGOUT(".");
		
	
	}
	
	TCP_DEBUGOUT("\n\rTCP Initialized\n\r");
	
	/* Return number of sockets initialized	*/
	
	return(i+1);
	

}




/*******************************************************************************/
/*******	TCP Internal functions										********/
/*******************************************************************************/


/** \brief Check and process the received TCP frame
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.07.2002
 *	\param frame pointer to received ip_frame structure
 *	\param len length of data contained in IP datagram (in bytes)
 *	\return 
 *		\li -1 - Error (packet not OK, or not TCP,or something else)
 *		\li >0 - Packet OK
 *
 *	Invoke this function to process received TCP frames. See main_demo.c for
 *	an example on how to accomplish this.
 */
INT16 process_tcp_in (struct ip_frame* frame, UINT16 len)
{
	struct tcb* soc;
	UINT16 hlen;
	UINT8 olen;
	UINT16 dlen;
	UINT32 diff;
	UINT16 i;
	INT8 sochandle;	
	INT16 temp;
	
	/* Is this TCP?	*/
	
	TCP_DEBUGOUT("Processing TCP...\n\r");
	
	if( frame->protocol != IP_TCP ) {
		TCP_DEBUGOUT("ERROR: The protocol is not TCP\n\r");
		return(-1);
	}
	
	/* Calculate checksum for received packet	*/

	
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
	
	if( tcp_check_cs(frame, len) == 1) {
		TCP_DEBUGOUT("TCP Checksum OK\n\r");
	} else {
		TCP_DEBUGOUT("ERROR:TCP Checksum failed\r\n");
		return(-1);
	} 

	/* Get the header	*/
	
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
	
	received_tcp_packet.sport = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.sport |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.dport = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.dport |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.seqno = (((UINT32)RECEIVE_NETWORK_B()) << 24);
	received_tcp_packet.seqno |= (((UINT32)RECEIVE_NETWORK_B()) << 16);
	received_tcp_packet.seqno |= (((UINT32)RECEIVE_NETWORK_B()) << 8);
	received_tcp_packet.seqno |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.ackno = (((UINT32)RECEIVE_NETWORK_B()) << 24);
	received_tcp_packet.ackno |= (((UINT32)RECEIVE_NETWORK_B()) << 16);
	received_tcp_packet.ackno |= (((UINT32)RECEIVE_NETWORK_B()) << 8);
	received_tcp_packet.ackno |= RECEIVE_NETWORK_B();

	received_tcp_packet.hlen_flags = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.hlen_flags |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.window = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.window |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.checksum = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.checksum |= RECEIVE_NETWORK_B();
	
	received_tcp_packet.urgent = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_tcp_packet.urgent |= RECEIVE_NETWORK_B();
	
	/* Little check for options	*/
	
	hlen = received_tcp_packet.hlen_flags & 0xF000;
	hlen >>= 10;
	
	if( hlen < MIN_TCP_HLEN ) {
		TCP_DEBUGOUT("ERROR: Received TCP Header too short\r\n");
		return(-1);
	}
	
	if(hlen == MIN_TCP_HLEN)
		TCP_DEBUGOUT("TCP does not contain options\r\n");
	
	olen = hlen - MIN_TCP_HLEN;
	
	if( olen > MAX_TCP_OPTLEN ) {
		TCP_DEBUGOUT("ERROR: Received TCP header contains too long option field\r\n");
		return(-1);
	}
	
	/* Calculate data length	*/
	
	if( hlen > len ) {
		TCP_DEBUGOUT("ERROR: TCP header longer than packet\r\n");
		return(-1);
	}
	
	dlen = len - hlen - olen;
	
	/* Get options (if any)	*/
	
	for(i=0; i<olen;i++)
		received_tcp_packet.opt[i] = RECEIVE_NETWORK_B();
		
	/* Try to find rigth socket to process with		*/
	
	sochandle = tcp_mapsocket(frame, &received_tcp_packet);
	
	if(sochandle < 0) {
		TCP_DEBUGOUT("ERROR: Processing TCP packet failed\r\n");
		tcp_sendreset(&received_tcp_packet, frame->sip);
		return(-1);
	}
	
	received_tcp_packet.buf_index = frame->buf_index + hlen;
	NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
	
	
	
	/* Get socket reference	*/
	
	soc = &tcp_socket[sochandle];
	
	/* Process the packet on TCP State Machine		*/
	
	switch(soc->state) {
		case TCP_STATE_CONNECTED:
		
			TCP_DEBUGOUT("CONNECTED State\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET)	{
				TCP_DEBUGOUT("ERROR:Reset received\r\n");

				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}
			
			/* Check for SYN (If the peer didn't get our SYN+ACK or ACK)	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_SYN )	{
				/* Is it the SYN+ACK we have already ACKed but maybe ACK lost?	*/
				
				if( received_tcp_packet.hlen_flags & TCP_FLAG_ACK )	{
					/* It's SYN+ACK but how about sequence	*/
					
					if( (received_tcp_packet.seqno + 1) == soc->receive_next ) {
					
						if( received_tcp_packet.ackno == soc->send_next ) {
						
							TCP_DEBUGOUT("Received SYN+ACK again\r\n");
							
							/* ACK the SYN	*/
							soc->myflags = TCP_FLAG_ACK;
							tcp_sendcontrol(sochandle);
							return(0);
						}
						
					}
				
				 /* It is maybe SYN again so it haven't get our SYN + ACK	*/
				 /* Let our retransmission handle it						*/
				 
				 return(0);
				
				
				}
			
			}
			
			/* Do we have unacked data?		*/
			
			if( soc->send_unacked != soc->send_next ) {
			
				/* Yep, is the ACK valid?	*/
				
				if( (received_tcp_packet.hlen_flags & TCP_FLAG_ACK) == 0) {
				
					TCP_DEBUGOUT("Packet without ACK and unacked data. Packet not processed\r\n");
					return(0);
				}
				
				if( received_tcp_packet.ackno == soc->send_next ) {
				
					/* We don't have unacked data now	*/
				
					soc->send_unacked = soc->send_next;
				
					/* Inform application	*/
				
					soc->event_listener(sochandle, TCP_EVENT_ACK, soc->rem_ip, soc->remport);
				
				}

			
			}
			
			/* Is the sequence OK	*/
			
			if(soc->receive_next != received_tcp_packet.seqno)
			{
				/* Out of range, inform what we except	*/
			
				DEBUGOUT("Too big sequence number received\r\n");
				
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
				return(0);
			}
			
			/* Generate data event to application	*/
				
			soc->event_listener(sochandle, TCP_EVENT_DATA, dlen, 0);
				
			soc->receive_next += dlen;			
					
			/* Is the FIN flag set?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN )	{
				TCP_DEBUGOUT("Other end want's to close\r\n");
				
				/* Inform application if we don't have unacked data	*/
				
				if( soc->send_unacked == soc->send_next) {
				
					soc->event_listener(sochandle, TCP_EVENT_CLOSE, soc->rem_ip, soc->remport);
				
					/* ACK FIN and set our own FIN	*/
				
					soc->receive_next++;
					soc->send_next++;
					soc->myflags = TCP_FLAG_ACK | TCP_FLAG_FIN;
				
					tcp_newstate(soc, TCP_STATE_LAST_ACK);
					tcp_sendcontrol(sochandle);
				
					return(0);
				}
			}
			
			/* ACK the data if there was it	*/
			
			if(dlen) {
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
			}
			
			tcp_newstate(soc, TCP_STATE_CONNECTED);			
			

			return(0);
			
		
			break;
	
		case TCP_STATE_FREE:
			
			/* Reset connection	*/
			tcp_sendreset(&received_tcp_packet, frame->sip);
			return(-1);
		
			break;
		
		case TCP_STATE_CLOSED:
			
			/* Reset connection	*/
			tcp_sendreset(&received_tcp_packet, frame->sip);
			return(-1);		
		
			break;
		
		case TCP_STATE_LISTENING:
		
			TCP_DEBUGOUT("LISTENING State...\r\n");
		
			/* Check Flags	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				tcp_newstate(soc, TCP_STATE_LISTENING);
				return(-1);
			}
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_ACK) {
				TCP_DEBUGOUT("ERROR:Ack received\r\n");
				tcp_newstate(soc, TCP_STATE_LISTENING);
				/* Reset connection	*/
				tcp_sendreset(&received_tcp_packet, frame->sip);
				return(-1);	
			}
			
			if((received_tcp_packet.hlen_flags & TCP_FLAG_SYN) == 0) {
				TCP_DEBUGOUT("ERROR:No SYN set on packet\r\n");
				tcp_newstate(soc, TCP_STATE_LISTENING);
				/* Reset connection	*/
				tcp_sendreset(&received_tcp_packet, frame->sip);
				return(-1);
			}
			
			/* OK, SYN received	*/
			
			/* Inform application and see if accepted	*/
			
			temp = (INT16)soc->event_listener(sochandle, TCP_EVENT_CONREQ, soc->rem_ip, soc->remport);
			
			if( temp == -1)	{
				TCP_DEBUGOUT("Application disregarded connection request\r\n");
				tcp_sendreset(&received_tcp_packet, frame->sip);
				return(-1);
			}
			
			if( temp == -2 ) {
				TCP_DEBUGOUT("Application wants to think about accepting conreq\r\n");
				return(1);
			}
			
			/* The connection request was accepted	*/
			
			TCP_DEBUGOUT("Next state SYN_RECEIVED\r\n");
			if(soc->flags & TCP_INTFLAGS_CLOSEPENDING)
				soc->flags ^= TCP_INTFLAGS_CLOSEPENDING;
			tcp_newstate(soc, TCP_STATE_SYN_RECEIVED);
			soc->receive_next = received_tcp_packet.seqno + 1;	/* Ack SYN		*/
			soc->send_unacked = tcp_initseq();
			
			soc->myflags = TCP_FLAG_SYN | TCP_FLAG_ACK;
			tcp_sendcontrol(sochandle);
			soc->send_next = soc->send_unacked + 1;
			
			return(1);
			
			break;
			
		case TCP_STATE_SYN_RECEIVED:
		
			TCP_DEBUGOUT("SYN_RECEIVED State...\r\n");
			
			/* Check Flags	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET)	{
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				
				/* Inform application	*/
				
				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}
			
			/* Is it SYN+ACK (if we are the because of simultaneous open)	*/
			
			if( (received_tcp_packet.hlen_flags & TCP_FLAG_SYN) &&
				(received_tcp_packet.hlen_flags & TCP_FLAG_ACK)	) {			
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("SYN+ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("SYN+ACK received, this side established\n\r");
				
				/* Get peer's seq number	*/
				
				soc->receive_next =  received_tcp_packet.seqno;
				soc->receive_next++;							/* ACK SYN	*/
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_CONNECTED);
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
				
				/* Inform application	*/
				
				soc->event_listener(sochandle, TCP_EVENT_CONNECTED, soc->rem_ip, soc->remport);
				
				return(0);					
								
			}
			
			/* Is it ACK?		*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_ACK )	{
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				if( received_tcp_packet.seqno != soc->receive_next ) {
					TCP_DEBUGOUT("ACK received but Wrong SEQ number\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("ACK received, this side CONNECTED\r\n");
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_CONNECTED);

				/* Inform application	*/
				
				soc->event_listener(sochandle, TCP_EVENT_CONNECTED, soc->rem_ip, soc->remport);
								
				return(0);
					
			}
			
			/* Is it SYN?		*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_SYN ) {
				TCP_DEBUGOUT("Repeated SYN\r\n");
				return(0);
			}
			
			/* We didn't understood this one, keep on trying but info with RESET	*/
			
			TCP_DEBUGOUT("Unrecognized packet\n\r");
			
			tcp_sendreset(&received_tcp_packet, frame->sip);
			
			return(-1);
			
			break;
			
		case TCP_STATE_SYN_SENT:
		
			TCP_DEBUGOUT("SYN_SENT State\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				
				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
								
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}
			
			/* Is it SYN+ACK?	*/
			
			if( (received_tcp_packet.hlen_flags & TCP_FLAG_SYN) &&
				(received_tcp_packet.hlen_flags & TCP_FLAG_ACK)	) {
				/* Rigth ACK?	*/
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("SYN+ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("SYN+ACK received, this side established\n\r");
				
				/* Get peer's seq number	*/
				
				soc->receive_next =  received_tcp_packet.seqno;
				soc->receive_next++;							/* ACK SYN	*/
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_CONNECTED);
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
				
				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_CONNECTED, soc->rem_ip, soc->remport);
								
				return(0);			
				
			}
			
			/* Is it SYN (simultaneous open)	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_SYN) {
				TCP_DEBUGOUT("Simultaneous open, next SYN_RECEIVED\r\n");
			
				/* Get peer's seq number	*/
				
				soc->receive_next =  received_tcp_packet.seqno;
				soc->receive_next++;							/* ACK SYN	*/				
				
				tcp_newstate(soc, TCP_STATE_SYN_RECEIVED);
				soc->myflags = TCP_FLAG_SYN | TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
				
				return(0);
			
			}
			
			/* This is something we didn't understood, maybe the other peer has	*/
			/* still old connection on or something								*/
			TCP_DEBUGOUT("TCP packet out of nowhere received...\r\n");
			tcp_sendreset(&received_tcp_packet, frame->sip);
			
			return(-1);
		
			break;
		
		case TCP_STATE_FINW1:
		
			TCP_DEBUGOUT("FINW1 State\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				
				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);
								
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}
			
			/* Is it FIN+ACK?			*/
			
			if( (received_tcp_packet.hlen_flags & TCP_FLAG_FIN) &&
				(received_tcp_packet.hlen_flags & TCP_FLAG_ACK)	) {
				/* Rigth ACK?	*/
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("FIN+ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("FIN+ACK received, next TIMED_WAIT\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_TIMED_WAIT);
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
							
				return(0);
			
			}
			
			/* Is it just FIN	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN	) {
				
				TCP_DEBUGOUT("Simultaneous close, next CLOSING\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
				
				tcp_newstate(soc, TCP_STATE_CLOSING);
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);			
				return(0);
			
			}			
			
			/* Is it just ACK?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_ACK	) {
				/* Rigth ACK?	*/
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("Our FIN is ACKed but peer don't agree to disconnect yet\r\n");
				TCP_DEBUGOUT("Next FINW2\r\n");
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_FINW2);
				
				return(0);
							
			}
						
			break;
			
		case TCP_STATE_FINW2:
		
			TCP_DEBUGOUT("FINW2 State\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				
				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}			
		
			/* Do we finally get FIN?	*/
		
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN	) {
				
				TCP_DEBUGOUT("FIN received, next TIMED_WAIT\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
				
				tcp_newstate(soc, TCP_STATE_TIMED_WAIT);
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);			
				return(0);
			
			}		
		
			break;
			
		case TCP_STATE_CLOSING:
		
			TCP_DEBUGOUT("CLOSING State...\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET)	{
				TCP_DEBUGOUT("ERROR:Reset received\r\n");

				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}			
			
			/* Is it ACK?			*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_ACK	) {
				/* Rigth ACK?	*/
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("Our FIN is ACKed and peer wants to close too\r\n");
				TCP_DEBUGOUT("Next TIMED_WAIT\r\n");

				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;
				
				tcp_newstate(soc, TCP_STATE_TIMED_WAIT);
				
				return(0);
							
			}
	
			/* Is it repeated FIN?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN	) {
				
				TCP_DEBUGOUT("Repeated FIN, repeat ACK\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
				
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);			
			
				return(0);
			
			}

		
			break;
		
		case TCP_STATE_LAST_ACK:
		
			TCP_DEBUGOUT("LAST_ACK State...\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");
				
				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}			
			
			/* Is it ACK?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_ACK	) {
				/* Rigth ACK?	*/
				
				if( received_tcp_packet.ackno != soc->send_next ) {
					TCP_DEBUGOUT("ACK received but wrong Ack\n\r");
					return(-1);
				}
				
				TCP_DEBUGOUT("Last ACK received, next LISTENING or CLOSED\r\n");
				
				/* We have no unacked data	*/
				
				soc->send_unacked = soc->send_next;				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
												
				return(0);
							
			}			

			/* Is it repeated FIN?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN	) {
				
				TCP_DEBUGOUT("Repeated FIN, repeat ACK\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
					
				soc->myflags = TCP_FLAG_FIN | TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
							
				return(0);
			
			}			
			
		
			break;
			
		case TCP_STATE_TIMED_WAIT:
		
			TCP_DEBUGOUT("TIMED_WAIT State...\r\n");
			
			/* Check for RESET	*/
			
			if(received_tcp_packet.hlen_flags & TCP_FLAG_RESET) {
				TCP_DEBUGOUT("ERROR:Reset received\r\n");

				/* Inform application	*/

				soc->event_listener(sochandle, TCP_EVENT_ABORT, soc->rem_ip, soc->remport);				
				
				if(soc->type & TCP_TYPE_SERVER)
					tcp_newstate(soc, TCP_STATE_LISTENING);
				else
					tcp_newstate(soc, TCP_STATE_CLOSED);
					
				return(-1);
			}			
			
			/* Is it repeated FIN?	*/
			
			if( received_tcp_packet.hlen_flags & TCP_FLAG_FIN	) {
				
				TCP_DEBUGOUT("Repeated FIN, repeat ACK\n\r");
				
				/* ACK FIN and all data	*/
				
				soc->receive_next = received_tcp_packet.seqno;
				soc->receive_next++;
				soc->receive_next += dlen;
					
				soc->myflags = TCP_FLAG_ACK;
				tcp_sendcontrol(sochandle);
							
				return(0);
			
			}
		
			
		
			break;
	
	
		default:
		
			TCP_DEBUGOUT("ERROR:TCP State machine in unknown state!!\r\n");
			
			tcp_sendreset(&received_tcp_packet, frame->sip);
			
			RESET_SYSTEM();
	
	}
	
	TCP_DEBUGOUT("Should not be there!\r\n");
	
	return(-1);
		
}


/** \brief Create and send TCP packet
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 16.07.2002
 *	\param sockethandle handle to processed socket
 *	\param buf pointer to data buffer (where TCP header will be stored)
 *	\param blen buffer length in bytes
 *	\param dlen length of data in bytes
 *	\return 
 *		\li -1 - Error
 *		\li >0 - Packet OK
 *
 *	Based on data supplied as function parameters and data stored in 
 *	socket's tcb, TCP header is created in buffer, checksum is calculated
 *	and packet is forwarded to lower layers (IP).
 *
 */
INT16 process_tcp_out (INT8 sockethandle, UINT8* buf, UINT16 blen, UINT16 dlen)
{
	struct tcb* soc;
	UINT16 cs;
	UINT8 cs_cnt;
	UINT16 i;
	UINT8* buf_start;
	
	TCP_DEBUGOUT("Entering to send TCP packet\r\n");
	
	if( sockethandle < 0 ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (<0)\r\n");
		return(-1);
	}
	
	if( sockethandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (>NO_OF_TCPSOCKETS)\r\n");
		return(-1);
	}
	
	if( (dlen + MIN_TCP_HLEN) > blen ) {
		TCP_DEBUGOUT("ERROR:Transmit buffer too small for TCP header\r\n");
		return(-1);
	} 
	
	soc = &tcp_socket[sockethandle];				/* Get socket	*/
	
	buf_start = buf;
	
	if( (dlen + MIN_TCP_HLEN) > soc->send_mtu ) {
		TCP_DEBUGOUT("ERROR:Send MTU exceeded\r\n");
		return(-1);
	}
	
	/* Assemble TCP header to buffer	*/
	
	*buf++ = (UINT8)(soc->locport >> 8);
	*buf++ = (UINT8)soc->locport;
	*buf++ = (UINT8)(soc->remport >> 8);
	*buf++ = (UINT8)soc->remport;
	*buf++ = (UINT8)(soc->send_unacked >>24);
	*buf++ = (UINT8)(soc->send_unacked >>16);
	*buf++ = (UINT8)(soc->send_unacked >>8);
	*buf++ = (UINT8)(soc->send_unacked);
	*buf++ = (UINT8)(soc->receive_next >>24);
	*buf++ = (UINT8)(soc->receive_next >>16);
	*buf++ = (UINT8)(soc->receive_next >>8);
	*buf++ = (UINT8)(soc->receive_next);
	*buf =	MIN_TCP_HLEN >> 2;
	*buf <<= 4;
	buf++;
	*buf++ = soc->myflags;
	*buf++ = (UINT8)(TCP_DEF_MTU >> 8);
	*buf++ = (UINT8)TCP_DEF_MTU;
	*buf++ = 0;								/* Checksum	*/
	*buf++ = 0;
	*buf++ = 0;								/* Urgent	*/
	*buf++ = 0;
	
	 
	/* Calculate checksum	*/
	
	cs = 0;
	cs_cnt = 0;
	
	/* Do it firstly to IP pseudo header	*/
	
	cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 24), cs_cnt++);	
	cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 16), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)localmachine.localip, cs_cnt++);
	
	cs = ip_checksum(cs, (UINT8)(soc->rem_ip >> 24), cs_cnt++);	
	cs = ip_checksum(cs, (UINT8)(soc->rem_ip >> 16), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)(soc->rem_ip >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)soc->rem_ip, cs_cnt++);	
	
	cs = ip_checksum(cs, 0, cs_cnt++);
	
	cs = ip_checksum(cs, (UINT8)IP_TCP, cs_cnt++);
		
	cs = ip_checksum(cs, (UINT8)((dlen + MIN_TCP_HLEN) >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)(dlen + MIN_TCP_HLEN), cs_cnt++);
	
	/* Go to TCP header + data	*/
	
	buf = buf_start;
	
	cs = ip_checksum_buf(cs, buf, dlen + MIN_TCP_HLEN);
		
	cs = ~ cs;

#if 0
	/* Is the padding required?	*/
	
	if(dlen & 0x01) {
		TCP_DEBUGOUT("Padding required\r\n");
		*buf = 0;
		dlen++;
	}
#endif
	
	/* Save checksum in correct place	*/
	
	buf = buf_start + 16;
	*buf++ = (UINT8)(cs >> 8);
	*buf = (UINT8)cs;
	
	/* Send it to IP	*/
	
	TCP_DEBUGOUT("Sending TCP...\r\n");
	
	process_ip_out(soc->rem_ip, IP_TCP, soc->tos, 100, buf_start, dlen + MIN_TCP_HLEN);
	
	TCP_DEBUGOUT("TCP packet sent\r\n");
	
	return(0);
	

}



/** \brief Send a TCP control packet (no data)
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 17.07.2002
 *	\param sockethandle handle to socket
 *
 *	This function is used to initiate sending of a control (no data) TCP 
 *	packet. Important thing in these packets are the flags and sequence
 *	numbers they carry.
 *
 */
void tcp_sendcontrol (INT8 sockethandle)
{
	UINT8 i;

	
	TCP_DEBUGOUT("Entering to send TCP control packet\r\n");
	
	kick_WD();
	
	if( sockethandle < 0 ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (<0)\r\n");
		return;
	}
	
	if( sockethandle > NO_OF_TCPSOCKETS ) {
		TCP_DEBUGOUT("ERROR:Socket Handle not valid (>NO_OF_TCPSOCKETS)\r\n");
		return;
	}
	
	process_tcp_out(sockethandle, &tcp_tempbuf[0], MIN_TCP_HLEN + 1, 0);
	
	return;
	
	
}

/** \brief Send a reset (RST) packet to remote host
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 20.08.2002
 *	\param frame pointer to received TCP packet
 *	\param remip remote IP address of packet
 *
 *	Uses socket #NO_OF_TCPSOCKETS to send a RESET packet to peer. 
 *	This function is used when we are establishing connection but
 *	we receive something else than SYN or SYN+ACK when it's
 *	possible that the peer has still old connection on which
 *	needs to be resetted without canceling the connection establishment
 *	on process.
 */
void tcp_sendreset (struct tcp_frame *frame, UINT32 remip)
{
	struct tcb* soc;

	soc = &tcp_socket[NO_OF_TCPSOCKETS];				/* Get socket	*/


	/* Is this itself a reset packet?	*/
	
	if( frame->hlen_flags & TCP_FLAG_RESET )
		return;

	/* Set temporary tcb variables	*/
	
	soc->rem_ip = remip;
	soc->remport = frame->sport;
	soc->locport = frame->dport;
	soc->tos = 0;
	
	/* Does the packet have ACK flag set?	*/
	
	if( frame->hlen_flags & TCP_FLAG_ACK ) {
		/* Jup, use it as our seq	*/
		
		soc->send_unacked = frame->ackno;
		soc->myflags = TCP_FLAG_RESET;	
		soc->receive_next = frame->seqno;
	} else {
		soc->send_unacked = 0;
		soc->myflags = TCP_FLAG_RESET | TCP_FLAG_ACK;	
		soc->receive_next = frame->seqno+1;
	}
		
	
	soc->send_mtu = TCP_DEF_MTU;
	
	tcp_sendcontrol(NO_OF_TCPSOCKETS);

}


/** \brief Get and return initial sequence number
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 17.07.2002
 *	\return UINT32 number containing initial sequence number to be used
 *
 *	This function returns initial sequence number to be used in a TCP 
 *	connection. For now, initial sequence number is selected based on
 *	base_timer value, which should be solid enough choice.
 *
 */
UINT32 tcp_initseq (void)
{

	TCP_DEBUGOUT("Calculating initial sequence number\r\n");
	
	return( ( (UINT32)base_timer << 24) | 0x00FFFFFF );

}

/** \brief Try to match received TCP packet to a socket
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.07.2002
 *	\param ipframe pointer to received IP frame
 *	\param tcpframe pointer to received TCP frame to be mapped
 *	\return
 *		\li -1 - Error (no resources or no socket found)
 *		\li >=0 - Handle to mapped socket
 *
 *	Function iterates through socket table trying to find a socket for 
 *	whom this TCP packet is intended.
 *
 */
INT8 tcp_mapsocket (struct ip_frame* ipframe, struct tcp_frame* tcpframe)
{
	struct tcb* soc;
	UINT8 i;

	
	/* Check if there is already connection on	*/
	
	for( i=0; i < NO_OF_TCPSOCKETS; i++) {
		soc = &tcp_socket[i];					/* Get socket	*/
		
		if(soc->state == TCP_STATE_LISTENING)
			continue;							/* No match		*/
		if(soc->remport != tcpframe->sport)
			continue;						
		if(soc->locport != tcpframe->dport)
			continue;						
		if(soc->rem_ip != ipframe->sip)	
			continue;						
		
		/* There is connection on already	*/
		
		TCP_DEBUGOUT("Active connection socket found\r\n");
		
		return(i);
	}
	
	/* Allocate listening one if SYN packet (Connection Request)	*/
	
	TCP_DEBUGOUT("No active connection, checking if SYN packet\r\n");
	
	/* Is it SYN?	*/
	
	if( (tcpframe->hlen_flags & TCP_FLAG_SYN) == 0 )
		return(-1);
	if( tcpframe->hlen_flags & TCP_FLAG_ACK )
		return(-1);
	if( tcpframe->hlen_flags & TCP_FLAG_RESET )
		return(-1);
	if( tcpframe->hlen_flags & TCP_FLAG_FIN )
		return(-1);
	
	TCP_DEBUGOUT("Trying to allocate listening one for SYN packet\r\n");
	
	/* Search listening sockets	*/
	
	for( i=0; i < NO_OF_TCPSOCKETS; i++) {
		soc = &tcp_socket[i];				/* Get socket	*/
	
		if(soc->state != TCP_STATE_LISTENING)
			continue;	
		
		if(soc->locport != tcpframe->dport)
			continue;
		
		/* Bind it	*/
		
		soc->rem_ip = ipframe->sip;
		soc->remport = tcpframe->sport;
		
		TCP_DEBUGOUT("Allocated new socket\r\n");
		
		return(i);
		
	}
	
	/* No success	*/
	
	TCP_DEBUGOUT("ERROR:No socket found or allocated for TCP packet\r\n");
	
	return(-1);

}


/** \brief Change TCP socket state and reinitialize timers
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 18.07.2002
 *	\param soc pointer to socket structure we're working with
 *	\param nstate new socket state
 *
 *	This function is used for every state-change that occurs in the TCP
 *	sockets so as to provide correct timers/retransmittions that ensure
 *	TCP connection is lasting.
 */
void tcp_newstate (struct tcb* soc, UINT8 nstate)
{
	soc->state = nstate;
	soc->retries_left = TCP_DEF_RETRIES;

	/* In some states we don't want to wait for many retries (e.g. TIMED_WAIT)	*/
	
	switch(soc->state) {
		case TCP_STATE_TIMED_WAIT:
			soc->retries_left = 0;
			break;
		
		case TCP_STATE_SYN_SENT:	
			/* When we are sending SYN it's propably that ARP is not valid 	*/
			/* Do retransmit faster on first time							*/
			init_timer(soc->retransmit_timerh, TCP_INIT_RETRY_TOUT*TIMERTIC);
			soc->retries_left = TCP_CON_ATTEMPTS;
			break;

		case TCP_STATE_LAST_ACK:
		case TCP_STATE_FINW1:
		case TCP_STATE_FINW2:
		case TCP_STATE_CLOSING:
			soc->retries_left = 1;
			break;
		
		default:
			break;
	
	}
	
	
	/* KeepAlive timer	*/
	if(soc->state == TCP_STATE_CONNECTED)
		init_timer(soc->persist_timerh, soc->tout);
	
	/* Retransmit timer	*/
	
	init_timer(soc->retransmit_timerh, TCP_DEF_RETRY_TOUT*TIMERTIC);
	
	return;


}

/** \brief Returns next free (not used) local port number
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 21.07.2002
 *	\return 
 *		\li 0 - no free ports!
 *		\li >0 - free local TCP port number
 *
 *	Function attempts to find new local port number that can be used to 
 *	establish a connection. 
 */
UINT16 tcp_getfreeport (void)
{
	struct tcb* soc;
	static UINT16 lastport = 1;
	UINT16 start;
	UINT16 i;
	

	/* Try with every port to every socket untill free found	*/
		
	for( start = lastport++; start != lastport; lastport++) {
		if(lastport == TCP_PORTS_END)
			lastport = 1;
			
		for(i = 0; i < NO_OF_TCPSOCKETS; i++) {
			soc = &tcp_socket[i];					/* Get socket	*/
			
			if( (soc->state > TCP_STATE_CLOSED) && (soc->locport == lastport) ) {
				/* Blaah, this socket has reserved the port, go to next one	*/
				break; 
			}
			
		}	
			
		/* Did we found it?	*/
			
		if( i == NO_OF_TCPSOCKETS)
			break; 
			
	}
		
	if(lastport == start) {
		TCP_DEBUGOUT("Out of TCP ports!!\n\r");
		return(0);
	}
		
	return(lastport);
		
}



/** \brief Check if TCP checksum check's out
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 16.07.2002
 *	\param ipframe pointer to IP frame that carried TCP message
 *	\param len length of TCP portion 
 *	\return
 *		\li 0 - checksum corrupted
 *		\li 1 - checksum OK
 *
 *	Function recalculates TCP checksum (pseudoheader+header+data) and 
 *	compares it to received checksum to see if everything is OK or there 
 *	is a problem with the checksum.
 */
UINT8 tcp_check_cs (struct ip_frame* ipframe, UINT16 len)
{
	UINT16 cs;
	UINT8 cs_cnt;
	UINT16 i;
	
	cs = 0;
	cs_cnt = 0;
	
	/* Do it firstly to IP pseudo header	*/
	
	cs = ip_checksum(cs, (UINT8)(ipframe->sip >> 24), cs_cnt++);	
	cs = ip_checksum(cs, (UINT8)(ipframe->sip >> 16), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)(ipframe->sip >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)ipframe->sip, cs_cnt++);
	
	cs = ip_checksum(cs, (UINT8)(ipframe->dip >> 24), cs_cnt++);	
	cs = ip_checksum(cs, (UINT8)(ipframe->dip >> 16), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)(ipframe->dip >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)ipframe->dip, cs_cnt++);	
	
	cs = ip_checksum(cs, 0, cs_cnt++);
	
	cs = ip_checksum(cs, (UINT8)ipframe->protocol, cs_cnt++);
		
	cs = ip_checksum(cs, (UINT8)(len >> 8), cs_cnt++);
	cs = ip_checksum(cs, (UINT8)len, cs_cnt++);
	
	/* Go to TCP data	*/
	while(len>15)
	{		
		RECEIVE_NETWORK_BUF(tcp_tempbuf,16);	
		
		cs = ip_checksum_buf(cs, tcp_tempbuf,16);
		len -= 16;	
		cs_cnt += 16;
	}
	
	while(len--){
		cs = ip_checksum(cs, RECEIVE_NETWORK_B(), cs_cnt++);
	}
	
	cs = ~ cs;
	
	if(cs != IP_GOOD_CS) {
		return (0);
	}
	
	/* It's OK	*/
	
	return(1);
	

}

