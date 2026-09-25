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

/** \file smtp_client.c
 *	\brief OpenTCP SMTP client implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 9.8.2002
 *	\bug
 *	\warning
 *	\todo
 *
 *	OpenTCP implementation of SMTP client that uses TCP api. For interface
 *	functions declarations see /inet/smtp/smtp_client.h.
 */
#include <inet/datatypes.h>
#include <inet/debug.h>
#include <inet/globalvariables.h>
#include <inet/system.h>
#include <inet/timers.h>
#include <inet/tcp_ip.h>
#include <inet/smtp/smtp_client.h>

UINT8 smtpc_init_done = 0; /**< Defines whether smtpc_init has already been invoked or not */

/** 
 * 	\brief SMTP client state information
 *
 *	smtp_client variable holds various information about the smtp client
 *  needed for proper operation.
 */
struct
{
	UINT8 state;
	UINT32 remip;
	UINT16 remport;
	INT8 sochandle;
	UINT8 tmrhandle;
	UINT16 unacked;
	UINT16 bufindex;
	
}smtp_client;


/* The applications that use TCP must implement following function stubs			*/
/* void application_name_init (void) - call once when processor starts				*/
/* void application_name_run (void) - call periodically on main loop				*/
/* INT32 application_name_eventlistener (INT8, UINT8, UINT32, UINT32)				*/
/* - called by TCP input process to inform arriving data, errors etc				*/

/* SMTP client application		*/

/** \brief Start E-mail sending procedure
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param ip IP address of SMTP server
 *	\param port Port number on server (remote port)
 *	\return
 *		\li - 1 - Error
 *		\li >=0 - Connection procedure started (OK)
 *
 *	This function is called by user when she wants to start E-mail 
 *	sending procedure. The function is responsible of establishing
 *	connection to SMTP server. After connection is established the
 *	SMTP client engine starts to make callbacks to user functions
 *	in order to get E-mail address information, data etc.
 */
INT8 smtpc_connect (UINT32 ip, UINT16 port){
	/* Do we have socket	*/

	if( smtp_client.sochandle < 0 ) {
		DEBUGOUT("smtpc_connect() called but no socket\r\n");
		return(-1);
	}
	
	if( smtp_client.state < SMTP_CLOSED ) {
		DEBUGOUT("smtpc_connect() called but uninitialized\r\n");
		return(-1);
	}
	
	if( smtp_client.state == SMTP_CLOSED ) {
		DEBUGOUT("SMTP Connection request going to be processed\r\n");
		smtp_client.remip = ip;
		smtp_client.remport = port;
		smtpc_changestate(SMTP_OPEN_REQUESTED);
		return(1);
	}
	
	return(-1);	
	
}


/** \brief Initializes SMTP client
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *
 *	This function should be called once when system starts.
 *	Make sure that system services e.g. timers, TCP are initialized
 *	before initializing applications!
 */
void smtpc_init (void){
	
	if(smtpc_init_done) {
		DEBUGOUT("smtp client already initialized\r\n");
		return;
	}
	
	
	/* Get timer handle	*/
	
	smtp_client.tmrhandle = get_timer();
	
	/* Get TCP Socket	*/
	
	smtp_client.sochandle = tcp_getsocket(TCP_TYPE_CLIENT, TCP_TOS_NORMAL, TCP_DEF_TOUT, smtpc_eventlistener);
	
	if( smtp_client.sochandle < 0 ) {
		DEBUGOUT("smtpc_init() uncapable of getting socket\r\n");
		RESET_SYSTEM();
	}	
	
	smtpc_changestate(SMTP_CLOSED);
	smtp_client.bufindex = TCP_APP_OFFSET;
	smtp_client.unacked = 0;	
	smtp_client.remip = 0;
	smtp_client.remport = 0;

	smtpc_init_done = 0x01;

}

/** \brief Retrieves SMTP clients' state
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 6.10.2002
 *
 *	Returns the state of SMTP client
 */
UINT8 smtpc_getstate (void){
	return(smtp_client.state);
	
}

