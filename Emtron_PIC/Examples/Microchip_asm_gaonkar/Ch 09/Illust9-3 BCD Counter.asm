;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;This program counts in BCD from 0 to 59 at the interval of 100 ms and     	: 
;displays the count at two seven-segment LEDs               				:
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 	Title "BCD Digit Display"
 	List p=18F452, f =inhx32
 	#include <p18F452.inc>		;Header file for PIC18F452      
          				
COUNTER  	EQU		0x00		;Register 00 is used as a BCD counter 	
REG1		EQU		0x01		;Unpacked digits are saved in 
REG2		EQU		0x02		;REG1 and REG2
TEMP		EQU		0x03		;Temporary register for swapping nibbles
COUNT60		EQU		0x04		;Register to hold count for comparison
L1REG		EQU		0x10		;Reg10 and REG11 are used to 
L2REG		EQU		0x11		;load delay counts
 
			ORG		00			;Begin assembly
			GOTO	MAIN		;Program begins at 0020H

MAIN:		ORG		0x20   		;Begin assembly at memory location 000020H
 			CLRF	PORTB    	;Initial readings at PORTB & PORTC = 00
 			CLRF	PORTC
 			CLRF	TRISB    	;Set up PORTB and PORTC as output ports
 			CLRF	TRISC
REPEAT:		CLRF	COUNTER		;BCD count begins at zero
			MOVLW	0x60		;The count for comparison
			MOVWF	COUNT60		;Load count for comparison
 
START:		CALL	UNPACK		;Unpack the count
 			CALL	OUTLED 		;Display the count
 			MOVLW	D'200'		;Multiplier count for delay
 			MOVWF	L2REG
 			CALL	DELAY_100ms	;Wait for 100 ms 
 			CALL 	UPDATE		;Go to next count
 			CPFSEQ 	COUNT60		;Is count = 60, if yes, skip
 			GOTO 	START		;Go back to START to display
 			GOTO	REPEAT
 
UNPACK:		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 			;Function:	This subroutine unpacks the BCD count in COUNTER 	:
			;			and stores the unpacked digits in REG1 and REG2    	:            				:
 			;Input: 	Packed BCD Count in COUNTER               			:
 			;Output: 	Unpacked BCD in REG1 and REG2            			:
 		  	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 			MOVF	COUNTER,0,0	;Get count in W register
 			ANDLW 	0x0F		;Mask high-order nibble 
 			MOVWF	REG1,0	  	;Save low-order nibble in REG1 
 			MOVF	COUNTER,0	;Get count in W again
 			ANDLW	0xF0		;Mask low-order nibble
 			MOVWF	REG2,0		;Save high-order nibble in REG2
 			SWAPF	REG2,1,0	;Swap high-order nibble for proper unpacking
 			RETURN
 
OUTLED: 	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 			;Function:	OUTLED gets the unpacked BCD digits from REG1 and  	: 
			;			REG2, gets seven-segment code by calling another 	:		
			;			subroutine GETCODE and displays BCD digits at 		:
			;			PORTB and PORTC       								:
 			;Input: 	Unpacked BCD number in REG1 and REG2       			: 
 			;Calls another subroutine GETCODE                				:
       		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 			MOVF	REG1,0,0		;Get low-order BCD digit in W
 			CALL	GETCODE			;Find its seven-segment code
 			MOVFF 	TABLAT, PORTC 	;Display it at PORTC
 			MOVF	REG2,0,0		;Get high-order BCD
 			CALL	GETCODE			;Get its code
 			MOVFF	TABLAT, PORTB	; Display at PORTB
 			RETURN
 			
GETCODE:	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine gets an unpacked digit from WREG 	:
			;			and looks up its seven-segment code and stores it 	:
			;			in TABLAT   										:
 			;Input: 	Unpacked digit in W                   				:
 			;Output: 	Seven-segment LED code in TABLAT            		:
       		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 			MOVWF	TEMP
 			MOVLW	UPPER LEDCODE	;Copy upper 5 bits in Table Pointer of 
 			MOVWF	TBLPTRU			;21_bit address of LEDCODE 
 			MOVLW	HIGH LEDCODE	;Copy high 8 bit in Table Pointer
 			MOVWF	TBLPTRH
 			MOVLW	LOW LEDCODE		;Copy low 8 bits in Table Pointer
 			MOVWF	TBLPTRL
 			MOVF	TEMP, 0, 0		;Get BCD number to be displayed
 			ADDWF	TBLPTRL 		;Add BCD number to Table Pointer
 			TBLRD*					;Read LED code from memory
 			RETURN
 
LEDCODE:	DB	0xC0, 0xF9, 0xA4, 0xB0, 0x99 ; Code for digits 0 to 4
 			DB	0x92, 0x82, 0xF8, 0x80, 0x98 ; Code for digits 5 to 9
 
DELAY_100ms:;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 			;Function:	Provides 100 ms delay Clock Frequency: 10 MHz    	:
 			;Input: 	A multiplier count in register L2REG          		:
 			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 		
 	LOOP2:	MOVLW	D'250'		;Load decimal count in W
 			MOVWF	L1REG		;Set up Loop1 Register (L1REG) as a counter
 	LOOP1:	DECF	L1REG, 1	;Decrement count in L1REG 
 			BNZ		LOOP1		;Go back to LOOP1 if L1REG =/ 0
 			DECF 	L2REG, 1	;Decrement Loop2 Register (L2REG)
 			BNZ		LOOP2 		;Go back to load 250 in L1REG 
 			RETURN
 			
 
UPDATE: 	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 			;Function:	This subroutine increments count in COUNTER and 	:
			;			adjusts it as a BCD count                           :
 			;Input: 	BCD count in COUNTER               					:
 			;Output: 	Next adjusted BCD count in COUNTER        			:
       		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 			INCF	COUNTER,0,0	;Increment count
 			DAW					;Decimal adjust the count
 			MOVWF	COUNTER,0	;Save adjusted count in Counter
 			RETURN				;Go back
 			END



