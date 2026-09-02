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

/** \file tftps.c
 *	\brief OpenTCP TFTP server implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 7.10.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Offer callback functions for TFTP server
 *  
 *	OpenTCP implementation of TFTP server application. For interface
 *	functions declarations see /inet/tftp/tftps.h.
 */


#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/globalvariables.h>
#include <inet/system.h>
#include <inet/timers.h>
#include <inet/tcp_ip.h>
#include <inet/tftp/tftps.h>

UINT8 tftpsapp_init = 0; /**< Defines whether tftps_init has already been invoked or not */


/* TFTPS states			*/

#define TFTPS_STATE_ENABLED		1
#define TFTPS_STATE_CONNECTED	2



/* TFTP Error codes		*/

#define	TFTPS_NOTDEFINED			0	/* Not Definet Error 		*/
#define	TFTPS_ACCESSVIOLATION	2	/* Access Violation	Error	*/
#define	TFTPS_ILLEGALOPERATION	4	/* Not supported Opcode		*/


/* TFTP Opcodes		*/

#define	TFTPS_OPCODE_WRQ			2	/* Packet is Write Request	*/
#define	TFTPS_OPCODE_DATA		3	/* Data Packet				*/
#define TFTPS_OPCODE_ACK			4	/* ACK Packet				*/
#define TFTPS_OPCODE_ERROR		5	/* Error Packet				*/

/** 
 * 	\brief TFTP server state information
 *
 *	tftps variable holds various information that the tftp server
 *  needs for proper operation. These include server state, socket handle,
 *	timer handle, remote IP address and port number of the host we're
 *	communicating with, retransmit counter and TFTP block number.
 */
struct
{
	UINT8 	state;
	INT8	sochandle;	
	UINT16	tmrhandle;
	UINT32 	remip;
	UINT16 	remport;
	UINT16	blocknumber;
	UINT32 	bytecount;
	UINT8 	retries;

} tftps;



/** \brief Initializes TFTP server
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.07.2002
 *	\return 
 *		\li -1 - Error
 *		\li >=0 - OK, server intialized
 *
 *	This function should be called before the TFTP Server application
 *	is used to set the operating parameters of it
 */
INT8 tftps_init (void){
	/* Already initialized?	*/
	
	if(tftpsapp_init)
		return(1);
	
	/* Get socket handle		*/
	
	tftps.sochandle = udp_getsocket(0, tftps_eventlistener, UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS);
	
	if(tftps.sochandle < 0)
		return(-1);
	
	/* Put it to listening mode	*/
		
	if( udp_open(tftps.sochandle, TFTPS_SERVERPORT) < 0 )
		return(-1);
	
	/* Get timer handle			*/
	
	tftps.tmrhandle = get_timer();
	
	tftps.state = TFTPS_STATE_ENABLED;
	tftps.remip = 0;
	tftps.remport = 0;
	tftps.retries = 0;
	tftps.blocknumber = 0;
	tftps.bytecount = 0;
	tftpsapp_init = 1;
	
	return(1);		
	
}

/********************************************************************************
Function:		tftps_run

Parameters:		void
				
Return val:		void
				
Date:			7.10.2002

Desc:			The main thread of TFTP server that should be called periodically
*********************************************************************************/

void tftps_run (void)
{
	if(tftpsapp_init == 0)
		return;
	
	/* Check for timeouts	*/
	
	if(tftps.state == TFTPS_STATE_CONNECTED) {
		if(check_timer(tftps.tmrhandle) == 0)
			tftps_deletesocket();	
	}
		
}

