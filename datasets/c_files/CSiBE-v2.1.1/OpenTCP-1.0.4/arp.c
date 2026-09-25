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

/** \file arp.c
 *	\brief OpenTCP ARP implementation
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Offer direct control over ARP (needed in future for DHCP)
 *
 *	OpenTCP ARP protocol implementation. Function declarations
 *	can be found in inet/arp.h.
 */
#include <inet/datatypes.h>
#include <inet/debug.h>
#include <inet/ethernet.h>
#include <inet/arp.h>
#include <inet/timers.h>
#include <inet/system.h>
#include <inet/globalvariables.h>

/** \brief ARP cache table holding ARP_TSIZE cache values 
 *
 *	ARP cache table is an array of arp_entry structures holding
 *	all of the necessary information about the state, timeouts and
 *	hardware/IP addresses of individual entries. By modifying the
 *	#ARP_TSIZE, cache size can be changed and thus RAM memory occupied
 *	by the ARP cache significantly reduced or increased. See arp_entry
 *	definition for more information about struct fields.
 */
struct arp_entry	arp_table[ARP_TSIZE]; 

/** \brief ARP timer handle used for measuring timeouts, doing retransmissions,..
 *	
 *	ARP module uses this timer handle to detect that a certain period of
 *	time has expired (defined by the value of #ARP_MANG_TOUT) and that
 *	cache entries should be examined to see what to do with them.
 */
UINT8 arp_timer; 

/** \brief Process and analyze the received ARP packet
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	
 *	\date 10.07.2002
 *	\param frame Pointer to ethernet_frame structure containing information
 *		about the received frame
 *	\return Return #TRUE if Ethernet frame processed held ARP packet,
 *		otherwise #FALSE.
 *
 *	Invoke process_arp function whenever ARP packet is received 
 *	(see main_demo.c for an example loop). This function will process the
 *	received packet, analyze it'c content briefly and perform on of the
 *	two possible actions:
 *		\li If the received packet is ARP request it will invoke
 *		arp_send_reply in order to send ARP reply back
 *		\li If the received packet is ARP response it will iterate through
 *		the cache table and try to find ARP entry that is beeing resolved
 *		or refreshed
 */
UINT8 process_arp (struct ethernet_frame* frame) {
	
	UINT8 temp;		
	
	/* Check if ARP packet*/
	
	if( frame->protocol == ARP_ETHCODE ) {
		/* Yep, ARP */
		
		NETWORK_RECEIVE_INITIALIZE(frame->buf_index);
		
		/* Is it long enough?	*/
		
		if( frame->frame_size < (2*MAXHWALEN + 2*MAXPRALEN + 2 + 6) ) {
			/* Somehow corrupted ARP packet	*/
			ARP_DEBUGOUT("Corrupted ARP packet\n\r");
			/*NETWORK_RECEIVE_END();*/
			return(TRUE);
		}
			 
		
		/* Ignore next 6 bytes: <HW type>, <Protocol type> */
		/* <HW address len> and <Protocol address len> 	   */
		
		for(temp=0; temp<6; temp++)
			RECEIVE_NETWORK_B();
		
		ARP_DEBUGOUT("Incoming ARP..\n\r");
		
		/* Check if request or response */
		
		if( RECEIVE_NETWORK_B() == 0x00) {
		
			temp = RECEIVE_NETWORK_B();	/* get opcode */
		
			if( temp == ARP_REQUEST ) {
				ARP_DEBUGOUT(" ARP REQUEST Received..\n\r");
				arp_send_response();
			} else if( temp == ARP_REPLY ) {
				ARP_DEBUGOUT("ARP Response Received..\n\r");
				arp_get_response();	
			}
			
		/* Wasn't request or response or all done, dump it */
		
		}
		
		/*NETWORK_RECEIVE_END();*/
		return(TRUE);
		
	}
	
	/* Wasn't ARP, don't touch the packet */
	
	return(FALSE);								
}

/** \brief Send response to an ARP request
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 10.07.2002
 *	\warning
 *		\li This function starts reading data from Ethernet controller
 *		without initializing it for reading it first, so NIC must already
 *		be initialized for reading from correct address (it expects ar$sha
 *		field from ARP packet immediately)
 *
 *	This function is invoked from process_arp() function in order to send
 *	a reply to an ARP request. First, incoming packet is checked to see
 *	if it is intended for us or not. If not, function does not do anything.
 *	Otherwise, ARP reply packet is formed and sent.
 */
