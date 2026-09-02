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

/** \file tftps.h
 *	\brief OpenTCP TFTP server interface file
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 7.10.2002
 * 	
 *	OpenTCP TFTP server protocol function declarations, constants, etc.
 */

#ifndef INCLUDE_TFTPS_H
#define INCLUDE_TFTPS_H

#include <inet/datatypes.h>

/* User defined	*/

/** \def TFTPS_SERVERPORT
 *	\brief Default server port for TFTP server
 *
 *	TFTP server will use this UDP port to listen for incoming traffic.
 */
#define TFTPS_SERVERPORT		69

/** \def TFTPS_FILENAME_MAXLEN
 *	\brief Maximum filename allowed by the TFTP server
 *
 *	Maximum filename-length TFTP server is ready to process.	
 */
#define TFTPS_FILENAME_MAXLEN	20

/** \def TFTPS_DEF_RETRIES
 *	\brief Default number of retries of TFTP server
 *
 *	Number of retries of resending the data before aborting.
 */
#define TFTPS_DEF_RETRIES		4

/** \def TFTPS_TIMEOUT
 *	\brief Timeout (in seconds) after which socket is deleted
 *
 *	
 */
#define TFTPS_TIMEOUT			20		/* Secs	*/


/* Prototypes	*/

INT8 tftps_init(void);
void tftps_run(void);
INT32 tftps_eventlistener(INT8, UINT8, UINT32, UINT16, UINT16, UINT16);
void tftps_sendack(void);
void tftps_senderror(UINT8);
void tftps_deletesocket(void);

#endif
