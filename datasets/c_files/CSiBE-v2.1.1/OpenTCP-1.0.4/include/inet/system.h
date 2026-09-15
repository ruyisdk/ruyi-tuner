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

/** \file system.h
 *	\brief OpenTCP system interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 23.6.2002
 * 	
 *	OpenTCP system function declarations, constants, general 
 *	assignments, etc.
 */
#ifndef SYSTEM_H_INCLUDE
#define SYSTEM_H_INCLUDE

#include <inet/datatypes.h>
#include <inet/globalvariables.h>
/** \def OPENTCP_VERSION
 *	\brief OpenTCP major version number
 *
 *	This define represents OpenTCP version information. Version
 *	is in the format MAJOR.MINOR.PATCH.
 */
#define OPENTCP_VERSION	"1.0.4"

/* Boolean	values*/
#define TRUE  1	/**< Boolean TRUE value as used in the OpenTCP */
#define FALSE 0	/**< Boolean FALSE value as used in the OpenTCP */

/**	\def NETWORK_TX_BUFFER_SIZE
 *	\ingroup opentcp_config
 *	\brief Transmit buffer size 
 *
 *	NETWORK_TX_BUFFER_SIZE defines the size of the network buffer
 *	used for data transmission by ICMP as well as TCP and UDP applications.
 *	
 *	See net_buf documentation for more reference on the shared transmit
 *	buffer.
 */
#define	NETWORK_TX_BUFFER_SIZE	1024			

/** \struct netif system.h
 *	\brief Network Interface declaration
 *
 *	This structure holds information about the network interface. This means
 *	that all of the network-related information are stored in this kind
 *	of structure.
 */
struct netif{
	/** \brief IP address of a device
	 *
	 *	IP address of a happy device using OpenTCP :-). This must hold
	 *	proper-value IP address in order for the networking stuff to work.
	 *
	 *	Possible scenarios for filling this field are:
	 *		\li By assigning static IP address to a device always after reset
	 *		\li By allowing user to choose IP address by some tool (e.g. through
	 *		serial communication, storing that information to some external
	 *		flash,...)
	 *		\li By using BOOTP or DHCP clients for obtaining dynamically
	 *		assigned address
	 *		\li	By obtaining the IP address from the first ICMP packet
	 *		the device receives
	 *
	 *	First three approaches can also be used for obtaining gateway
	 *	and subnet-mask information.
	 */
	LWORD	localip;
	
	/** \brief Ethernet address given to a device
	 *
	 *	This array holds an Ethernet address assigned to a device. Note that
	 *	these must be unique so if you're shipping your product to outside
	 *	world you must purchase sufficient address range.
	 *
	 */
	BYTE 	localHW[6];
	
	/** \brief	Default network gateway
	 *
	 *	IP address of a default network gateway. This is needed if the
	 *	device is to communicate with the outside network (Internet) and
	 *	not only intranet.
	 */
	LWORD	defgw;
	
	/**	\brief	Network submask
	 *
	 * 	Network submask. Also needed if the the device is to communicate
	 *	with the outside network. Used when determining whether the 
	 *	host we're sending some data to is on the local network (send 
	 *	data directly) or not (send through gateway).
	 */
	LWORD	netmask;
};

/* System variable definitions	*/

#define	MASTER_MS_CLOCK		base_timer		/**< Interrupt driven msec free-running clock	*/
#define TXBUF	net_buf		/**< TXBUF points to transmit network buffer */

/*	System macros		*/

/**	\def RESET_SYSTEM
 *	\brief Macro used to reset the MCU
 *
 *	By default this macro is only an infinite loop and the system is 
 *	reset by the (presumably) running watchdog timer.
 *
 *	Change this if another form of reset is desired/needed.
 */
#define	RESET_SYSTEM()	while(1)		/* Let the watchdog bite	*/

/**	\def OS_EnterCritical
 *	\brief Macro used to enter critical sections
 *	\todo 
 *		\li Move this to other arch-dependant place
 *
 *	This is highly dependant on the architecture that is used and/or
 *	possible operating system beeing used so it will be moved to some
 *	other place in the future.
 *
 *	Usually disabling globally interrupts works just fine :-)
 */
#define OS_EnterCritical	__DI

/**	\def OS_ExitCritical
 *	\brief Macro used to exit critical sections
 *	\todo 
 *		\li Move this to other arch-dependant place
 *	
 *	This is highly dependant on the architecture that is used and/or
 *	possible operating system beeing used so it will be moved to some
 *	other place in the future.
 *
 *	For now this only globally enables interrupts
 */
#define	OS_ExitCritical		__EI

/** \def RECEIVE_NETWORK_B
 *	\brief Use this macro to read data from Ethernet controller
 *
 *	This macro should be used to read data from the Ethernet
 *	controller. Procedure for doing this would be as follows:
 *		\li Initialize reading of data from certain address in the
 *		Ethernet controller (usually you will do that based on buf_index
 *		value of ip_frame, udp_frame or tcp_frame type of variables; 
 *		in certain special situations you can also use buf_index from 
 *		ethernet_frame type of var.
 *		\li Keep invoking RECEIVE_NETWORK_B() to read one byte at a time from
 *		the ethernet controller. Take care not to read more data than
 *		actually received
 *		\li If needed, reinitialize reading of data again and start all
 *		over again
 *		\li When finished discard the current frame in the Ethernet
 *		controller by invoking NETWORK_RECEIVE_END() macro
 *
 */
