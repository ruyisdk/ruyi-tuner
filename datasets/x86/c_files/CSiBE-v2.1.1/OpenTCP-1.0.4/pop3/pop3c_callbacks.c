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

/** \file pop3c_callbacks.c
 *	\brief OpenTCP POP3 callback functions
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 11.9.2002
 *	\bug
 *	\warning
 *	\todo
 *  
 *	This file holds empty callback functions needed by the POP3 client
 *	to get user-specific e-mail data from the application. Add your own
 *	code to perform the requested tasks.
 *
 */

#include <inet/debug.h>
#include <inet/datatypes.h>
#include <inet/pop3/pop3_client.h>

/** \brief POP3 client error handler
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *
 *	This callback function is called by POP3 Client when there 
 *	happens error of some kind (timeout, losing of connection etc.).
 */
void pop3c_error (void){


}

/** \brief Invoked to inform user app about the number of new e-mails
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *	\param msgs Number of new e-mails waiting on the server
 *
 *	This callback function is called by POP3 Client in order to 
 *	indicate the number of new E-mails on server.
 */
void pop3c_messages (UINT16 msgs){

}

/** \brief Offers e-mail message to the user app
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *	\param index index number of message
 *	\param msglen Length of message data
 *	\param from Buffer containing sender (null terminated string)
 *	\param subject Buffer containing subject (null terminated string)
 *	\return
 *		\li -2 - Reject the e-mail (delete from server)
 *		\li -1 - Skip the e-mail (leave it on server)
 *		\li >=0 - Read and delete the mail from server
 *
 *	This callback function is called by POP3 Client in order to 
 *	offer the e-mail message to user. User can reject this mail, 
 *	skip this, mail or read it as indicated with return value
 */
INT16 pop3c_msgoffer (UINT16 index, UINT32 msglen, UINT8* from, UINT8* subject){
	return(-1); 
}

/** \brief Get user name that is to be used for loging to the server
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *	\param dbuf Pointer to buffer to which the username will be stored
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by POP3 Client when it wants
 *	to know the username of us. The user is responsible of 
 *	storing that name to destbuf without NULL termination ('\0') 
 * and returning number of bytes on that username.
 */
INT8 pop3c_getusername (UINT8* dbuf){
	
	
}


/** \brief Get password that is to be used for loging to the server
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 11.09.2002
 *	\param dbuf Pointer to buffer to which the password will be stored
 *	\return
 *		\li -1 - Error
 *		\li >0 - Number of bytes inserted
 *
 *	This callback function is called by POP3 Client when it wants
 *	to know the password of us. The user is responsible of 
 *	storing that name to destbuf without NULL termination ('\0') 
 *	and returning number of bytes on the password.
 */
INT8 pop3c_getpassword (UINT8* dbuf){
	

}


/** \brief Indicates succesfull reading of E-mails
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 14.10.2002
 *
 *	This callback function is called by POP3 Client to indicate 
 *	succesfull reading of E-mails
 */
void pop3c_allok (void){

}


/** \brief Receives E-mail data
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 14.10.2002
 *	\param data E-mail data as received by POP3 client
 *
 *	This callback function is called by POP3 Client in order to 
 *	give data to application
 */
void pop3c_data (UINT8 data){


}
