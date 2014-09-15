;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;Alex Leaf
;ECE 382
;Lab 1 Calculator
;14 September 2014
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text


function:   .byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x44, 0x22, 0x22, 0x22, 0x11, 0xCC, 0x55; input function
add:        .byte 0x11																	;stored values for what function
sub:        .byte 0x22																	;to do
mul:        .byte 0x33
clr:        .byte 0x44
end:        .byte 0x55
big:        .byte 0xFF
            .retain
            .data
.space
result:     .space 50																    ;stored space in memory for anwers

                                             ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                                   ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
           			mov.w #function, r4        ;input first values into registers to use for functions
           			mov.w #result, r8
		 			mov.b @r4+, r5
           			mov.b @r4+, r6
           			mov.b big, r13
           			jmp firstIteration

checkForOperation	mov.b @r10, r5			    ; check for which operation to perform
					mov.b @r4+, r6
					mov.w @r8, r10
					inc r8
					jmp firstIteration

ifCleared			mov.b @r4+, r5				;operation performed in clear was encountered
           			mov.b @r4+, r6
					mov.w @r8, r10
					inc r8


firstIteration		cmp.b end, r6						;compares to check for which operation to perform
					jz endProgram

					cmp.b clr, r6
					jz clrFunction

					cmp.b add, r6
					jz         addFunction

					cmp.b sub, r6
					jz         subFunction

					cmp.b mul, r6
					jz mulFunction




addFunction         mov.b @r4+, r7					;function to perform operation
					add     r5, r7
					mov.w r8, r10
					cmp r7, r13
					jn greaterThan255
					mov.b r7, 0(r10)
					jmp checkForOperation
greaterThan255		mov.b #0xFF, r7					; function to perform if the answer was greater than 0xFF
					mov.b r7, 0(r10)
					jmp checkForOperation







subFunction 	   mov.b @r4+, r7					;function to perform for subtraction
				   sub     r7, r5
				   mov.w r8, r10
				   jn negAnswer
				   mov.b r5, 0(r10)
				   jmp checkForOperation

negAnswer  mov.b   #0x00, r7						;  function to perform if a negatvie answer was encountered
				   mov.b r7, 0(r10)
				   jmp checkForOperation

mulFunction        mov.b @r4+, r7					;function to perform for multiplication
			       mov.w r8, r10
				   mov.b r5, r14
				   mov.b r7, r11
multiplyLoop										;loop for multiplication function
				   cmp #0, r11
				   jz timesZero
				   cmp #1, r11
				   jz doneWithLoop
				   add r14, r5
				   dec r11
				   jmp multiplyLoop

doneWithLoop       cmp r5, r13						;jumped here when multiplication loop finished and stored final answer
				   jn greaterThan255
				   mov.b r5, 0(r10)
				   jmp checkForOperation

timesZero		  mov.w #0x000, r5					;function if multiplication operand was zero
				  mov.b r5, 0(r10)
				  jmp checkForOperation


clrFunction		   mov.w #0x0000, r5				; funtion if clear was encountered, stored 0x00 in memory
				   mov.w r8, r10
				   mov.b r5, 0(r10)
				   jmp ifCleared


endProgram jmp endProgram							;end program loop

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