#define RECEIVE_NETWORK_B()				inNE2000again()

/** \def RECEIVE_NETWORK_BUF
 *	\brief Use this macro to read data from Ethernet controller to a buffer
 *
 *	This macro should be used to read data from the Ethernet
 *	controller to a buffer in memory. Procedure for using this macro
 * is the same as for using RECEIVE_NETWORK_B() macro.
 *
 */
#define RECEIVE_NETWORK_BUF(c,d)		inNE2000againbuf(c,d)

/** \def SEND_NETWORK_B
 *	\brief Use this macro to write data to Ethernet controller
 *
 *	This macro should be used to write data to Ethernet
 *	controller. Procedure for doing this would be as follows:
 *		\li Initialize writing of data to certain address in the
 *		Ethernet controller. Buffer space in Ethernet controller is
 *		divided among the protocols in the following way:
 *			\li 256 byte Tx for ARP (see ARP_BUFFER )
 *			\li 1536 byte Tx for ICMP (see ICMP_BUF)
 *			\li 1536 byte Tx for TCP (see TCP_BUF)
 *			\li 1536 byte Tx for UDP (see UDP_BUF)
 *		\li Write the data by using SEND_NETWORK_B() macro
 *		\li When all of the data is written instruct the Ethernet controller
 *		to send the data by calling the NETWORK_COMPLETE_SEND() macro with
 *		number of bytes to send as a parameter
 *
 */
#define SEND_NETWORK_B(c) 				outNE2000again(c)

/** \def SEND_NETWORK_BUF
 *	\brief Use this macro to write data from buffer to Ethernet controller
 *
 *	This macro should be used to write data from a buffer to Ethernet
 *	controller. Usage is the same as for the SEND_NETWORK_B() macro.
 */
#define SEND_NETWORK_BUF(c,d)			outNE2000againbuf(c,d)

/** \def NETWORK_CHECK_IF_RECEIVED
 *	\ingroup periodic_functions
 *	\brief Use this macro to check if there is recieved data in Ethernet controller
 *
 *	Invoke this macro periodically (see main_demo.c for example) to check
 *	if there is new data in the Ethernet controller.
 *
 *	If there is new data in the Ethernet controller, this macro (function
 *	that it points to that is) will return a value of TRUE and fill in
 *	the appropriate values in the received_frame variable. Otherwise it
 *	returns FALSE.
 */
#define NETWORK_CHECK_IF_RECEIVED() 	NE2000ReceiveFrame()

/** \def NETWORK_RECEIVE_INITIALIZE
 *	\brief Initialize reading from a given address
 *
 *	This macro initializes reading of the received Ethernet frame from
 *	a given address in the Ethernet controller.
 */
#define NETWORK_RECEIVE_INITIALIZE(c)	NE2000DMAInit_position(c)

/** \def NETWORK_RECEIVE_END
 *	\ingroup periodic_functions
 *	\brief Dump received packet in the Ethernet controller
 *
 *	Invoke this macro when the received Ethernet packet is not needed
 *	any more and can be discarded.
 */
#define NETWORK_RECEIVE_END() 			NE2000DumpRxFrame()

/** \def NETWORK_COMPLETE_SEND
 *	\brief Send the Ethernet packet that was formed in the Ethernet controller
 *
 *	After the data has been written to the Ethernet controller, use this
 *	function to instruct the Ethernet controller that data is in it's 
 *	internal buffer and should be sent.
 */
#define NETWORK_COMPLETE_SEND(c) 		NE2000SendFrame(c)

/** \def NETWORK_SEND_INITIALIZE
 *	\brief Initialize sending of Ethernet packet from a given address
 *
 *	Use this function to initialize sending (or creating) of an Ethernet
 *	packet from a given address in the Ethernet controller.
 */
#define NETWORK_SEND_INITIALIZE(c) 		InitTransmission(c)

/** \def NETWORK_ADD_DATALINK
 *	\brief	Add lower-level datalink information
 *
 *	This implementation adds Ethernet data-link information by
 *	invoking NE2000WriteEthernetHeader() function that writes Ethernet
 *	header based on information provided (destination and source ethernet
 *	address and protocol field).
 */
#define NETWORK_ADD_DATALINK(c)			NE2000WriteEthernetHeader(c)


/* System functions	*/

extern void kick_WD(void);
extern void wait(INT16);
extern void enter_power_save(void);
extern void exit_power_save(void);
extern INT16 strlen(UINT8*, UINT16);
extern INT16 bufsearch(UINT8*, UINT16, UINT8*);
extern UINT16 hextoascii(UINT8);
extern void itoa(UINT16, UINT8*);
extern void ltoa(UINT32, UINT8*);
extern INT16 atoi(UINT8*, UINT8);
extern UINT8 asciitohex(UINT8);
extern UINT8 isnumeric(UINT8);
extern void mputs(UINT8*);
void mputhex(UINT8 );
extern UINT32 random(void);
extern void dummy(void);

/*	External functions	*/

extern void init(void);


#endif