/********************************************************************************
Function:		smtpc_eventlistener

Parameters:		INT8 cbhandle - handle to TCP socket where event is coming from	
				UINT8 event - type of event
				UINT32 par1 - parameter the meaning of depends on event
				UINT32 par2 - parameter the meaning of depends on event
				
Return val:		INT32 - depends on event but usually (-1) is error of some
						kind and positive reply means OK
				
Date:			21.7.2002

Desc:			This function is given to TCP socket as function pointer to be
				used by TCP engine to make callbacks to inform about events
				on TCP e.g. arriving data. Main functionality of this function 
				is to parse data from TCP to detect SMTP server reply commands,
				handling out retransmissions and making state changes
*********************************************************************************/


INT32 smtpc_eventlistener (INT8 cbhandle, UINT8 event, UINT32 par1, UINT32 par2)
{
	/* This function is called by TCP stack to inform about events	*/
	
	UINT16 cmd;
		
	
	if( cbhandle != smtp_client.sochandle)		/* Not our handle	*/
		return(-1);
	
	switch( event )	{
	
		case TCP_EVENT_CONREQ:
		
			/* We don't allow incoming connections	*/
			
			return(-1);
	
		case TCP_EVENT_ABORT:
		
			if(smtp_client.state > SMTP_CLOSED)	{
				/* Inform application	*/	
				smtpc_error();	
			}
		
			smtpc_changestate(SMTP_CLOSED);
			smtp_client.unacked = 0;
			
			return(1);
		
			break;
		
		case TCP_EVENT_CONNECTED:
		
			if(smtp_client.state == SMTP_CONNECTIONOPEN_SENT) {
				DEBUGOUT("SMTP TCP connection opened\r\n");
				smtpc_changestate(SMTP_CONNECTION_OPENED);
				smtp_client.unacked = 0;
				smtp_client.bufindex = TCP_APP_OFFSET;
				return(-1);
			}
				
			break;
			
		case TCP_EVENT_CLOSE:
		
			smtpc_changestate(SMTP_CLOSED);
			smtp_client.unacked = 0;
			return(1);
		
			break;
			
		case TCP_EVENT_ACK:
		
			/* Our message is acked	*/
			
			smtp_client.unacked = 0;
			
			break;
			
		case TCP_EVENT_DATA:
		
			/* Do we have unacked data?	*/
			
			if(smtp_client.unacked)
				return(-1);
		
			/* Get reply from server	*/
			
			if(par1 < 3)					/* Long enough?	*/
				return(-1);
		
			/* Get command				*/
			
			NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
			cmd = RECEIVE_NETWORK_B();
			cmd += RECEIVE_NETWORK_B();
			cmd += RECEIVE_NETWORK_B();
			
			switch(smtp_client.state) { 
				
				case SMTP_CONNECTION_OPENED:
				
					if(cmd == SMTP_CMD_SERVER_READY) {
						DEBUGOUT("SMTP Server is ready\r\n");
						smtpc_changestate(SMTP_SERVER_READY);
						return(1);
					}
					
					break;
				
				case SMTP_HELO_SENT:
				
					if(cmd == SMTP_CMD_OK) {	
						DEBUGOUT("HELO acked by SMTP server\r\n");
						smtpc_changestate(SMTP_HELO_ACKED);
						return(1);
					}
					
					break;				
					
				case SMTP_MAILFROM_SENT:
				
					if(cmd == SMTP_CMD_OK) {
						DEBUGOUT("MAIL FROM Acked by SMTP server\r\n");
						smtpc_changestate(SMTP_MAILFROM_ACKED);
						return(1);
					}
					
					break;			
					
				case SMTP_RCPTTO_SENT: 
				
					if(cmd == SMTP_CMD_OK) {
						DEBUGOUT("RCPT TO Acked by SMTP server\r\n");
						smtpc_changestate(SMTP_RCPTTO_ACKED);
						return(1);
					}
					
					break;	
					
				case SMTP_DATAREQ_SENT:
				
					if(cmd == SMTP_CMD_DATAOK) {
						DEBUGOUT("DATA Acked by SMTP Server\r\n");
						smtpc_changestate(SMTP_DATAREQ_ACKED);
						return(1);
					}
					
					break;										
				
				case SMTP_DATAEND_SENT:
				
					if(cmd == SMTP_CMD_OK) {
						DEBUGOUT("CRLF.CRLF Acked by SMTP Server\r\n");
						smtpc_changestate(SMTP_DATAEND_ACKED);
						return(1);
					}
					
					break;					
					
				case SMTP_QUIT_SENT:
				
					if(cmd == SMTP_CMD_QUITOK) {
						DEBUGOUT("QUIT Acked by SMTP Server\r\n");
						smtpc_changestate(SMTP_QUIT_ACKED);
						return(1);
					}
					
					break;
					
				default:
					break;

			
			}

		
			return(1);
		
			
		case TCP_EVENT_REGENERATE:
		
			/* Send last packet again	*/
		
			DEBUGOUT("SMTP is regenerating...\r\n");
		
			switch (smtp_client.state) {
			
				case SMTP_HELO_SENT:
					smtpc_sendhelo();
					return(1);
				
				case SMTP_MAILFROM_SENT:
					smtpc_sendmailfrom();
					return(1);
					
				case SMTP_RCPTTO_SENT:
					smtpc_sendrcptto();
					return(1);
				
				case SMTP_DATAREQ_SENT:
					smtpc_senddatareq();
					return(1);
				
				case SMTP_BODY_SENT:
					smtpc_sendbody();
					return(1);	
				
				case SMTP_SENDING_DATA:
					smtpc_senddata();
					return(1);
				
				case SMTP_DATAEND_SENT:	
					smtpc_senddataend();
					return(1);
				
				case SMTP_QUIT_SENT:
					smtpc_sendquit();
					return(1);
					
				default:
					return(-1);
			}
		
		
			break;
	
	
		default:
			return(-1);
	}	

	return(-1);

}

