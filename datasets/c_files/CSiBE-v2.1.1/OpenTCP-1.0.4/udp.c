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

/** \file udp.c
 *	\brief OpenTCP UDP implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 15.7.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Send ICMP Destination Unreachable when receiving UDP packets
 *		to non-existent UDP ports.
 *  
 *	OpenTCP UDP implementation. All functions necessary for UDP packet
 *	processing are present here. Note that only a small subset
 *	of these functions must be used for "normal" applications that
 *	are using the UDP for communciation. For function declarations and
 *	lots of other usefull stuff see inet/tcp_ip.h.
 *
 *	For examples how to use UDP and write applications that communicate
 *	using UDP see inet/demo/main_demo.c and inet/demo/udp_demo.c.
 *
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/ethernet.h>
#include <inet/ip.h>
#include <inet/tcp_ip.h>
#include <inet/system.h>

/** \brief UDP table holding socket parameters for every UDP socket 
 *
 *	UDP table is an array of ucb structures holding all of the 
 *  necessary information about the state, listener, port numbers
 *	and other info about the UDP sockets opened. Number of UDP sockets
 *	that can be opened at any given time is defined by the NO_OF_UDPSOCKETS
 *	and may be changed in order to change the amount of used RAM memory.
 *	See ucb definition for more information about the structure itself.
 *
 */
struct ucb udp_socket[NO_OF_UDPSOCKETS];

/**	\brief Used for storing field information about the received UDP packet
 *	
 *	Various fields from the received UDP packet are stored in this variable.
 *	See udp_frame definition for struct information.
 */
struct udp_frame received_udp_packet;

/** \brief Initialize UDP socket pool
 *	\ingroup core_initializer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\return 
 *		\li -1 - Error
 *		\li >0 - Number of UDP sockets initialized
 *	\warning 
 *		\li This function <b>must</b> be invoked before any other
 *			UDP-related function is called
 *
 *	This function initializes UDP socket pool to get everything into
 *	a known state at startup.
 */
INT8 udp_init (void)
{
	UINT8 i;
	struct ucb* soc;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(0);
	
	UDP_DEBUGOUT("Initializing UDP");
	
	for(i=0; i < NO_OF_UDPSOCKETS; i++) {
		soc = &udp_socket[i];			/* Get Socket	*/
		
		soc->state = UDP_STATE_FREE;
		soc->tos = 0;
		soc->locport = 0;
		soc->opts = UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS;	 
		soc->event_listener = 0;
		
		UDP_DEBUGOUT(".");
		
	}
	
	UDP_DEBUGOUT("\n\rUDP Initialized\n\r");
	
	/* Return number of sockets initialized	*/
	
	return(i+1);

}

/** \brief Allocate a free socket in UDP socket pool
 *  \ingroup udp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\param tos type of service for socket. For now nothing implemented so 0.
 *	\param listener pointer to callback function that will be invoked by
 *		the TCP/IP stack to inform socket application of #UDP_DATA_ARRIVAL
 *		event (for now only this, in future maybe others!)
 *	\param opts Options for checksum generation & inspection. Can be one
 *		of the following:
 *		\li #UDP_OPT_NONE
 *		\li #UDP_OPT_SEND_CS
 *		\li #UDP_OPT_CHECK_CS
 *		\li #UDP_OPT_SEND_CS | #UDP_OPT_CHECK_CS
 *	\return 
 *		\li -1 - Error
 *		\li >=0 - Handle to reserved socket
 *
 *	Invoke this function to try to obtain a free socket from UDP socket pool.
 *	Function returns a handle to the free socket that is later used for 
 *	accessing the allocated socket.
 */
INT8 udp_getsocket (UINT8 tos, INT32 (*listener)(INT8, UINT8, UINT32, UINT16, UINT16, UINT16), UINT8 opts )
{
	INT8 i;
	struct ucb* soc;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(-1);
	
	
	if(listener == 0) {
		UDP_DEBUGOUT("ERROR:Event listener function for UDP not specified\r\n");
		return(-1);
	}
	
	UDP_DEBUGOUT("Searching for free UDP socket...\r\n");
	
	for(i=0; i < NO_OF_UDPSOCKETS; i++) {
		soc = &udp_socket[i];			/* Get Socket	*/
	
		if(soc->state == UDP_STATE_FREE) {
			/* We found it	*/
			
			UDP_DEBUGOUT("Free socket found\r\n");
			
			soc->state = UDP_STATE_CLOSED;
			soc->tos = tos;
			soc->locport = 0;
			
			soc->opts = 0;
			
			if(opts & UDP_OPT_SEND_CS)
				soc->opts |= UDP_OPT_SEND_CS;
			if(opts & UDP_OPT_CHECK_CS)
				soc->opts |= UDP_OPT_CHECK_CS;
			
			soc->event_listener = listener;

			/* Return handle	*/
			
			return(i);
		}
	
	}
	
	/* We are there so no socket found	*/
	
	UDP_DEBUGOUT("No UDP socket found\r\n");
	return(-1);

}


