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

/** \file ethernet.c
 *	\brief OpenTCP Ethernet protocol and driver for Realtek's RTL8019AS
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *		\li Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 19.2.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li How to adopt to different MCU speeds in the code?
 *  
 *	OpenTCP implementation of Ethernet protocol and driver for
 *	Realtek's RTL8019AS Ethernet controller. Function declarations,data
 *	structures etc. may be found in inet/ethernet.h.
 */
 
#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/system.h>
#include <inet/ethernet.h>


#include <inet/arch/config.h>

UINT8	NE2000NextPktPtr;			/**< Start address of next packet in the Ethernet controller */
UINT8 	NE2000CurrPktPtr;			/**< Start address of current packet in the Ethernet controller */

UINT8 	EtherSleep = 0;	/**< Used for storing state of Ethernet controller (0 = awake; 1 = sleeping) */

/** \brief Used for storing various information about the received Ethernet frame
 *	
 *	Fields from Ethernet packet (dest/source hardware address, 
 *	protocol, frame size, start of the Ethernet packet in Ethernet controller)
 *	are stored in this structure. These values are later used from upper
 *	layer protocols (IP, ARP). See ethernet_frame definition for more
 *	information about struct fields.
 *
 */	
struct ethernet_frame received_frame;

/** \brief Used for storing various information about the Ethernet frame that will be sent
 *	
 *	Fields from Ethernet packet (dest/source hardware address, 
 *	protocol, frame size) are stored in this structure by the
 *	upper layer protocols (IP, ARP, other). These values are 
 *	then used for initializing transmission of an Ethernet frame.
 *	See ethernet_frame definition for more
 *	information about struct fields.
 *
 */
struct ethernet_frame send_frame;


/** \brief Write data to NE2000 register
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasytems.com)
 *	\date 19.02.2002
 *	\param reg NE2000 register address
 *	\param dat new register content
 *
 *	Write data to NE2000 register.
 *
 */
void outNE2000 (UINT8 reg , UINT8 dat)
{

 	UINT8 temp = reg;
 	
 	DATADIR = DDR_OUT;				/* datapins = output */
 	DATABUS = dat;				/* data to bus */
 	ADRBUS =  (temp | 0x60);	/* dont change R,W,Reset pins */
 	
 	/* Wait until bus free */
 	
 	IOW = 0;					/* do writestrobe */
 	while(IOCHRDY == 0);
 	IOW = 1;

}	

/** \brief Write data to the same NE2000 register as before
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param dat new register content
 *
 *	Invoke this function to write data to the same register as 
 *	in previously invoked outNE2000(). Saves some cycles because
 *	data direction registers and address are set up.
 *
 *	Use SEND_NETWORK_B() macro instead of invoking this function
 *	directly.
 */
void outNE2000again (UINT8 dat)
{
 	/* Write data to same reg as outNE2000 before */
 	
 	DATABUS = dat;
 	
 	/* Wait until bus free */

	IOW = 0;				/* do writestrobe */
 	while(IOCHRDY == 0);
 	IOW = 1;
}

/** \brief Write buffer data to the same NE2000 register as before
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 20.07.2003
 *	\param buf pointer to buffer from which we're taking data
 *	\param len number of bytes from buffer to write
 *
 *	Invoke this function to write data from a buffer to the same 
 *	register as in previously invoked outNE2000(). Saves some 
 *	cycles because data direction registers and address are set up.
 *
 *	Use SEND_NETWORK_BUF() macro instead of invoking this function
 *	directly.
 */
void outNE2000againbuf (UINT8* buf, UINT16 len)
{

	while(len--)
	{
		DATABUS = *buf++;
		IOW = 0;
		while(IOCHRDY == 0);		/* Wait until bus free */
		IOW = 1;
	}
}


/** \brief Read byte from NE2000 register
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param reg NE2000 register address
 *	\return Register content
 *
 *	Invoke this function to read contents of a NE2000 register.
 *
 */
UINT8 inNE2000 (UINT8 reg)
{
 	UINT8 temp = reg;
 	DATADIR = DDR_IN;				/* port input */
 	ADRBUS = (temp | 0x60);
 	
 	/* Wait until bus free */
 	
 	IOR = 0;					/* do readstrobe */
 	while(IOCHRDY == 0);
 	temp = DATABUS;
 	IOR = 1;
 	
 	return temp;
}

