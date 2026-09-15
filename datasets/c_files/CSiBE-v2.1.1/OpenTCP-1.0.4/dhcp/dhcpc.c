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

/** \file dhcpc.c
 *	\brief OpenTCP DHCP client implementation
 *	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.03
 *	\date 23.5.2003
 *	\bug
 *	\warning
 *	\todo
 *		\li	We SHOULD first test (with PING or ARP) assigned IP
 *		address to see if it's in use already.
 *
 *	OpenTCP DHCP client protocol implementation. Features a complete
 * 	DHCP state machine. Function declarations can be found in 
 *	inet/dhcp/dhcpc.h
 */

#include<inet/datatypes.h>
#include<inet/debug.h>
#include<inet/system.h>
#include<inet/tcp_ip.h>
#include<inet/timers.h>
#include<inet/arp.h>
#include<inet/ethernet.h>
#include<inet/dhcp/dhcpc.h>

/** \brief Holds DHCP clients' state information
 *	
 *	This variable holds DHCP clients' current state information. Possible
 *  states are DHCP_STATE_INIT_REBOOT, DHCP_STATE_REBOOTING, 
 *	DHCP_STATE_INIT, DHCP_STATE_SELECTING, DHCP_STATE_REQUESTING,
 *	DHCP_STATE_BOUND, DHCP_STATE_RENEWING, DHCP_STATE_REBINDING. 
 */
UINT8 dhcpc_state;

/** \brief DHCP client's timer handle
 *
 *	Hold DHCP clients' timer handle. We'll use only one timer from
 *	timer pool and take care of the rest by ourselves manually
 */
UINT8 dhcpc_timer_handle;

/** \brief DHCP client's UDP socket handle
 *
 *	DHCP client's UDP socket handle
 */	
INT8 dhcpc_soc_handle;

/** \brief Holds information if DHCP client is initialized
 *
 *	Holds information if DHCP client is initialized
 */  
UINT8	dhcpc_initialized=0;

/** \brief DHCP renew timer
 * 
 *	This variable holds renew time (in seconds) after which we'll
 *  start the renewing process. While obtaining the parameters from
 * 	DHCP server (thus before we know of the renew time) this is
 *	used also to time retransmissions.
 */
UINT32 dhcpc_t1;

/** \brief DHCP rebind timer 
 * 
 *	This variable holds rebind time (in seconds) after which we'll
 *	start the rebinding process. While obtaining the paramters from
 * 	DHCP server (thus before we know of the renew time) this is 
 *  also used to time retransmissions as well as timeout detection
 */
UINT32 dhcpc_t2;

/** \brief DHCP server identifier as received from DHCP server
 *
 *	This variable will hold DHCP server identifier (which will actually
 *	be server's IP address).
 */
UINT32 dhcpc_server_identifier;

/** \brief Holds offered IP address or IP address that we're requesting
 *
 *	This variable holds the IP address that DHCP server offered to us
 *	during address request procedure and this is the address that we
 *	will be requesting in all future requests untill DHCP server
 *	disallows us to use it any more.
 */
UINT32 dhcpc_requested_ip;

INT32 dhcpc_eventlistener(INT8 cbhandle, UINT8 event, UINT32 ipaddr, UINT16 port, UINT16 buffindex, UINT16 datalen);
INT8 dhcpc_send_message(UINT8 msg_type);

/** \brief Initializes DHCP client
 * 	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 23.05.2003
 *
 *	This function should be called once when system starts to initialize
 *	and start DHCP client. Before this function is invoked,
 *	localmachine.localip MUST be se to either zero (in which case DHCP
 *	client will request any IP address) or a previously assigned IP
 *	address (which doesn't mean DHCP server will allow us to continue
 *	using this address) in which case DHCP client will first try to
 *	obtain that existing IP address.
 */
