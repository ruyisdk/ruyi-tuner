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

/** \file tcp_ip.h
 *	\brief OpenTCP ARP interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 1.2.2002
 * 	
 *	OpenTCP TCP and UDP protocol function declarations, constants, etc. 
 */

#ifndef INCLUDE_TCP_IP_H
#define INCLUDE_TCP_IP_H

#include <inet/datatypes.h>
#include <inet/ethernet.h>
#include <inet/ip.h>

/* User define			*/

/** \def NO_OF_TCPSOCKETS
 *	\ingroup opentcp_config
 *	\brief Defines number of TCP sockets available
 *
 *	Change this number to change maximum number of TCP sockets available
 *	to the application.
 *
 */
#define NO_OF_TCPSOCKETS	8

/** \def NO_OF_UDPSOCKETS
 *	\ingroup opentcp_config
 *	\brief Defines number of UDP sockets available
 *
 *	Change this number to change maximum number of UDP sockets available
 *	to the application.
 *
 */
#define NO_OF_UDPSOCKETS	4

/** \def TCP_PORTS_END
 *	\ingroup opentcp_config
 *	\brief Define reserved-ports space
 *
 *	TCP socket numbers will only be assigned to be lower than this 
 *	number. 
 */
#define TCP_PORTS_END		1023

/** \def UDP_PORTS_END
 *	\ingroup opentcp_config
 *	\brief Define reserved-ports space
 *
 *	UDP socket numbers will only be assigned to be lower than this 
 *	number. 
 */
#define UDP_PORTS_END			1023					

/* UDP Control optios			*/

/** \def UDP_OPT_NONE
 *	\brief Disable checksum calculation for UDP socket
 *
 *	By choosing only this option for UDP socket, checksum calculation 
 *	will be disabled for both incoming/outgoing UDP packets. This will
 *	make UDP extremely fast, but also more prone to errors. This is usually
 *	not a big limitation considering that checksum is not so good in
 *	error-detection anyway.
 */
#define UDP_OPT_NONE		0

/** \def UDP_OPT_SEND_CS
 *	\brief Enable checksum calculation for outgoing UDP packets
 *
 *	When only this option is chosen, checksum is calculated for outgoing
 *	UDP packets. This is sometimes neccessary since certain applications
 *	can disable reception of UDP packets without a calculated checksum.
 *
 */
#define UDP_OPT_SEND_CS		1

/** \def UDP_OPT_CHECK_CS
 *	\brief Enable checksum checking for received UDP packets
 *
 *	When this option is enabled, checksum is checked for all received
 *	UDP packets to check for transmission errors.
 */
#define UDP_OPT_CHECK_CS	2

#define UDP_SEND_MTU		ETH_MTU - ETH_HEADER_LEN - UDP_HLEN - IP_MAX_HLEN

#define UDP_HLEN			8				/**< UDP Header Length			*/

#define	MIN_TCP_HLEN		20
#define	MAX_TCP_OPTLEN		40				
#define TCP_DEF_MTU			512				/* Default MTU for TCP			*/

/** \def TCP_DEF_RETRIES
 *	\ingroup opentcp_config
 *	\brief Number of attempted TCP retransmissions before giving up
 *
 *	This number defines how many times will TCP module try to retransmit
 *	the data before recognizing that connection was broken. Increase this
 *	value for high-latency, low-throughput networks with substantial packet
 *	loss.
 *
 */
#define	TCP_DEF_RETRIES		7			

/** \def TCP_CON_ATTEMTPS
 *	\ingroup opentcp_config
 *	\brief Number of connection-establishment attempts
 *
 *	This number defines how many times will TCP module try to connect
 *	to the desired host.
 */
#define TCP_CON_ATTEMPTS	7

/** \def TCP_DEF_KEEPALIVE
 *	\ingroup opentcp_config
 *	\brief Defines a number of  seconds after which an empty ACK packet is sent
 *
 *	If for TCP_DEF_KEEPALIVE seconds nothing is received/sent over the
 *	TCP connection (this includes received empty TCP packets) an empty
 *	(keep-alive) TCP packet will be sent to check if the other side is 
 *	still replying (and able to reply).
 */
#define	TCP_DEF_KEEPALIVE	4			

/** \def TCP_DEF_RETRY_TOUT
 *	\ingroup opentcp_config
 *	\brief Default data-retransmission period (in seconds)
 *
 *	If data was not acknowledged during the time-frame defined by this
 *	value (in seconds) retransmission procedure will occur.
 */