/** \brief Continue reading byte(s) from NE2000
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\return Register content
 *
 *	Invoke this function to continue reading contents of a NE2000 register,
 *	usefull when reading a sequence of bytes from Ethernet controller.
 *
 *	Use RECEIVE_NETWORK_B() macro instead of directly invoking this
 *	function for easier driver change.
 */
UINT8 inNE2000again (void)
{
 	UINT8 temp;
 	
 	/* Wait until bus free */

 	IOR = 0; 	
 	while(IOCHRDY == 0);
 	temp = DATABUS;
 	IOR = 1;
 	
 	return(temp);
 
}

/** \brief Read bytes from NE2000 to buffer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 20.07.2003
 *
 *	Invoke this function to continue reading contents of a NE2000 register,
 *	only this time to a buffer directly.
 *
 *	Use RECEIVE_NETWORK_BUF() macro instead of directly invoking this
 *	function for easier driver change.
 */
void inNE2000againbuf (UINT8* buf, UINT16 len)
{
	while(len--)
	{
		IOR = 0;
		while(IOCHRDY == 0);		/* Wait until bus free */ 				
 		*buf++ = DATABUS;
 		IOR = 1;	
	}
}

/** \brief Check to see if new frame has been received
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\return
 *		\li #TRUE - if there is a new packet waiting
 *		\li #FALSE - if there is no new packet waiting
 *
 *	Invoke this function to check if there is a new Ethernet frame
 *	in the NIC's buffer waiting to be processed.
 */
UINT8 NE2000CheckRxFrame (void)
{
 	/* Checks to see if ethernet frame has been received */
 	
 	UINT8 temp;
 	
 	outNE2000( CR ,0x62);			/* page 1, abort DMA */
 	temp = inNE2000( CURR );
 	outNE2000( CR, 0x02 );			/* page 0 */
 	
 	if( temp != inNE2000( BOUNDARY ) ) {
 		/* Boundary != Current => packet exists */
 		
		/* Check still for receive status	*/
 		if(inNE2000(RCR) & 0x01)
 			return(TRUE);

 	}	
	
 	return(FALSE); 
}

/** \brief Discard current received frame
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *
 *	Discard the current received frame by advancing the receive circular
 *	buffer tail pointer.
 */
void NE2000DumpRxFrame (void)
{
 
 	outNE2000( CR, 0x22 );			/* page0, abort DMA */
 	
 	/* Set boundary to start of next packet */
 	
 	outNE2000( BOUNDARY, NE2000NextPktPtr );	

 
}
 
 
/** \brief Initialize and configure RTL8019AS
 *	\ingroup core_initializer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param mac Pointer to NIC's hardware address
 *
 *	Invoke this function at startup to properly initialize NIC's registers,
 *	HW address and operation.
 */ 
void NE2000Init (UINT8* mac)
{

 	/* Give HW Reset	*/
 	
 	RESETPIN_NE2000 = 1;
 	wait(10000);
 	RESETPIN_NE2000 = 0;
 	wait(10000);
 	
 	outNE2000( RESETPORT, 0 );		/* reset NE2000*/
 	/* Wait for a while */
 	
 	wait(30000);

 	
 	/* Goto page 3 and set registers */
 	outNE2000( CR, 0xC1 );			/* page3, stop */
 	outNE2000( 0x01, 0xC0 );		/* config reg. write enble */
 	outNE2000( 0x05, 0 );			/* link test enable */
 	/* outNE2000( 0x06, 0x70 );		//Full duplex, leds */
 	
 	/* Goto page 1 and set registers */
 	
 	outNE2000( CR, 0x41 );								/* page1, stop */
 	outNE2000( PAR5, *mac++);			/* Set MAC Address  */
 	outNE2000( PAR4, *mac++);
	outNE2000( PAR3, *mac++);
	outNE2000( PAR2, *mac++);
	outNE2000( PAR1, *mac++);
	outNE2000( PAR0, *mac); 
	
 	outNE2000( CURR, RXBUF_START );	/* Current address */
 	NE2000NextPktPtr = RXBUF_START;
 	NE2000CurrPktPtr = RXBUF_START;
 	
 	/* Goto page 0 and set registers */
 	
 	outNE2000( CR, 0 );				 		/* page0, Stop */
 	outNE2000( PSTART, RXBUF_START); 		/* Rx buffer start address */
 	outNE2000( PSTOP, RXBUF_END );	 		/* Rx buffer end address */
 	outNE2000( BOUNDARY, RXBUF_START );	 	/* Boundary */
 	outNE2000( ISR, 0xFF );			 		/* Interrupt services */
 	outNE2000( RCR, 0xC4);			 		/* Rx config (Accept all), was C4 */
 	outNE2000( TCR, 0xE0);			 		/* Tx config */
 	outNE2000( DCR, 0xB8);			 		/* Dataconfig */
 	
 	/* Start action ! */
 	
 	outNE2000( CR, 0x22 );			 /* Page0, start */
 	
}


