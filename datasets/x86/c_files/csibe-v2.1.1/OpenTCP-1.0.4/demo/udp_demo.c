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

/** \file udp_demo.c
 *	\ingroup opentcp_example
 *	\brief Demonstration of a possible scenario of writing UDP application
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
 *	Blank UDP demo application showing UDP functions and how applications
 *	might use them.
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/globalvariables.h>
#include <inet/system.h>
#include <inet/tcp_ip.h>

/* The applications that use UDP must implement following function stubs			*/
/* void application_name_init (void) - call once when processor starts				*/
/* void application_name_run (void) - call periodically on main loop				*/
/* INT32 application_name_eventlistener (INT8, UINT8, UINT32, UINT16, UINT16, UINT16)	*/
/* - called by TCP input process to inform arriving data, errors etc 				*/

/* These will probably go to some include file */
void udp_demo_init(void);
void udp_demo_run(void);
INT32 udp_demo_eventlistener(INT8 , UINT8 , UINT32 , UINT16 , UINT16 , UINT16 );

/** \brief Socket handle holder for this application
 *
 * This variable holds the assigned socket handle. Note that this application 
 * will reserve one UDP socket immediately and will not release it. For
 * saving resources, UDP sockets can also be allocated/deallocated 
 * dynamically.
 */
UINT8 udp_demo_soch;

UINT8 udp_demo_senddata; /**< Used to trigger data sending */

#define UDP_DEMO_PORT	5000 /**< Port number on which we'll work */

#define UDP_DEMO_RMTHOST_IP	0xAC100101	/**< Remote IP address this application will send data to*/

#define UDP_DEMO_RMTHOST_PRT	5001	/**< Port number on remote server we'll send data to */

/* Internal function used for sending data to a predefined host */
INT16 udp_demo_send(void);

/* Initialize resources needed for the UDP socket application */
void udp_demo_init(void){

	DEBUGOUT("Initializing UDP demo client\r\n");
	
	/* Get socket:
	 * 	0 - for now not type of service implemented in UDP
	 * 	udp_echo_eventlistener - pointer to listener function
	 *	UDP_OPT_SEND_CS|UDP_OPT_CHECK_CS - checksum options. Calculate
	 *		checksum for outgoing packets and check checksum for
	 *		received packets.
	 */
	udp_demo_soch=udp_getsocket(0 , udp_demo_eventlistener , UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS);
	
	if(udp_demo_soch == -1){
		DEBUGOUT("No free UDP sockets!! \r\n");
		RESET_SYSTEM();
	}
	
	/* open socket for receiving/sending of the data on defined port*/
	udp_open(udp_demo_soch,UDP_DEMO_PORT);
	
	/* for now no data sending */
	udp_demo_senddata=0;
}

/* UDP Demo app main loop that is periodically invoked from the
 * main loop (see main_demo.c)
 */
void udp_demo_run(void){
	/* do maybe some other UDP demo app stuff
	 * .....
	 */
	if(udp_demo_senddata) {
		switch(udp_demo_send()){
			case -1:
				DEBUGOUT("Error (General error, e.g. parameters)\r\n");
				break; 
			case -2:
				DEBUGOUT("ARP or lower layer not ready, try again\r\n");
				break;
			case -3:
				DEBUGOUT("Socket closed or socket handle not valid!\r\n");
				break;
			default:
				/* data sent (could check how many bytes too)
				 * if no more data to send, reset flag
				 */
				udp_demo_senddata=0;
				break;
		
		}
	}
}

/*
 * Event listener invoked when TCP/IP stack receives UDP datagram for
 * a given socket. Parameters:
 * - cbhandle - handle of the socket this packet is intended for. Check it
 *	just to be sure, but in general case not needed
 * - event - event that is notified. For UDP, only UDP_EVENT_DATA
 * - ipaddr - IP address of remote host who sent the UDP datagram
 * - port - port number of remote host who sent the UDP datagram
 * - buffindex - buffer index in RTL8019AS allowing you to read 
 * 	received data more than once from Ethernet controller by
 *	invoking NETWORK_RECEIVE_INITIALIZE(buffindex) and then start
 *	reading the bytes all over again
 */ 
INT32 udp_demo_eventlistener(INT8 cbhandle, UINT8 event, UINT32 ipaddr, UINT16 port, UINT16 buffindex, UINT16 datalen){
	UINT16 i;
	if(cbhandle!=udp_demo_soch){
		DEBUGOUT("Not my handle!!!!");
		return (-1);
	}
	
	switch(event){
		case UDP_EVENT_DATA:
			
			/* read data that was received (and 
			 * probably do something with it :-)
			 */
			for(i=0;i<datalen;i++)
				RECEIVE_NETWORK_B();
				
			/* If needed initialize data sending
			 * by setting udp_demo_senddata variable or
			 * send data directly from event listener (
			 * only possible for UDP applications!!!!
			 */
			 
			break;
			
		default:
			/* should never get here */
			DEBUGOUT("Unknown UDP event :-(");
			break;
	}
	return 0;
}

/* internal function invoked to send UDP message to, in this case,
 * some predefined host.
 */
#define MSG_SIZE 20
INT16 udp_demo_send(void){
	UINT8	i;
	
	/* put message in buffer. Message needs to start from UDP_APP_OFFSET
	 * because TCP/IP stack will put headers in front of the message to
	 * avoid data copying
	 */
	for(i=0;i<MSG_SIZE;i++)
		net_buf[UDP_APP_OFFSET+i]=i;
	
	/* send message		*/
	return udp_send(udp_demo_soch,UDP_DEMO_RMTHOST_IP,UDP_DEMO_RMTHOST_PRT,net_buf+UDP_APP_OFFSET,NETWORK_TX_BUFFER_SIZE-UDP_APP_OFFSET,MSG_SIZE);
	
}