#define TCP_DEF_RETRY_TOUT	4

/** \def TCP_INIT_RETRY_TOUT
 *	\ingroup opentcp_config
 *	\brief Initial retransmission period (in seconds)
 *
 *	Initial retransmission is made a little faster, which helps with
 *	connection establishment if ARP cache didn't contain remote IP address.
 */
#define TCP_INIT_RETRY_TOUT	1

/** \def TCP_SYN_RETRY_TOUT
 *	\ingroup opentcp_config
 *	\brief Retranmission period for SYN packet
 *
 *	Controls SYN packet (segment) retransmit period.
 */
#define TCP_SYN_RETRY_TOUT	2

/** \def TCP_TOS_NORMAL
 *	\brief Defines normal type of service for TCP socket
 *
 *	This defines normal (and for now the only one implemented) type of
 *	service for the TCP socket.
 */
#define TCP_TOS_NORMAL		0

/** \def TCP_DEF_TOUT
 *	\ingroup opentcp_config
 *	\brief Default idle timeout
 *
 *	This period defines idle timeout in seconds - this feature allows
 *	TCP/IP stack to close the TCP connection if no data has been exchanged
 *	over it during this period of time. This relates ONLY to data. Empty
 *	keep-alive TCP packets are not included.
 */
#define TCP_DEF_TOUT		120				

#define TCP_HALF_SEQ_SPACE	0x0000FFFF		/* For detecting sequence space	*/


/* ICMP message types */

#define ICMP_TYPE_DEST_UNREACHABLE	3
#define ICMP_ECHO_REQUEST	8
#define ICMP_ECHO_REPLY		0
#define ICMP_CODE_FRAGMENTATION_NEEDED_DF_SET	4
#define ICMP_MTUMSG_LEN	16
#define ICMP_ECHOREQ_HLEN	8
#define ICMP_TEMPIPSET_DATALEN	102


/* UDP States					*/

/** \def UDP_STATE_FREE
 *	\brief Defines that UDP socket is free and available
 *	
 *	If an entry of ucb type has this as a state value, then it is free
 *	and can be allocated by the udp_getsocket().
 */
#define UDP_STATE_FREE			1

/** \def UDP_STATE_CLOSED
 *	\brief Defines that UDP socket is allocated but closed
 *
 *	Entries of ucb type that have this as their state value were
 *	allocated by udp_getsocket() but they are in the closed state,
 *	so no data can be received/sent through the socket.
 */
#define UDP_STATE_CLOSED		2

/** \def UDP_STATE_OPENED
 *	\brief Defines that UDP socket is allocated and opened
 *
 *	Corresponding UDP socket was allocated and opened so data
 *	can be transmitted/received through it.
 */
#define UDP_STATE_OPENED		3

/* UDP Events					*/

/** \def UDP_EVENT_DATA
 *	\brief Only UDP event notified to UDP socket event listener
 *
 *	For now, this is the only UDP event that is notified to the
 *	UDP sockets' event listener.
 */
#define UDP_EVENT_DATA			64


/* TCP FLAGS					*/

#define	TCP_FLAG_ACK			0x10
#define TCP_FLAG_PUSH			0x08
#define TCP_FLAG_RESET			0x04
#define TCP_FLAG_SYN			0x02
#define TCP_FLAG_FIN			0x01

/* TCP Internal flags			*/

#define TCP_INTFLAGS_CLOSEPENDING	0x01

/* TCP socket types				*/
/** \def TCP_TYPE_NONE
 *	\brief TCP socket is nor a client nor a server
 *
 *	If TCP socket entry is of this type it can not be used for anything. 
 *	This may only be used for testing, debugging, etc. purposes or if 
 *	application is not sure what it wants to be it can reserve a TCP 
 *	socket by getting a socket of type TCP_TYPE_NONE.
 */
#define	TCP_TYPE_NONE			0x00

/** \def TCP_TYPE_SERVER
 *	\brief TCP socket represents a server application
 *
 *	If TCP socket entry is of server type, application using it can only
 *	listen on a given socket for incoming connections. No connections
 *	can be opened towards some outside host unless the outside host
 *	initiates the connection.
 */
#define	TCP_TYPE_SERVER			0x01

/** \def TCP_TYPE_CLIENT
 *	\brief TCP socket represents a client application
 *
 *	If TCP socket entry is of client type, application using it can
 *	establish connection through it towards other Internet hosts but
 *	can not accept any incoming connections on the port (execute
 *	tcp_listen() on it that is).
 */
