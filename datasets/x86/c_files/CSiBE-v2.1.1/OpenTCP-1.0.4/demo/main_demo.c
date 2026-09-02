/** \file main_demo.c
 *	\ingroup opentcp_example
 *	\brief This file shows an example of main loop of an app using OpenTCP
 *	\author Vladan Jovanovic (vladan.jovanovic@violasystems.com)
 *	\version 1.0
 *	\date 11.6.2002
 *	\bug
 *	\warning
 *	\todo
 *  
 *	This file shows an example main loop of an application using
 *	OpenTCP TCP/IP stack. This file should be used together with
 *	corresponding tcp_client_demo.c, tcp_server_demo.c and udp_demo.c
 *	files.
 */
#include <inet/debug.h>
#include <inet/debug.h>
#include <inet/arch/config.h>
#include <inet/datatypes.h>
#include <inet/timers.h>
#include <inet/system.h>
#include <inet/ethernet.h>
#include <inet/ip.h>
#include <inet/tcp_ip.h>

/* Network Interface definition. Must be somewhere so why not here? :-)*/
struct netif localmachine;

/* main stuff */
void main(void)
{
	UINT16 len;
	
	/* initialize processor-dependant stuff (I/O ports, timers...).
	 * This will normally be some function under the arch/xxxMCU dir. Most
	 * important things to do in this function as far as the TCP/IP stack
	 * is concerned is to:
	 *  - initialize some timer so it executes decrement_timers
	 * 	on every 10ms (TODO: Throw out this dependency from several files
	 *	so that frequency can be adjusted more freely!!!)
	 *  - not mess too much with ports allocated for Ethernet controller
	 */
	init();
	 
    	/* Set our network information. This is for static configuration.
     	* if using BOOTP or DHCP this will be a bit different.
     	*/
   	
   	/* IP address */
    	localmachine.localip = 0xAC1006E9;	/* 172.16.6.233	*/
    	/* Default gateway */
    	localmachine.defgw =	0xAC100101;
    	/* Subnet mask */
    	localmachine.netmask = 0xFFFF0000;
    	/* Ethernet (MAC) address */
    	localmachine.localHW[5] = 0x00;
    	localmachine.localHW[4] = 0x06;
    	localmachine.localHW[3]	= 0x70;
    	localmachine.localHW[2]	= 0xBA;
    	localmachine.localHW[1]	= 0xBE;
    	localmachine.localHW[0]	= 0xEE;
   	

	/* Init system services		*/    
	timer_pool_init();
		
    	/*interrupts can be enabled AFTER timer pool has been initialized */
    	
    	/* Initialize all network layers	*/
    	NE2000Init(&localmachine.localHW[0]);
    	arp_init();
    	udp_init();
    	tcp_init();

	/* Initialize applications	*/
	udp_demo_init();
	tpcc_demo_init();
	tcps_demo_init();
    

  	DEBUGOUT(">>>>>>>>>Entering to MAIN LOOP>>>>>>>>>\n\r");
  
    	/***	MAIN LOOP	***/
    
    	while(1) {
		/* take care of watchdog stuff */
			
		/* do some stuff here
	 	* .........
	 	*/
	 
	     
    		/* Try to receive Ethernet Frame	*/
    	
    		if( NETWORK_CHECK_IF_RECEIVED() == TRUE )	{
    		   		
    			switch( received_frame.protocol) {
    			
    				case PROTOCOL_ARP:
    					process_arp(&received_frame);	
		    			break;
    			
    			
    				case PROTOCOL_IP:   			
    					len = process_ip_in(&received_frame);
    				
    					if(len < 0)
    						break;
    				
    					switch(received_ip_packet.protocol){
    						case IP_ICMP:
	    						process_icmp_in (&received_ip_packet, len);    					
    							break;
    						case IP_UDP:
    							process_udp_in (&received_ip_packet,len);
    							break;
    						case IP_TCP:
	    						process_tcp_in (&received_ip_packet, len);				
    							break;
    						default:
							break;
					}
    			break;

    			default:
    			
    				break;
    		}
		
		/* discard received frame */    		
    		NETWORK_RECEIVE_END();
    	}
    	 
    	/* Application main loops */
    	/* Do not forget this!!! These don't get invoked magically :-) */
    	udp_demo_run();
    	tcpc_demo_run();
    	tcps_demo_run();
    	

    	/* TCP/IP stack Periodic tasks	*/
  	/* Check possible overflow in Ethernet controller */
    	NE2000CheckOverFlow();
    	/* manage arp cache tables */
    	arp_manage();
    	/* manage opened TCP connections (retransmissions, timeouts,...)*/
    	tcp_poll();
    }
    
}