INT32 tftps_eventlistener (INT8 cbhandle, UINT8 event, UINT32 remip, UINT16 remport, UINT16 bufindex, UINT16 dlen)
{
	UINT16 opcode;
	UINT16 i;
	UINT8 ch;
	UINT16 u16temp;
	UINT8 fname[TFTPS_FILENAME_MAXLEN];

	if(tftpsapp_init == 0)
		return(-1);
		
	if(cbhandle != tftps.sochandle)
		return(-1);	
		
	/* If we are on other state than enabled, check that we are talking with the same gyu	*/
	
	if(	tftps.state != TFTPS_STATE_ENABLED)	{
		if(remip != tftps.remip)
			return(-1);
		if(remport != tftps.remport)
			return(-1);	
	}
	
	if(dlen < 2)
		return(-1);
		
	/* Bind socket	*/
			
	tftps.remip = remip;
	tftps.remport = remport;	
	
	/* Get information	*/
	
	NETWORK_RECEIVE_INITIALIZE(bufindex);
	
	opcode = RECEIVE_NETWORK_B();
	opcode <<= 8;
	opcode |= RECEIVE_NETWORK_B();
	
	dlen -= 2;
	
	/* Process it	*/
	
	switch(opcode) {
		case TFTPS_OPCODE_WRQ:							/* Write request?	*/
		
			/* Get filename	*/ 
			
			fname[0] = '\0';
			
			for(i=0; i<dlen; i++) {
				if(i >= TFTPS_FILENAME_MAXLEN) {
					tftps_senderror(TFTPS_NOTDEFINED);
					tftps_deletesocket();
					return(1);
				}
				
				ch = RECEIVE_NETWORK_B();
				
				fname[i] = ch;
				
				if(ch == '\0') {
					i++;
					break;
				}
			}
			
			dlen -= i;
			/* !!!!!!!!!!!!!!!!!!!!!!!!	*/
			/* Check here the filename	*/
			/* if NOT OK, RETURN 		*/
			/* !!!!!!!!!!!!!!!!!!!!!!!! */
			
			/* Check mode, only octet mode is supported	*/
			
			if(dlen < 6) {
				tftps_senderror(TFTPS_NOTDEFINED);
				tftps_deletesocket();			
				return(1);
			}
			
			if( (RECEIVE_NETWORK_B() != 'o') || (RECEIVE_NETWORK_B() != 'c') || (RECEIVE_NETWORK_B() != 't') ||
				(RECEIVE_NETWORK_B() != 'e') || (RECEIVE_NETWORK_B() != 't') || (RECEIVE_NETWORK_B() != '\0')	) {
				tftps_senderror(TFTPS_NOTDEFINED);
				tftps_deletesocket();
				return(1);
			}
			
			/* All OK, send ACK	*/
			
			tftps.state = TFTPS_STATE_CONNECTED;
			tftps.blocknumber = 0;
			tftps.bytecount = 0;
			tftps.retries = TFTPS_DEF_RETRIES;
			init_timer(tftps.tmrhandle, TFTPS_TIMEOUT*TIMERTIC);
					
			tftps_sendack();
					
			tftps.blocknumber++;
					
			return(1);			
			
		
		case TFTPS_OPCODE_DATA:											/* Data Packet ? */
		
			if(tftps.state != TFTPS_STATE_CONNECTED) {
				tftps_senderror(TFTPS_NOTDEFINED);
				tftps_deletesocket();
				return(1);
			}		
			
			if(dlen < 2) {
				tftps_senderror(TFTPS_NOTDEFINED);
				tftps_deletesocket();			
				return(1);
			}				
	
			/* Get block number	*/
			
			u16temp = RECEIVE_NETWORK_B();
			u16temp <<= 8;
			u16temp |= RECEIVE_NETWORK_B();
	
			dlen -= 2;	
			
			if( (u16temp < tftps.blocknumber) && (tftps.blocknumber > 0) ) {
				/* Duplicate msg, send ACK again	*/
			
				if( tftps.retries > 0 ) {
					tftps.retries--;
					tftps.blocknumber--;
					tftps_sendack();
					tftps.blocknumber++;
				} else {
					tftps_senderror(TFTPS_NOTDEFINED);
					tftps_deletesocket();
				}
		
				return(1);		
			}
		
			if( u16temp != tftps.blocknumber ) {
				/* Something really wrong */
		
				tftps_senderror(TFTPS_NOTDEFINED);
				tftps_deletesocket();
				return(1);
			}					
			
			/* !!!!!!!!!!!!!!!!!!!!!!!!	*/
			/* Read the data here		*/
			/* !!!!!!!!!!!!!!!!!!!!!!!!	*/
			
			if( dlen < 512 ) {
				/* Other side Wants to close */
			
				tftps_sendack();
				tftps_deletesocket();
				return(1);
			}			
			
			/* All OK	*/
			
			tftps.retries = TFTPS_DEF_RETRIES;
			init_timer(tftps.tmrhandle, TFTPS_TIMEOUT*TIMERTIC);
			tftps_sendack();
			tftps.blocknumber++;			
	
			return(1);
			
		case TFTPS_OPCODE_ERROR:
		
			tftps_deletesocket();
	
			return(1);
	
		default:
		
			/* Unsupported Opcode, Send error */
		
			tftps_senderror(TFTPS_ILLEGALOPERATION);
			tftps_deletesocket();			
	
			return(1);
	}	
		
}


void tftps_sendack (void)
{
	/* Send a TFTP ACK packet */
	
	net_buf[UDP_APP_OFFSET + 0] = 0;		/* Opcode	*/
	net_buf[UDP_APP_OFFSET + 1] = 4;
	net_buf[UDP_APP_OFFSET + 2] = (UINT8)(tftps.blocknumber >> 8);
	net_buf[UDP_APP_OFFSET + 3] = (UINT8)tftps.blocknumber;
	
	udp_send(tftps.sochandle, tftps.remip, tftps.remport, &net_buf[UDP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - UDP_APP_OFFSET, 4);
	

}




void tftps_senderror (UINT8 errno )
{
	/* Send TFTP Error -packet */
	
	net_buf[UDP_APP_OFFSET + 0] = 0;		/* Opcode	*/
	net_buf[UDP_APP_OFFSET + 1] = 5;
	net_buf[UDP_APP_OFFSET + 2] = (UINT8)(tftps.blocknumber >> 8);
	net_buf[UDP_APP_OFFSET + 3] = (UINT8)tftps.blocknumber;
	net_buf[UDP_APP_OFFSET + 4] = errno;
	net_buf[UDP_APP_OFFSET + 5] = '\0';
	net_buf[UDP_APP_OFFSET + 6] = 0;
	
	udp_send(tftps.sochandle, tftps.remip, tftps.remport, &net_buf[UDP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - UDP_APP_OFFSET, 7);	
	
}

void tftps_deletesocket (void)
{
	/* Clear Socket Data */

	tftps.blocknumber = 0;
	tftps.state = TFTPS_STATE_ENABLED;
	tftps.retries = 0;
	tftps.remip = 0;
	tftps.remport = 0;	


}



