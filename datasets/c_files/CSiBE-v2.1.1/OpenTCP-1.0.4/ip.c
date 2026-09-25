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

/** \file ip.c
 *	\brief OpenTCP IP protocol implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 11.6.2002
 *	\bug
 *	\warning
 *	\todo 
 *		\li Implement stub handler for supporting fragmented datagrams (
 *		may be usefull on MCUs with lots of available RAM)
 *  
 *	OpenTCP IP protocol implementation functions. For declaration,
 *	constants and data structures refer to inet/ip.h.
 */
#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/ethernet.h>
#include <inet/arp.h>
#include <inet/ip.h>
#include <inet/system.h>


/**	\brief Used for storing various information about the incoming IP packet
 *	
 *	Various fields from the IP packet are stored in this structure. These
 *	values are later used from other upper layer protocols (ICMP, UDP, TCP
 *	and possibly others) to extract needed information about the received
 *	packet. See ip_frame definition for struct information.
 */
struct ip_frame received_ip_packet;

/**	\brief Used for storing various information about the outgoing IP packet
 *	
 *	Various fields from the IP packet are stored in this structure. These
 *	values are filled based on the information supplied by the upper 
 * 	layer protocols (ICMP, UDP, TCP and possibly others) and used to form
 *	a correct IP packet (correct filed values, checksum,..). See ip_frame
 *	definition for struct information.
 */
struct ip_frame send_ip_packet;

UINT16 ip_id;	/**< ID field in the next IP packet that will be sent */

/** \brief Process received IP frame
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti
 *	\date 11.06.2002
 *	\param frame pointer to ethernet_frame structure holding information
 *		about the received frame that carries IP datagram.
 *	\return
 *		\li -1 - IP packet not OK
 *		\li >0 - Length of next layer data (IP packet OK)
 *
 *	Process received IP packet by checking necessary header information
 *	and storing it accordingly to received_ip_packet variable. If everything
 *	checks out, return length of the data carried in the IP datagram (for
 *	higher-level protocols), otherwise return -1.
 */