/** \brief Release a given socket
 *	\ingroup udp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\param sochandle handle of UDP socket to be released
 *	\return 
 *		\li -1 - error
 *		\li >=0 - OK (returns handle to release socket)
 *
 *	This function releases UDP socket. This means that the socket entry is
 *	marked as free and all of the ucb fields are initialized to default
 *	values.
 */
INT8 udp_releasesocket (INT8 sochandle)
{
	struct ucb* soc;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_UDPSOCKETS ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &udp_socket[sochandle];		/* Get referense	*/
	
	soc->state = UDP_STATE_FREE;
	soc->tos = 0;
	soc->locport = 0;
	soc->opts = UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS;	
	soc->event_listener = 0;

	return(sochandle);

}


/** \brief Open a given UDP socket for communication
 *  \ingroup udp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\param sochandle handle to socket to be opened
 *	\param locport local port number
 *	\return
 *		\li -1 - Error
 *		\li >=0 - Handle to opened socket
 *
 *	This function binds local port to given UDP socket and opens
 *	the socket (virtually) in order to enable communication.
 */
INT8 udp_open (INT8 sochandle, UINT16 locport)
{
	struct ucb* soc;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_UDPSOCKETS ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if(locport == 0) {
		locport=udp_getfreeport();
		return(-1);
	}
	
	soc = &udp_socket[sochandle];		/* Get referense	*/

	soc->state = UDP_STATE_OPENED;
	soc->locport = locport;
	
	return(sochandle);

}



/** \brief Close given socket for communication
 *  \ingroup udp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\param sochandle handle to socket to be closed
 *	\return 
 *		\li -1 - Error
 *		\li >=0 - handle to closed socket
 *
 *	Closes a given socket in order to disable further communication
 *	over it.
 */
INT8 udp_close (INT8 sochandle)
{
	struct ucb* soc;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_UDPSOCKETS ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	soc = &udp_socket[sochandle];		/* Get referense	*/

	soc->state = UDP_STATE_CLOSED;
	
	return(sochandle);

}


/** \brief Send data to remote host using given UDP socket
 *  \ingroup udp_app_api
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 26.07.2002
 *	\param sochandle handle to UDP socket to use
 *	\param remip remote IP address to which data should be sent
 *	\param remport remote port number to which data should be sent
 *	\param buf pointer to data buffer (start of user data)
 *	\param blen buffer length in bytes (without space reserved at the 
 *		beginning of buffer for headers)
 *	\param dlen length of user data to be sent (in bytes)
 *	\return 
 *		\li -1 - Error (general error, e.g. parameters)
 *		\li -2 - ARP or lower layer not ready, try again later
 *		\li -3 - Socket closed or invalid local port
 *		\li >0 - OK (number represents number of bytes actually sent)
 *
 *	\warning
 *		\li <i>buf</i> parameter is a pointer to data to be sent in 
 *		user buffer. But note that there <b>MUST</b> be sufficient
 *		free buffer space before that data for UDP header (of #UDP_HLEN
 *		size). 
 *
 *	Use this function to send data over an already opened UDP socket. 
 */
