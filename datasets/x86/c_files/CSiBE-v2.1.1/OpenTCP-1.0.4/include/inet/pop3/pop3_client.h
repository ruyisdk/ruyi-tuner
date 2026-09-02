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
 
/** \file pop3_client.h
 *	\brief OpenTCP POP3 client interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 20.8.2002
 * 	
 *	OpenTCP POP3 function declarations, constants, etc.
 */

#ifndef INCLUDE_POP3_CLIENT_H
#define INCLUDE_POP3_CLIENT_H

#include<inet/datatypes.h>

#define POP3C_SENDERMAXLEN	30		/**< Maximum length for senders' e-mail
									 *	 address including '\0'	
									 */
#define POP3C_SUBJECTMAXLEN	30		/**< Maximum length of the subject
						              *  field including '\0'	
						              */

#define POP3C_TOUT			20	/**< POP3 client timeout in secs*/

/** \struct pop3c_struct pop3_client.h
 *	\brief	POP3 client structure
 *
 *	As expected this structure holds the fields that are needed for proper
 *	operation of the POP3 client. Refer to documentation of the fields to 
 *	get more information about them.
 */
struct pop3c_struct
{
	UINT8 state;						/**< State of POP3 client state machine	*/
	UINT32 remip;						/**< Remote IP of POP3 server				*/
	UINT16 remport;						/**< Remote port of POP3 server				*/
	INT8 sochandle;						/**< Handle to TCP socket					*/
	UINT8 tmrhandle;					/**< Handle to timer						*/
	UINT8 unacked;						/**< Do we have unacked data or not?		*/
	UINT16 msgtotal;					/**< Number of messages in message box	*/
	UINT16 curmsgindex;					/**< Index of current message				*/
	UINT32 curmsgtotlen;				/**< Total length of current message		*/
	UINT16 curmsghlen;					/**< Header length of current message		*/
	UINT8 headerbuf[9];					/**< Used to parse from,to,subject			*/	
	UINT8 charsinheaderbuf;				/**< Number of valid chars in headerbuf	*/
	UINT8 from[POP3C_SENDERMAXLEN];		/**< Sender of E-mail						*/
	UINT8 subject[POP3C_SUBJECTMAXLEN];	/**< Subject of E-mail						*/
	
};


/* POP3 States				*/

#define POP3C_UNINITIALIZED			1	/**< POP3 state: Not initialized yet	*/
#define POP3C_CLOSED				2	/**< POP3 state: TCP connection closed				*/
#define POP3C_OPEN_REQUESTED		3	/**< POP3 state: User has requested mail read			*/
#define POP3C_CONNECTIONOPEN_SENT	4	/**< POP3 state: TCP connection request sent			*/
#define POP3C_CONNECTION_OPENED		5	/**< POP3 state: TCP Connection opened				*/
#define POP3C_SERVER_READY			6	/**< POP3 state: POP3 server has indicated +OK		*/
#define POP3C_USERNAME_SENT			7	/**< POP3 state: USER sent by us						*/
#define POP3C_USERNAME_ACKED		8	/**< POP3 state: Server answered username +OK			*/
#define POP3C_PASSWORD_SENT			9	/**< POP3 state: PASS sent by us						*/
#define POP3C_PASSWORD_ACKED		10	/**< POP3 state: Server answered password +OK			*/
#define POP3C_STAT_SENT				11	/**< POP3 state: STAT sent by us						*/
#define POP3C_STAT_GET				12	/**< POP3 state: Server has answered how many messages*/
#define POP3C_LIST_SENT				13	/**< POP3 state: LIST sent by us						*/
#define POP3C_LIST_GET				14	/**< POP3 state: Server has repld. with the len of msg*/
#define POP3C_TOP0_SENT				15	/**< POP3 state: TOP x 0 sent by us					*/
#define POP3C_RECEIVING_HEADER		16	/**< POP3 state: We are receiving header				*/
#define POP3C_RECEIVING_HDR_FROM	17	/**< POP3 state: We are parsing 'from:' 				*/
#define POP3C_RECEIVING_HDR_SUBJ	18	/**< POP3 state: We are parsing 'subject:'			*/
#define POP3C_TOP0_GET				19	/**< POP3 state: Server has replied with header	 	*/
#define POP3C_RETR_SENT				20	/**< POP3 state: RETR sent by us						*/
#define POP3C_RECEIVING_MSG_HEADER	21	/**< POP3 state: We are reading the message header	*/
#define POP3C_RECEIVING_MSG			22	/**< POP3 state: Receiving the message */
#define POP3C_MESSAGE_RECEIVED		23  /**< POP3 state: Received the message */
#define POP3C_DELE_SENT				24	/**< POP3 state: DELE sent by us						*/
#define POP3C_DELE_ACKED			25	/**< POP3 state: Server has replied dele +OK			*/
#define POP3C_QUIT_SENT				26	/**< POP3 state: QUIT sent by us						*/
#define POP3C_QUIT_ACKED			27	/**< POP3 state: Server has replied quit +OK			*/

#define POP3C_OK	'+' 


/* Function prototypes (internal)	*/

INT8 pop3c_connect(UINT32, UINT16);
void pop3c_init(void);
UINT8 pop3c_getstate(void);
INT32 pop3c_eventlistener(INT8, UINT8, UINT32, UINT32);
void pop3c_run(void);
void pop3c_senduser(void);
void pop3c_sendpassword(void);
void pop3c_sendstat(void);
void pop3c_sendlist(UINT16);
void pop3c_sendtop(UINT16);
void pop3c_sendretr(UINT16);
void pop3c_senddele(UINT16);
void pop3c_sendquit(void);
void pop3c_changestate(UINT8);
INT16 pop3c_parsestat(void);
INT16 pop3c_parselist(void);



/* Function prototypes (callbacks, external)	*/

void pop3c_error(void);
void pop3c_data(UINT8);
void pop3c_allok(void);
void pop3c_messages(UINT16);
INT16 pop3c_msgoffer(UINT16, UINT32, UINT8*, UINT8*);
INT8 pop3c_getusername(UINT8*);
INT8 pop3c_getpassword(UINT8*);

#endif