void arp_send_response(void)
{
	struct arp_entry *qstruct;
	UINT8 rem_hwadr[MAXHWALEN];
	UINT32 rem_ip;
	UINT32 ltemp;
	INT8 i;
	BYTE j;

	/* Record Sender's HW address		*/
	
	for( i=MAXHWALEN-1; i >= 0; i-- )
		rem_hwadr[i] = RECEIVE_NETWORK_B();		
	
	/* Read Sender's IP Address	*/
	
	for( i=0; i<MAXPRALEN; i++) {
		rem_ip <<= 8;
		rem_ip |= RECEIVE_NETWORK_B();
	} 
	
	
	/* Skip Target HW address		*/
	
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();	
	
	/* Is The Packet For Us?	*/
	
	for( i=0; i<MAXPRALEN; i++) {
		ltemp <<= 8;
		ltemp |= RECEIVE_NETWORK_B();
	}
		
	
	if( ltemp != localmachine.localip ) 
		return;								/* No	*/

	ARP_DEBUGOUT("Preparing for ARP Reply\n\r");
	
	/* OK. Now send reply		*/
	
	NETWORK_SEND_INITIALIZE(ARP_BUFFER);
	
	/* Add datalink (Ethernet addresses) information	*/
	
	for( i=0; i<MAXHWALEN; i++)	{
		send_frame.destination[i] = rem_hwadr[i];
		send_frame.source[i] = localmachine.localHW[i];
	}
	
	send_frame.protocol = PROTOCOL_ARP;
	
	NETWORK_ADD_DATALINK(&send_frame);
	
	/* PUT ARP Data	*/
	
	SEND_NETWORK_B( (BYTE)(AR_HARDWARE>>8) );				/* Hardware Type	*/
	SEND_NETWORK_B( (BYTE)AR_HARDWARE );
	SEND_NETWORK_B(0x08);									/* Protocol Type	*/
	SEND_NETWORK_B(0x00);
	SEND_NETWORK_B(MAXHWALEN);								/* HW Adr Len		*/
	SEND_NETWORK_B(MAXPRALEN);								/* Protocol Adr. Len*/
	SEND_NETWORK_B( 0x00 );									/* ARP Opcode		*/	
	SEND_NETWORK_B( 0x02 );					
	SEND_NETWORK_B((UINT8)(localmachine.localHW[5]));		/* Address fields	*/
	SEND_NETWORK_B((UINT8)(localmachine.localHW[4]));
	SEND_NETWORK_B((UINT8)(localmachine.localHW[3]));
	SEND_NETWORK_B((UINT8)(localmachine.localHW[2]));
	SEND_NETWORK_B((UINT8)(localmachine.localHW[1]));
	SEND_NETWORK_B((UINT8)(localmachine.localHW[0]));
	SEND_NETWORK_B((UINT8)(localmachine.localip>>24));
	SEND_NETWORK_B((UINT8)(localmachine.localip>>16));
	SEND_NETWORK_B((UINT8)(localmachine.localip>>8));
	SEND_NETWORK_B((UINT8)(localmachine.localip));
	SEND_NETWORK_B((UINT8)rem_hwadr[5]);
	SEND_NETWORK_B((UINT8)rem_hwadr[4]);
	SEND_NETWORK_B((UINT8)rem_hwadr[3]);
	SEND_NETWORK_B((UINT8)rem_hwadr[2]);
	SEND_NETWORK_B((UINT8)rem_hwadr[1]);
	SEND_NETWORK_B((UINT8)rem_hwadr[0]);						
	SEND_NETWORK_B((UINT8)(rem_ip>>24));
	SEND_NETWORK_B((UINT8)(rem_ip>>16));
	SEND_NETWORK_B((UINT8)(rem_ip>>8));
	SEND_NETWORK_B((UINT8)rem_ip);
	
	NETWORK_COMPLETE_SEND(0x0040);		/* Send the packet	*/
	
	ARP_DEBUGOUT("ARP Reply Sent..\n\r");
	
	/* Add the Sender's info to cache because we can	*/
	
	arp_add(rem_ip, &send_frame.destination[0], ARP_TEMP_IP);
	
	return;
		
}


