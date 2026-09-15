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

/** \file smtpc_callbacks.c
 *	\brief OpenTCP SMTP callback functions
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 11.9.2002
 *	\bug
 *	\warning
 *	\todo
 *  
 *	This file holds empty callback functions needed by the SMTP client
 *	to get user-specific e-mail data from the application. Add your own
 *	code to perform the requested tasks.
 *
 */

#include <inet/datatypes.h>
#include <inet/smtp/smtp_client.h>



/** \brief SMTP client error handler
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 20.08.2002
 *
 *	This callback function is called by SMTP Client when there 
 *	happens error of some kind (timeout, losing of connection etc.). It 
 *	indicates that e-mail was not delivered to server.
 */
void smtpc_error (void){


}



/** \brief SMTP client success handler
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *
 *	This callback function is called by SMTP Client when the packet
 *	is succesfully delivered to E-mail server.
 */
void smtpc_allok (void)
{


}


/** \brief Fills in local domain information
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param dbuf pointer to buffer to which the domain name will be stored
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by SMTP Client when it wants
 *	to know the local domain. The user is responsible of storing that
 *	domain to destbuf without NULL termination ('\0') and returning
 *	number of bytes on domain.
 */
INT8 smtpc_getdomain (UINT8* dbuf){

}

 
/** \brief Returns senders' e-mail address
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param dbuf pointer to buffer to which the sender will be stored
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by SMTP Client when it wants
 *	to know the E-mail address of sender. The user is responsible of 
 *	storing that address to destbuf without NULL termination ('\0') 
 *	and returning number of bytes on E-mail address.
 */
INT8 smtpc_getsender (UINT8* dbuf){

}



/** \brief Returns receivers' e-mail address
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param dbuf pointer to buffer to which the receiver will be stored
 *	\return 
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by SMTP Client when it wants
 *	to know the E-mail address of receiver. The user is responsible of 
 *	storing that address to destbuf without NULL termination ('\0') 
 *	and returning number of bytes on E-mail address.
 */
INT8 smtpc_getreceiver (UINT8* dbuf){


}

/** \brief Returns subject of the E-mail
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param dbuf pointer to buffer to which the subject will be stored
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by SMTP Client when it wants
 *	to know the subject of E-mail to be sent. The user is responsible 
 *	of storing subject to destbuf without NULL termination ('\0') 
 *	and returning number of bytes inserted.
 */
INT8 smtpc_getsubject (UINT8* dbuf){
	

}


/** \brief Returns e-mail data (message) to be sent
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *	\param dbuf pointer to buffer to which the data will be stored
 *	\param buflen length of data buffer
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by SMTP Client when it wants
 *	to get mail plain data from user. The user is responsible of 
 *	filling dbuf and returning number of bytes assembled. When data
 *	end is reached the function must return (-1) without storing
 *	any bytes to buffer (so just send data untill you don't have
 *	any bytes to sent when callback is made to that function and 
 *	return -1). Do not move read pointer of your data forward before
 *	SMTP makes callback to smtpc_dataacked!
 */
INT16 smtpc_getdata (UINT8* dbuf, UINT16 buflen){


}


/** \brief Last data received by remote host
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 12.08.2002
 *
 *	This callback function is called by SMTP Client when TCP has
 *	ensured that the last packet was transmitted succesfully and
 *	next time when smtpc_getdata callback is made new data should be 
 *	assembled
 */
void smtpc_dataacked (void){

}

