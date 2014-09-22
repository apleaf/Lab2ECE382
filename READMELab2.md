Lab2ECE382
==========

##Lab 2 Encrpytion Assembly Program for MSP430

Purpose:  
The purpose of this lab was to take in an encrpyted string of bytes of an unknown length, and XOR each encrypted byte in the message with the correct corresponding byte in the decryption key.  XORing the encrpyted message with the key decrpyted the message and stored the decrpyted message starting at memory location 0x0200.  In the lab we were to use two subroutines, one taking in values through pass-by-reference, and the other taking in the values through pass-by-value. Completing the lab proved we had a basic understanding of the two ways to pass parameters to subroutines, and also an understanding of how to use subroutines correctly.    

###Flow Chart and Pseudocode
![alt text](http://i60.tinypic.com/21cf23k.jpg)

###Coding:
The assembly program first stored the encrypted message and key in ROM, allocated space in RAM for the decrypted message to be stored, and stored values for the lengths of the message and key. The program started by calling the first subroutine, "decryptMessage."  The "decryptMessage" subroutine accepted the address of the encrypted message, address of the key, address where the decrypted message was to be stored, and stored the memory location for each of those in a register. This subroutine also took in the actual values for the length of the key and the length of the message and stored thsoe two values each in a register also. The subroutine performed a compare to check if it reached the end of the message.  If it had not reached the end of the message, the subroutine "decryptCharacter" was called.  In "decryptCharacter" the invidual values stored in the memory locations talked about in the previous subroutine for the encrypted message and the key are XORed together.  That value is stored in a register and the key is incremented to the next byte in the key.  The subroutine then returns to the location it was originally called, meaning we return from "decryptCharacter" back to the "decryptMessage" subroutine.  The XOR'ed result is then stored in RAM, and the encrpyted message pointer is incremented to point to the next byte in the encrypted message.  The counter to check when the message is decremented, and the program performs the check again to see if it has reached the end of the encrypted message.  When the end of the encrypted message is reached, the program jumps to an infinite loop. 

###Debugging:
I could not get my program to correctly store the XORed values at the correct location in memory.  After some testing, I realized that I was not referencing the correct register when I was storing the values.  After correcting my code to use the correct register, my program worked.

###Testing Methodology/results:
To test my program, I ran the given encrypted messages with their respective keys for the requiered functionality and B functionality.

Required functionality used a key of 1 byte in length, and the B functionality used a key 3 bytes in length.

##Required Functionality: 

Given Encrpyted Message: 0xef,0xc3,0xc2,0xcb,0xde,0xcd,0xd8,0xd9,0xc0,0xcd,0xd8,0xc5,0xc3,0xc2,0xdf,0x8d,0x8c,0x8c,0xf5,0xc3,0xd9,0x8c,0xc8,0xc9,0xcf,0xde,0xd5,0xdc,0xd8,0xc9,0xc8,0x8c,0xd8,0xc4,0xc9,0x8c,0xe9,0xef,0xe9,0x9f,0x94,0x9e,0x8c,0xc4,0xc5,0xc8,0xc8,0xc9,0xc2,0x8c,0xc1,0xc9,0xdf,0xdf,0xcd,0xcb,0xc9,0x8c,0xcd,0xc2,0xc8,0x8c,0xcd,0xcf,0xc4,0xc5,0xc9,0xda,0xc9,0xc8,0x8c,0xde,0xc9,0xdd,0xd9,0xc5,0xde,0xc9,0xc8,0x8c,0xca,0xd9,0xc2,0xcf,0xd8,0xc5,0xc3,0xc2,0xcd,0xc0,0xc5,0xd8,0xd5,0x8f

Given Key: 0xac

Key Length: 0x01

Message Length: 0x5e

Decrpyted Message:
C	o	n	g	r	a	t	u
l	a	t	i	o	n	s	!
.	.	Y	o	u	.	d	e
c	r	y	p	t	e	d	.
t	h	e	.	E	C	E	3
8	2	.	h	i	d	d	e
n	.	m	e	s	s	a	g
e	.	a	n	d	.	a	c
h	i	e	v	e	d	.	r
e	q	u	i	r	e	d	.
f	u	n	c	t	i	o	n
a	l	i	t	y	#


##B Functionality: 

Given Encrpyted Message: 0xf8,0xb7,0x46,0x8c,0xb2,0x46,0xdf,0xac,0x42,0xcb,0xba,0x03,0xc7,0xba,0x5a,0x8c,0xb3,0x46,0xc2,0xb8,0x57,0xc4,0xff,0x4a,0xdf,0xff,0x12,0x9a,0xff,0x41,0xc5,0xab,0x50,0x82,0xff,0x03,0xe5,0xab,0x03,0xc3,0xb1,0x4f,0xd5,0xff,0x40,0xc3,0xb1,0x57,0xcd,0xb6,0x4d,0xdf,0xff,0x4f,0xc9,0xab,0x57,0xc9,0xad,0x50,0x80,0xff,0x53,0xc9,0xad,0x4a,0xc3,0xbb,0x50,0x80,0xff,0x42,0xc2,0xbb,0x03,0xdf,0xaf,0x42,0xcf,0xba,0x50,0x8f

Given Key: 0xacdf23

Key Length: 0x03

Message Length: 0x52

Decrpyted Message:
T	h	e	.	m	e	s	s
a	g	e	.	k	e	y	.
l	e	n	g	t	h	.	i
s	.	1	6	.	b	i	t
s	.	.	.	I	t	.	o
n	l	y	.	c	o	n	t
a	i	n	s	.	l	e	t
t	e	r	s	,	.	p	e
r	i	o	d	s	,	.	a
n	d	.	s	p	a	c	e
s	#	.	.	.	.	.	.

My program successfully decrpyted the given messages for requiered functionality and B functionality.

###Observations/Conclusions: 
In conslusion of the lab, I was successful in creating an assembly program to decrypt a message with an arbitrarily long key and store the decrypted message in RAM.

###Documentation: 
None





