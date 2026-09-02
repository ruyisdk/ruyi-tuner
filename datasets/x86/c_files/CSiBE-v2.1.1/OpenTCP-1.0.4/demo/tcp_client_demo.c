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

/** \file tcp_client_demo.c
 *	\ingroup opentcp_example
 *	\brief Demonstration of a possible scenario of writing TCP applications
 *	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 10.10.2002
 *	\bug
 *	\warning
 *		\li This example is given for demonstration purposes only. It
 *		was not tested for correct operation.
 *	\todo
 *  
 *	Blank TCP demo application showing TCP functions and how applications
 *	might use them. Please note that this is an example for a TCP client
 *	application - the kind of application that initiates communication and
 *	does not accept incoming connections.
 *
 */
 

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/globalvariables.h>
#include <inet/system.h>
#include <inet/tcp_ip.h>

/* The applications that use TCP must implement following function stubs			*/
/* void application_name_init (void) - call once when processor starts				*/
/* void application_name_run (void) - call periodically on main loop				*/
/* INT32 application_name_eventlistener (INT8, UINT8, UINT32, UINT32)				*/
/* - called by TCP input process to inform arriving data, errors etc */

/* These will probably go to some include file */
void tcpc_demo_init(void);
void tcpc_demo_run(void);
INT32 tcpc_demo_eventlistener(INT8 , UINT8 , UINT32 , UINT32 );

/** \brief Socket handle holder for this application
 *
 * This variable holds the assigned socket handle. Note that this application 
 * will reserve one TCP socket immediately and will not release it. For
 * saving resources, TCP sockets can also be allocated/deallocated 
 * dynamically.
 */
INT8 tcpc_demo_soch;

UINT8 tcpc_demo_senddata; /**< Used to trigger data sending */

UINT8 tcpc_demo_connect; /**< Used to trigger connection initiation to remote host */

#define TCPC_DEMO_RMT_IP	0xAC100101	/**< Remote IP address this application will connect to*/
#define TCPC_DEMO_RMT_PORT	5001		/**< Port number on remote server we'll connect to */

/* Internal function used for sending data to a predefined host */
INT16 tcpc_demo_send(void);

/* Initialize resources needed for the TCP server application */
void tcpc_demo_init(void)
{
	
	DEBUGOUT("Initializing TCP server application. \r\n");
		
	/* Get socket:
	 * 	TCP_TYPE_CLIENT - type of TCP socket is client (no incomming TCP conn.)
	 * 	TCP_TOS_NORMAL  - no other type of service implemented so far
	 *	TCP_DEF_TOUT	- timeout value in seconds. If for this many seconds
	 *		no data is exchanged over the TCP connection the socket will be
	 *		closed.
	 *	tcpc_demo_eventlistener - pointer to event listener function for
	 * 		this socket.	
	 */

	tcpc_demo_soch = tcp_getsocket(TCP_TYPE_CLIENT, TCP_TOS_NORMAL, TCP_DEF_TOUT, tcpc_demo_eventlistener);
	
	if( tcpc_demo_soch < 0 )
	{
		DEBUGOUT("TCP client unable to get socket. Resetting!!!\r\n");
		RESET_SYSTEM();
	}
	
	/* for now no data sending */
	tcpc_demo_senddata=0;
	
	/* and don't try to connect */
	tcpc_demo_connect=0;
}

void tcpc_demo_run(void)
{	
	
	/* do maybe some other TCP server app stuff
	 * .....
	 */
	 
	if(tcpc_demo_connect){
		if(tcp_connect(tcpc_demo_soch, TCPC_DEMO_RMT_IP, TCPC_DEMO_RMT_PORT,0)>0){
			/* Connection establishing procedure started */
			tcpc_demo_connect=0;
			}
	}
	
	if(tcpc_demo_senddata){
		if(tcpc_demo_send()!=-1)		
			tcpc_demo_senddata=0;
	}
}

 /*
 * Event listener invoked when TCP/IP stack receives TCP data for
 * a given socket. Parameters:
 * - cbhandle - handle of the socket this packet is intended for. Check it
 *	just to be sure, but in general case not needed
 * - event - event that is notified. For TCP there are quite a few possible
 *	events, check switch structure below for more information
 * - par1, par2 - parameters who's use depends on the event that is notified
 */
