;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;Alex Leaf
;ECE 382
;Lab 2 Message Decryptor
;22 September 2014-----------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs

                            ; Additionally retain any sections
                                            ; that have references to current
                                            ; section


encrypt: .byte 0xf8,0xb7,0x46,0x8c,0xb2,0x46,0xdf,0xac,0x42,0xcb,0xba,0x03,0xc7,0xba,0x5a,0x8c,0xb3,0x46,0xc2,0xb8,0x57,0xc4,0xff,0x4a,0xdf,0xff,0x12,0x9a,0xff,0x41,0xc5,0xab,0x50,0x82,0xff,0x03,0xe5,0xab,0x03,0xc3,0xb1,0x4f,0xd5,0xff,0x40,0xc3,0xb1,0x57,0xcd,0xb6,0x4d,0xdf,0xff,0x4f,0xc9,0xab,0x57,0xc9,0xad,0x50,0x80,0xff,0x53,0xc9,0xad,0x4a,0xc3,0xbb,0x50,0x80,0xff,0x42,0xc2,0xbb,0x03,0xdf,0xaf,0x42,0xcf,0xba,0x50,0x8f    ;
key:     .byte 0xac, 0xdf, 0x23           ; load registers with necessary info for decryptMessage here
messageLength: .byte 0x52					;b function length is 82(52 in hex), a is 94 (5E in hex)
keyLength: .byte 0x03						;b function length is 3, a length is 1
			.data

decrypt:     .space 200

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------



            call    #decryptMessage

forever:    jmp     forever

;-------------------------------------------------------------------------------
                                            ; Subroutines
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;Subroutine Name: decryptMessage
;Author:
;Function: Decrypts a string of bytes and stores the result in memory.  Accepts
;           the address of the encrypted message, address of the key, and address
;           of the decrypted message (pass-by-reference).  Accepts the length of
;           the message by value.  Uses the decryptCharacter subroutine to decrypt
;           each byte of the message.  Stores theresults to the decrypted message
;           location.

;-------------------------------------------------------------------------------

decryptMessage: mov.w #encrypt, r4               ;taking in the values using the pass by reference technique
				mov.w #key, r11
				mov.w #decrypt, r10
				mov.w #keyLength, r12
				mov.w #messageLength, r13
				mov.b @r12, r12						;taking in the values using the pass by value technique
				mov.b @r13, r13

loop:
				cmp.b #1, r13						;counter to check when at end of message
				jn end
				call #decryptCharacter				;calls subroutine
				mov.b r5, 0(r10)
				inc r10
				dec.b r13
				jmp loop
end





            ret

;-------------------------------------------------------------------------------
;Subroutine Name: decryptCharacter
;Author:
;Function: Decrypts a byte of data by XORing it with a key byte.  Returns the
;           decrypted byte in the same register the encrypted byte was passed in.
;           Expects both the encrypted data and key to be passed by value.
;Inputs:
;Outputs:
;Registers destroyed:
;-------------------------------------------------------------------------------

decryptCharacter:
				 mov.b @r11+, r9
				 mov.b @r4+, r5
				 xor.b r9, r5							;XORs encrypted message with key
				 cmp.b #1, r12
				 jz resetKeyPointer
				 dec.b r12
				 ret

resetKeyPointer: mov.w #key, r11						;when reaches end of key, points back to first byte to start iteration again
				 mov.w #keyLength, r12
				 mov.b @r12, r12






            ret


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect    .stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
