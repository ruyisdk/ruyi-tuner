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


/** \file dns.c
 *	\brief OpenTCP DNS client implementation
 *	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 10.10.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Probably should implement sending different ID with
 *		requests.
 *		\li Maybe create similar cache as for ARP ?
 *		\li <b>Definitely</b> implement DNS's IP address use as a
 *		parameter to get_host_by_name function. This would allow more
 *		flexible manipulation
 *
 *	OpenTCP DNS client implementation. API functions, data structures
 *	and constants may be found in inet/dns/dns.h
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/globalvariables.h>
#include <inet/system.h>
#include <inet/timers.h>
#include <inet/tcp_ip.h>
#include <inet/dns/dns.h>


#define DNS_STATE_READY 	0
#define DNS_STATE_BUSY		1
#define DNS_STATE_RESEND	2	/* retransmit request */

UINT8 dns_state; /**< Current DNS state. Used to prevent multiple requests, issue retransmissions,... See DNS_STATE_* for possible values. */
UINT8 dns_socket; /**< UDP socket used by the DNS resolver */
UINT8 dns_timer; /**< DNS timer handle used for retransmissions */
UINT8 dns_retries; /**< DNS retry counter used for detecting timeouts */

UINT32 dns_tmp_ip; /**< Used in many ways: as an IP address holder, for issuing requests to authorative name servers,.. */

UINT8 *dns_hostptr;	/**< Pointer to hostname that is beeing resolved. Needed for retransmissions.*/


void (*dns_event_listener)(UINT8 event, UINT32 data);

/** \brief Initialize resources needed for the DNS client
 * 	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 10.10.2002
 *
 *	Invoke this function at startup to properly initialize DNS resources.
 *
 */
void dns_init(void){

	dns_state = DNS_STATE_READY;

	dns_socket=udp_getsocket(0 , dns_eventlistener , UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS);

	if(dns_socket == -1){
		DEBUGOUT("DNS: No free UDP sockets!! \r\n");
		return;
	}

	/* open socket */
	udp_open(dns_socket,DNS_UDP_PORT);

	/* now the timer. This will be used for retransmitting the requests */
	dns_timer=get_timer();

	/* TODO: if GetTimer is modified so that it doesn't reset system if
		no timers available, check return value! */

	DEBUGOUT("Initialized DNS client\r\n");

}

/** \brief Retransmits requests towards the DNS server
 * 	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 10.10.2002
 *
 *	This is internal function and IS NOT INTENDED to be invoked by the
 *	user application. It simply checks if retransmissions should be done
 *	(when retransmissions not used yet) and if yes, sends one.
 *	Otherwise timeout error is sent to the event listener.
 */
void dns_retransmit(void){
	if(dns_retries!=0){
		dns_state=DNS_STATE_RESEND;
		dns_retries--;
		get_host_by_name(dns_hostptr,dns_event_listener);
		init_timer(dns_timer,DNS_RESEND_PERIOD*TIMERTIC);
	}else{

		/* timeout happened */
		dns_state=DNS_STATE_READY;

		dns_event_listener(DNS_EVENT_ERROR,DNS_ERROR_TIMEOUT);

	}

}

/** \brief DNS client main loop
 * 	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 10.10.2002
 *
 *	Simple main loop that checks whether DNS requests should be sent or
 *	not (based on timer timeout). If yes, and DNS is in appropriate state,
 *	dns_retransmit() function is invoked.
 */
void dns_run(void){
	if((dns_state==DNS_STATE_BUSY)||(dns_state==DNS_STATE_RESEND)){
		/* checking retransmission timer */
		if(!check_timer(dns_timer)){

			DEBUGOUT("DNS: retransmitting the request \r\n");
			/* timeout, send another one */
			dns_retransmit();

		}
	}
}

/** \brief DNS client event listener
 * 	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 10.10.2002
 *	\param cbhandle handle of the socket this packet is intended for.
 * 	\param event event that is notified. For UDP, only UDP_EVENT_DATA.
 * 	\param ipaddr IP address of remote host who sent the UDP datagram
 * 	\param port port number of remote host who sent the UDP datagram
 * 	\param buffindex buffer index in RTL8019AS
 *	\return
 *		\li - 1 - error in processing
 *		\li 0 - DNS reply successfully processed
 *	\note
 *		\li Event listeners are NOT to be invoked directly. They are
 *		callback functions invoked by the TCP/IP stack to notify events.
 *
 *	This, of course, is where responses from DNS server are processed and
 *	checked whether they contain the IP address we requested or if they
 *	contain authorative name server to which we should proceed.
 *
 *	If we received the IP address we requested, #DNS_EVENT_SUCCESS is
 *	reported to application DNS event listener. Otherwise #DNS_EVENT_ERROR
 *	is reported.
 */