INT16 process_ip_in (struct ethernet_frame* frame)
{

	UINT8 olen;
	UINT8 i;
	
	/* Check for Protocol								*/
	
	IP_DEBUGOUT("Checking if IP Protocol\n\r");
	
	if( frame->protocol != PROTOCOL_IP )
		return(-1);
	
	
	IP_DEBUGOUT("It's IP\n\r");
	
	if( frame->frame_size < ETH_HEADER_LEN )
		return(-1);
		
	if( (frame->frame_size - ETH_HEADER_LEN) < IP_HLEN )
		return(-1); 
				
	/* Get IP Header Information						*/
		
	NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
		
	received_ip_packet.vihl = RECEIVE_NETWORK_B();
		
	/* Is it IPv4?	*/
		
	if( (received_ip_packet.vihl & 0xF0) != 0x40 ) {
		IP_DEBUGOUT("ERROR: IP is not version 4!\n\r");
		return(-1);
	}
		
	IP_DEBUGOUT("IP Version 4 OK!\n\r");	
		
	received_ip_packet.tos = RECEIVE_NETWORK_B();						
	
	received_ip_packet.tlen = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_ip_packet.tlen |= RECEIVE_NETWORK_B();
		
	received_ip_packet.id = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_ip_packet.id |= RECEIVE_NETWORK_B();
		
	received_ip_packet.frags = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_ip_packet.frags |= RECEIVE_NETWORK_B();
		
	received_ip_packet.ttl= RECEIVE_NETWORK_B();
		
	received_ip_packet.protocol= RECEIVE_NETWORK_B();
		
	received_ip_packet.checksum = ((UINT16)RECEIVE_NETWORK_B()) << 8;
	received_ip_packet.checksum |= RECEIVE_NETWORK_B();
		
	received_ip_packet.sip = (((UINT32)RECEIVE_NETWORK_B()) << 24);
	received_ip_packet.sip |= (((UINT32)RECEIVE_NETWORK_B()) << 16);
	received_ip_packet.sip |= (((UINT32)RECEIVE_NETWORK_B()) << 8);
	received_ip_packet.sip |= RECEIVE_NETWORK_B();
		
	received_ip_packet.dip = (((UINT32)RECEIVE_NETWORK_B()) << 24);
	received_ip_packet.dip |= (((UINT32)RECEIVE_NETWORK_B()) << 16);
	received_ip_packet.dip |= (((UINT32)RECEIVE_NETWORK_B()) << 8);
	received_ip_packet.dip |= RECEIVE_NETWORK_B();

	/* Is that packet for us?			*/


	if((received_ip_packet.dip != localmachine.localip )&&
		(received_ip_packet.dip != IP_BROADCAST_ADDRESS)) {

		/* It's not for us. Check still if ICMP with rigth physical	*/
		/* address that migth be used to set temporary IP			*/
		
		IP_DEBUGOUT("IP address does not match!\n\r");
		
		if( received_ip_packet.protocol != IP_ICMP) 
			return(-1);
			
		/* Check physical address			*/
		
		for(i=0; i<PHY_ADR_LEN; i++)
		{
			if(frame->destination[i] != localmachine.localHW[i])
				return(-1);
		}	

	}
	
	
	/* Is there options to copy?		*/
		
	olen = ((received_ip_packet.vihl & 0x0F) << 2) - IP_MIN_HLEN;
	
	/* Somebody bluffing with too long option field?	*/
	
	if(olen > MAX_IP_OPTLEN) {
		IP_DEBUGOUT("ERROR:Size of maximum allowed IP option lengt exceeded!\n\r");
		return(-1);
	}
	
	if( olen > (frame->frame_size - ETH_HEADER_LEN - IP_HLEN) )	{
		IP_DEBUGOUT("ERROR:IP option field too long!\n\r");
		return(-1);
	}
		
	for( i=0; i < olen; i++ ) {
		received_ip_packet.opt[i] = RECEIVE_NETWORK_B();	
		IP_DEBUGOUT("IP Options..\n\r");
	}
	
	if(received_ip_packet.tlen >  (frame->frame_size - ETH_HEADER_LEN) ) {
		IP_DEBUGOUT("ERROR: Total len too long\r\n");
		return(-1);
	}
	
	/* Is the checksum OK?	*/
	
	IP_DEBUGOUT("Validating the IP checksum..\n\r");
	
	if ( ip_check_cs(&received_ip_packet) != TRUE )	{
		IP_DEBUGOUT("IP Checksum Corrupted..\n\r");
		return(-1);
	}	
	
	IP_DEBUGOUT("..Checksum OK!\n\r");	
	
	/* Add the address to ARP cache	*/
	
	if( received_ip_packet.sip != IP_BROADCAST_ADDRESS)
		arp_add( received_ip_packet.sip, &frame->source[0], ARP_TEMP_IP);
	
	/* Calculate the start of next layer data	*/
	
	received_ip_packet.buf_index = frame->buf_index + IP_HLEN + olen;
	
	/* Is this packet fragmented?						*/
	/* We don't deal with those							*/
	/* TODO: Implement Stub handler for more mem. uP's	*/
	
	if( received_ip_packet.frags & (IP_MOREFRAGS | IP_FRAGOFF) ) {
		IP_DEBUGOUT("Fragmented IP packet\r\n");
		return(-1);
	}
	/* checking moved upwards!
	if( received_ip_packet.frags & IP_FRAGOFF )	{
		IP_DEBUGOUT("Fragmented IP packet\r\n");
		return(-1);
	}
	*/
	
	IP_DEBUGOUT("Leaving IP succesfully..\n\r");
	
	return(received_ip_packet.tlen - IP_HLEN - olen);
	
}

/** \brief Try to send out IP frame
 * 	\author 
 *		\li Jari Lahti
 *	\date 11.06.2002
 *	\param ipadr remote IP address
 *	\param pcol protocol over IP used. Can be one of the
 *		following:
 *		\li #IP_ICMP
 *		\li #IP_UDP
 *		\li #IP_TCP
 *	\param tos type of service required
 *	\param ttl time to live header field of IP packet
 *	\param dat pointer to data buffer
 *	\param len length of data to be sent in IP datagram
 *	\return
 *		\li -1 - general error
 *		\li -2 - ARP cache not ready
 *		\li >0 - number of data bytes sent (packet OK)
 *
 *	Invoke this function to perform all of the necessary preparation in
 *	order to send out an IP packet. These include:
 *		\li Consulting ARP cache for HW address to send the packet to
 *		\li Filling send_ip_packet variable with correct values
 *		\li Calculating checksum for the IP packet
 *		\li Adding datalink header information
 *		\li	Sending IP header and data
 *		\li Instructing NIC to send the data
 */