/********************************************************************************
Function:		smtpc_run

Parameters:		void	
				
Return val:		void
				
Date:			21.7.2002

Desc:			This function is main 'thread' of SMTP client program
				and should be called periodically when SMTP client is
				active. This function is responsible of sending commands and
				data to SMTP server and making callbacks to user function stubs.
*********************************************************************************/


void smtpc_run (void)
{
	/* On that function we can send data when called by main loop	*/
	
	if( smtpc_init_done == 0 )
		return;
	
	if( smtp_client.state < SMTP_OPEN_REQUESTED)
		return;
		
	/* Is there timeout of some sort?	*/
		
	if(check_timer(smtp_client.tmrhandle) == 0) {
		/* Yep	*/
		tcp_abort(smtp_client.sochandle);
		smtpc_changestate(SMTP_CLOSED);
			
		/* Make user callback	*/
		smtpc_error();
		return;
		
	}	
	
	if( smtp_client.state == SMTP_OPEN_REQUESTED) {
		/* We are on this state because user has requested connection	*/
		/* but connection is not yet opened.							*/
		/* Try to get TCP stack to accept our connection request		*/
		
		tcp_abort(smtp_client.sochandle);	/* Release old connection	*/
		if(tcp_connect(smtp_client.sochandle, smtp_client.remip, smtp_client.remport, 0) >= 0)
			smtpc_changestate(SMTP_CONNECTIONOPEN_SENT);
		
		return;
	}
	
	

	if( tcp_getstate(smtp_client.sochandle) != TCP_STATE_CONNECTED ) {
		return;
	}
	
	if( tcp_checksend(smtp_client.sochandle) < 0 )
		return;
	
	/* It's connected and no unacked data so try to send	*/
	
	
	if(smtp_client.state == SMTP_SERVER_READY) {
		/* Send HELO	*/
		smtpc_sendhelo();
		smtpc_changestate(SMTP_HELO_SENT);
		DEBUGOUT("SMTP HELO packet sent\r\n");
		return;
	}
	
	if(smtp_client.state == SMTP_HELO_ACKED) {
		/* Send MAIL FROM	*/
		smtpc_sendmailfrom();
		smtpc_changestate(SMTP_MAILFROM_SENT);
		DEBUGOUT("SMTP MAIL FROM packet sent\r\n");
		return;
	}	
	
	if(smtp_client.state == SMTP_MAILFROM_ACKED) {
		/* Send RCPT TO	*/
		smtpc_sendrcptto();
		smtpc_changestate(SMTP_RCPTTO_SENT);
		DEBUGOUT("SMTP RCPT TO packet sent\r\n");
		return;
	}	
	
	if(smtp_client.state == SMTP_RCPTTO_ACKED) {
		/* Send DATA	*/
		smtpc_senddatareq();
		smtpc_changestate(SMTP_DATAREQ_SENT);
		DEBUGOUT("SMTP DATA packet sent\r\n");
		return;
	}	
	
	if(smtp_client.state == SMTP_DATAREQ_ACKED)	{
		/* Send BODY	*/
		smtpc_sendbody();
		smtpc_changestate(SMTP_BODY_SENT);
		DEBUGOUT("SMTP BODY packet sent\r\n");
		return;
	}	
	
	
	/* Body is part of plain text so we just make internal state change	*/
	/* when TCP has acked the body packet. This pseudo-state just helps */
	/* us to regenerate the body when needed							*/
	
	if(smtp_client.state == SMTP_BODY_SENT)
		smtpc_changestate(SMTP_SENDING_DATA);
	
	if(smtp_client.state == SMTP_SENDING_DATA) {
		/* Inform user app that old data is acked now	*/
		
		smtpc_dataacked();		
	
		if (smtpc_senddata() < 0) {
			/* End of data, send CRLF.CRLF	*/
			
			DEBUGOUT("SMTP End of data reached\r\n");
			smtpc_senddataend();
			smtpc_changestate(SMTP_DATAEND_SENT);
			
		}
		return;
	}	
	
		
	if(smtp_client.state == SMTP_DATAEND_ACKED) {
		/* Send QUIT	*/
		smtpc_sendquit();
		smtpc_changestate(SMTP_QUIT_SENT);
		DEBUGOUT("SMTP QUIT packet sent\r\n");
		return;
	}		


	if(smtp_client.state == SMTP_QUIT_ACKED) {
	
		/* Inform application that data is sent OK	*/
		
		smtpc_allok();
	
		/* Try to close TCP	*/
		
		if(tcp_close(smtp_client.sochandle) >= 0) {
			smtpc_changestate(SMTP_CLOSED);
			DEBUGOUT("SMTP connection closed OK\r\n");
			return;
		}
		
		/* Close is not accepted by TCP. See if timeout	*/
		
		if(check_timer(smtp_client.tmrhandle) == 0) {
			/* Use brute force		*/
			
			tcp_abort(smtp_client.sochandle);
			smtpc_changestate(SMTP_CLOSED);
			DEBUGOUT("SMTP connection closed by ABORT\r\n");
			return;
		}
		
		/* Keep trying untill timeout	*/
		
		return;
		
	}	
	
	return;

}