#define	TCP_TYPE_CLIENT			0x02

/** \def TCP_TYPE_CLIENT_SERVER
 *	\brief	TCP socket can act as client or as server
 *
 *	If TCP socket entry is of this type, application using it can 
 *	both listen on a given socket or establish connection towards an
 *	outside host.
 */
#define	TCP_TYPE_CLIENT_SERVER	0x03

/* TCP States. For more detailed descriptions see RFC793		*/

#define	TCP_STATE_FREE			1	/**< Entry is free and unused 				*/
#define	TCP_STATE_RESERVED		2	/**< Entry is reserved for use				*/
#define	TCP_STATE_CLOSED		3	/**< Entry allocated, socket still closed	*/
#define TCP_STATE_LISTENING		4	/**< Socket in listening state,
									 *	 waiting for incoming connections
									 */
#define TCP_STATE_SYN_RECEIVED	5	/**< SYN packet received (either first
									 *	 SYN packet or response to SYN that
									 *	 we have previously sent)
									 */
#define	TCP_STATE_SYN_SENT		6	/**< SYN packet sent as an attempt
									 *	 to establish a connection
									 */
#define TCP_STATE_FINW1			7	/**< User issued tcp_close request
									 *	 issued so FIN packet was sent
									 */
#define	TCP_STATE_FINW2			8	/**< Received ACK of our FIN, now
									 *	 waiting for other side to send
									 *	 FIN
									 */
#define TCP_STATE_CLOSING		9	/**< Received FIN independently of 
									 *	 our FIN
									 */
#define	TCP_STATE_LAST_ACK		10	/**< Waiting for last ACK packet as a 
									 *	 response to our FIN
									 */
#define TCP_STATE_TIMED_WAIT	11	/**< Waiting for 2MSL to prevent
									 *	 erroneous connection duplication
									 */
#define	TCP_STATE_CONNECTED		12	/**< Connection established and data
									 *	 flowing freely to both sides :-)
									 */



/* TCP callback events			*/

/** \def TCP_EVENT_CONREQ
 *	\brief Connection request event
 *	
 *	Connection request event is notified to TCP server applications'
 *	event listener when SYN packet is received for it's socket. Event
 *	listener can then, if it wants to, inspect IP addres and port number
 *	of the remote host, or some other internal parameters, to decide
 *	whether it should allow connection establishment or not. One of the
 *	following values must then be returned from the event listener:
 *		\li -1 - do not allow connection to be established. RST packet will
 *		be sent to remote host.
 *		\li	-2 - do not respond to this particular SYN packet (keep quiet).
 *		This may be used if device is somehow busy and not yet ready to
 *		establish a connection, but doesn't wan't to forcefully reject the
 *		connection with a RST packet.
 *		\li 1 - allow connection to be established
 */
#define TCP_EVENT_CONREQ		1

/** \def TCP_EVENT_CONNECTED
 *	\brief Connection established event
 *
 *	Applications' event listener is informed by this event that
 *	connection is established and that it may start sending/receiving
 *	data.
 */

#define TCP_EVENT_CONNECTED		2

/** \def TCP_EVENT_CLOSE
 *	\brief Connection closed event
 *
 *	TCP connection was properly closed (either by calling tcp_close() by
 *	application or remote host initialized closing sequence).
 */
#define TCP_EVENT_CLOSE			4

/** \def TCP_EVENT_ABORT
 *	\brief Connection aborted event
 *
 *	Connection is, for some reason, aborted. This can happen for a number
 *	of reasons:
 *		\li Data retransmissions performed sufficient number of times but
 *		no acknowledgment was received
 *		\li No response for some time to keep-alive packets
 *		\li Remote host forcefully closed the connection for some reason
 *		\li Application invoked tcp_abort() function
 */
#define TCP_EVENT_ABORT			8

/** \def TCP_EVENT_ACK
 *	\brief Data acknowledged event
 *
 *	TCP/IP stack has received correct acknowledgment packet for the 
 *	previously sent data and is informing the application about it.
 *	After this event, application can send new data packet to remote
 *	host.
 */
#define TCP_EVENT_ACK			16

/** \def TCP_EVENT_REGENERATE
 *	\brief Regenerate data event
 *
 *	Previously sent data packet was not acknowledged (or the acknowledgment
 *	packet did not arrive) so retransmission needs to be peformed.
 *	Application must resend the data that was sent in the previous packet.
 */
#define TCP_EVENT_REGENERATE	32

