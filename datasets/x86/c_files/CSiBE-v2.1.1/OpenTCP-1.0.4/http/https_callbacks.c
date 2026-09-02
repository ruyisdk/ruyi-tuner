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

/** \file https_callbacks.c
 *	\brief HTTP server callback functions
 *	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\version 1.0
 *	\date 9.10.2002
 *  \bug
 *	\warning
 *	\todo
 *
 *	This file holds definitions and descriptions of HTTP callback functions
 *	that will be overridden by user code. These callback functions are 
 *	invoked by HTTP server to get a feedback from the part of HTTP server
 *	who's behaviour is defined by the user application.
 */ 
#include<inet/datatypes.h>
#include<inet/debug.h>
#include<inet/globalvariables.h>
#include<inet/system.h>
#include<inet/http/http_server.h>


/** \brief File not found message
 *
 *	Message that will be displayed if a file with appropriate name (hash
 *	value) was not found.
 */
const char https_not_found_page[] = "HTTP/1.0 200 OK\r\n"
"Last-modified: Fri, 18 Oct 2002 12:04:32 GMT\r\n"
"Server: ESERV-10/1.0\nContent-type: text/html\r\n"
"Content-length: 400\r\n"
"\r\n"
"<HEAD>"
"<TITLE>Viola Systems Embedded WEB Server</TITLE></HEAD>"
"<BODY>"
"<H2>HTTP 1.0 404 Error. File Not Found</H2>"
"The requested URL was not found on this server."
"<HR>"
"<BR>"
"<I>"
"Viola Systems Embedded WEB Server 2.0, 2002"
"<BR>"
"Web Server for Embedded Applications"
"</I>"
"<BR>"
"<A HREF=http://www.violasystems.com>"
"www.violasystems.com - Embedding The Internet</A>"
"</BODY>";

/** \brief Brief function description here
 * 	\author 
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 09.10.2002
 *	\param hash Calculated file-name hash value. Used so that the whole
 *		file name doesn't need to be stored in RAM
 *	\param ses HTTP session identifier
 *	\return
 *		\li -1 - This function should return -1 if no file has been found
 *		\li 1 - This function should return 1 if a file with appropriate
 *			hash value has been found.
 *	\warning
 *		\li This function <b>MUST</b> be implemented by user application
 *		to work with local configuration
 *
 *	This function is invoked by the HTTP server once a hash value of a 
 *	requested file name has been calculated. User application uses this
 *	hash value to check if appropriate file is available to web server.
 *	Appropriate https session entry is then filled accordingly.	
 *
 */
INT16 https_findfile (UINT8 hash, UINT8 ses)
{
	/* Access the File table on FLASH with given hash key	*/
	/* and modify session File parametera					*/
	
	
	/* 
	if( file_not_found )
	{
		File not found, initialize return message
					
		https[ses].fstart = 0xFFFFFFFF;
		https[ses].funacked  = 0;
		https[ses].flen = strlen(&https_not_found_page[0], 1000);
		https[ses].fpoint = 0;
		
		return(-1);
	}
	*/
	
	/* OK, file found. */	
	/* Modify structure	
	https[ses].fstart = file start address;
	https[ses].flen = file length;
	https[ses].fpoint = current pointer within the file
	https[ses].funacked = 0;	no unacked data for now
	*/
	return(1);  
	
}

/** \brief Fill network transmit buffer with HTTP headers&data
 * 	\author
 *		\li Jari Lahti (jari.lahti@violasystems.com)
 *	\date 09.10.2002
 *	\param ses HTTP session identifier
 *	\param buf Pointer to buffer where data is to be stored
 *	\param buflen Length of the buffer in bytes
 *	\return
 *		\li >=0 - Number of bytes written to buffer
 *	\warning 
 *		\li This function <b>MUST</b> be implemented by user application
 *		to work with local configuration
 *
 *	This handlers' job is to fill the buffer with the data that web server
 *	should return back through the TCP connection. This is accomplished
 *	based session identifer and values of variables in appropriate
 *	https entry.
 */
INT16 https_loadbuffer (UINT8 ses, UINT8* buf, UINT16 buflen) {
	UINT16 i;
	
	if( https[ses].fstart == 0xFFFFFFFF )
	{
		/* Error site asked	*/
		
		kick_WD();
		
		for(i=0; i < (https[ses].flen - https[ses].fpoint); i++)
		{
			if(i >= buflen)
				break;
		
			*buf++ = https_not_found_page[https[ses].fpoint + i];
		
		}
		
		return(i);
	
	}
	
	/* Access some storage media (internal/external flash...)*/
	
	for(i=0; i < (https[ses].flen - https[ses].fpoint); i++)
	{
		if(i >= buflen)
			break;	
		
		kick_WD();
		/*
		
		*buf++ = next_data_byte(...);
		
		*/
		
	
	}
	
	return(i);
	


}