void smtpc_sendhelo (void)
{
	INT8 i;
	UINT8* buf;

	/* Fill TCP Tx buffer with "HELO " and use callback function	*/
	/* smtp_getdomain in order to get domain from systems and send	*/
	/* that combined "HELO domainnname" to SMTP server				*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'H';
	*buf++ = 'E';
	*buf++ = 'L';
	*buf++ = 'O';
	*buf++ = ' '; 
	
	i = smtpc_getdomain(buf);
	
	if(i < 0)
		return;
	
	buf += i;	
	
	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}



void smtpc_sendmailfrom (void)
{
	INT8 i;
	UINT8* buf;

	/* Fill TCP Tx buffer with "MAIL FROM: <" and use callback function				*/
	/* smtp_getsender in order to get local e-mail address from user and send		*/
	/* that combined "MAIL FROM: <myadr>" to SMTP server							*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'M';
	*buf++ = 'A';
	*buf++ = 'I';
	*buf++ = 'L';
	*buf++ = ' '; 
	*buf++ = 'F';
	*buf++ = 'R';
	*buf++ = 'O';
	*buf++ = 'M';
	*buf++ = ':';
	*buf++ = ' ';
	*buf++ = '<';	
	
	i = smtpc_getsender(buf);
	
	if(i < 0)
		return;
	
	buf += i;
	
	/* Insert >CRLF	*/
	
	*buf++ = '>';
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 15);

}



