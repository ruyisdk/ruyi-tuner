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

/** \file bootp.c
 *	\brief OpenTCP BOOTP client implementation
 *	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 10.7.2002
 *	\bug
 *	\warning
 *	\todo
 *		\li Offer callback for once the BOOTP client is definitely finished (
 *		#BOOTPC_STATE_REPLY_GET state)
 *
 *	OpenTCP BOOTP client protocol implementation. Function
 *	declarations can be found in inet/bootp/bootp.h
 */

#include<inet/datatypes.h>
#include<inet/system.h>
#include<inet/timers.h>
#include<inet/tcp_ip.h>
#include<inet/bootp/bootp.h>
#include<inet/globalvariables.h>

UINT8 bootp_app_init = 0; /**< Defines whether bootpc_init has already been invoked or not */

/**
 * 	\brief BOOTP client information
 *
 *	bootp variable holds various information about the BOOTP client and also
 *	information needed by the BOOTP client to function properly.
 */
struct
{
	UINT8 	state;
	UINT8	mode;
	INT8	sochandle;
	UINT16	tmrhandle;
	UINT16	bootsecs;

} bootp;


/** \brief Initializes BOOTP client
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 19.07.2002
 *	\return
 *		\li	-1 - Error during initialization
 *		\li >=0 - OK
 *
 *	Invoke this function to initialize BOOTP client. This will also trigger
 *	BOOTP address-fetching procedure.
 *
 */
INT8 bootpc_init (UINT8 mode)
{
	/* Already initialized?	*/

	if(bootp_app_init)
		return(1);

	/* Get socket handle		*/

	bootp.sochandle = udp_getsocket(0, bootpc_eventlistener, UDP_OPT_SEND_CS | UDP_OPT_CHECK_CS);

	if(bootp.sochandle < 0)
		return(-1);

	/* Put it to listening mode	*/

	if( udp_open(bootp.sochandle, BOOTP_CLIENTPORT) < 0 )
		return(-1);

	/* Get timer handle			*/

	bootp.tmrhandle = get_timer();
	bootp.bootsecs = 0;
	bootp.mode = mode;

	bootp.state = BOOTPC_STATE_DISABLED;


	bootp_app_init = 1;

	return(1);

}

/** \brief Stop BOOTP client operation
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 09.10.2002
 *
 *	Invoke this function to disable BOOTP client operation once it is not
 *	needed any more or just to temporarily suspend it's operation.
 */
void bootpc_stop (void){
	if(bootp_app_init == 0)
		return;

	bootp.state = BOOTPC_STATE_DISABLED;
}

/** \brief Enable BOOTP client operation
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 09.10.2002
 *
 *	Invoke this function to enable BOOTP client operation.
 *
 */
INT8 bootpc_enable (void){
	if(bootp_app_init == 0)
		return(-1);

	bootp.state = BOOTPC_STATE_ENABLED;

	return(1);

}


/** \brief BOOTP client main loop
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 07.10.2002
 *
 *	Main thread of the BOOTP client that should be invoked periodically.
 */