INT8 dhcpc_init(void)
{
	
	/* If we already have some IP address (stored from some previous
	 * requests, try obtaining it again */	
	if((localmachine.localip!=0)&&(localmachine.localip!=0xffffffff)){
		dhcpc_state=DHCP_STATE_INIT_REBOOT;
	}else{
		/* start from beginning */
		dhcpc_state=DHCP_STATE_INIT;
		}
	
	dhcpc_soc_handle=udp_getsocket(0,dhcpc_eventlistener,UDP_OPT_SEND_CS|UDP_OPT_CHECK_CS);
	
	if(dhcpc_soc_handle<0){
		DEBUGOUT("DHCP client not able to obtain socket!\r\n");
		return (-1);
	}	
	
	/* open socket for communication immediately */
	udp_open(dhcpc_soc_handle,DHCP_CLIENT_PORT);
	
	/* get timer handle */
	dhcpc_timer_handle=get_timer();
	
	/* initialize timer for 1 sec intervals */
	init_timer(dhcpc_timer_handle,TIMERTIC*1);	/* on every second */
	
	dhcpc_initialized=1;
	DEBUGOUT("DHCP Client initialized\r\n");
	
	return (0);
}

/** \brief DHCP client main state machine
 * 	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 23.05.2003
 *
 *	Call this function periodically from main loop to ensure
 *	proper operation. This function holds the main state machine
 *	of DHCP client that ensures proper operation.
 */
void dhcpc_run(void){
	UINT8 sec=0;
	
	if(!dhcpc_initialized)
		return;
		
	if(!check_timer(dhcpc_timer_handle))
		sec=1;
	
	switch(dhcpc_state){
		case DHCP_STATE_INIT_REBOOT:
			dhcpc_state=DHCP_STATE_REBOOTING;
			dhcpc_t1=4;	/* next retransmission in 4 secs */
			dhcpc_t2=8;	/* after that after 8 secs retrs */
			dhcpc_requested_ip=localmachine.localip;
			dhcpc_send_message(DHCP_REQUEST);
			break;

		case DHCP_STATE_REBOOTING:
			if(sec)
				dhcpc_t1--;
			
			if(!dhcpc_t1){
				if(dhcpc_t2>=32){
					/* we need to restart, we don't want to wait more
					 * than 30 secs for retransmissions
					 */
					 dhcpc_state=DHCP_STATE_INIT_REBOOT;
				}else{
					dhcpc_t1=dhcpc_t2;
					dhcpc_t2<<=1;	/* exponential backoff retransmission */
					dhcpc_send_message(DHCP_REQUEST);
				}			
			}		
			break;
		case DHCP_STATE_INIT:
			/* switch to selecting, send DHCPDISCOVER and initialize
			 * timeout timer
			 */
			DEBUGOUT("DHCP State=INIT; Sending DHCPDISCOVER message; State INIT-->SELECTING\r\n");
			dhcpc_state=DHCP_STATE_SELECTING;
			dhcpc_send_message(DHCP_DISCOVER);
			/* T1 will be timeout timer. T2 will hold next timeout value */
			dhcpc_t1=4;	/* next retransmission after 4 secs */
			dhcpc_t2=8;	/* after 4 secs expire, this will be next timeout */
			break;
		case DHCP_STATE_SELECTING:
			/* one second expired ? */
			if(sec)
				dhcpc_t1--;
			
			/* timeout expired without receiving DHCPOFFER ? */
			if(!dhcpc_t1){
				DEBUGOUT("DHCP State=SELECTING; ");
				/* yes, retransmit or restart the process */
				if(dhcpc_t2>=32){
					/* we need to restart, we don't want to wait more
					 * than 30 secs for retransmissions
					 */
					 dhcpc_state=DHCP_STATE_INIT;
					 DEBUGOUT("Timeout for retransmissions too big; State SELECTING-->INIT\r\n");
				}else{
					DEBUGOUT("Retransmitting DHCPDISCOVER\r\n");
					dhcpc_t1=dhcpc_t2;
					dhcpc_t2<<=1;	/* exponential backoff retransmission */
					dhcpc_send_message(DHCP_DISCOVER);
				}
			}
			break;
		case DHCP_STATE_REQUESTING:
			/* DHCPREQUEST sent, waiting for proper response. Retransmit
			 * if necessary
			 */
			if(sec)
			 	dhcpc_t1--;
			 
			if(!dhcpc_t1){
				/* timeout occured without receiving DHCPACK */
				DEBUGOUT("DHCP State=REQUESTING; ");
				if(dhcpc_t2>=32){
					/* we need to restart, we don't want to wait more
					 * than 30 secs for retransmissions. Restart whole
					 * process
					 */
					 dhcpc_state=DHCP_STATE_INIT;
					 DEBUGOUT("Timeout for retransmits too big; State REQUESTING-->INIT\r\n");
				}else{
					DEBUGOUT("Retransmitting DHCPREQUEST\r\n");
					dhcpc_t1=dhcpc_t2;
					dhcpc_t2<<=1;	/* exponential backoff retransmission */
					dhcpc_send_message(DHCP_REQUEST);
				}				
			} 
			break;
		case DHCP_STATE_BOUND:
			/* wait for T1 to expire */
			if(sec){
				dhcpc_t1--;
				dhcpc_t2--;
			}
			if(!dhcpc_t1){
				DEBUGOUT("DHCP State=BOUND; Starting renewing process; State BOUND-->RENEWING\r\n");
				/* T1 expired, start renewing process */
				dhcpc_state=DHCP_STATE_RENEWING;
				
				dhcpc_send_message(DHCP_REQUEST);
				
				/* T1 will be used for retransmissions untill we
				 * return to BOUND state or reset to INIT state
				 */
				dhcpc_t1=10;	/* fixed 10sec retransmissions */
			}
			break;
		case DHCP_STATE_RENEWING:
			if(sec){
				dhcpc_t1--;
				dhcpc_t2--;
			}
			
			if(!dhcpc_t2){
				DEBUGOUT("DHCP State=RENEWING; T2 expired; State RENEWING-->REBINDING\r\n");
				/* oh no, T2 also expired. switch to rebinding state. This
				 * is our last attempt to retain this IP address.
				 */
				dhcpc_state=DHCP_STATE_REBINDING;
				
				dhcpc_send_message(DHCP_REQUEST);
				
				/* dhcpc_t1 will be used for timeouts */
				dhcpc_t1=5;	/* 5 second retransmits */
				
				/* dhcpc_t2 will be used for fixed numer of retries. This
				 * is a bit different than per RFC, but we don't want 
				 * another 32-bit timer value for keeping lease time.
				 */
				dhcpc_t2=10;
			}else
				if(!dhcpc_t1){
					DEBUGOUT("DHCP State=RENEWING; Retransmitting DHCPREQUEST\r\n");	
					/* retransmit DHCP REQUEST messages */
					dhcpc_send_message(DHCP_REQUEST);
					dhcpc_t1=10;
				}
			break;
		case DHCP_STATE_REBINDING:
			if(sec)
				dhcpc_t1--;
			
			if(!dhcpc_t1){
			
				dhcpc_t1=5;	/* 5 second retransmits */
				
				dhcpc_t2--;	/* retransmit count */
				
				if(!dhcpc_t2){
					DEBUGOUT("DHCP State=REBINDING; Lease time expired; State REBINDING-->INIT\r\n");
					/* used up retransmission. Assume that lease time
					 * expired by now. Restart the process
					 */
					 dhcpc_state=DHCP_STATE_INIT;
					 localmachine.localip=0;	/* can't use this any more */
				}else{
					DEBUGOUT("DHCP State=REBINDING; Retransmitting DHCPREQUEST\r\n");
					/* still have some time */
					dhcpc_send_message(DHCP_REQUEST);
				}
			}
			break;
		default:
			break;
	}
	
	if(sec){
		init_timer(dhcpc_timer_handle,TIMERTIC*1);
	}
}