INT16 process_ip_out (UINT32 ipadr, UINT8 pcol, UINT8 tos, UINT8 ttl, UINT8* dat, UINT16 len)
{
	struct arp_entry *qstruct;
	UINT16 i;
	
	/* Try to get MAC address from ARP cache	*/
	
	qstruct = arp_find(ipadr, &localmachine, ARP_TEMP_IP);
	
	if( qstruct == 0 )		/* Not ready yet	*/
		return(-2);
		
	/* Select network buffer						*/
	/* TODO: This network related stuff should 		*/
	/* be moved and abstracted to Ethernet layer	*/
	
	switch(pcol) {
		case IP_ICMP:
		
			NETWORK_SEND_INITIALIZE(ICMP_BUF);
			IP_DEBUGOUT("Assembling IP packet to ICMP buffer\n\r");
			
			break;
			
		case IP_UDP:
		
			NETWORK_SEND_INITIALIZE(UDP_BUF);
			IP_DEBUGOUT("Assembling IP packet to UDP buffer\n\r");
			
			break;
			
		case IP_TCP:
		
			NETWORK_SEND_INITIALIZE(TCP_BUF);
			IP_DEBUGOUT("Assembling IP packet to TCP buffer\n\r");
			
			break;
	
		default:			/* Unknown protocol	*/
			return(-1);
	}
	
	/* Fill the Ethernet information	*/
	
	for( i=0; i<MAXHWALEN; i++)	{
		send_frame.destination[i] = qstruct->hwadr[i];
		send_frame.source[i] = localmachine.localHW[i];
	}
	
	send_frame.protocol = PROTOCOL_IP;
	
	NETWORK_ADD_DATALINK(&send_frame);
	
	/* Construct the IP header	*/
	
	send_ip_packet.vihl = IP_DEF_VIHL;
	send_ip_packet.tos = tos;
	send_ip_packet.tlen = IP_HLEN + len;
	send_ip_packet.id = ip_id++;
	send_ip_packet.frags = 0;
	send_ip_packet.ttl = ttl;
	send_ip_packet.protocol = pcol;
	send_ip_packet.checksum = 0;
	send_ip_packet.sip = localmachine.localip;
	send_ip_packet.dip = ipadr;
	
	/* Calculate checksum for the IP header	*/
	
	send_ip_packet.checksum = ip_construct_cs( &send_ip_packet );
	
	/* Assemble bytes to network	*/
	
	SEND_NETWORK_B(send_ip_packet.vihl);
	SEND_NETWORK_B(send_ip_packet.tos);
	SEND_NETWORK_B( (UINT8)(send_ip_packet.tlen >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.tlen );		
	SEND_NETWORK_B( (UINT8)(send_ip_packet.id >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.id );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.frags >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.frags );
	SEND_NETWORK_B(send_ip_packet.ttl);
	SEND_NETWORK_B(send_ip_packet.protocol);	
	SEND_NETWORK_B( (UINT8)(send_ip_packet.checksum >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.checksum );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.sip >> 24) );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.sip >> 16) );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.sip >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.sip );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.dip >> 24) );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.dip >> 16) );
	SEND_NETWORK_B( (UINT8)(send_ip_packet.dip >> 8) );
	SEND_NETWORK_B( (UINT8)send_ip_packet.dip );
	
	/* Assemble data	*/
	
	SEND_NETWORK_BUF(dat,len);
		
	/* Launch it		*/
	
	NETWORK_COMPLETE_SEND( send_ip_packet.tlen );
	
	return(len);
	
	
}

/** \brief Construct checksum of the IP header
 * 	\author 
 *		\li Jari Lahti
 *	\date 08.07.2002
 *	\param frame pointer to ip_frame structure holding header information
 *		based on which checksum is calculated
 *	\return Calculated checksum
 *
 *	Checksum of the supplied IP datagram is calculated.
 *
 */