void bootpc_run (void)
{
	INT16 i;
	UINT8 buf[4];

	/* State machine	*/

	if(bootp_app_init == 0)
		return;

	switch(bootp.state) {
		case BOOTPC_STATE_ENABLED:

			/* Check the IP address of the device and start BOOTP procedure for getting	*/
			/* one if zero or 255.255.255.255											*/

			if( (localmachine.localip == 0) || (localmachine.localip == 0xFFFFFFFF) ) {
				/* We need to start BOOTP request procedure	*/
				/* Firstly wait random time					*/

				localmachine.localip = 0;
				localmachine.defgw = 0;
				localmachine.netmask = 0;

				init_timer(bootp.tmrhandle, ((UINT32)(localmachine.localHW[0]) << 2) + localmachine.localHW[1]);
				bootp.state = BOOTPC_STATE_REQUEST_NEEDED;
			}

			return;

		case BOOTPC_STATE_REQUEST_NEEDED:

			if( check_timer(bootp.tmrhandle) != 0 )
				return;

			/* Send request	*/

			if(localmachine.localip != 0){
				bootp.state = BOOTPC_STATE_ENABLED;
				return;

			}

			i = 0;

			net_buf[UDP_APP_OFFSET + i++] = 0x01;
			net_buf[UDP_APP_OFFSET + i++] = 0x01;
			net_buf[UDP_APP_OFFSET + i++] = 0x06;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0xCA;
			net_buf[UDP_APP_OFFSET + i++] = 0x03;
			net_buf[UDP_APP_OFFSET + i++] = 0x32;
			net_buf[UDP_APP_OFFSET + i++] = 0xF1;

			net_buf[UDP_APP_OFFSET + i++] = (UINT8)(bootp.bootsecs >> 8);
			net_buf[UDP_APP_OFFSET + i++] = (UINT8)bootp.bootsecs;

			net_buf[UDP_APP_OFFSET + i++] = 0x80;

			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;
			net_buf[UDP_APP_OFFSET + i++] = 0x00;

			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[5];
			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[4];
			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[3];
			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[2];
			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[1];
			net_buf[UDP_APP_OFFSET + i++] = localmachine.localHW[0];

			net_buf[UDP_APP_OFFSET + i++] = 99;
			net_buf[UDP_APP_OFFSET + i++] = 130;
			net_buf[UDP_APP_OFFSET + i++] = 83;
			net_buf[UDP_APP_OFFSET + i++] = 99;
			net_buf[UDP_APP_OFFSET + i++] = 255;

			for( ;i<300;i++)
				net_buf[UDP_APP_OFFSET + i] = 0;

			/* Send it	*/

			udp_send(bootp.sochandle, IP_BROADCAST_ADDRESS, BOOTP_SERVERPORT, &net_buf[UDP_APP_OFFSET], NETWORK_TX_BUFFER_SIZE - UDP_APP_OFFSET, 300);

			init_timer(bootp.tmrhandle, BOOTP_RETRY_TOUT*TIMERTIC);

			bootp.bootsecs += BOOTP_RETRY_TOUT*TIMERTIC;

			bootp.state = BOOTPC_STATE_WAITING_REPLY;

			return;

		case BOOTPC_STATE_WAITING_REPLY:

			/* Wait untill timeout elapsed and try again	*/

			if( check_timer(bootp.tmrhandle) != 0 )
				return;

			bootp.state = BOOTPC_STATE_REQUEST_NEEDED;

			return;

		case BOOTPC_STATE_REPLY_GET:
			/* parameters configured. Inspect state of bootp.mode
			 * and do something (if needed). Also turn BOOTP client
			 * on/off.
			 */

			return;


		default:

			return;
	}

}

/** \brief BOOTP event listener
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 07.10.2002
 *	\param cbhandle handle of the socket this packet is intended for.
 * 	\param event event that is notified. For UDP, only UDP_EVENT_DATA.
 * 	\param ipaddr IP address of remote host who sent the UDP datagram
 * 	\param port port number of remote host who sent the UDP datagram
 * 	\param buffindex buffer index in RTL8019AS
 *	\return
 *		\li - 1 - error in processing
 *		\li >0 - BOOTP reply successfully processed
 *	\note
 *		\li Event listeners are NOT to be invoked directly. They are
 *		callback functions invoked by the TCP/IP stack to notify events.
 *
 *	Analyze received UDP packet and see if it contains what we need. If
 *	yes, get new network settings.
 *
 */
