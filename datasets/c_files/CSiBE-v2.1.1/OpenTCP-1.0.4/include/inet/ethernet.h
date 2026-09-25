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

/** \file ethernet.h
 *	\brief OpenTCP Ethernet interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 23.6.2002
 * 	
 *	OpenTCP Ethernet driver and protocol function declarations,
 *	constants, etc.
 */

#ifndef INCLUDE_ETHERNET_H
#define INCLUDE_ETHERNET_H

#include <inet/datatypes.h>

/* Symbolic constants	*/

#define	ETH_ADDRESS_LEN	6

/* Protocol Constants	*/

#define	ETH_HEADER_LEN		14
#define ETH_CHIP_HEADER_LEN	4
#define	ETH_MTU				1500

#define	PROTOCOL_IP			0x0800			/**< IP over Ethernet	*/
#define PROTOCOL_ARP		0x0806			/**< ARP over Ethernet 	*/

/* Page0 register offsets */
 
#define CR			0x00	/**< Command register, R/W 		*/
#define	PSTART		0x01	/**< Rx buffer start page, W 		*/
#define	PSTOP		0x02	/**< Rx buffer stop page 			*/
#define	BOUNDARY	0x03	/**< Address of last byte that
 							 *	 host has read from RxBuf, R/W 
 							 */
#define	TPSR		0x04	/**< Tx Buf start page, W			*/
#define	TSR			0x04	/**< Status of Tx, R				*/
#define	TBCR0		0x05	/**< Length of transmittet packet	*/
#define	TBCR1		0x06	/**< W							*/
#define	ISR			0x07	/**< Interrupt status req, R/W	*/
#define	RSAR0		0x08	/**< RemoteDMA start address, W 	*/
#define	RSAR1		0x09	
#define	RBCR0		0x0A	/**< RemoteDMA bytecount 	,W		*/
#define RBCR1		0x0B
#define	RCR			0x0C	/**< Rx Conf reg, W				*/
#define	TCR			0x0D	/**< Tx Conf req, W				*/
#define	DCR			0x0E	/**< ISA bus configuration, W		*/
#define	IMR			0x0F	/**< Interrupt mask register, W	*/
 
/* Page 1 register offsets */
 
#define	PAR0		0x01	/**< Physical address ,R/W		*/
#define	PAR1		0x02
#define	PAR2		0x03
#define	PAR3		0x04
#define	PAR4		0x05
#define	PAR5		0x06
#define CURR		0x07	/**< Current local DMA receivereg	*/
#define	MAR0		0x08	/**< Multicast address register, R/W */
 
/* DMA Ports */
 
#define IOPORT 		0x10	/**< DMA dataregister */
#define	RESETPORT	0x1F	 


/* Buffer addresses */
#define RXBUF_START	0x40	/**< 3328 byte Rx Buffer 	 	 */
#define	RXBUF_END	0x4D	/**< (2 max packets	   		 */
#define	ARP_BUFFER	0x5F	/**< 256 byte Tx for ARP 		 */
#define	ICMP_BUF	0x4D	/**< 1536 byte Tx for ICMP	 */
#define	TCP_BUF		0x53	/**< 1536 byte Tx for TCP		 */
#define	UDP_BUF		0x59	/**< 1536 byte Tx for UDP		 */


/** \struct ethernet_frame ethernet.h
 *	\brief Ethernet packet header fields
 *
 *	This structure holds information about the Ethernet packets. In
 *	addition to standard Ethernet header (destination HW address, source
 *	HW address, frame size and protocol), buff_index is added. This variable
 *	is used by higher level protocols (IP, ARP or other) to initialize
 *	reading of the Ethernet packet by invoking NETWORK_RECEIVE_INITIALIZE
 *	macro to initialize reading of the data carried in the Ethernet packet (
 *	not the Ethernet header itself!).
 */
struct ethernet_frame
{
	UINT8	destination[ETH_ADDRESS_LEN];	/**< destination hardware address
											 *	 as read from the received
											 *	 ethernet packet
											 */
	UINT8	source[ETH_ADDRESS_LEN];		/**< source hardware address
											 *	 as read from the received
											 *	 ethernet packet
											 */
	UINT16	frame_size;						/**< size of the received
											 *	 Ethernet packet
											 */	
	UINT16	protocol;						/**< protocol field of the
											 * 	 Ethernet header. For now we
											 *	 work with:
											 *		\li PROTOCOL_IP	- 0x0800
											 *		\li PROTOCOL_ARP - 0x0806
											 */
	UINT16	buf_index;						/**< Address in the Ethernet
											 * 	 controllers buffer where
											 *	 data can be read from
											 */

};

/* API prototypes	*/
void outNE2000(UINT8, UINT8);
void outNE2000again(UINT8);
UINT8 inNE2000(UINT8);
UINT8 inNE2000again(void);
UINT8 NE2000CheckRxFrame(void);
void NE2000DumpRxFrame(void);
void NE2000Init(UINT8*);
void NE2000CheckOverFlow(void);
UINT8 NE2000ReceiveFrame(void);
void InitTransmission(UINT8);
void NE2000WriteEthernetHeader(struct ethernet_frame*);
void NE2000DMAInit(UINT8);
void NE2000DMAInit_position(UINT16);
void NE2000SendFrame(UINT16);
void NE2000EnterSleep(void);
void NE2000ExitSleep(void);


#endif


