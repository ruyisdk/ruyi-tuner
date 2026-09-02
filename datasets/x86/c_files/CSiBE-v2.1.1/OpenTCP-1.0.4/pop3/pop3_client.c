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

/** \file pop3_client.c
 *	\brief OpenTCP POP3 client implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 20.08.2002
 *	\bug
 *	\warning
 *	\todo
 *  
 *	OpenTCP implementation of POP3 client that uses TCP api. For interface
 *	functions declarations see /pop3/pop3_client.h.
 */

#include<inet/debug.h>
#include<inet/datatypes.h>
#include<inet/globalvariables.h>
#include<inet/system.h>
#include<inet/timers.h>
#include<inet/tcp_ip.h>
#include<inet/pop3/pop3_client.h>


UINT8 pop3c_init_done = 0; /**< Defines whether pop3c_init has already been invoked or not */

/**	\brief	Holds information needed by the POP3 client for successful operation.
 *
 *	All of the information that the POP3 client is using for operation
 *	are stored here. See pop3c_struct definition for more
 *	information about the structure fields.
 */
struct pop3c_struct pop3_client; 


/* The applications that use TCP must implement following function stubs			*/
/* void application_name_init (void) - call once when processor starts				*/
/* void application_name_run (void) - call periodically on main loop				*/
/* INT32 application_name_eventlistener (INT8, UINT8, UINT32, UINT32)				*/
/* - called by TCP input process to inform arriving data, errors etc				*/


/* POP3 Client application		*/


/** \brief Start E-mail reading procedure
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *	\param ip IP address of POP3 server from which to read the e-mails
 *	\param port Port on the server
 *	\return
 *		\li -1 - Error
 *		\li >0 - Connection procedure started (OK)
 *
 *	This function is called by user when she wants to start E-mail 
 *	reading procedure. The function is responsible of establishing
 *	connection to POP3 server. After connection is established the
 *	POP3 client engine starts to make callbacks to user functions
 *	in order to get username information, data etc.
 */
INT8 pop3c_connect (UINT32 ip, UINT16 port){
	/* Do we have socket	*/

	if( pop3_client.sochandle < 0 ) {
		DEBUGOUT("pop3c_connect() called but no socket\r\n");
		return(-1);
	}
	
	if( pop3_client.state < POP3C_CLOSED ) {
		DEBUGOUT("pop3c_connect() called but uninitialized\r\n");
		return(-1);
	}
	
	if( pop3_client.state == POP3C_CLOSED )	{
		DEBUGOUT("POP3 Connection request going to be processed\r\n");
		pop3_client.remip = ip;
		pop3_client.remport = port;
		pop3c_changestate(POP3C_OPEN_REQUESTED);
		return(1);
	}
	
	return(-1);	
	
}

/** \brief Initialize POP3 client
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *
 *	This function should be called once when system starts.
 *	Make sure that system services e.g. timers, TCP are initialized
 *	before initializing applications!
 */
void pop3c_init (void){
	
	if(pop3c_init_done) {
		DEBUGOUT("POP3 client already initialized\r\n");
		return;
	}
	
	
	/* Get timer handle	*/
	
	pop3_client.tmrhandle = get_timer();
	
	/* Get TCP Socket	*/
	
	pop3_client.sochandle = tcp_getsocket(TCP_TYPE_CLIENT, TCP_TOS_NORMAL, TCP_DEF_TOUT, pop3c_eventlistener);
	
	if( pop3_client.sochandle < 0 )	{
		DEBUGOUT("pop3c_init() uncapable of getting socket\r\n");
		RESET_SYSTEM();
	}	
	
	pop3c_changestate(POP3C_CLOSED);	
	pop3_client.remip = 0;
	pop3_client.remport = 0;
	pop3_client.unacked = 0;
	pop3_client.msgtotal = 0;
	pop3_client.curmsgindex = 0;
	pop3_client.curmsgtotlen = 0;
	pop3_client.curmsghlen = 0;
	pop3_client.headerbuf[0] = '\0';
	pop3_client.charsinheaderbuf = 0;
	pop3_client.from[0] = '\0';
	pop3_client.subject[0] = '\0';
	
	pop3c_init_done = 0x01;				/* We are initialized now	*/

}
/** \brief Get current POP3 client state
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 10.10.2002
 *	\return Current POP3 client state
 *
 *	Invoke this function to get current state of the POP3 client
 *
 */