/** \brief Extract data from the received ARP packet
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 10.07.2002
 *	\warning
 *		\li This function starts reading data from Ethernet controller
 *		without initializing it for reading it first, so NIC must already
 *		be initialized for reading from correct address (it expects ar$sha
 *		field from ARP packet immediately)
 *
 *	This function is invoked from process_arp() function when ARP reply
 *	packet is detected. Basic checking is performed to see if the packet
 *	is intended for us, and if it is, ARP cache table is checked and 
 *	corresponding entry is refreshed (resolved).
 *
 */
void arp_get_response(void)
{
	struct arp_entry *qstruct;
	UINT8 rem_hwadr[MAXHWALEN];
	UINT32 	rem_ip;
	UINT32 	ltemp;
	INT8 i;
	UINT8 j;
	
	/* Read Sender's HW address	*/
	
	for( i=MAXHWALEN-1; i >= 0; i-- )
		rem_hwadr[i] = RECEIVE_NETWORK_B();
		
	/* Read Sender's IP Address	*/
	
	for( i=0; i<MAXPRALEN; i++) {
		rem_ip <<= 8;
		rem_ip |= RECEIVE_NETWORK_B();
	}
	
	
	/* Skip our HW Address	*/
	
	for(i=0; i<MAXHWALEN; i++)
		RECEIVE_NETWORK_B();
	
	
	/* Is The Packet For Us?	*/
	
	for( i=0; i<MAXPRALEN; i++)	{
		ltemp <<= 8;
		ltemp |= RECEIVE_NETWORK_B();
	}
		
	
	if( ltemp != localmachine.localip ) 
		return;								/* No	*/

	ARP_DEBUGOUT("Now entering to process ARP Reply..\n\r");
	
	/* Are we waiting for that reply?	*/
	
	for( i=1; i<ARP_TSIZE; i++ ) {
		qstruct = &arp_table[i];
		
		if( qstruct->state == ARP_FREE )
			continue;
		
		if( qstruct->state == ARP_RESERVED )
			continue;				
		
		if( rem_ip == qstruct->pradr ) {
			/* We are caching that IP, refresh it	*/
			
			ARP_DEBUGOUT("Refreshing ARP cache from Reply..\n\r");
			
			for( j=0; j<MAXHWALEN; j++ )		
				qstruct->hwadr[j] = rem_hwadr[j];
				
			qstruct->ttl = ARP_TIMEOUT;
			qstruct->retries = ARP_MAXRETRY;				/* No need for Retry	*/
			qstruct->state = ARP_RESOLVED;
		
			/* Done	*/
			
			break;
		}	
	
	}

}

/** \brief Send ARP request based on information in an ARP cache table
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 1.11.2001
 *	\param entry Index of ARP cache entry that is beeing resolved
 * 
 *	Invoked from arp_find() and arp_manage() functions, arp_send_request
 *	creates ARP request packet based on data stored in the ARP cache entry
 *	who's index is given as a parameter.
 */
