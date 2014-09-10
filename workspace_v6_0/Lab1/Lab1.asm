;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text


function:   .byte 0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33, 0x00, 0x44, 0x33, 0x33, 0x08, 0x55
add:        .byte 0x11
sub:        .byte 0x22
mul:        .byte 0x33
clr:        .byte 0x44
end:        .byte 0x55
big:        .byte 0xFF	                ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
            .data
.space
result:     .space 50

                                             ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                                   ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
           			mov.w #function, r4
           			mov.w #result, r8
		 			mov.b @r4+, r5
           			mov.b @r4+, r6
           			mov.b big, r13
           			jmp firstIteration

checkForOperation	mov.b @r10, r5
					mov.b @r4+, r6
					mov.w @r8, r10
					inc r8
					jmp firstIteration

ifCleared			mov.b @r4+, r5
           			mov.b @r4+, r6
					mov.w @r8, r10
					inc r8


firstIteration		cmp.b end, r6
					jz endProgram

					cmp.b clr, r6
					jz clrFunction

					cmp.b add, r6
					jz         addFunction

					cmp.b sub, r6
					jz         subFunction

					cmp.b mul, r6
					jz mulFunction




addFunction         mov.b @r4+, r7
					add     r5, r7
					mov.w r8, r10
					cmp r7, r13
					jn greaterThan255
					mov.b r7, 0(r10)
					jmp checkForOperation
greaterThan255		mov.b #0xFF, r7
					mov.b r7, 0(r10)
					jmp checkForOperation







subFunction 	   mov.b @r4+, r7
				   sub     r7, r5
				   mov.w r8, r10
				   jn negAnswer
				   mov.b r5, 0(r10)
				   jmp checkForOperation

negAnswer  mov.b   #0x00, r7
				   mov.b r7, 0(r10)
				   jmp checkForOperation

mulFunction        mov.b @r4+, r7
			       mov.w r8, r10
				   mov.b r5, r14
				   mov.b r7, r11
multiplyLoop
				   cmp #0, r11
				   jz timesZero
				   cmp #1, r11
				   jz doneWithLoop
				   add r14, r5
				   dec r11
				   jmp multiplyLoop

doneWithLoop       cmp r5, r13
				   jn greaterThan255
				   mov.b r5, 0(r10)
				   jmp checkForOperation

timesZero		  mov.w #0x000, r5
				  mov.b r5, 0(r10)
				  jmp checkForOperation


clrFunction		   mov.w #0x0000, r5
				   mov.w r8, r10
				   mov.b r5, 0(r10)
				   jmp ifCleared


endProgram jmp endProgram
                                                 ; Main loop here
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