INT16 udp_send (INT8 sochandle, UINT32 remip, UINT16 remport, UINT8* buf, UINT16 blen, UINT16 dlen)
{
	struct ucb* soc;
	UINT8* user_buf_start;
	UINT16 cs;
	UINT8 cs_cnt;
	INT16 i;
	
	if( NO_OF_UDPSOCKETS < 0 )
		return(-1);
	
	if( NO_OF_UDPSOCKETS == 0 )
		return(-1);
	
	if( sochandle > NO_OF_UDPSOCKETS ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if( sochandle < 0 ) {
		UDP_DEBUGOUT("Socket handle non-valid\r\n");
		return(-1);
	}
	
	if(remip == 0) {
		UDP_DEBUGOUT("Remote IP 0 not allowed\r\n");
		return(-1);
	}
	
	if(remport == 0) {
		UDP_DEBUGOUT("Remote port 0 not allowed\r\n");
		return(-1);
	}
	
	if( dlen > blen )
		dlen = blen;
	
	if( (dlen + UDP_HLEN) > UDP_SEND_MTU)
		dlen = UDP_SEND_MTU - UDP_HLEN;
	
	soc = &udp_socket[sochandle];		/* Get referense	*/

	if(soc->state != UDP_STATE_OPENED ) {
		UDP_DEBUGOUT("UDP Socket Closed\r\n");
		return(-3);
	}
	
	if(soc->locport == 0) {
		UDP_DEBUGOUT("ERROR:Socket local port is zero\r\n");
		return(-1);
	}

	user_buf_start = buf;
	
	buf -= UDP_HLEN;
	
	/* Put header	*/
	
	*buf++ = (UINT8)(soc->locport >> 8);
	*buf++ = (UINT8)soc->locport;
	*buf++ = (UINT8)(remport >> 8);
	*buf++ = (UINT8)remport;
	*buf++ = (UINT8)((dlen + UDP_HLEN) >> 8);
	*buf++ = (UINT8)(dlen + UDP_HLEN);
	*buf++ = 0;
	*buf = 0;
	
	buf = user_buf_start;
	buf -= UDP_HLEN;
	
	/* Calculate checksum if needed	*/
	
	cs = 0;
	
	if( soc->opts & UDP_OPT_SEND_CS) {
		cs = 0;
		cs_cnt = 0;
	
		/* Do it firstly to IP pseudo header	*/
	
		cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 24), cs_cnt++);	
		cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 16), cs_cnt++);
		cs = ip_checksum(cs, (UINT8)(localmachine.localip >> 8), cs_cnt++);
		cs = ip_checksum(cs, (UINT8)localmachine.localip, cs_cnt++);
	
		cs = ip_checksum(cs, (UINT8)(remip >> 24), cs_cnt++);	
		cs = ip_checksum(cs, (UINT8)(remip >> 16), cs_cnt++);
		cs = ip_checksum(cs, (UINT8)(remip >> 8), cs_cnt++);
		cs = ip_checksum(cs, (UINT8)remip, cs_cnt++);	
	
		cs = ip_checksum(cs, 0, cs_cnt++);
	
		cs = ip_checksum(cs, (UINT8)IP_UDP, cs_cnt++);
		
		cs = ip_checksum(cs, (UINT8)((dlen + UDP_HLEN) >> 8), cs_cnt++);
		cs = ip_checksum(cs, (UINT8)(dlen + UDP_HLEN), cs_cnt++);	
	
		/* Go to UDP header + data	*/
	
		buf = user_buf_start;
		buf -= UDP_HLEN;
	
		cs = ip_checksum_buf(cs, buf, dlen + UDP_HLEN);
			
		cs = ~ cs;
	
		if(cs == 0)
			cs = 0xFFFF;
		
		/* Save checksum in correct place	*/
		buf = user_buf_start;
		buf -= UDP_HLEN;
		buf += 6;
		*buf++ = (UINT8)(cs >> 8);
		*buf = (UINT8)cs;	
		
		buf = user_buf_start;
		buf -= UDP_HLEN;
			
	}
	
	/* Send it to IP	*/
	
	UDP_DEBUGOUT("Sending UDP...\r\n");
	
	i = process_ip_out(remip, IP_UDP, soc->tos, 100, buf, dlen + UDP_HLEN);
	
	/* Errors?	*/
	
	if( i < 0 )
		return(i);
	
	UDP_DEBUGOUT("UDP packet sent\r\n");
	
	return(i - UDP_HLEN);


}



/** \brief Process received UDP frame
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 15.07.2002
 *	\param frame pointer to received IP frame structure
 *	\param len length of data in bytes
 *	\return
 *		\li -1 - Error (packet not UDP, header errror or no socket for it)
 *		\li >0 - Packet OK
 *
 *	Invoke this function to process received UDP frames. See main_demo.c for
 *	an example on how to accomplish this.
 */