void arp_send_req (UINT8 entry)
{

	struct arp_entry *qstruct;
	UINT8 i;
	
	qstruct = &arp_table[entry];
	
	NETWORK_SEND_INITIALIZE(ARP_BUFFER);
	
	/* Add datalink (Ethernet addresses) information	*/
	
	for( i=0; i<MAXHWALEN; i++) {
		send_frame.destination[i] = 0xFF;
		send_frame.source[i] = localmachine.localHW[i];
	}
	
	send_frame.protocol = PROTOCOL_ARP;
	
	NETWORK_ADD_DATALINK(&send_frame);
	
	/* PUT ARP Data	*/

	SEND_NETWORK_B( (BYTE) (AR_HARDWARE>>8) );			/* Hardware Type	*/
	SEND_NETWORK_B( (BYTE) AR_HARDWARE );
	SEND_NETWORK_B(0x08);								/* Protocol Type	*/
	SEND_NETWORK_B(0x00);
	SEND_NETWORK_B(MAXHWALEN);							/* HW Adr Len		*/
	SEND_NETWORK_B(MAXPRALEN);							/* Protocol Adr. Len*/
	SEND_NETWORK_B( (BYTE)(ARP_REQUEST>>8));			/* ARP Opcode		*/
	SEND_NETWORK_B( (BYTE) ARP_REQUEST );
	SEND_NETWORK_B((UINT8)localmachine.localHW[5]);		/* Address fields	*/
	SEND_NETWORK_B((UINT8)localmachine.localHW[4]);
	SEND_NETWORK_B((UINT8)localmachine.localHW[3]);
	SEND_NETWORK_B((UINT8)localmachine.localHW[2]);
	SEND_NETWORK_B((UINT8)localmachine.localHW[1]);
	SEND_NETWORK_B((UINT8)localmachine.localHW[0]);
	SEND_NETWORK_B((UINT8)(localmachine.localip>>24));
	SEND_NETWORK_B((UINT8)(localmachine.localip>>16));
	SEND_NETWORK_B((UINT8)(localmachine.localip>>8));
	SEND_NETWORK_B((UINT8)localmachine.localip);
	SEND_NETWORK_B((UINT8)0xFF);
	SEND_NETWORK_B((UINT8)0xFF);
	SEND_NETWORK_B((UINT8)0xFF);
	SEND_NETWORK_B((UINT8)0xFF);
	SEND_NETWORK_B((UINT8)0xFF);
	SEND_NETWORK_B((UINT8)0xFF);						
	SEND_NETWORK_B((UINT8)(qstruct->pradr>>24));
	SEND_NETWORK_B((UINT8)(qstruct->pradr>>16));
	SEND_NETWORK_B((UINT8)(qstruct->pradr>>8));
	SEND_NETWORK_B((UINT8)qstruct->pradr);
	
	
	/* Packet assembled now, just send it ... */
	
	NETWORK_COMPLETE_SEND(0x0040);						/* Min packet size	*/
 
 	ARP_DEBUGOUT("ARP Request Sent\n\r");
	
}


/** \brief Allocate ARP entry in ARP cache table
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 1.11.2001
 *	\param type Type of ARP cache entry beeing allocated. Can be one of the
 *		following:
 *		\li #ARP_FIXED_IP
 *		\li #ARP_TEMP_IP 
 *	\return >=0 - pointer to allocated ARP entry (actaully index in the 
 *		ARP cache table)
 * 
 *	Allocate arp entry for given type. Chooses the unused entry if 
 *	one exists. Otherwice deletes entries in round-robin fashion.
 */
INT8 arp_alloc (UINT8 type)
{
	struct arp_entry *qstruct;
	INT8 i;
	static BYTE aenext = 1;		/* Cache Manager	*/
	INT16 found;
	
	/* try to find free entry */
	found=-1;

	for( i=0; i<ARP_TSIZE; i++ ) {
	
		if( arp_table[i].state == ARP_FREE ) {
			found=i;
			break;
		}
	}
	
	if(found != (-1) ) {
		qstruct = &arp_table[found];
		qstruct->state = ARP_RESERVED;
		qstruct->type = type;	
		return( (UINT8)found );
	}


	/* if no success, try ro find first temporary entry	*/
	/* on round-robin fashion							*/
	

	for( i=0; i<ARP_TSIZE; i++ ) {	
		if( arp_table[aenext].type == ARP_TEMP_IP) {
			found = aenext;			
			break;
		}
			
		/* Move to next entry */
	
		aenext = (aenext + 1);
		if( aenext >= ARP_TSIZE )
			aenext = 1;
			
	}
	
	
	/* Was there free or temporary entries?	*/
	
	if( found == (-1) )
		return(-1);
		
	/* Next time start from next entry	*/
	
	aenext = (aenext + 1);	
	if( aenext >= ARP_TSIZE )
		aenext = 1;		

	qstruct = &arp_table[found];
	
	/* Set ARP initial parameters	*/
	
	qstruct->state = ARP_RESERVED;
	qstruct->type = type;
	
	/* Was return(i)!!! <-wrong!!	*/
	
	return((UINT8)found);


}
/** \brief Add given IP address and MAC address to ARP cache
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 10.07.2002
 *	\param pra - protocol address (assumed IPv4)
 *	\param hwadr - pointer to Ethernet MAC address (6 bytes)
 *	\param type - type of address allocated if not found. Can be one of the
 *		following:
 *		\li #ARP_FIXED_IP
 *		\li #ARP_TEMP_IP
 *	\return
 *		\li 0 - Address already in cache. Refreshed.
 *		\li 1 - New entry in ARP cache created
 *
 *	New IP address is added to ARP cache based on the information
 *	supplied to function as parameters.
 */
