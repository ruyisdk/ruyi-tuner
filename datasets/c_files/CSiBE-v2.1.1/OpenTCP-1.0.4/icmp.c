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

/** \file icmp.c
 *	\brief OpenTCP ICMP implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 8.7.2002
 *	\bug
 *	\warning
 *	\todo 
 *		\li Add more functionality, not just ICMP Echo request/reply
 *			(possibly Destination unreachable processing)
 *		\li IP address setting option should be runtime or #define 
 *		configurable
 *
 *	OpenTCP ICMP implementation. Functions and other
 *	ICMP-related stuff is declared in inet/tcp_ip.h.
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/ethernet.h>
#include <inet/ip.h>
#include <inet/tcp_ip.h>
#include <inet/system.h>

/** \brief Process recieved ICMP datagram
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 08.07.2002
 *	\param frame - pointer to received IP frame structure
 *	\param len - length of the received IP datagram (in bytes)
 *	\return 
 *		\li -1 - packet not OK (not proper ICMP or not ICMP at all)
 *		\li >=0 - packet OK
 *
 *	Invoke process_icmp_in whenever IP datagram containing ICMP message
 *	is detected (see main_demo.c for example main loop implementing this).
 *	
 *	This function simply checks correctnes of received ICMP message and
 *	send ICMP replies when requested.
 *
 */
INT16 process_icmp_in (struct ip_frame* frame, UINT16 len) 
{
	UINT8 type;
	UINT8 code;
	UINT16 checksum;
	UINT16 i;
	UINT16 j;
	UINT8 tbuf[16];
		
	/* Is this ICMP?	*/
	
	ICMP_DEBUGOUT("Processing ICMP...\n\r");
	
	if( frame->protocol != IP_ICMP ) {
		ICMP_DEBUGOUT("ERROR: The protocol is not ICMP\n\r");
		return(-1);
	}
	
	/* Calculate checksum for received packet	*/

	checksum = 0;
	i = len;
	
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
	
	while(i>15){
		
		RECEIVE_NETWORK_BUF(tbuf, 16);	
		
		checksum = ip_checksum_buf(checksum, tbuf,16);
		
		i -= 16;	
	}

	for(j=0; j < i; j++)
		checksum = ip_checksum(checksum, RECEIVE_NETWORK_B(), (UINT8)j);
	
	checksum = ~ checksum;
	
	if(checksum != IP_GOOD_CS) {
		ICMP_DEBUGOUT("ERROR: ICMP Checksum failed!\n\r");
		return (-1);
	}
	
	ICMP_DEBUGOUT("ICMP Checksum OK\n\r");
	
	/* Start processing the message	*/
	
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
	
	type = RECEIVE_NETWORK_B();
	code = RECEIVE_NETWORK_B();
	
	/* We have already checked the CS, skip it	*/
	
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();

	switch(type) {
		case ICMP_ECHO_REQUEST:
		
			if(code != 0) {
				ICMP_DEBUGOUT("ERROR:Misformed ICMP ECHO Request\n\r");
				return(-1);
			}
			
			ICMP_DEBUGOUT("ICMP ECHO Request received\n\r");
			
			/* Is it a packet for setting temporary IP?	*/
			
			if(len == (ICMP_ECHOREQ_HLEN + ICMP_TEMPIPSET_DATALEN) )
			{
				/* Yep, set temporary IP address	*/
				
				ICMP_DEBUGOUT("PING with 102 bytes of data, getting temp. IP\r\n");			
				localmachine.localip = frame->dip;
				localmachine.defgw = frame->sip;
				localmachine.netmask = 0;
			}
			
			
			/* Same IP?		*/
			
			if(localmachine.localip != frame->dip)
				return(-1);

			/* Reply it	*/
			
			TXBUF[0] = ICMP_ECHO_REPLY;
			TXBUF[1] = 0;
			TXBUF[2] = 0;
			TXBUF[3] = 0;
			
			/* Copy with truncate if needed	*/
			
			if(len > NETWORK_TX_BUFFER_SIZE)
				len = NETWORK_TX_BUFFER_SIZE;
			
			RECEIVE_NETWORK_BUF(&TXBUF[4], len);
			
			/* Calculate Checksum for packet to be sent	*/
			
			checksum = 0;
			
			checksum = ip_checksum_buf(checksum, &TXBUF[0], len);
	
			checksum = ~ checksum;
			
			/* Put the checksum on place	*/
			
			TXBUF[2] = (UINT8)(checksum>>8);
			TXBUF[3] = (UINT8)checksum;
			
			/* Send it						*/
			
			process_ip_out(frame->sip, IP_ICMP, 0, 100, &TXBUF[0], len);
			
			ICMP_DEBUGOUT("ICMP Reply sent\n\r");
			
			return(0);
			
		
		break;
		
		case ICMP_ECHO_REPLY:
		
		break;
	
		default:				/* Unrecognized ICMP message	*/
			
			ICMP_DEBUGOUT("Unregognized ICMP message\n\r");
			return(-1); 
	}
	
}