/** \brief Sends DHCP messages
 * 	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 23.05.2003
 *	\param msg_type Type of DHCP message to be sent. This implementation
 *		can send only #DHCP_DISCOVER, #DHCP_REQUEST and #DCHP_DECLINE
 *		messages.
 *	\return Returns result of udp_send() function.
 * 
 *	This is internal function invoked to send appropriate DHCP message.
 */
INT8 dhcpc_send_message(UINT8 msg_type)
{

	UINT16 index;
	UINT8 *buf_ptr;	/* transmit buffer pointer */
	
	/* first clear transmit buffer to all zeroes */
	for(index=UDP_APP_OFFSET;index<NETWORK_TX_BUFFER_SIZE;index++)
		net_buf[index]=0;
		
	buf_ptr=net_buf+UDP_APP_OFFSET;
	
	/* create DHCP message */
	
	*buf_ptr++=BOOT_REQUEST;
	*buf_ptr++=0x01;		/* htype=ethernet */
	*buf_ptr++=0x06;		/* hlen=6 for ethernet */
	*buf_ptr++=0x00;		/* hops=0 by clients */
	
	/* xid, use constant value for all requests (allowed by RFC) */
	*buf_ptr++=0xAA;
	*buf_ptr++=0xBB;
	*buf_ptr++=0xCC;
	*buf_ptr++=0xDD;
	
	/* seconds from boot. Fixed for now */
	*buf_ptr++=0x00;
	*buf_ptr++=0x00;
	
	/* flags, use broadcast */
	*buf_ptr++=0x80;
	*buf_ptr++=0x00;
	
	/* ciaddr. Sent only if client is in BOUND, RENEW or REBINDING
	 * state (RFC2131)
	 */
	if((dhcpc_state==DHCP_STATE_BOUND)
		||(dhcpc_state==DHCP_STATE_RENEWING)
		||(dhcpc_state==DHCP_STATE_REBINDING)){
		*buf_ptr++=(UINT8)(localmachine.localip>>24);
		*buf_ptr++=(UINT8)(localmachine.localip>>16);
		*buf_ptr++=(UINT8)(localmachine.localip>>8);
		*buf_ptr++=(UINT8)(localmachine.localip);		
	}else{
		buf_ptr+=4;	/* skip 4 bytes, buffer zeroed already */
	}
	
	/* yiaddr, siaddr, giaddr, skip */
	buf_ptr+=12;
	
	/* chaddr */
	*buf_ptr++=localmachine.localHW[5];
	*buf_ptr++=localmachine.localHW[4];
	*buf_ptr++=localmachine.localHW[3];
	*buf_ptr++=localmachine.localHW[2];
	*buf_ptr++=localmachine.localHW[1];
	*buf_ptr++=localmachine.localHW[0];
	buf_ptr+=10;
	
	/* sname and file, skip */
	buf_ptr+=192;
	
	/* options field. First magic cookie */
	*buf_ptr++=99;
	*buf_ptr++=130;
	*buf_ptr++=83;
	*buf_ptr++=99;

	/* message type */
	*buf_ptr++=DHCP_OPT_MSG_TYPE;
	*buf_ptr++=1;
	*buf_ptr++=msg_type;
		
	/* next depends on what state we're in and message type */
	switch(msg_type){

		case DHCP_REQUEST:
		case DHCP_DECLINE: /* sent only from REQUESTING state */

			/* Requested IP address MUST NOT be sent in RENEWING and
			 * REBINDING states (RFC2123 page 31)
			 */
			if((dhcpc_state!=DHCP_STATE_RENEWING)
				&&(dhcpc_state!=DHCP_STATE_REBINDING)){
				*buf_ptr++=DHCP_OPT_REQUESTED_IP;
				*buf_ptr++=4;
				*buf_ptr++=(UINT8)(dhcpc_requested_ip>>24);
				*buf_ptr++=(UINT8)(dhcpc_requested_ip>>16);
				*buf_ptr++=(UINT8)(dhcpc_requested_ip>>8);
				*buf_ptr++=(UINT8)(dhcpc_requested_ip);
			}	
			/* server identifier, only when not in INIT_REBOOT state 
			 *(RFC2131, Section 4.3.2) or RENEWING, REBINDING
			 * state (RFC2131 page 31)
			 */
			if((dhcpc_state!=DHCP_STATE_INIT_REBOOT)
				&&(dhcpc_state!=DHCP_STATE_REBOOTING)	/* for retransmissions */			
				&&(dhcpc_state!=DHCP_STATE_RENEWING)
				&&(dhcpc_state!=DHCP_STATE_REBINDING)){
				*buf_ptr++=DHCP_OPT_SERV_IDENT;
				*buf_ptr++=4;
				*buf_ptr++=(UINT8)(dhcpc_server_identifier>>24);
				*buf_ptr++=(UINT8)(dhcpc_server_identifier>>16);
				*buf_ptr++=(UINT8)(dhcpc_server_identifier>>8);
				*buf_ptr++=(UINT8)(dhcpc_server_identifier);
			}	
			/* go through to request parameters we're interested in, but
			 * only if we're not sending DECLINE message (parameter list
			 * MUST NOT be sent in such a message)
			 */
			 if(msg_type==DHCP_DECLINE)
			 	break;
			
		case DHCP_DISCOVER:		
			/* parameter request list. These also MUST be transmitted
			 * with DHCP REQUEST message */
			*buf_ptr++=DHCP_OPT_PARAM_REQUEST;
			*buf_ptr++=7;	/* number of parameters we're requesting */
			*buf_ptr++=DHCP_OPT_SUBNET_MASK;
			*buf_ptr++=DHCP_OPT_ROUTER;
			*buf_ptr++=DHCP_OPT_DNS_SERVER;
			*buf_ptr++=DHCP_OPT_HOST_NAME;
			*buf_ptr++=DHCP_OPT_LEASE_TIME;
			*buf_ptr++=DHCP_OPT_T1_VALUE;
			*buf_ptr++=DHCP_OPT_T2_VALUE;
			break;			

		default:
			break;
	}
	
	/* end option */
	*buf_ptr++=DHCP_OPT_END;
	while(buf_ptr<(net_buf+UDP_APP_OFFSET+300))
		*buf_ptr++=0x00;
		
	/* send message. Send unicast when server's IP is available (only
	 * in selected states, check RFC) and allowed (also check RFCs).
	 * Check RFCs in any case :-)
	 */
	if((dhcpc_state==DHCP_STATE_BOUND)
		||(dhcpc_state==DHCP_STATE_RENEWING))
		return udp_send(dhcpc_soc_handle,dhcpc_server_identifier,DHCP_SERVER_PORT,net_buf+UDP_APP_OFFSET,NETWORK_TX_BUFFER_SIZE-UDP_APP_OFFSET,buf_ptr-(net_buf+UDP_APP_OFFSET));
	else
		return udp_send(dhcpc_soc_handle,IP_BROADCAST_ADDRESS,DHCP_SERVER_PORT,net_buf+UDP_APP_OFFSET,NETWORK_TX_BUFFER_SIZE-UDP_APP_OFFSET,buf_ptr-(net_buf+UDP_APP_OFFSET));

}