INT8 arp_add (UINT32 pra, UINT8* hwadr, UINT8 type)
{
	struct arp_entry *qstruct;
	INT8 i;
	INT8 j;

	for( i=0; i<ARP_TSIZE; i++ ) {
		qstruct = &arp_table[i];
		
		if( qstruct->state == ARP_FREE )
			continue;
			
		if((qstruct->pradr == pra)&&(pra != IP_BROADCAST_ADDRESS)) {
			/* The address is in cache, refresh it	 */
			
			ARP_DEBUGOUT(" Refreshing Existing ARP Entry..\n\r");
		
			for( j=0; j<MAXHWALEN; j++ )		
				qstruct->hwadr[j] = *hwadr++;
				
			qstruct->ttl = ARP_TIMEOUT;
			qstruct->retries = ARP_MAXRETRY;
			qstruct->state = ARP_RESOLVED;
	
			/* All OK	*/
		
			return (0);	
		}
	
	}
	
	if(is_subnet(pra,&localmachine) == FALSE){
		return (-1);
	}
	
	if( localmachine.defgw == pra )	{
		if(localmachine.defgw != 0) {
			type = ARP_FIXED_IP;
		}
	}

	
	/* Address was'nt on cache. Need to allocate new one	*/
	
	ARP_DEBUGOUT("Allocating New ARP Entry..\n\r");
	
	i = arp_alloc(type);
	
	if( i < 0 )				/* No Entries Left?	*/
		return(-1);
			
	/* Fill the fields		*/
		
	qstruct = &arp_table[i];
		
	qstruct->pradr = pra;										/* Fill IP				*/
	
	for(i=0; i<MAXHWALEN; i++)
		qstruct->hwadr[i] = *hwadr++;							/* Fill HW address		*/

	qstruct->retries = ARP_MAXRETRY;
	qstruct->ttl = ARP_TIMEOUT;
	qstruct->state = ARP_RESOLVED;				
	
	ARP_DEBUGOUT("ARP Entry Created!..\n\r");

	return(1);

}
 
/** \brief Find an ARP entry given a protocol address
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 01.11.2001
 *	\param pra - Protocol address (IPv4)
 *	\param machine - Pointer to configuration of network interface used
 *	\param type - Type of address allocated if not found. Can be one of the
 *		following:
 *		\li #ARP_FIXED_IP
 *		\li #ARP_TEMP_IP
 *	\return
 *		\li 0 - ARP entry not found or not ready yet (waiting for ARP response)
 *		\li struct arp_entry* - pointer to solved entry of ARP cache table
 *
 *	This function tries to resolve IPv4 address by checking the ARP cache
 *	table and sending ARP requested if needed. 
 */
struct arp_entry* arp_find (LWORD pra, struct netif *machine, UINT8 type)
{
	struct arp_entry *qstruct;
	INT8 i;
	
	ARP_DEBUGOUT("Trying to find MAC address from ARP Cache\n\r");
	
	/* Is the address in the cache	*/
	
	for( i=0; i<ARP_TSIZE; i++ ) {
		qstruct = &arp_table[i];
		
		if( qstruct->state == ARP_FREE )
			continue;
		if( qstruct->pradr == pra) {
			/* The address is in cache, is it valid? */
			
			ARP_DEBUGOUT("Address In Cache\n\r");
			
			if( qstruct->state < ARP_RESOLVED ) {
				ARP_DEBUGOUT("Address in cache but unresolved :(\n\r");
				return(0);
			}
			/* All OK	*/
		
			return(qstruct);	
		}
	
	}
	
	/* The address wasn't on the cache. Is it in our Subnet?	*/
	