UINT32 ip_construct_cs (struct ip_frame* frame)
{
	UINT16 ip_cs;
	UINT8 cs_cnt;
	UINT8 olen;
	UINT8 i;
	
	ip_cs = 0;
	cs_cnt = 0;
	
	ip_cs = ip_checksum(ip_cs, frame->vihl, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->tos, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->tlen >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->tlen, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->id >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->id, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->frags >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->frags, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->ttl, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->protocol, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 24), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 16), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->sip, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 24), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 16), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->dip, cs_cnt++);	
	
	/* Is there options?				*/
		
	olen = ((frame->vihl & 0x0F) << 2) - IP_MIN_HLEN;
	
	for( i=0; i<olen; i++)
		ip_cs = ip_checksum(ip_cs, (UINT8)frame->opt[i], cs_cnt++);
	
	/* Take complement	*/
	
	ip_cs = ~ ip_cs;

	return(ip_cs);

}

/** \brief Check IP frame's checksum
 * 	\author 
 *		\li Jari Lahti
 *	\date 11.06.2002
 *	\param frame pointer to IP frame to be checked
 *	\return
 *		\li 0 - checksum corrupted
 *		\li 1 - checksum OK
 *
 *	Checksum of an IP packet is calculated and compared with the received
 *	checksum. Error is signaled if there is discrepancy between them.
 *
 */
UINT8 ip_check_cs (struct ip_frame* frame)
{
	UINT16 ip_cs;
	UINT8 cs_cnt;
	UINT8 olen;
	UINT8 i;
	
	ip_cs = 0;
	cs_cnt = 0;
	
	ip_cs = ip_checksum(ip_cs, frame->vihl, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->tos, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->tlen >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->tlen, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->id >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->id, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->frags >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->frags, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->ttl, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, frame->protocol, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->checksum >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->checksum, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 24), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 16), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->sip >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->sip, cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 24), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 16), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)(frame->dip >> 8), cs_cnt++);
	ip_cs = ip_checksum(ip_cs, (UINT8)frame->dip, cs_cnt++);	
	
	/* Is there options?				*/
		
	olen = ((frame->vihl & 0x0F) << 2) - IP_MIN_HLEN;
	
	for( i=0; i<olen; i++)
		ip_cs = ip_checksum(ip_cs, (UINT8)frame->opt[i], cs_cnt++);
	
	/* Analyze the result	*/
	
	ip_cs = ~ ip_cs;
	
	if(ip_cs == IP_GOOD_CS)
		return 1;
	
	/* Fuck, it failed!	*/
	
	return 0;
	

}

/** \brief Used for constructuing IP checksum
 * 	\author 
 *		\li Jari Lahti
 *	\date 24.02.2002
 *	\param cs last checksum value
 *	\param dat byte to be added to checksum
 *	\param count byte indicating whether dat is MSB or LSB byte
 *	\return new checksum value
 *
 *	Based on count value, dat byte is added to checksum either as a MSB
 *	or a LSB byte and the new checksum value is then returned.
 *
 */
UINT16 ip_checksum (UINT16 cs, UINT8 dat, UINT8 count)
{
	UINT8 b = dat;
	UINT8 cs_l;
	UINT8 cs_h;
	
	cs_h = (UINT8)(cs >> 8); 
	cs_l = (UINT8)cs;

	if( count & 0x01 ) {
		/* We are processing LSB	*/
		
		if( (cs_l = cs_l + b) < b ) {
			if( ++cs_h == 0 )
				cs_l++;
		}
		
	} else {
		/* We are processing MSB	*/
		
		if( (cs_h = cs_h + b) < b )	{
			if( ++cs_l == 0 )
				cs_h++;
		}
	}

	return( ( (UINT16)cs_h << 8 ) + cs_l);

}


/** \brief Used for constructuing IP checksum of a data buffer
 * 	\author 
 *		\li Jari Lahti
 *	\date 03.08.2003
 *	\param cs last checksum value
 *	\param buf buffer who's checksum we're calculating
 *	\param len length of data in buffer
 *	\return new checksum value
 *
 *	Calculates checksum of the data in buffer and returns new
 *	checksum value.
 */
UINT32 ip_checksum_buf (UINT16 cs, UINT8* buf, UINT16 len)
{
	UINT16 dat;
	UINT32 temp;
	
	temp = cs;
	
	while(len>1)
	{
		len -= 2;
		dat = *buf++;
		dat <<= 8;
		dat |= *buf++;
		temp += dat;
	}
	
	temp = (temp >> 16) + (temp & 0xFFFF);	/* Add in carry		*/
	temp += (temp >>16);					/* Maybe one more	*/
	
	if(len)
		temp = ip_checksum(temp, *buf, 0);
	
	return( (UINT16) temp );

}