/** \brief Processes received parameter from DHCP server
 * 	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 23.05.2003
 *	\param n Number of bytes to read&process.
 *	\return Returns last for 4 bytes that were read as a 32-bit variable
 * 
 *	This is internal function that get's invoked to read a received
 *	parameter in DHCP message. Introduced to optimize code a little
 *	as 4 byte parameters are often returned by DHCP server (netmask,
 *	gateway, server identifier, T1, T2, lease expiration time, DNS IP,..)
 */
UINT32 dhcpc_read_n_bytes(UINT8 n){
	UINT32 ret_value=0;
	/* read n bytes and return value of last of them (max 4, can be less)*/
	while(n--){
		ret_value=(ret_value<<8)|RECEIVE_NETWORK_B();
	}
	return ret_value;
}

/** \brief DHCP event listener, parses all DHCP replies
 * 	\author 
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 23.05.2003
 * 
 *	This is internal function invoked by OpenTCP UDP module when
 *	DHCP reply on a given UDP port is received. This function parses
 *	the response, checks for correctnes and performs certain actions
 *	based on the current state of DHCP client.
 */
INT32 dhcpc_eventlistener(INT8 cbhandle, UINT8 event, UINT32 ipaddr, UINT16 port, UINT16 buffindex, UINT16 datalen)
{
	UINT32 temp;
	UINT32 yiaddr;	/* assigned IP */
	UINT8 i;
	UINT8 msg_type=0;
	
	if(cbhandle!=dhcpc_soc_handle){
		DEBUGOUT("DHCP Client: Not my handle!!!!\r\n");
		return (-1);
	}
	
	switch(event){
		case UDP_EVENT_DATA:
			DEBUGOUT("DHCP Client: Received data....");
			/* initial correctness checking */
			if(datalen<236){
				DEBUGOUT("length not OK, dumping packet\r\n");
				return (-1);
				}
			
			/* op */
			if(RECEIVE_NETWORK_B()!=BOOT_REPLY){
				DEBUGOUT("op not BOOT_REPLY, dumping packet\r\n");
				return (-1);
				}
				
			/* skip htype, hlen, hops */
			RECEIVE_NETWORK_B();
			RECEIVE_NETWORK_B();
			RECEIVE_NETWORK_B();
			
			/* check xid */
			temp=0;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<24;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<16;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<8;
			temp|=RECEIVE_NETWORK_B();
			if(temp!=0xAABBCCDD){
				DEBUGOUT("xid not OK, dumping packet\r\n");
				return (-1);
				}
				
			/* skip secs, flags, ciaddr and find yiaddr*/
			for(i=0;i<12;i++)
				yiaddr=(yiaddr<<8)|RECEIVE_NETWORK_B();
			 
			 /* skip siaddr, giaddr, chaddr, sname, file. 
			  * We get all the info we need from options.
			  */
			for(i=0;i<216;i++)
				RECEIVE_NETWORK_B();
			
			/* check magic cookie */
			temp=0;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<24;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<16;
			temp|=((UINT32)RECEIVE_NETWORK_B())<<8;
			temp|=RECEIVE_NETWORK_B();
			if(temp!=0x63825363){
				DEBUGOUT("magic cookie not OK, dumping packet\r\n");
				return (-1);
				}
			DEBUGOUT("initial check OK, proceeding...\r\n");
			/* process further received message, depends on state we're in */
			switch(dhcpc_state){
				case DHCP_STATE_SELECTING:
					/* select first DHCPOFFER */
					dhcpc_server_identifier=0;
					DEBUGOUT("DHCP Client state=SELECTING; ");
					/* iterate through parameters and try to find if 
					 * this really is DHCPOFFER. Besides that, we're
					 * only interested in SERVERIDENTIFIER option (which
					 * is actually server's IP address)
					 */
					while((i=RECEIVE_NETWORK_B())!=DHCP_OPT_END){
						/* there are still options to process*/
						switch(i){
							case DHCP_OPT_MSG_TYPE:
								RECEIVE_NETWORK_B();
								msg_type=RECEIVE_NETWORK_B();	
								break;
							case DHCP_OPT_SERV_IDENT:
								RECEIVE_NETWORK_B();
								/* Read SERVER IDENTIFIER */
								dhcpc_server_identifier|=((UINT32)RECEIVE_NETWORK_B())<<24;
								dhcpc_server_identifier|=((UINT32)RECEIVE_NETWORK_B())<<16;
								dhcpc_server_identifier|=((UINT32)RECEIVE_NETWORK_B())<<8;
								dhcpc_server_identifier|=RECEIVE_NETWORK_B();
								break;
							case DHCP_OPT_OVERLOAD:
								/* we can't process overloaded messages */
								DEBUGOUT("Overloaded DHCP message, can't process...\r\n");
								return (-1);
								break;
							default:
								/* not interesting parameter for now */
								if(i==DHCP_OPT_PAD)
									break;
								i=RECEIVE_NETWORK_B();	/* parameter length */
								while(i--){
									RECEIVE_NETWORK_B();
								}
								break;
						}
					}
					/* ok, processed all, got what we were looking for ? */
					if((!dhcpc_server_identifier)||(msg_type!=DHCP_OFFER)){
						DEBUGOUT(" Not a DHCP offer or no server identifier; Aborting...\r\n");
						return(-1);
					}
					
					DEBUGOUT(" DHCP offer valid, sending DHCP REQUEST; State SELECTING-->REQUESTING\r\n");
					/* we have the offer, contact the server! */
					dhcpc_state=DHCP_STATE_REQUESTING;
					dhcpc_requested_ip=yiaddr;	/* offered IP ! */
					
					dhcpc_send_message(DHCP_REQUEST);
					
					dhcpc_t1=4;	/* 4 secs for first retransmission */
					dhcpc_t2=8;	/* next one after 8 secs */
					break;

				case DHCP_STATE_REQUESTING:
					/* wait for DHCPACK */
					
					DEBUGOUT("DHCP Client state=REQUESTING; ");

					/* is message from the same server who sent the offer 
					 * and assigned IP == offered IP? This will also reject
					 * subsequent DHCPOFFERs from slow DHCP servers.
					 */
					if((dhcpc_server_identifier!=ipaddr)||(yiaddr!=dhcpc_requested_ip)){
						DEBUGOUT("Server or requested IP not the same, dumping..\r\n");
						return (-1);
					}
					
					/* ok, go through param list and process them. We expect to get
					 * all the params here and that this is DHCPACK message
					 */
					DEBUGOUT("Received params: ");
					while((i=RECEIVE_NETWORK_B())!=DHCP_OPT_END){
						
						switch(i){
							case DHCP_OPT_PAD:
								break;
							case DHCP_OPT_SUBNET_MASK:
								temp=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								/* temp holds subnet mask, for now just show it and set params*/
								localmachine.netmask=temp;
								DEBUGOUT("Subnet mask;");
								break;
							case DHCP_OPT_ROUTER:
								temp=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								/* temp holds gateway IP */
								localmachine.defgw=temp;
								DEBUGOUT("Gateway IP; ");
								break;
							case DHCP_OPT_DNS_SERVER:
								temp=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								DEBUGOUT("DNS IP;");
								break;
							case DHCP_OPT_HOST_NAME:
								/* Read host name here and store it */
								i=RECEIVE_NETWORK_B();	/* length of host name */
								while(i--){
									/* read host name. Store this if necessary */
									RECEIVE_NETWORK_B();
								}
								DEBUGOUT("Host name; ");
								break;
							case DHCP_OPT_LEASE_TIME:
								temp=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								/* time calculation from RFC! These values can also
								 * be received directly in options
								 */
								dhcpc_t1=0.5*temp;
								dhcpc_t2=0.875*temp;
								DEBUGOUT("Lease time;"); 
								break;
							case DHCP_OPT_OVERLOAD:
								DEBUGOUT("Overloaded DHCP message, can't process...\r\n");
								return (-1);
								break;
							case DHCP_OPT_MSG_TYPE:
								/* if this is DHCPACK we can switch state and assume
								 * that the parameters are OK
								 */
								RECEIVE_NETWORK_B();
								if(RECEIVE_NETWORK_B()==DHCP_ACK){
									DEBUGOUT("DHCP_ACK Message!; State REQUESTING-->BOUND; ");
									dhcpc_state=DHCP_STATE_BOUND;
									
									/* we should actually probe the received IP with
									 * ARP first, but let's wait with that for 
									 * now.....
									 */
									localmachine.localip=dhcpc_requested_ip;
									/* dhcpc_requested_ip holds the assigned IP
									 * address. USE IT OR LOOSE IT!
									 */
									DEBUGOUT("IP address;");
								}else{
									DEBUGOUT("NOT DHCPACK message; dumping...\r\n");
									return(-1);
								}	
								break;
							case DHCP_OPT_T1_VALUE:
								DEBUGOUT("T1;");
								dhcpc_t1=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
							case DHCP_OPT_T2_VALUE:
								DEBUGOUT("T2; ");
								dhcpc_t2=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
							default:
								dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
						}
					}
					DEBUGOUT("\r\n");
					break;
				case DHCP_STATE_RENEWING:
				case DHCP_STATE_REBINDING:
				case DHCP_STATE_REBOOTING:
					/* wait for DHCPACK. If we get DHCPNAK restart. Here
					 * we're only interested in ACK and T1 and T2 parameters.
					 * NOTE: other parameters can change as well during time(
					 * DNS, gateway etc. Add cases similar to those in
					 * REQUESTING state here as well if you want those.
					 */
					DEBUGOUT("DHCP Client state=REQUESTING or REBINDING; ");
					while((i=RECEIVE_NETWORK_B())!=DHCP_OPT_END){
						switch(i){
							case DHCP_OPT_PAD:
								break;
							case DHCP_OPT_LEASE_TIME:
								DEBUGOUT("Lease time; ");
								temp=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								/* time calculation from RFC! These values can also
								 * be received directly in options
								 */
								dhcpc_t1=0.5*temp;
								dhcpc_t2=0.875*temp; 
								break;								
							case DHCP_OPT_MSG_TYPE:
								RECEIVE_NETWORK_B();
								i=RECEIVE_NETWORK_B();
								if(i==DHCP_NAK){
									DEBUGOUT("DHCP_NAK received; State --> INIT\r\n");
									dhcpc_state=DHCP_STATE_INIT;
									localmachine.localip=0;
									return(-1);
								}
								if(i==DHCP_ACK){
									DEBUGOUT("DHCP_ACK received; State --> BOUND\r\n");
									dhcpc_state=DHCP_STATE_BOUND;
								}
								break;
							case DHCP_OPT_T1_VALUE:
								DEBUGOUT("T1; ");
								dhcpc_t1=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
							case DHCP_OPT_T2_VALUE:
								DEBUGOUT("T2; ");
								dhcpc_t2=dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
							default:
								dhcpc_read_n_bytes(RECEIVE_NETWORK_B());
								break;
						}
					}
					break;
				default:
					/* dump frames when in all other states */
					break;				
			}
			break;
		default:
			/* should never get here */
			DEBUGOUT("DHCP Client: Unknown UDP event :-( \r\n");
			break;
	}
	return 1;

}