	if( is_subnet(pra, machine) ) {
		/* Yep, we need to send ARP REQUEST	*/
		
		ARP_DEBUGOUT("Need to send ARP Request to local network..\n\r");
		
		if( machine->defgw == pra ) {
			if(machine->defgw != 0) {
				type = ARP_FIXED_IP;
			}
		}
		i = arp_alloc(type);
		
		if( i < 0 )				/* No Entries Left?	*/
			return(0);
			
		/* Send Request after filling the fields	*/
		
		qstruct = &arp_table[i];
		
		qstruct->pradr = pra;						/* Fill IP				*/
		qstruct->hwadr[0] = 0xFF;					/* Fill Broadcast IP	*/
		qstruct->hwadr[1] = 0xFF;
		qstruct->hwadr[2] = 0xFF;
		qstruct->hwadr[3] = 0xFF;
		qstruct->hwadr[4] = 0xFF;
		qstruct->hwadr[5] = 0xFF;
		qstruct->retries = ARP_MAXRETRY;
		qstruct->ttl = ARP_RESEND;
		arp_send_req( i );
		qstruct->state = ARP_PENDING;				/* Waiting for Reply	*/
		
		return(0);
	
	} 

	/* The Address belongst to the outern world, need to use MAC of			*/
	/* Default Gateway														*/
	
	ARP_DEBUGOUT("Need to use MAC of Default GW\n\r");
	
	/* Check for Broadcast													*/
	
	if(machine->defgw == 0)				/* It's not specified	*/
		return(0);
	
	
	for( i=0; i<ARP_TSIZE; i++ ) {
		qstruct = &arp_table[i];
		
		if( qstruct->state == ARP_FREE )
			continue;
			
		if( qstruct->pradr == machine->defgw ) {
			/* The address is in cache, is it valid? */
		 
			
			if( qstruct->state < ARP_RESOLVED ) {
				ARP_DEBUGOUT("The Address of Def. GW is not Solved!\n\r");
				return(0);
			}
		
			/* All OK	*/
			
			ARP_DEBUGOUT(" >> Default Gateway MAC found!\n\r");
		
			return(qstruct);
				
		}
	
	}
	
	ARP_DEBUGOUT("Need to send ARP Request to default gateway..\n\r");
		
	i = arp_alloc(ARP_FIXED_IP);
		
	if( i < 0 )				/* No Entries Left?	*/
		return(0);
			
	/* Send Request after filling the fields	*/
		
	qstruct = &arp_table[i];
		
	qstruct->pradr = machine->defgw;						/* Fill IP				*/
	qstruct->hwadr[0] = 0xFF;					/* Fill Broadcast IP	*/
	qstruct->hwadr[1] = 0xFF;
	qstruct->hwadr[2] = 0xFF;
	qstruct->hwadr[3] = 0xFF;
	qstruct->hwadr[4] = 0xFF;
	qstruct->hwadr[5] = 0xFF;
	qstruct->retries = ARP_MAXRETRY;
	qstruct->ttl = ARP_RESEND;
	arp_send_req( i );
	qstruct->state = ARP_PENDING;				/* Waiting for Reply	*/
	
	return(0);

	
}


/** \brief Manage ARP cache periodically
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 04.11.2001
 *	\warning
 *		\li Invoke this function periodically to ensure proper ARP
 *		cache behaviour
 *
 *	Iterate through ARP cache aging entries. If timed-out entry is found,
 *	remove it (dynamic address) or update it (static address). This function
 *	must be called periodically by the system.
 *
 */