UINT8 pop3c_getstate (void){
	return(pop3_client.state);
	
}

/********************************************************************************
Function:		pop3c_eventlistener

Parameters:		INT8 cbhandle - handle to TCP socket where event is coming from	
				UINT8 event - type of event
				UINT32 par1 - parameter the meaning of depends on event
				UINT32 par2 - parameter the meaning of depends on event
				
Return val:		INT32 - depends on event but usually (-1) is error of some
						kind and positive reply means OK
				
Date:			21.8.2002

Desc:			This function is given to TCP socket as function pointer to be
				used by TCP engine to make callbacks to inform about events
				on TCP e.g. arriving data. Main functionality of this function 
				is to parse data from TCP to detect POP3 server reply commands,
				handling out retransmissions and making state changes
*********************************************************************************/


INT32 pop3c_eventlistener (INT8 cbhandle, UINT8 event, UINT32 par1, UINT32 par2)
{
	/* This function is called by TCP stack to inform about events	*/
	
	UINT8 cmd;
	UINT16 i;
	static UINT16 len;
	static UINT16 match;
	static UINT8  end_detect;
	UINT8 ch;
	UINT8 j;
	UINT8 endbuf[4];
		
	
	if( cbhandle != pop3_client.sochandle)		/* Not our handle	*/
		return(-1);
	
	switch( event ) {
	
		case TCP_EVENT_CONREQ:
		
			/* We don't allow incoming connections	*/
			
			return(-1);
	
		case TCP_EVENT_ABORT:
		
			if(pop3_client.state > POP3C_CLOSED) {
				/* Inform application	*/	
				pop3c_error();	
			}
		
			pop3c_changestate(POP3C_CLOSED);
			pop3_client.unacked = 0;
			
			return(1);
		
			break;
		
		case TCP_EVENT_CONNECTED:
		
			if(pop3_client.state == POP3C_CONNECTIONOPEN_SENT) {
				DEBUGOUT("POP3 TCP connection opened\r\n");
				pop3c_changestate(POP3C_CONNECTION_OPENED);
				pop3_client.unacked = 0;
				return(-1);
			}
				
			break;
			
		case TCP_EVENT_CLOSE:
		
			pop3c_changestate(POP3C_CLOSED);
			pop3_client.unacked = 0;
			return(1);
		
			break;
			
		case TCP_EVENT_ACK:
		
			/* Our message is acked	*/
			
			pop3_client.unacked = 0;
			
			break;
			
		case TCP_EVENT_DATA:
		
			/* Do we have unacked data?	*/
			
			if(pop3_client.unacked)
				return(-1);
		
			/* Get reply from server	*/
			
			if(par1 < 3)					/* Long enough?	*/
				return(-1);
		
			/* Get command				*/
			
			NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
			cmd = RECEIVE_NETWORK_B();
			NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);

			switch(pop3_client.state) {
				
				case POP3C_CONNECTION_OPENED:
				
					if(cmd == POP3C_OK)	{
						DEBUGOUT("POP3 Server is ready\r\n");
						pop3c_changestate(POP3C_SERVER_READY);
						return(1);
					}
					
					break;
				
				case POP3C_USERNAME_SENT:
				
					if(cmd == POP3C_OK)	{	
						DEBUGOUT("USER +OK by POP3 server\r\n");
						pop3c_changestate(POP3C_USERNAME_ACKED);
						return(1);
					}
					
					break;				
					
				case POP3C_PASSWORD_SENT:
				
					if(cmd == POP3C_OK) {
						DEBUGOUT("PASS +OK by POP3 server\r\n");
						pop3c_changestate(POP3C_PASSWORD_ACKED);
						return(1);
					}
					
					break;			
					
				case POP3C_STAT_SENT: 
				
					if(cmd == POP3C_OK)	{
						DEBUGOUT("STAT get from POP3 server\r\n");
						
						/* Parse number of messages	*/
						
						NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
							
						pop3_client.msgtotal = 0;
						pop3_client.curmsgindex = 0;
						pop3_client.curmsgtotlen = 0;
						pop3_client.curmsghlen = 0;
						if( pop3c_parsestat() < 0 )	{
							/* Error parsing STAT reply	*/
							/* Inform application		*/	
							pop3c_error();							
							tcp_abort(pop3_client.sochandle);
							pop3c_changestate(POP3C_CLOSED);
							pop3_client.unacked = 0;							
							return(1);
						}
						
						/* Inform application about the nmbr of messages	*/
						pop3c_messages(pop3_client.msgtotal);
						
						pop3c_changestate(POP3C_STAT_GET);
						return(1);
					}
					
					break;	
					
				case POP3C_LIST_SENT:
				
					if(cmd == POP3C_OK)	{
						DEBUGOUT("LIST get from POP3 server\r\n");
						
						/* Parse message total len	*/
						
						NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);	
						
						pop3_client.curmsgtotlen = 0;
						
						if(pop3c_parselist() < 0) {
							/* Error parsing LIST reply	*/
							/* Inform application		*/	
							pop3c_error();							
							tcp_abort(pop3_client.sochandle);
							pop3c_changestate(POP3C_CLOSED);
							pop3_client.unacked = 0;							
							return(1);						
						
						}
						
						
						pop3c_changestate(POP3C_LIST_GET);
						return(1);
					}
					
					break;										
				
				case POP3C_TOP0_SENT:
				
					if(cmd == POP3C_OK) {
						DEBUGOUT("TOP x 0 get from POP3 server\r\n");
						
						/* Continue imediately to receive header	*/
						pop3_client.curmsghlen = 0;
						pop3_client.from[0] = '\0';
						pop3_client.subject[0] = '\0';
						match = 0;
						
						/* Receive untill LF found	*/
					
						for(i=0; i<(UINT16)par1; i++)
						{
							ch = RECEIVE_NETWORK_B();
						
							if(ch == '\n')
							{	i++;
								break;
							}
						}
				
						par1 = i;						
						
						
						pop3c_changestate(POP3C_RECEIVING_HEADER);	
					}else
						break;
					
				case POP3C_RECEIVING_HEADER:
				case POP3C_RECEIVING_HDR_FROM:
				case POP3C_RECEIVING_HDR_SUBJ:
				
					pop3_client.curmsghlen += (UINT16)par1;
					
					if( pop3_client.curmsghlen > (pop3_client.curmsgtotlen + 100) )	{
						/* Somebody tries to fool us	*/
						/* Move to next msg				*/
						
						pop3c_changestate(POP3C_MESSAGE_RECEIVED);
						break;	
						
					}
					
					/* We try to find 'from:', or 'subject:'	*/
					
					NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
					
					for( i=0; i<(UINT16)par1; i++) {
						
						ch = RECEIVE_NETWORK_B();
						
						if( pop3_client.state == POP3C_RECEIVING_HEADER) {
						
							if( ch == '\r')	{
								pop3_client.charsinheaderbuf = 0;
								continue;
							}
						
							if( ch == '\n')	{
								pop3_client.charsinheaderbuf = 0;
								continue;
							}
						
							if( ch == ' ')		/* Remove spaces	*/
								continue;
					
							/* Buffer already full for this line?	*/
					
							if(pop3_client.charsinheaderbuf > 8)
								continue;
					
							/* End of header? (parsing of that is not absolutely correct)	*/
							/* We detect it from CRLF. or LFCR. or CR. or LF.				*/
							/* the correct indication being CRLF.CRLF						*/
							
							if( (ch == '.') && (pop3_client.charsinheaderbuf == 0) ) {
								/* Remove CRLF.CRLF from header length	*/
								
								if( pop3_client.curmsghlen >= 5 )
									pop3_client.curmsghlen -= 5;
								
								pop3c_changestate(POP3C_TOP0_GET);
								break;
							}
					
					
							ch = tolower(ch);
						
							pop3_client.headerbuf[pop3_client.charsinheaderbuf] = ch;
							pop3_client.charsinheaderbuf++;
							pop3_client.headerbuf[pop3_client.charsinheaderbuf] = '\0';
						
							/* Is it 'from:' ?	*/
						
							if(bufsearch(&pop3_client.headerbuf[0],pop3_client.charsinheaderbuf,"from:") == 0) {
								/* Continue imidiately to read sender	*/
							
								pop3_client.from[0] = '\0';
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HDR_FROM);	
								continue;
							}
						
							/* Is it 'subject:' ?	*/
						
							if(bufsearch(&pop3_client.headerbuf[0],pop3_client.charsinheaderbuf,"subject:") == 0) {
								/* Continue imidiately to read subject	*/
									
								pop3_client.subject[0] = '\0';
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HDR_SUBJ);	
								continue;
							}
						
						}	/* of RECEIVING_HEADER	*/
						
						
						if( pop3_client.state == POP3C_RECEIVING_HDR_FROM) {
							if( ch == ' '){		/* Remove spaces	*/
								if(pop3_client.charsinheaderbuf == 0)
									continue;
							}
							
							if( ch == '\r')	{
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}
							
							if( ch == '\n')	{
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}
							
							/* Store it	*/
							
							pop3_client.from[pop3_client.charsinheaderbuf] = ch;
							pop3_client.charsinheaderbuf++;
							pop3_client.from[pop3_client.charsinheaderbuf] = '\0';
							
							if(pop3_client.charsinheaderbuf >= POP3C_SENDERMAXLEN) {
								/* The buffer is exeeded	*/
								/* Mark it corrupted		*/
								
								pop3_client.from[0] = '\0';
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}	
												
						} 	/* of RECEIVING_HDR_FROM	*/
						
						
						if( pop3_client.state == POP3C_RECEIVING_HDR_SUBJ) {
							if( ch == ' '){		/* Remove spaces	*/
								if(pop3_client.charsinheaderbuf == 0)
									continue;
							}
							
							if( ch == '\r')	{
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}
							
							if( ch == '\n')	{
								pop3_client.charsinheaderbuf = 0;
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}
							
							/* Store it	*/
							
							pop3_client.subject[pop3_client.charsinheaderbuf] = ch;
							pop3_client.charsinheaderbuf++;
							pop3_client.subject[pop3_client.charsinheaderbuf] = '\0';
							
							if(pop3_client.charsinheaderbuf >= POP3C_SUBJECTMAXLEN)	{
								/* The buffer is exeeded	*/
								/* Mark it corrupted		*/
								
								pop3_client.subject[0] = '\0';
								pop3c_changestate(POP3C_RECEIVING_HEADER);
								continue;
							}	
												
						} 	/* of RECEIVING_HDR_SUBJ	*/						
						
					
					}
					

					break;
											
					
				case POP3C_RETR_SENT:
				
					if(cmd == POP3C_OK)	{
						DEBUGOUT("RETR +OK by POP3 server\r\n");
						
						/* Continue imidiately to receive message	*/
						
						pop3c_changestate(POP3C_RECEIVING_MSG_HEADER);
					
					} else
						break;
						
				case POP3C_RECEIVING_MSG_HEADER:	
				
					/* Try to find empty row to detect the start of actual message	*/
					
					match = 0;
					NETWORK_RECEIVE_INITIALIZE(received_tcp_packet.buf_index);
					
					for(i=0; i < (UINT16)par1; i++)	{					
						ch = RECEIVE_NETWORK_B();
						
						if(match == 0)	{
							if( (ch == '\r') || (ch == '\n') )
								match++;
							else
								match = 0;
							continue;	
						}

						if(match == 1) {
							if( (ch == '\r') || (ch == '\n'))
								match++;
							else
								match = 0;
							continue;	
						}						
						
						if(match == 2) {
							if( (ch == '\r') || (ch == '\n'))
								match++;
							else
								match = 0;
							continue;	
						}			
						
						if(match == 3) {
							if( (ch == '\r') || (ch == '\n')) {
								match++;
								
								/* Continue to read the actual msg	*/
								par1 -= (i + 1);
								pop3c_changestate(POP3C_RECEIVING_MSG);
								break;
							} else
								match = 0;
							continue;	
						}						
									
					}
					
					/* If we don't find the end of header we will timeout	*/
					/* on pop3c_run so no error handling here				*/
				
					if( pop3_client.state != POP3C_RECEIVING_MSG)
						break;
					
					end_detect = 0;	
					case POP3C_RECEIVING_MSG:
					
						/* Search is this packet end of msg and do not give	*/
						/* CRLF.CRLF to application							*/
						for(i=0; i < (UINT16)par1; i++)	{
							ch = RECEIVE_NETWORK_B();
							
							pop3c_data(ch);
							
							if( (ch == '\r') && (end_detect != 3))
								end_detect = 0;
							
							
							if( end_detect == 0 ) {
								if(ch == '\r')
									end_detect++;
								else
									end_detect = 0;
								
								continue;
							}
							
							if( end_detect == 1 ){
								if(ch == '\n')
									end_detect++;
								else
									end_detect = 0;
								
								continue;
							}							
							
							if( end_detect == 2 ){
								if(ch == '.')
									end_detect++;
								else
									end_detect = 0;
								
								continue;
							}	
							
							if( end_detect == 3 ){
								if(ch == '\r')
									end_detect++;
								else
									end_detect = 0;
								
								continue;
							}													
							
							if( end_detect == 4 ){	
								if(ch == '\n') {													
									pop3c_changestate(POP3C_MESSAGE_RECEIVED);
									return(1);
								}
								else
									end_detect = 0;
								
								continue;
							}
						
						}
						
						break;
						
					case POP3C_DELE_SENT:
					
						if(cmd == POP3C_OK)	{
							DEBUGOUT("DELE +OK by POP3 server\r\n");
							pop3c_changestate(POP3C_DELE_ACKED);
							return(1);
						}
					
						break;	
						
					case POP3C_QUIT_SENT:
					
						if(cmd == POP3C_OK)	{
							DEBUGOUT("QUIT +OK by POP3 server\r\n");
							pop3c_changestate(POP3C_QUIT_ACKED);
							return(1);
						}
					
						break;										
					
						
				default:
					break;

			
			}

		
			return(1);
		
			
		case TCP_EVENT_REGENERATE:
		
			/* Send last packet again	*/
		
			DEBUGOUT("POP3C is regenerating...\r\n");
		
			switch (pop3_client.state) {
			
				case POP3C_USERNAME_SENT:
					pop3c_senduser();
					return(1);
				
				case POP3C_PASSWORD_SENT:
					pop3c_sendpassword();
					return(1);
					
				case POP3C_STAT_SENT:
					pop3c_sendstat();
					return(1);
				
				case POP3C_LIST_SENT:
					pop3c_sendlist(pop3_client.curmsgindex);
					return(1);
				
				case POP3C_TOP0_SENT:
					pop3c_sendtop(0);
					return(1);	
				
				case POP3C_RETR_SENT:
					pop3c_sendretr(pop3_client.curmsgindex);
					return(1);
				
				case POP3C_DELE_SENT:	
					pop3c_senddele(pop3_client.curmsgindex);
					return(1);
				
				case POP3C_QUIT_SENT:
					pop3c_sendquit();
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
Function:		pop3c_run

Parameters:		void		
				
Return val:		void
				
Date:			11.9.2002

Desc:			This function should be called periodically from main loop
				in order to run pop3 client 'thread'.
*********************************************************************************/

void pop3c_run (void)
{
	INT16 i;

	/* On that function we can send data when called by main loop	*/
	
	if( pop3c_init_done == 0 )
		return;
	
	if( pop3_client.state < POP3C_OPEN_REQUESTED)
		return;
		
	/* Is there timeout of some sort?	*/
		
	if(check_timer(pop3_client.tmrhandle) == 0) {
		/* Yep	*/
		tcp_abort(pop3_client.sochandle);
		pop3c_changestate(POP3C_CLOSED);
			
		/* Make user callback	*/
		pop3c_error();
		return;
		
	}
	
	if( pop3_client.state == POP3C_OPEN_REQUESTED) {
		/* We are on this state because user has requested connection	*/
		/* but connection is not yet opened.							*/
		/* Try to get TCP stack to accept our connection request		*/
		
		tcp_abort(pop3_client.sochandle);		/* Release old connection	*/
		if(tcp_connect(pop3_client.sochandle, pop3_client.remip, pop3_client.remport, 0) >= 0)
			pop3c_changestate(POP3C_CONNECTIONOPEN_SENT);
		
		return;
	}
	
	if( tcp_getstate(pop3_client.sochandle) != TCP_STATE_CONNECTED ) {
		return;
	}	
	
	if( tcp_checksend(pop3_client.sochandle) < 0 )
		return;
	
	/* It's connected and no unacked data so try to send	*/	
	
	if(pop3_client.state == POP3C_SERVER_READY) {
		/* Send USER	*/
		pop3c_senduser();
		pop3c_changestate(POP3C_USERNAME_SENT);
		DEBUGOUT("POP3C USER packet sent\r\n");
		return;
	}	
	
	if(pop3_client.state == POP3C_USERNAME_ACKED) {
		/* Send PASS	*/
		pop3c_sendpassword();
		pop3c_changestate(POP3C_PASSWORD_SENT);
		DEBUGOUT("POP3C PASS packet sent\r\n");
		return;
	}	
	
	if(pop3_client.state == POP3C_PASSWORD_ACKED) {
		/* Send STAT	*/
		pop3c_sendstat();
		pop3c_changestate(POP3C_STAT_SENT);
		DEBUGOUT("POP3C STAT packet sent\r\n");
		return;
	}
	
	if(pop3_client.state == POP3C_STAT_GET) {
		/* Still messages?		*/
		if( pop3_client.curmsgindex < pop3_client.msgtotal ) {
			pop3_client.curmsgindex++;
			pop3c_sendlist(pop3_client.curmsgindex);
			pop3c_changestate(POP3C_LIST_SENT);
			DEBUGOUT("POP3C LIST packet sent\r\n");
			return;
		}
		
		/* End of messages	*/
		
		pop3c_sendquit();
		pop3c_changestate(POP3C_QUIT_SENT);
		DEBUGOUT("POP3C QUIT packet sent\r\n");
		return;		
		
	}
	
	if(pop3_client.state == POP3C_LIST_GET) {
		/* Now we have the whole length of current message. Receive body	*/
		
		pop3c_sendtop(pop3_client.curmsgindex);
		pop3c_changestate(POP3C_TOP0_SENT);
		DEBUGOUT("POP3C TOP packet sent\r\n");
		return;
	}
	
	if(pop3_client.state == POP3C_TOP0_GET) {
		/* Offer the e-mail to sender	*/
		
		if((pop3_client.curmsgtotlen + 100 )> pop3_client.curmsghlen) {
			if(pop3_client.curmsgtotlen < pop3_client.curmsghlen)
				i = pop3c_msgoffer(pop3_client.curmsgindex, 0, &pop3_client.from[0], &pop3_client.subject[0]);
			else
				i = pop3c_msgoffer(pop3_client.curmsgindex, pop3_client.curmsgtotlen - pop3_client.curmsghlen, &pop3_client.from[0], &pop3_client.subject[0]);
			
			if( i == (-2) ) {
				/* User want's the mail to be deleted directly	*/
				
				pop3c_senddele(pop3_client.curmsgindex);
				pop3c_changestate(POP3C_DELE_SENT);
				DEBUGOUT("POP3C deleting the e-mail\r\n");
				return;
			}
			
			if( i == (-1) ) {
				/* User want's the mail to be left on server without reading it	*/
				/* So goto next one												*/
				
				pop3c_changestate(POP3C_STAT_GET);
				return;
			}
			
			if( i >= 0 ) {
				/* User wants to read and delete the mail normally	*/
				
				pop3c_sendretr(pop3_client.curmsgindex);
				pop3c_changestate(POP3C_RETR_SENT);
				DEBUGOUT("POP3C reading the e-mail\r\n");
				return;	
			
			}
			
			return;		
		}
		
		/* The mail is somehow corrupted, just delete it	*/
		
		pop3c_senddele(pop3_client.curmsgindex);
		pop3c_changestate(POP3C_DELE_SENT);
		DEBUGOUT("POP3C deleting CORRUPTED e-mail\r\n");
		return;
		
	
	}
	
	
	if(pop3_client.state == POP3C_MESSAGE_RECEIVED) {
		/* Delete the readed message	*/
		
		pop3c_senddele(pop3_client.curmsgindex);
		pop3c_changestate(POP3C_DELE_SENT);
		DEBUGOUT("POP3C deleting readed e-mail\r\n");
		return;
	}
	
	if(pop3_client.state == POP3C_DELE_ACKED) {
		/* Goto next one	*/
		pop3c_changestate(POP3C_STAT_GET);
		return;
	}
	
	if(pop3_client.state == POP3C_QUIT_ACKED) {	
	
		/* Try to close TCP	*/
		
		if(tcp_close(pop3_client.sochandle) >= 0) {
			pop3c_changestate(POP3C_CLOSED);
			pop3c_allok();
			DEBUGOUT("POP3C connection closed OK\r\n");
			return;
		}
		
		/* Close is not accepted by TCP. See if timeout	*/
		
		if(check_timer(pop3_client.tmrhandle) == 0) {
			/* Use brute force		*/
			
			tcp_abort(pop3_client.sochandle);
			pop3c_changestate(POP3C_CLOSED);
			pop3c_allok();
			DEBUGOUT("POP3C connection closed by ABORT\r\n");
			return;
		}
		
		/* Keep trying untill timeout	*/
		
		return;	
		
	}
	
	return;
	
}




void pop3c_senduser (void)
{
	INT8 i;
	UINT8* buf;

	/* Fill TCP Tx buffer with "USER " and use callback function	*/
	/* pop3c_getusername in order to get the username				*/
	/* that combined "USER username" to POP3 server					*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'U';
	*buf++ = 'S';
	*buf++ = 'E';
	*buf++ = 'R';
	*buf++ = ' '; 	
	
	i = pop3c_getusername(buf);
	
	if(i < 0)
		return;
		
	buf += i;	
	
	/* Insert >CRLF	*/
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}



void pop3c_sendpassword (void)
{
	INT8 i;
	UINT8* buf;

	/* Fill TCP Tx buffer with "PASS " and use callback function	*/
	/* pop3c_getpassword in order to get the password				*/
	/* that combined "PASS password" to POP3 server					*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'P';
	*buf++ = 'A';
	*buf++ = 'S';
	*buf++ = 'S';
	*buf++ = ' '; 	
	
	i = pop3c_getpassword(buf);
	
	if(i < 0)
		return;
		
	buf += i;	
	
	/* Insert >CRLF	*/
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}



void pop3c_sendstat (void)
{
	UINT8* buf;

	/* Fill TCP Tx buffer with "STAT\r\n" and send it to POP3 server	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'S';
	*buf++ = 'T';
	*buf++ = 'A';
	*buf++ = 'T';
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 6);

}

void pop3c_sendlist (UINT16 msgnbr)
{
	UINT8* buf;
	INT16 i;

	/* Ask LIST of given message number in order to get the total len of it	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'L';
	*buf++ = 'I';
	*buf++ = 'S';
	*buf++ = 'T';
	*buf++ = ' ';
	
	ltoa( (UINT32)msgnbr, buf);
	
	i = strlen(buf,40);
	
	if(i<0)
		return;
	
	buf += i;	
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}


void pop3c_sendtop (UINT16 msgnbr)
{
	UINT8* buf;
	INT16 i;

	/* Ask TOP msgnbr 0 in order to get the header of msg	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'T';
	*buf++ = 'O';
	*buf++ = 'P';
	*buf++ = ' ';
	
	ltoa( (UINT32)msgnbr, buf);
	
	i = strlen(buf,40);
	
	if(i<0)
		return;
	
	buf += i;	
	
	*buf++ = ' ';
	*buf++ = '0';
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 8);

}

void pop3c_sendretr (UINT16 msgnbr)
{
	UINT8* buf;
	INT16 i;

	/* Ask RETR of given message number in order to get the message	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'R';
	*buf++ = 'E';
	*buf++ = 'T';
	*buf++ = 'R';
	*buf++ = ' ';
	
	ltoa( (UINT32)msgnbr, buf);
	
	i = strlen(buf,40);
	
	if(i<0)
		return;
	
	buf += i;	
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}


void pop3c_senddele (UINT16 msgnbr)
{
	UINT8* buf;
	INT16 i;

	/* Ask DELE of given message number in order to delete it	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'D';
	*buf++ = 'E';
	*buf++ = 'L';
	*buf++ = 'E';
	*buf++ = ' ';
	
	ltoa( (UINT32)msgnbr, buf);
	
	i = strlen(buf,40);
	
	if(i<0)
		return;
	
	buf += i;	
	
	*buf++ = '\r';
	*buf = '\n';
		

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, i + 7);

}



void pop3c_sendquit (void)
{
	UINT8* buf;

	/* Fill TCP Tx buffer with "QUIT\r\n" and send it to POP3 server	*/
	
	buf = &net_buf[TCP_APP_OFFSET];
	
	*buf++ = 'Q';
	*buf++ = 'U';
	*buf++ = 'I';
	*buf++ = 'T';
	*buf++ = '\r';
	*buf = '\n';

	tcp_send(pop3_client.sochandle, &net_buf[TCP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - TCP_APP_OFFSET, 6);

}


INT16 pop3c_parsestat (void)
{
	/* Parse total number of messages	*/
	
	UINT8 i;
	UINT8 ch;
	
	if( RECEIVE_NETWORK_B() != '+')
		return(-1);
	if( tolower(RECEIVE_NETWORK_B()) != 'o')
		return(-1);	
	if( tolower(RECEIVE_NETWORK_B()) != 'k')
		return(-1);	
	if( RECEIVE_NETWORK_B() != ' ')
		return(-1);		

	pop3_client.msgtotal = 0;

	for(i=0; i<5; i++) {
		ch = RECEIVE_NETWORK_B();
		
		if(ch == ' ')
			return(1);
		
		if(	isnumeric(ch) == 0)
			return(-1);
		
		ch = asciitohex(ch);
		
		pop3_client.msgtotal *= 10;
		pop3_client.msgtotal += ch;	
				
	}
	
	/* If we get there the number of messages is too big	*/
	
	return(-1);
	

}

INT16 pop3c_parselist (void)
{
	/* Parse total length of current message	*/

	UINT8 i;
	UINT8 ch;

	if( RECEIVE_NETWORK_B() != '+')
		return(-1);
	if( tolower(RECEIVE_NETWORK_B()) != 'o')
		return(-1);	
	if( tolower(RECEIVE_NETWORK_B()) != 'k')
		return(-1);	
	if( RECEIVE_NETWORK_B() != ' ')
		return(-1);
	
	/* Receive untill next space	*/
	
	for(i=0; i<5; i++) {
		ch = RECEIVE_NETWORK_B();
		
		if( ch == ' ')
			break;
	}	

	/* Space not found?	*/

	if( ch != ' ')
		return(-1);
	
	pop3_client.curmsgtotlen = 0;
		
	for(i=0; i<9; i++) {
		ch = RECEIVE_NETWORK_B();	
		
		if(ch == '\r')
			return(1);
		if(ch == '\n')
			return(1);	
		
		if(	isnumeric(ch) == 0)
			return(-1);
		
		ch = asciitohex(ch);
		
		pop3_client.curmsgtotlen *= 10;
		pop3_client.curmsgtotlen += ch;		
		
	}	
	
	/* If all OK we are NOT here	*/
	
	return(-1);

}





void pop3c_changestate (UINT8 nstate)
{
	
	init_timer(pop3_client.tmrhandle, POP3C_TOUT*TIMERTIC);
	pop3_client.state = nstate;

}