INT32 dns_eventlistener(INT8 cbhandle, UINT8 event, UINT32 ipaddr, UINT16 port, UINT16 buffindex, UINT16 datalen){
	UINT8 tmp_byte;
	UINT16 tmp_int;
	UINT8 *tmp_ptr;
	UINT8 count;
	/* it will fit in 8bits most of the time but... */
	UINT16 dns_ancount;
	UINT16 dns_nscount;

	if(cbhandle!=dns_socket){
		DEBUGOUT("DNS: not my handle!!!!");
		return (-1);
	}

	if(ipaddr!=dns_tmp_ip){
		DEBUGOUT("DNS: received DNS but IP addr not OK!\r\n");
	}

	switch(event){
		case UDP_EVENT_DATA:
			/* only process data while not in ready state */
			if(dns_state==DNS_STATE_READY){
				DEBUGOUT("DNS: Received answer in wrong state\r\n");
				return (-1);
			}

			/* inital size checking. Every DNS reply will be bigger
				than 16 bytes */
			if(datalen<16){
				DEBUGOUT("DNS: UDP packet way to short for DNS!\r\n");
				return (-1);
			}

			/* some data received, check if it's what we're waiting for */
			tmp_int=RECEIVE_NETWORK_B();
			tmp_int=(tmp_int<<8)+RECEIVE_NETWORK_B();
			if(tmp_int!=0xaaaa){
				DEBUGOUT("DNS: ERROR: ID wrong!\r\n");
				return (-1);
			}

			tmp_byte=RECEIVE_NETWORK_B();

			if(!(tmp_byte&0x80)){
				DEBUGOUT("DNS: THIS IS NOT AN ANSWER! WE'RE NOT A DNS SERVER!\r\n");
				return (-1);
			}

			/* opcode or truncated ? */
			if(tmp_byte&0x7a){
				DEBUGOUT("DNS: Opcode not zero or message truncated. \r\n");
				dns_event_listener(DNS_EVENT_ERROR,DNS_ERROR_GENERAL);
				return (-1);
			}

			tmp_byte=RECEIVE_NETWORK_B();

			/* check RCODE */
			if((tmp_byte&0x7f)&&(tmp_byte&0x80)){
				/* RCODE not zero, and recursion is available	*/
				/* There was an error. Inform listener 			*/
				DEBUGOUT("DNS: RCODE not zero and recursion available! \r\n");
				dns_event_listener(DNS_EVENT_ERROR,tmp_byte&0x7f);
				return (-1);
			}

			/* question count == 1 ? */
			tmp_int=(((UINT16)RECEIVE_NETWORK_B())<<8);
			tmp_int+=RECEIVE_NETWORK_B();
			if(tmp_int != 1){
				DEBUGOUT("DNS: we only sent one question and received a couple of answers!!\r\n");
				dns_event_listener(DNS_EVENT_ERROR,DNS_ERROR_GENERAL);
				return (-1);
			}

			dns_ancount=(((UINT16)RECEIVE_NETWORK_B())<<8);
			dns_ancount+=RECEIVE_NETWORK_B();

			dns_nscount=(((UINT16)RECEIVE_NETWORK_B())<<8);
			dns_nscount+=RECEIVE_NETWORK_B();

			/* skip ARCOUNT */
			RECEIVE_NETWORK_B();
			RECEIVE_NETWORK_B();

			/* got to the data, let's process it */
			/* check if question section is appropriate (QNAME the same
				and QTYPE=QCLASS=1
			*/
			tmp_ptr=dns_hostptr;
			while((tmp_byte=RECEIVE_NETWORK_B())!=0){
				while((tmp_byte--)!=0){
					if(*tmp_ptr++!=RECEIVE_NETWORK_B()){
						DEBUGOUT("DNS: QNAME not the same!!!! \r\n");
						/* we'll assume that this was from some previous
							query and just exit here */
						return (-1);
					}
				}
				/* reached the end of the label. Is it dot or end of string? */

				if(*tmp_ptr=='\0'){
					continue;
				}

				if(*tmp_ptr++!='.'){
					DEBUGOUT("DNS: DOT not where it's supposed to be!\r\n");
					return (-1);
				}
			}


			/* qtype and qclass */
			tmp_int=(((UINT16)RECEIVE_NETWORK_B())<<8);
			tmp_int+=RECEIVE_NETWORK_B();

			tmp_int|=((UINT16)(RECEIVE_NETWORK_B())<<8);
			tmp_int|=RECEIVE_NETWORK_B();

			if(tmp_int!=0x0001){
				DEBUGOUT("DNS: Question section QTYPE and/or QCLASS not ok!\r\n");
				dns_event_listener(DNS_EVENT_ERROR,DNS_ERROR_GENERAL);
				return (-1);
			}

			/* process all answer RRs and try to find answer */

			/* simply try to find INET class RR. It is
				_PROBABLY_ what we're after. More extensive checking
				would demand buffering the reply which may not be
				desireable.
			 */
			while(dns_ancount||dns_nscount){
				do{
					tmp_byte=RECEIVE_NETWORK_B();
				}while((tmp_byte!=0)&&((tmp_byte&0xc0)!=0xc0));

				if(tmp_byte!=0)	/*second offset byte used in compression*/
					RECEIVE_NETWORK_B();

				/* TYPE */
				tmp_int=((UINT16)RECEIVE_NETWORK_B())<<8;
				tmp_int|=RECEIVE_NETWORK_B();

				/* CLASS */
				tmp_int|=(((UINT16)RECEIVE_NETWORK_B())<<8);
				tmp_int|=RECEIVE_NETWORK_B();

				/* CLASS==INET and TYPE=A ? */
				if(tmp_int==0x0001){

					/* got it. Skip TTL and read RDLENGTH */
					for(tmp_byte=0;tmp_byte<6;tmp_byte++){
						tmp_int=(tmp_int<<8)+RECEIVE_NETWORK_B();
					}

					if(tmp_int==0x0004){
						/* great, read IP address*/
						dns_tmp_ip=((UINT32)RECEIVE_NETWORK_B())<<24;
						dns_tmp_ip+=((UINT32)RECEIVE_NETWORK_B())<<16;
						dns_tmp_ip+=((UINT32)RECEIVE_NETWORK_B())<<8;
						dns_tmp_ip+=RECEIVE_NETWORK_B();

						/* we got some IP address. Is it what we asked for
							or a NS IP addr*/
						if(dns_ancount){
							DEBUGOUT("DNS: Got IP address!\r\n");
							dns_event_listener(DNS_EVENT_SUCCESS,dns_tmp_ip);
							dns_state=DNS_STATE_READY;
						}else{
							DEBUGOUT("DNS: Got auth DNS IP addr!\r\n");
							/* invoke another query to the authority */
							dns_retransmit();
						}

						return 0;
					}else{
						/* nope, skip other bytes */
						while(tmp_int--)
							RECEIVE_NETWORK_B();
					}
				}else{

					DEBUGOUT("DNS: RR.CLASS not INET. Skipping!\r\n");

					/* skip TTL and read RDLENGTH*/
					for(tmp_byte=0;tmp_byte<6;tmp_byte++){
						tmp_int=(tmp_int<<8)+RECEIVE_NETWORK_B();
					}

					/* skip RDATA */
					while(tmp_int--)
						RECEIVE_NETWORK_B();
				}
				/* decrement counters */
				if(dns_ancount)
					dns_ancount--;
				else
					if(dns_nscount)
						dns_nscount--;

			}
			break;

		default:
			DEBUGOUT("DNS: unknown UDP event :-(");
			break;
	}
	return 0;
}