void arp_manage (void)
{
	struct arp_entry *qstruct;
	UINT8 i,j;
	static UINT8 aenext=0;
	
	/* Check Timer before entering	*/
	
	if( check_timer(arp_timer) )
		return;
		
	init_timer( arp_timer, ARP_MANG_TOUT*TIMERTIC);
	
	/* DEBUGOUT("Managing ARP Cache\n\r"); */
	
	for( i=0; i<ARP_TSIZE; i++ ) {
		/* DEBUGOUT("."); */
	
		qstruct = &arp_table[aenext];
		
		j = aenext;
		
		/* Take next entry next time	*/
				
		aenext++;
		if(aenext >= ARP_TSIZE)
			aenext = 0;	
	
		if( qstruct->state == ARP_FREE )
			continue;
			
		/* TODO: How about ARP_RESERVED?	*/
			
		if( qstruct->ttl > 0 )				/* Aging		*/
			qstruct->ttl --;
		
		if( qstruct->ttl == 0 )	{			/* Timed Out?	*/
			/* Do it for temporay entries	*/
			
			ARP_DEBUGOUT("Found Timed out Entry..\n\r");
		
			if( qstruct->type == ARP_TEMP_IP ) {

				/* Release it?	*/
				if( qstruct->state == ARP_RESOLVED ) {	
					ARP_DEBUGOUT("Releasing ARP Entry..\n\r");
					qstruct->state = ARP_FREE;
					continue;
				}
				
				/* Decrease retries left	*/
				
				if( qstruct->retries > 0 )	
					qstruct->retries--;
				
				if( qstruct->retries == 0 )	{
					ARP_DEBUGOUT("ARP Replies Used up, releasing entry..\n\r");
					qstruct->state = ARP_FREE;
					continue;
				}
				
				/* So we need to resend ARP request	*/
				
				ARP_DEBUGOUT("Trying to Resolve dynamic ARP Entry..\n\r");
			
				qstruct->ttl = ARP_RESEND;
				arp_send_req( j );
				qstruct->state = ARP_PENDING;				/* Waiting for Reply	*/			
				
				return;
			
			}
		
			/* Do it for Static Entries			*/
		
			if( qstruct->type == ARP_FIXED_IP ) {
				
				/* So we need to resend ARP request	*/
				
				/* Do not try to refresh broadcast	*/
				
				if(qstruct->pradr == IP_BROADCAST_ADDRESS) 	{
					qstruct->ttl = ARP_TIMEOUT;
					continue;
				}
				
				ARP_DEBUGOUT("Refreshing Static ARP Entry..\n\r");
				
				if( qstruct->retries > 0 )	
					qstruct->retries--;
				
				if( qstruct->retries == 0 )
					qstruct->state = ARP_PENDING;
				else
					qstruct->state = ARP_REFRESHING;
			
				qstruct->ttl = ARP_RESEND;
				
				arp_send_req( j );
				
				return;
			
			}
		
		}
	
	}


}



/** \brief Initialize data structures for ARP processing
 *	\ingroup core_initializer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 01.11.2001
 *	\warning 
 *		\li Invoke this function at start-up to properly initialize
 *		ARP cache subsystem.
 *
 *	Call this function to properly initialize ARP cache table and so that
 *	ARP allocates and initializes a timer for it's use.
 */
void arp_init (void)
{
	struct arp_entry *qstruct;
	INT8 i;
	
	ARP_DEBUGOUT("Initializing ARP");
	
	for( i=0; i<ARP_TSIZE; i++ ) {
		qstruct = &arp_table[i];
		
		qstruct->state = ARP_FREE;
		qstruct->type = ARP_TEMP_IP;
		
		ARP_DEBUGOUT(".");
	}
	
	arp_timer = get_timer();
	init_timer(arp_timer, ARP_MANG_TOUT*TIMERTIC);

	/* set broadcast entry	*/
	
	qstruct = &arp_table[0];
	qstruct->pradr = IP_BROADCAST_ADDRESS;
	qstruct->state = ARP_RESOLVED;
	qstruct->type = ARP_FIXED_IP;
	qstruct->ttl = ARP_TIMEOUT;
	qstruct->retries = ARP_MAXRETRY;	
	
	for(i=0; i<MAXHWALEN; i++)
		qstruct->hwadr[i] = 0xFF;							
	
	ARP_DEBUGOUT("\n\r");
	
}
/** \brief Checks if a given IP address belongs to the subnet of a
 		given machine
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 05.11.2001
 *	\param ipadr - IP address under check
 *	\param machine - pointer to configuration of network parameters used
 *	\return
 *		\li #TRUE - ipadr belongs to subnet of given machine
 *		\li #FALSE - ipadr is NOT a part of subnet of given machine 
 *
 *	Based on information supplied in ipadr and machine parameters this
 *	function performs basic check if IP address is on the same subnet as
 *	the one defined for the machine. 
 *
 */
BYTE is_subnet (LWORD ipadr, struct netif* machine)
{

	UINT32 ltemp;

	ltemp = ipadr & machine->netmask;						/* Get Subnet part	*/
	
	ltemp ^= (machine->localip & machine->netmask);			/* Compare to my IP	*/
	
	if( ltemp )
		return(FALSE);
	
	return(TRUE);

}