INT32 tcpc_demo_eventlistener(INT8 cbhandle, UINT8 event, UINT32 par1, UINT32 par2)
{
/* This function is called by TCP stack to inform about events	*/
	UINT16 i;
	
	if( cbhandle != tcpc_demo_soch)		/* Not our handle	*/
		return(-1);
	
	switch( event ){
		
		/* Connection request event. Used by TCP/IP stack to inform
		 * the application someone is trying to establish a connection.
		 * Server can decide, based on provided IP address and port number,
		 * whether to allow or not connection establishment.
		 * Parameters:
		 *  - par1 - remote hosts IP address
		 *  - par2 - remote hosts port number
		 * 
		 * Return values from event listener:
		 * -1 - do not allow connection to be established (send reset)
		 * -2 - do not send any response for now to the SYN packet (let's
		 *		think a little before answering)
		 * 1  - allow connection to be established
		 */
		case TCP_EVENT_CONREQ:
			/* should never get here in client TCP application! */
			DEBUGOUT("Connection request arrived!\r\n");
			
			/* Enable all connections	*/
			return(-1);
		
			break;
			
		/* Connection abort event. Connection on a given socket is beeing 
		 * aborted for somereason (usually retransmissions are used up or 
		 * some abnormal situation in communication happened).
 		 * Parameters:
		 *  - par1 - remote hosts IP address
		 *  - par2 - remote hosts port number
		 */
		case TCP_EVENT_ABORT:
			DEBUGOUT("Connection aborting!\r\n");
			break;
		
		/* Connection established event - three-way handshaking performed
		 * OK and connection is established.
		 * Parameters:
		 *  - par1 - remote hosts IP address
		 *  - par2 - remote hosts port number
		 */
		case TCP_EVENT_CONNECTED:
			DEBUGOUT("TCP connection established!\r\n");
			/* do something ... (initialize data sending for example */
			break;
			
		/* Connection closing event. Happens when TCP connection is
		 * intentionally close by some side calling close function and
		 * initializing proper TCP connection close procedure.
		 * Parameters:
		 *  - par1 - remote hosts IP address
		 *  - par2 - remote hosts port number
		 */
		case TCP_EVENT_CLOSE:
			DEBUGOUT("TCP Connection closing...!\r\n");
			break;
			
		/* Data acknowledgment event. Happens when data that was
		 * previously sent gets acknowledged. This means we can now
		 * send some more data! :-)
		 * Parameters:
		 *  - par1 - remote hosts IP address
		 *  - par2 - remote hosts port number
		 */
		case TCP_EVENT_ACK:
			DEBUGOUT("Data acknowledged!\r\n");
			/* if more data should be sent, adjust variables and
				set tcpc_demo_senddata variable */
				
			break;
		
		/* Data received event. Happens when we receive some data over the
		 * TCP connection.
		 * Parameters:
		 *  - par1 - number of data bytes received
		 *  - par2 = 0
		 */
		case TCP_EVENT_DATA:
			DEBUGOUT("Data arrived!\r\n");
			/* read data that was received (and 
			 * probably do something with it :-)
			 */
			for(i=0;i<par1;i++)
				RECEIVE_NETWORK_B();
				
			/* If needed initialize data sending
			 * by setting tcpc_demo_senddata variable
			 */
			break;
			
		/* Regenerate data event. Happens when data needs to be
		 * retransmitted because of possible loss on the network.
		 * Note that THE SAME DATA must be sent over and over again
		 * until TCP_EVENT_ACK is generated (for that data)! 
		 * Parameters:
		 *  - par1 - amount of data to regenerate (usually all)
		 *	- par2 = 0
		 */
		case TCP_EVENT_REGENERATE:
			tcpc_demo_send();
			break;
	
	
		default:
			return(-1);
	}
}

INT16 tcpc_demo_send(void){
	UINT16 i;
	/* first check if data sending is possible (it may be that
	 * previously sent data is not yet acknowledged)
	 */
	if(tcp_checksend(tcpc_demo_soch) < 0 ){
		/* Not yet */
		return -1;
	}
	
	/* put message in buffer. Message needs to start from TCP_APP_OFFSET
 	 * because TCP/IP stack will put headers in front of the message to
 	 * avoid data copying
 	 */
	for(i=0;i<32;i++)
		net_buf[TCP_APP_OFFSET+i]='A'+(i%25);

	/* send data */
	return tcp_send(tcpc_demo_soch, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 32);

}
