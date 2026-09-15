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

/** \file smtp_client.h
 *	\brief OpenTCP SMTP client interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 9.8.2002
 * 	
 *	OpenTCP SMTP client function declarations, constants, etc.
 */

#ifndef INCLUDE_SMTP_CLIENT_H
#define INCLUDE_SMTP_CLIENT_H

#include<inet/datatypes.h> 

/* SMTPC timeout		*/

#define SMTPC_TOUT		20				/**< SMTP clients' timeout in seconds	*/



/* States of SMTP state machine	*/


#define SMTP_UNINITIALIZED			1	/**< SMTP Client state: Not initialized yet					*/
#define SMTP_CLOSED					2	/**< SMTP Client state: TCP connection closed				*/
#define SMTP_OPEN_REQUESTED			3	/**< SMTP Client state: User has requested mail read			*/
#define SMTP_CONNECTIONOPEN_SENT	4	/**< SMTP Client state: TCP connection request sent			*/
#define SMTP_CONNECTION_OPENED		5	/**< SMTP Client state: TCP Connection opened				*/
#define SMTP_SERVER_READY			6	/**< SMTP Client state: SMTP server has indicated 220		*/
#define SMTP_HELO_SENT				7	/**< SMTP Client state: HELO sent by us						*/
#define SMTP_HELO_ACKED				8	/**< SMTP Client state: Server has acked HELO by 250			*/
#define SMTP_MAILFROM_SENT			9	/**< SMTP Client state: MAIL FROM sent by us					*/
#define SMTP_MAILFROM_ACKED			10	/**< SMTP Client state: Server has acked MAIL FROM by 250	*/
#define SMTP_RCPTTO_SENT			11	/**< SMTP Client state: RCPT To sent by us					*/
#define SMTP_RCPTTO_ACKED			12	/**< SMTP Client state: Server has acked RCPT TO by 250		*/
#define SMTP_DATAREQ_SENT			13	/**< SMTP Client state: DATA sent by us						*/
#define SMTP_DATAREQ_ACKED			14	/**< SMTP Client state: Server has acked DATA by 354			*/
#define SMTP_BODY_SENT				15	/**< SMTP Client state: We have sent RFC822 body				*/
#define SMTP_SENDING_DATA			16	/**< SMTP Client state: We are sending data...				*/
#define SMTP_DATAEND_REACHED		17	/**< SMTP Client state: We have no more data					*/
#define SMTP_DATAEND_SENT			18	/**< SMTP Client state: CRLF.CRLF sent by us					*/
#define SMTP_DATAEND_ACKED			19	/**< SMTP Client state: Server has acked CRLF.CRLF by 250	*/
#define SMTP_QUIT_SENT				20	/**< SMTP Client state: QUIT sent by us						*/
#define SMTP_QUIT_ACKED				21	/**< SMTP Client state: Server has acked quit by 221			*/


/* SMTP Server replies	*/

#define SMTP_CMD_SERVER_READY	'2' + '2' + '0'		/**< Server outputs when connected	*/
#define SMTP_CMD_OK				'2' + '5' + '0'		/**< Command executed OK				*/
#define SMTP_CMD_DATAOK			'3' + '5' + '4'		/**< OK to send data					*/
#define SMTP_CMD_QUITOK			'2' + '2' + '1'		/**< OK to quit, close connection		*/



/* Function prototypes	(internal)	*/

INT8 smtpc_connect(UINT32, UINT16);
void smtpc_init(void);
INT32 smtpc_eventlistener(INT8, UINT8, UINT32, UINT32);
void smtpc_run(void);
UINT8 smtpc_getstate(void);
void smtpc_sendhelo(void);
void smtpc_sendmailfrom(void);
void smtpc_sendrcptto(void);
void smtpc_senddatareq(void);
void smtpc_sendbody(void);
void smtpc_senddataend(void);
void smtpc_sendquit(void);
INT16 smtpc_senddata(void);
void smtpc_changestate(UINT8);


/* Function prototypes (callbacks)	*/
INT8 smtpc_getdomain(UINT8*);
INT8 smtpc_getsender(UINT8*);
INT8 smtpc_getreceiver(UINT8*);
INT8 smtpc_getsubject(UINT8*);
INT16 smtpc_getdata(UINT8*, UINT16);
void smtpc_dataacked(void);
void smtpc_error(void);
void smtpc_allok(void);


#endif