void smtpc_sendrcptto (void)
{
	INT8 i;
	UINT8* buf;

	/* Fill TCP Tx buffer with "RCPT TO: <" and use callback function			*/
	/* smtp_getreceiver in order to get receiver address from user and send		*/
	/* that combined "RCPT To: <rcvadr>" to SMTP server							*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'R';
	*buf++ = 'C';
	*buf++ = 'P';
	*buf++ = 'T';
	*buf++ = ' '; 
	*buf++ = 'T';
	*buf++ = 'O';
	*buf++ = ':';
	*buf++ = ' ';
	*buf++ = '<';	
	
	i = smtpc_getreceiver(buf);
	
	if(i < 0)
		return;
		
	buf += i;	
	
	/* Insert >CRLF	*/
	
	*buf++ = '>';
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 13);

}

void smtpc_senddatareq (void)
{
	UINT8* buf;

	/* Fill TCP Tx buffer with "DATA" and send to SMTP server	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'D';
	*buf++ = 'A';
	*buf++ = 'T';
	*buf++ = 'A';

	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf = '\n';
		
	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 6);

}

void smtpc_sendbody (void)
{
	UINT8* buf;
	INT8 i;
	UINT8 j;

	/* Fill TCP Tx buffer with RFC 822 body and send to SMTP server	*/
	
	j = 0;
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'T';
	*buf++ = 'o';
	*buf++ = ':';
	*buf++ = ' ';
	
	i = smtpc_getreceiver(buf);
	
	if(i < 0)
		return;
		
	buf += i;	
		
	j += i;

	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf++ = '\n';
	
	*buf++ = 'S';
	*buf++ = 'u';
	*buf++ = 'b';
	*buf++ = 'j';
	*buf++ = 'e';
	*buf++ = 'c';
	*buf++ = 't';
	*buf++ = ':';
	*buf++ = ' ';
	
	i = smtpc_getsubject(buf);
	
	if(i < 0)
		return;
	
	buf += i;
	
	j += i;

	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf++ = '\n';	
	
	*buf++ = 'F';
	*buf++ = 'r';
	*buf++ = 'o';
	*buf++ = 'm';
	*buf++ = ':';
	*buf++ = ' ';
	
	i = smtpc_getsender(buf);
	
	if(i < 0)
		return;
	
	buf += i;
	
	j += i;

	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf++ = '\n';	
	
	/* Insert emty row	*/
	
	*buf++ = '\r';
	*buf = '\n';
		
	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, j + 27);

}


void smtpc_senddataend (void)
{
	UINT8* buf;

	/* Fill TCP Tx buffer with CRLF.CRLF and send to SMTP server	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = '\r';
	*buf++ = '\n';
	*buf++ = '.';
	*buf++ = '\r';
	*buf = '\n';
		
	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 5);

}


void smtpc_sendquit (void)
{
	UINT8* buf;

	/* Fill TCP Tx buffer with "QUIT" and send to SMTP server	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'Q';
	*buf++ = 'U';
	*buf++ = 'I';
	*buf++ = 'T';

	/* Insert CRLF	*/
	
	*buf++ = '\r';
	*buf = '\n';
		
	tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 6);

}


INT16 smtpc_senddata (void)
{

	INT16 len;

	/* Use callback smtpc_getdata in order to fill Tx buffer with user data	*/
	/* Normally user callback should return number of bytes assembled but	*/
	/* when end of data is reached no bytes are written but (-1) returned	*/
	
	len = smtpc_getdata(&net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET);
	
	if(len < 0)
		return(-1);
		
	if(len > 0)	
		tcp_send(smtp_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, (UINT16)len);
	
	return(len);
	
}

void smtpc_changestate (UINT8 nstate)
{
	
	init_timer(smtp_client.tmrhandle, SMTPC_TOUT*TIMERTIC);
	smtp_client.state = nstate;

}