/** \def TCP_EVENT_DATA
 *	\brief Data arrival event
 *
 *	TCP received some data from remote host and is informing application
 *	that it is available for reading from the Ethernet controller.
 */
#define	TCP_EVENT_DATA			64



/* TCP and UDP buffer handling			*/

/** \def TCP_APP_OFFSET
 *	\brief Transmit buffer offset for TCP applications
 *
 *  This value defines offset that TCP applications must use when
 *	writing to transmit buffer. This many bytes will be used
 *	<b>before</b> the first byte of applications data in the 
 *	transmit buffer to store TCP header.
 */
#define TCP_APP_OFFSET			MIN_TCP_HLEN		/* Application buffers must have 	*/
													/* this much free on start of buf	*/

/** \def UDP_APP_OFFSET
 *	\brief Transmit buffer offset for UDP applications
 *
 *  This value defines offset that UDP applications must use when
 *	writing to transmit buffer. This many bytes will be used
 *	<b>before</b> the first byte of applications data in the 
 *	transmit buffer to store UDP header.
 */

#define UDP_APP_OFFSET			UDP_HLEN



/* UDP Structures			*/

/** \struct udp_frame
 *	\brief UDP header information
 *
 *	This structures' fields are used to hold information about the headers
 *	of the received UDP packet. 
 *
 *	In addition to standard UDP header fields, buf_index field
 *	has been added allowing applications to re-read the received data many
 *	times by reinitializing reading based on the address stored in this
 *	field.
 */
struct udp_frame
{
	UINT16 sport;		/**< Source port					*/
	UINT16 dport;		/**< Destination port				*/
	UINT16 tlen;		/**< total len (UDP part)			*/
	UINT16 checksum;	/**< UDP checksum					*/
	UINT16 buf_index;	/**< Data offsett from the start
						 * 	 of network buffer			
						 */
};

/** \struct ucb
 *	\brief UDP control block
 *
 *	This structure holds various fields used to keep track of UDP socket
 *	states, settings and event listener function.
 *
 */
struct ucb
{
	/** \brief State of socket entry
	 *
	 *	This variable holds state of a particular UDP socket entry 
	 *	in the UDP socket table. Following values are possible:
	 *		\li UDP_STATE_FREE
	 *		\li UDP_STATE_CLOSED
	 *		\li UDP_STATE_OPENED
	 */
	UINT8 	state;		
	
	/** \brief Type of service allocated for a socket
	 *
	 *	For now no services implemented so this value
	 *	is not important.
	 */	
	UINT8	tos;

	UINT16	locport;	/**< Local UDP port of Socket		*/
	
	/** \brief Socket options 
	 *
	 *	Currently, this holds information about checksum calculation
	 *	options. Can be one of the following:
	 *		\li	UDP_OPT_NONE - cheksum calculation not performed
	 *		\li UDP_OPT_SEND_CS - checksum is calculated for outgoing
	 *		UDP packets
	 *		\li UDP_OPT_CHECK_CS - checksum is checked for incoming
	 *		UDP packets
	 *		\li UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS - both checksum
	 *		calculations are enabled
	 */
	UINT8	opts;		
	
	/** \brief UDP socket application event listener
	 *
	 *	Pointer to a event listener - a callback function used
	 *	by TCP/IP stack to notify application about certain events.
	 */	
	INT32 	(*event_listener)
			(INT8, UINT8, UINT32, UINT16, UINT16, UINT16 );
}; 



/* TCP Structures			*/

/** \struct tcp_frame
 *	\brief TCP header information
 *
 *	This structure holds header fields from the received TCP packet. 
 *
 *	In addition to standard header fields, buf_index field
 *	has been added allowing applications to re-read the received data many
 *	times by reinitializing reading based on the address stored in this
 *	field.
 */
struct tcp_frame
{
	UINT16	sport;						/**< Source port					*/
	UINT16	dport;						/**< Destination port				*/
	UINT32	seqno;						/**< Sequence number				*/
	UINT32	ackno;						/**< Acknowledgement number		*/
	UINT16	hlen_flags;					/**< Header length and flags		*/
	UINT16 	window;						/**< Size of window				*/
	UINT16 	checksum;					/**< TCP packet checksum			*/
	UINT16 	urgent;						/**< Urgent pointer				*/
	UINT8	opt[MAX_TCP_OPTLEN + 1];	/**< Option field					*/
	UINT16	buf_index;					/**< Next offset from the start of
										 *   network buffer				
										 */	
};