/** \brief Invokes DNS resolver
 * 	\author
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\date 10.10.2002
 *	\param host_name_ptr Pointer to null-terminated host name to be
 *		resolved
 *	\param listener Pointer to DNS listener function that listens to events
 *		from DNS client. This function takes two parameters: first one can
 *		take a value of #DNS_EVENT_SUCCESS or #DNS_EVENT_ERROR and thus
 *		determine the meaning of the second parameter. If first parameter
 *		is #DNS_EVENT_SUCCESS, second parameter represents requested IP
 *		address. In case of #DNS_EVENT_ERROR, second parameter can be one
 *		of the: #DNS_ERROR_FORMAT, #DNS_ERROR_SERVER_FAILURE,
 *		#DNS_ERROR_NAME_ERROR, #DNS_ERROR_NOT_IMPLEMENTED, #DNS_ERROR_REFUSED,
 *		#DNS_ERROR_TIMEOUT, #DNS_ERROR_GENERAL
 *	\return
 *		\li #DNS_ERROR_BUSY - Signals that DNS is currently processing
 *		another request so it is not possible to process a new one
 *		\li #DNS_ERROR_OVERFLOW -  Network transmit buffer too small to hold
 *		DNS request
 *		\li #DNS_ERROR_LABEL - Label in host name longer than 63 bytes. Error
 *		\li #DNS_ERROR_NAME - Host name longer than 264 bytes. Error
 *
 *	Invoke this function to start name-resolving process. Note that currently
 *	DNS client can process only one request at a time and will not allow
 *	multiple requests.
 *
 *
 */