INT32 bootpc_eventlistener (INT8 cbhandle, UINT8 event, UINT32 remip, UINT16 remport, UINT16 bufindex, UINT16 dlen) {
	INT16 i,j,k;
	UINT32 ip = 0;
	UINT32 nm = 0;
	UINT32 dgw = 0;
	UINT8 ch;


	/* This function is called by UDP stack to inform about events	*/

	if(bootp_app_init == 0)
		return(-1);

	if( cbhandle != bootp.sochandle)		/* Not our handle	*/
		return(-1);

	/* The only event is data	*/

	if(bootp.state != BOOTPC_STATE_WAITING_REPLY)
		return(-1);

	/* Process reply	*/

	NETWORK_RECEIVE_INITIALIZE(bufindex);

	if(dlen < 300)
		return(-1);

	if(	RECEIVE_NETWORK_B() != BOOTP_REPLY)
		return(-1);

	if(	RECEIVE_NETWORK_B() != BOOTP_HTYPE_ETHERNET)
		return(-1);

	if(	RECEIVE_NETWORK_B() != BOOTP_HWLEN_ETHERNET)
		return(-1);

	RECEIVE_NETWORK_B();		/* Skip hops	*/

	/* Check transaction ID	*/

	if(	RECEIVE_NETWORK_B() != 0xCA)
		return(-1);

	if(	RECEIVE_NETWORK_B() != 0x03)
		return(-1);

	if(	RECEIVE_NETWORK_B() != 0x32)
		return(-1);

	if(	RECEIVE_NETWORK_B() != 0xF1)
		return(-1);

	/* Skip elapsed, unused, client address	*/

	for(i=0; i<8; i++)
		RECEIVE_NETWORK_B();

	/* Get IP	*/

	ip = RECEIVE_NETWORK_B();
	ip <<= 8;
	ip |= RECEIVE_NETWORK_B();
	ip <<= 8;
	ip |= RECEIVE_NETWORK_B();
	ip <<= 8;
	ip |= RECEIVE_NETWORK_B();

	/* Skip server ip & bootp router address	*/

	for(i=0; i<8; i++)
		RECEIVE_NETWORK_B();

	/* Check MAC								*/

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[5])
		return(-1);

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[4])
		return(-1);

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[3])
		return(-1);

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[2])
		return(-1);

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[1])
		return(-1);

	if(	RECEIVE_NETWORK_B() != localmachine.localHW[0])
		return(-1);

	RECEIVE_NETWORK_B();
	RECEIVE_NETWORK_B();

	for(i=0; i<200; i++)
		RECEIVE_NETWORK_B();

	/* Check options	*/

	dlen -= 236;

	i = 0;

	while(i<dlen) {
		ch = RECEIVE_NETWORK_B();
		i++;

		if( (ch != BOOTP_OPTION_SUBNETMASK) && (ch != BOOTP_OPTION_DEFGW) )	{
			/* Not supported option, skip it	*/

			j = RECEIVE_NETWORK_B();
			i++;

			if(j >= 2) {
				j -= 2;

				while(j--) {
					RECEIVE_NETWORK_B();
					i++;
				}
			}

			continue;

		}

		if( ch == BOOTP_OPTION_SUBNETMASK) {
			RECEIVE_NETWORK_B();			/* Skip totlen	*/
			nm = RECEIVE_NETWORK_B();
			nm <<= 8;
			nm |= RECEIVE_NETWORK_B();
			nm <<= 8;
			nm |= RECEIVE_NETWORK_B();
			nm <<= 8;
			nm |= RECEIVE_NETWORK_B();

			i += 5;

		}

		if( ch == BOOTP_OPTION_DEFGW) {
			j = RECEIVE_NETWORK_B();		/* Get totlen	*/
			dgw = RECEIVE_NETWORK_B();
			dgw <<= 8;
			dgw |= RECEIVE_NETWORK_B();
			dgw <<= 8;
			dgw |= RECEIVE_NETWORK_B();
			dgw <<= 8;
			dgw |= RECEIVE_NETWORK_B();

			i += 5;

			/* Skip others	*/

			if( j>5 ) {
				j -= 5;

				while(j--) {
					RECEIVE_NETWORK_B();
					i++;
				}

			}

		}

	}

	/* Store parameters		*/

	localmachine.localip = ip;
	localmachine.defgw = dgw;
	localmachine.netmask = nm;

	/* Change state	*/

	bootp.state = BOOTPC_STATE_REPLY_GET;

	return(1);

}