/** \brief Check if receive-buffer overflow occured
 *	\ingroup periodic_functions
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *
 *	This function checks if receive-buffer overflow has happened. If it did,
 *	NIC is reinitialized to ensure proper operation.
 *
 *	Invoke this function periodically to ensure proper operation under
 *	heavy load.
 */
void NE2000CheckOverFlow (void)
{
 	/* Checks if Receive Buffer overflow has happened */
 	/* and re-initializes the NIC if needed			  */
 	
 	UINT8 temp;

	outNE2000( CR, 0x22 );			/* page0, abort DMA */

 	if( inNE2000( ISR ) & 0x10 ) {
 	
 		/* OverFlow occured!! */
 	
 		outNE2000( CR, 0x21 );		/* Issue Stop-command 		*/
 
 		outNE2000( RBCR0, 0x00 );	/* Clear remote Byte Count	*/
 		outNE2000( RBCR1, 0x00 );
 	
 		/* Poll the interrupt status register for RST bit */
 	
 		kick_WD();
 		while( ( inNE2000( ISR ) & 0x80 ) == 0 );

		/* RST was set, NIC is in Stop mode	*/
		/* Enter to LOOPBACK mode now		*/
	
		outNE2000( TCR, 0x02 );
 	
 		/* Issue Start Command 							*/
 		/* NIC is still inactive because LOOPBACK on	*/
 	
 		outNE2000(CR,0x22);
 	
 		/* Remove Packet from buffer */
	
		if(inNE2000(BOUNDARY) != NE2000NextPktPtr) {
 			ETH_DEBUGOUT("\r\n*********Normal Overflow**********\r\n");
 			outNE2000( BOUNDARY, NE2000NextPktPtr );
 		} else {
 			/* There has been an overflow after we have received the packet	*/
 			/* last time													*/
 		
 			ETH_DEBUGOUT("???????????????????????????????????\r\n");
 			ETH_DEBUGOUT("Unrecognized overflow!!\r\n");
 			ETH_DEBUGOUT("中中中中中中中中中中中中中中中中中么r\n");
 		
 			outNE2000(CR ,0x62);			/* page 1, abort DMA */
 			temp = inNE2000(CURR);
 			outNE2000( CR, 0x22 );			/* page0, abort DMA */
 		
 			/* Dischard the whole buffer	*/
 		
 			outNE2000( BOUNDARY, temp);
 			
 			NE2000NextPktPtr = temp;
 			NE2000CurrPktPtr = temp; 			
 		
 		}
 
		
		outNE2000( ISR, 0xFF );			 /* Interrupt services */
	
		/* Exit from loopback to normal mode */
	
		outNE2000( TCR, 0xE0);			 /* Tx config */
 	
 	}
 
}

/** \brief Checks if new Ethernet frame exists and initializes variables
 *		accordingly
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasytems.com)
 *	\date 19.02.2002
 *	\return
 *		\li #TRUE - new frame exists, variables initialized so further
 *			processing may start
 *		\li #FALSE - no new Ethernet frame detected
 *
 *	Invoke this function periodically (better not directly but by invoking
 *	NETWORK_CHECK_IF_RECEIVED() macro) to test for newly-arrived Ethernet
 *	packets.
 *
 *	Once this function detects a new Etherent packet, internal variables 
 *	are initialized (NE2000CurrPktPtr, NE2000NextPktPtr and received_frame
 *	structure) and TRUE is returned, indicating that processing of
 *	newly-arrived frame may begin.
 */