UINT8 get_host_by_name(UINT8 *host_name_ptr, void (*listener)(UINT8 , UINT32 )){

	UINT8 *buf_ptr;
	INT8 i;
	UINT16 total;

	switch(dns_state){

		case DNS_STATE_READY:
			dns_state=DNS_STATE_BUSY;
			dns_hostptr=host_name_ptr;
			dns_event_listener=listener;
			dns_tmp_ip=DNS_SERVER_IP;
			dns_retries=DNS_NUM_RETRIES;
			init_timer(dns_timer,DNS_RESEND_PERIOD*TIMERTIC);
			break;

		case DNS_STATE_BUSY:
			DEBUGOUT("DNS: Error, trying to invoke two DNS requests at the same time!\r\n");
			return	DNS_ERROR_BUSY;


		case DNS_STATE_RESEND:
			if(host_name_ptr!=dns_hostptr){
				DEBUGOUT("DNS: Ptrs different. Can't do that! \r\n");
				return DNS_ERROR_BUSY;
			}
			break;

		default:
			DEBUGOUT("DNS: What am I doing in this state?\r\n");
			RESET_SYSTEM();
	}


	/* OK, create message in the Netbuf transmit buffer */

	buf_ptr=net_buf+UDP_APP_OFFSET;

	/* first the header */
	*((UINT16 *)buf_ptr)=0xAAAA; /* id, fixed for now*/
	buf_ptr+=2;

	*buf_ptr++=0x01;
	*buf_ptr++=0x00;

	/*question count*/
	*buf_ptr++=0x00;
	*buf_ptr++=0x01;

	/* others are zero */
	for(i=0;i<6;i++)
		*buf_ptr++=0x00;

	/* ok, create the question section */
	total=0;

	while((*host_name_ptr)!='\0'){

		/* we are still not at the end. Reserve space for count */
		buf_ptr++;
		i=0;

		while(((*host_name_ptr)!='.')&&((*host_name_ptr)!='\0')){
			i++;
			*buf_ptr++=*host_name_ptr++;
			if(buf_ptr==(net_buf+NETWORK_TX_BUFFER_SIZE)){
				DEBUGOUT("DNS: Buffer overflow!!!\r\n");
				return(DNS_ERROR_OVERFLOW);
			}
		}

		/* label shorter than 63 bytes or less? */
		if((i<=0)||(i>=64)){
			DEBUGOUT("DNS: Label size wrong! Aborting....\r\n");
			return(DNS_ERROR_LABEL);
		}

		/* it seems ok for now. Increase total name length*/
		total+=i;

		if(total>=264){
			DEBUGOUT("DNS: Name size wrong! Aborting....\r\n");
			return(DNS_ERROR_NAME);
		}

		*(buf_ptr-i-1)=i;	/* store label length */

		/* ok, where are we ? */
		if((*host_name_ptr)=='.'){
			/* still not at the end, skip dot */
			host_name_ptr++;
		}else
			if((*host_name_ptr)=='\0'){
				/* OHO, finished,
					add ZERO,QTYPE and QCLASS */
				*buf_ptr++=0x00;
				*buf_ptr++=0x00;
				*buf_ptr++=0x01;
				*buf_ptr++=0x00;
				*buf_ptr++=0x01;
				kick_WD();
				/* ok, now send the request */
				return udp_send(dns_socket,dns_tmp_ip,DNS_UDP_PORT,net_buf+UDP_APP_OFFSET,NETWORK_TX_BUFFER_SIZE-UDP_APP_OFFSET,buf_ptr-(net_buf+UDP_APP_OFFSET));
			}
	}
}