/** \struct tcb
 *	\brief TCP transmission control block
 *
 *	This structure holds various fields used to keep track of TCP socket
 *	states, settings and event listener function. It is needed to ensure
 *	proper operation of TCP state machine and TCP connections based on it.
 *
 *	
 */
struct tcb
{
	/** \brief State of the TCP socket [entry]
	 *
	 *	This variable holds information used by the OpenTCP to manage
	 *	sockets as well as information needed to manage TCP connection.
	 *	Possible values are:
	 *		\li TCP_STATE_FREE
	 *		\li TCP_STATE_RESERVED
	 *		\li TCP_STATE_CLOSED
	 *		\li TCP_STATE_LISTENING
	 *		\li TCP_STATE_SYN_RECEIVED
	 *		\li TCP_STATE_SYN_SENT
	 *		\li TCP_STATE_FINW1
	 *		\li TCP_STATE_FINW2
	 *		\li TCP_STATE_CLOSING
	 *		\li TCP_STATE_LAST_ACK
	 *		\li TCP_STATE_TIMED_WAIT
	 *		\li TCP_STATE_CONNECTED
	 */
	UINT8	state;						
	
	/** \brief type of the TCP socket
	 *
	 *	Defines type of the TCP socket allocated. This determines
	 *	how connection is established/closed in some cases.
	 *	Possible values are:
	 *		\li TCP_TYPE_NONE
	 *		\li TCP_TYPE_SERVER
	 *		\li TCP_TYPE_CLIENT
	 *		\li TCP_TYPE_CLIENT_SERVER
	 */
	UINT8	type;						
	UINT8	flags;						/**< State machine flags			*/
	UINT32	rem_ip;						/**< Remote IP address			*/
	UINT16	remport;					/**< Remote TCP port				*/
	UINT16	locport;					/**< Local TCP port				*/
	UINT32 	send_unacked;
	UINT8	myflags;					/**< My flags to be Txed			*/
	UINT32	send_next;
	UINT16 	send_mtu;
	UINT16	tout;						/**< Socket idle timeout (seconds)*/
	UINT8	tos;						/**< Type of service allocated */
	UINT32	receive_next;
	UINT16	persist_timerh;				/**< Persistent timers' handle */
	UINT16	retransmit_timerh;			/**< Retransmission timers' handle */
	UINT8	retries_left;				/**< Number of retries left before
										 *	 aborting
										 */
	
	/** \brief TCP socket application event listener
	 *
	 *	Pointer to an event listener - a callback function used
	 *	by TCP/IP stack to notify application about certain events.
	 */
	INT32 	(*event_listener)(INT8, UINT8, UINT32, UINT32);	
	
};

/* ICMP function prototypes	*/

INT16 process_icmp_in(struct ip_frame*, UINT16);

/* UDP Function prototypes */
INT8 udp_init (void);
INT8 udp_getsocket (UINT8 , INT32 (* )(INT8, UINT8, UINT32, UINT16, UINT16, UINT16), UINT8 );
INT8 udp_releasesocket (INT8 );
INT8 udp_open (INT8 , UINT16 );
INT8 udp_close (INT8 );
INT16 udp_send (INT8 , UINT32 , UINT16 , UINT8* , UINT16 , UINT16 );
INT16 process_udp_in(struct ip_frame* , UINT16 );
UINT16 udp_getfreeport(void); 

/*	TCP Function prototypes	*/

INT16 process_tcp_in(struct ip_frame*, UINT16);
INT16 process_tcp_out(INT8, UINT8*, UINT16, UINT16);
INT8 tcp_init(void);
INT8 tcp_listen(INT8, UINT16);
INT8 tcp_mapsocket(struct ip_frame*, struct tcp_frame*);
UINT8 tcp_check_cs(struct ip_frame*, UINT16);
void tcp_sendcontrol(INT8);
UINT32 tcp_initseq(void);
void tcp_poll(void);
void tcp_newstate(struct tcb*, UINT8);
INT8 tcp_getsocket(UINT8, UINT8, UINT16, INT32 (*)(INT8, UINT8, UINT32, UINT32) );
INT8 tcp_releasesocket(INT8);
INT8 tcp_connect(INT8, UINT32, UINT16, UINT16);
INT16 tcp_send(INT8, UINT8*, UINT16, UINT16);
INT8 tcp_close(INT8);
void tcp_sendreset(struct tcp_frame*, UINT32);
INT8 tcp_getstate(INT8);
UINT16 tcp_getfreeport(void);
INT16 tcp_checksend(INT8);
INT8 tcp_abort(INT8);



#endif