UINT8 NE2000ReceiveFrame (void)
{

 	
 	if( NE2000CheckRxFrame() == FALSE ) 
 		return(FALSE);

 	
 	/* There is data, receive Ethernet info */
 	
 	NE2000CurrPktPtr = inNE2000(BOUNDARY);	/* Store pointer */
 	outNE2000( CR, 0x22 );					/* page0, abort DMA */
 	
 	/* Initialize DMA  to Start of the packet 	*/
 	
 	
 	outNE2000( RSAR0, 0 );
 	outNE2000( RSAR1, NE2000CurrPktPtr );
 	outNE2000( RBCR0, 0xFF );				/* Set DMA length for */
 	outNE2000( RBCR1, 0x0F );				/* definitely sufficient */

	outNE2000( CR, 0x0A );					/* page 0, remote read */
 	
 	inNE2000( IOPORT );						/* ignore receive status */
 	
 	NE2000NextPktPtr = inNE2000again();		/* Store pointer */
 	
 	/* Record Frame Size					*/
 	
 	received_frame.frame_size = inNE2000again();					
 	received_frame.frame_size |= ((UINT16)inNE2000again()) << 8;
 	
 	if(received_frame.frame_size > 4)
 		received_frame.frame_size -= 4;			/* Remove chip specific bytes	*/
 	else
 		return(FALSE);
 	
 	/* Record destination Ethernet Address	*/
 	
 	received_frame.destination[5] = inNE2000again();						
 	received_frame.destination[4] = inNE2000again();
 	received_frame.destination[3] = inNE2000again();
 	received_frame.destination[2] = inNE2000again();
 	received_frame.destination[1] = inNE2000again();
 	received_frame.destination[0] = inNE2000again();
 	
 	/* Record senders Ethernet address 		*/
 	
 	received_frame.source[5] = inNE2000again();
 	received_frame.source[4] = inNE2000again();
 	received_frame.source[3] = inNE2000again();
 	received_frame.source[2] = inNE2000again();
 	received_frame.source[1] = inNE2000again();
 	received_frame.source[0] = inNE2000again(); 
 	
 	/* Record Protocol	*/
 	
 	received_frame.protocol = inNE2000again();
 	received_frame.protocol <<= 8;
 	received_frame.protocol |= inNE2000again();
 	
 	/* Give the next layer data start buffer index from the start	*/
 	
 	received_frame.buf_index = ETH_HEADER_LEN;
 	
 	/* Stop DMA */
 	
 	outNE2000( CR, 0x22 );	
 	
 	ETH_DEBUGOUT("Ethernet Frame Received\n\r");
 	
 	return(TRUE);						/* Indicate we got packet */
 	
}

/** \brief Initialize transmission of new packet
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param page Address in Ethernet controller where outgoing packet
 *		buffered
 *
 *	This function is used to initialize transmission of an Ethernet 
 *	packet. Packet is created starting from <i>page</i> address.
 *
 *	Do not invoke this function directly, but instead use 
 *	NETWORK_SEND_INITIALIZE() macro.
 */
void InitTransmission (UINT8 page)
{
 	/* Initializes NE2000 for remote write  					*/
 	
 	while( (inNE2000(CR) & 0x04) ) ;		/* wait Tx to complete */
 	
 	outNE2000( CR, 0x22 );				/* page0, abort DMA */
 	
 	outNE2000( TPSR, page );			/* Tx buffer Start */
 	
 	outNE2000( RSAR0, 0x00 );			/* Remote DMA start */
 	outNE2000( RSAR1, page );
 	
 	outNE2000( RBCR0, 0xEA );			/* Max.Ethernet frame */
 	outNE2000( RBCR1, 0x05 );			/* size */
 	
 	outNE2000( CR, 0x12 );				/* page0, remote write */
 	
 	/* Set Address lines to be ready	*/
 	
 	DATADIR = DDR_OUT;				/* datapins = output */
 	ADRBUS =  (IOPORT | 0x60);	/* dont change R,W,Reset pins */
 		
 	
}

/** \brief Write Ethernet Header to transmission buffer
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param frame Pointer to ethernet_frame structure containing information
 *		about the new Ethernet frame
 *
 *	Invoke this function (through NETWORK_ADD_DATALINK() macro) to create
 *	an Ethernet header in the NIC's transmit buffer. Do this only after
 *	invoking NETWORK_SEND_INITIALIZE() macro.
 *
 */
void NE2000WriteEthernetHeader (struct ethernet_frame* frame)
{
	INT8 i;
	
	/* Write destination Ethernet Address	*/
	
	for(i=ETH_ADDRESS_LEN-1; i >= 0; i--) {
		outNE2000again(frame->destination[i]);
	}

	/* Write sender (our) Ethernet address	*/
	
	for(i=ETH_ADDRESS_LEN-1; i >= 0; i--) {
		outNE2000again(frame->source[i]);
	}
	
	/* Write protocol						*/
	
	outNE2000again( (UINT8)(frame->protocol >> 8) );
	outNE2000again( (UINT8)frame->protocol );

}