INT16 process_udp_in(struct ip_frame* frame, UINT16 len)
{
	struct ucb* soc;
	UINT16 checksum;
	UINT16 i;
	INT8 sochandle;
		
	/* Is this UDP?	*/
	
	UDP_DEBUGOUT("Processing UDP...\n\r");
	
	if( frame->protocol != IP_UDP ) {
		UDP_DEBUGOUT("ERROR: The protocol is not UDP\n\r");
		return(-1);
	}
	
	/* Start processing the message	*/
	
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);

	received_udp_packet.sport = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_udp_packet.sport |= RECEIVE_NETWORK_B();
	
	received_udp_packet.dport = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_udp_packet.dport |= RECEIVE_NETWORK_B();	
	
	received_udp_packet.tlen = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_udp_packet.tlen |= RECEIVE_NETWORK_B();
	
	received_udp_packet.checksum = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_udp_packet.checksum |= RECEIVE_NETWORK_B();
	
	if(received_udp_packet.tlen < UDP_HLEN ) {
		UDP_DEBUGOUT("UDP frame too short\n\r");
		return(-1);
	}
	
	
	/* Map UDP socket	*/
	
	sochandle = -1;
	
	for( i=0; i < NO_OF_UDPSOCKETS; i++) {
		soc = &udp_socket[i];				/* Get referense	*/

		if(soc->state != UDP_STATE_OPENED )
			continue;
		
		if(soc->locport != received_udp_packet.dport)
			continue;
		
		/* Socket found	*/
		
		sochandle = i;
		
		break;
	}
	
	if( sochandle < 0 ) {
		UDP_DEBUGOUT("No socket found for received UDP Packet\r\n");
		
		/* TODO: Send ICMP	*/
		
		return(-1);
	}
	
	/* Calculate checksum for received packet	*/
	
	if(soc->opts & UDP_OPT_CHECK_CS) {
		if(received_udp_packet.checksum != 0) {
			checksum = 0;
			i = 0;
			
			/* Do it firstly to IP pseudo header	*/
	
			checksum = ip_checksum(checksum, (UINT8)(frame->dip >> 24), (UINT8)i++);	
			checksum = ip_checksum(checksum, (UINT8)(frame->dip >> 16), (UINT8)i++);
			checksum = ip_checksum(checksum, (UINT8)(frame->dip >> 8), (UINT8)i++);
			checksum = ip_checksum(checksum, (UINT8)frame->dip, (UINT8)i++);
	
			checksum = ip_checksum(checksum, (UINT8)(frame->sip >> 24), (UINT8)i++);	
			checksum = ip_checksum(checksum, (UINT8)(frame->sip >> 16), (UINT8)i++);
			checksum = ip_checksum(checksum, (UINT8)(frame->sip >> 8), (UINT8)i++);
			checksum = ip_checksum(checksum, (UINT8)frame->sip, (UINT8)i++);	
	
			checksum = ip_checksum(checksum, 0, (UINT8)i++);
	
			checksum = ip_checksum(checksum, (UINT8)IP_UDP, (UINT8)i++);
		
			checksum = ip_checksum(checksum, (UINT8)(len >> 8), (UINT8)i++);
			checksum = ip_checksum(checksum, (UINT8)len, (UINT8)i++);	

	
			NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
	
			for(i=0; i < len; i++)
				checksum = ip_checksum(checksum, RECEIVE_NETWORK_B(), (UINT8)i);
	
			checksum = ~ checksum;
	
			if(checksum != IP_GOOD_CS) {
				UDP_DEBUGOUT("ERROR: UDP Checksum failed!\n\r");
				return (-1);
			}
		
		}
	
		UDP_DEBUGOUT("UDP Checksum OK\n\r");
	
	}
	
	
	received_udp_packet.buf_index = frame->buf_index + UDP_HLEN;
	NETWORK_RECEIVE_INITIALIZE(received_udp_packet.buf_index);
	
	/* Generate data event	*/
	
	soc->event_listener(sochandle, UDP_EVENT_DATA, frame->sip, received_udp_packet.sport, received_udp_packet.buf_index, received_udp_packet.tlen - UDP_HLEN);
	
	return(1);

}

/** \brief Returns next free (not used) local port number
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.10.2002
 *	\return 
 *		\li 0 - no free ports!
 *		\li >0 - free local TCP port number
 *
 *	Function attempts to find new local port number that can be used to 
 *	establish a connection. 
 */
UINT16 udp_getfreeport (void){
	struct ucb* soc;
	static UINT16 lastport = 1;
	UINT16 start;
	UINT16 i;
	

	/* Try with every port to every socket untill free found	*/
		
	for( start = lastport++; start != lastport; lastport++)	{
		if(lastport == UDP_PORTS_END)
			lastport = 1;
			
		for(i = 0; i < NO_OF_UDPSOCKETS; i++) {
			soc = &udp_socket[i];					/* Get socket	*/
			
			if( (soc->state > UDP_STATE_CLOSED) && (soc->locport == lastport) )			{
				/* Blaah, this socket has reserved the port, go to next one	*/
				break; 
			}
			
		}	
			
		/* Did we found it?	*/
			
		if( i == NO_OF_UDPSOCKETS)
			break; 
			
	}
		
	if(lastport == start) {
		DEBUGOUT("Out of UDP ports!!\n\r");
		return(0);
	}
		
	return(lastport);
		
}