/** \brief Initialize NE2000 in preparation for remote DMA
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param page Address for the DMA
 *
 *	
 */
void NE2000DMAInit (UINT8 page)
{
	
 	outNE2000( CR, 0x22 );			/* page0, abort DMA  */
 	
 	/* Initialize DMA  to address field in Ethernet Frame 	*/
 	/* That is, isolate chip specific fields from  			*/
 	/* actual Ethernet Frame							   	*/
 	
 	outNE2000( RSAR0, 4 );
 	outNE2000( RSAR1, page );
 	outNE2000( RBCR0, 0xFF );		/* Set DMA length for */
 	outNE2000( RBCR1, 0x0F );		/* definitely sufficient */
 	
}

/** \brief Initialize reading from NE2000
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param pos Position from the start of current frame from which DMA
 *		is initialized.
 *
 *	Invoke this function (through NETWORK_RECEIVE_INITIALIZE() macro) 
 *	to prepair NIC for reading from the specified position.
 */
void NE2000DMAInit_position (UINT16 pos)
{
 	
 	UINT16 abspos;
 	UINT16 page;
 	UINT8 offset;
 	
 	/* Calculate start page	*/
 	
	abspos = pos + 4;
	
	page = (UINT8)(abspos >> 8);
	page += NE2000CurrPktPtr;
	
	/* Check we are not exceeding the Rx buffer space	*/
	
	if( page >= RXBUF_END ) {
		page = RXBUF_START + (page - RXBUF_END);
	} 
	
	offset = (UINT8)(abspos & 0xFF);
	
	/* Make settings		*/
	 
	outNE2000( CR, 0x22 );			/* page0, abort DMA */
 	
 	/* Initialize DMA  to address field in Ethernet Frame 	*/
 	/* That is, isolate chip specific fields from  			*/
 	/* actual Ethernet Frame							   	*/
 	
 	outNE2000( RSAR0, offset );
 	outNE2000( RSAR1, (UINT8)page );
 	outNE2000( RBCR0, 0xFF );		/* Set DMA length for */
 	outNE2000( RBCR1, 0x0F );		/* definitely sufficient */
 	
 	outNE2000( CR, 0x0A );			/* page 0, remote read */
	
	/* Init Address bus	*/

 	DATADIR = DDR_IN;				/* port input */
 	ADRBUS = (IOPORT | 0x60);
 	
 	/* Now just read by inNE2000again()		*/
}



/** \brief Instruct NIC to send the Ethernet frame
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *	\param len Length of packet stored in the NIC's buffer
 *	\warning
 *		\li Minimum Ethernet packet size is 64 bytes
 *
 *	Invoke this function (through NETWORK_COMPLETE_SEND() macro) when
 *	the whole packet is formed inside NIC's memory and is ready to be 
 *	sent. Proper length of the packet must be supplied so that NIC
 *	knows how much data to put on the line.
 */
void NE2000SendFrame ( UINT16 len )
{
 	/* After filling Tx buffer, call this function to send it */
 	/* Input: 	Len: packet length							  */

 	
 	/* Check if we need to insert Pad bytes */
 	
 	while(len < 50) {
 		outNE2000again((BYTE)0x00);
 		len++;
 	}
 	
 	len += 6 + 6 + 2;
 	
 	outNE2000( CR, (BYTE)0x22 );				/* Page0, abort DMA */
 	
 	outNE2000( TBCR0, (BYTE)(len) );
 	outNE2000( TBCR1, (BYTE)(len >> 8 ) );
 	
 	/* Transmit packet to Ether */
 	
 	outNE2000( CR, (BYTE)0x06 );		/* Page0, transmit */
 	
 	
}

/** \brief Put NE2000 to sleep mode
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *
 *	Invoke this function to put Ethernet controller to sleep mode.
 *
 */
void NE2000EnterSleep (void) 
{
	if (EtherSleep)
		return;

	EtherSleep = 1;
	
	outNE2000( CR, 0xE2 );			/* page3, abort DMA	 */
	outNE2000( 0x06, 0x04);			/* Sleep */
}

/** \brief Restore NE2000 from sleep mode
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.02.2002
 *
 *	Invoke this function to instruct NE2000 to exit sleep mode and 
 *	continue normal operation.
 */
void NE2000ExitSleep (void) 
{
	if (EtherSleep) {
		outNE2000( CR, 0xE2 );			/* age3, abort DMA	 */
		outNE2000( 0x06, 0x00);			/* Wake up */
		EtherSleep = 0;
	}
		
}
