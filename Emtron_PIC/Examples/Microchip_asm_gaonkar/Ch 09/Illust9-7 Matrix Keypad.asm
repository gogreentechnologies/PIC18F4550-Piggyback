;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;This program is written as a subroutine.  It checks a key closure, 	:
;debounces multiple key contacts, and encodes the key in binary digit 	:
;that represents key's position    										:
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	Title "Illust9-7 Matrix Keypad"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	     	;This is a header file  
								  
                                

KYSOPEN		EQU		0x00			;Define data registers used
COUNTER		EQU		0x01
L1REG		EQU		0x10			;Registers for delay
L2REG		EQU		0x11
	
			ORG		0x20            ;Assemble at memory location 000020H
KEYPAD:		MOVLW	0x0F			;Enable RB7-RB4 as output and RB3-RB0
			MOVWF	TRISB			;as input
			BSF		INTCON2,7,0		;Enable pull-up resistors
			MOVLW	0xFF			;Load FFH, reading when all keys are open
			MOVWF	KYSOPEN
		
            ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            ;Function: KEYCHK checks first that all keys are open, then     :
			;checks a key closure, debounces the key, and saves the reading :
			;in KEYREG                                                      :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
KEYCHK:		MOVF	PORTB,0,0	;Read PORTB
			CPFSGT 	KYSOPEN		;Are all keys open?
			RETURN				;If yes, go back to check again
			MOVLW	D'40'		;Load 40 multiplier in L2REG to multiply 
			MOVWF	L2REG 		;  500 microsec delay in LOOP1
			CALL	DELAY_20ms 	;Wait 20 ms to debounce the key
		
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: KEYCODE encodes the key and identify the key position:                    :
		;Output: Encoded key position in W register                     :
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

KEYCODE:
COLRB4:		MOVLW	0xFF		;Get ready to scan Column RB4 
			IORWF	PORTB, F	;All other keys should be 1s
GNDB4:		BCF		PORTB, 4	;Ground Column - RB4
KEYB40:		BTFSS 	PORTB, 0	;Check RB0, if = 0, find code
			BRA		KEYB41 		;If RB0 = 1, check next key
			MOVLW	0x0C		;Code for Key 'C"
			RETURN
KEYB41:		BTFSC	PORTB, 1 	;Check RB1, if = 0, find code
			BRA		KEYB42		;If RB1 = 1, check next key
			MOVLW	0x8			;Code for key '8'
			RETURN
KEYB42:		BTFSC	PORTB, 2 	;Check RB2, if = 0, find code
			BRA		KEYB43		;If RB2 = 1, check next key
			MOVLW	0x4			;Code for key '4'
			RETURN
KEYB43:		BTFSC	PORTB, 3 	;Check RB3, if = 0, find code
			BRA		COLRB4		;If RB3 = 1, go to next column 
			MOVLW	0x0			;Code for key '0'
			RETURN
COLRB5:		MOVLW	0xFF		;Get ready to scan Column RB5 
			IORWF	PORTB, F	;All other keys should be 1s
GNDB5:		BCF		PORTB, 5	;Ground Column RB5
			BTFSC 	PORTB, 0	;Check RB0, if = 0, find code
			BRA		KEYB51 
			MOVLW	0x0D		
			RETURN
KEYB51:		BTFSC	PORTB, 1 	;Check RB1, if = 0, find code
			BRA		KEYB52
			MOVLW	0x9			
			RETURN
KEYB52:		BTFSC	PORTB, 2	;Check RB2, if = 0, find code
			BRA		KEYB53
			MOVLW	0x5			
			RETURN
KEYB53:		BTFSC	PORTB, 3 	;Check RB3, if = 0, find code
			BRA		COLRB5 		;If RB3 = 1, go to next column
			MOVLW	0x1
			RETURN
COLRB6:		MOVLW	0xFF		;Get ready to scan Column RB6
			IORWF	PORTB, F	;All other keys should be 1s
GNDB6:		BCF		PORTB, 6	;Ground Column RB6
			BTFSC 	PORTB, 0	;Check RB0, if = 0, find code
			BRA		KEYB61 
			MOVLW	0x0E
			RETURN
KEYB61:		BTFSC	PORTB, 1 	;Check RB1, if = 0, find code
			BRA		KEYB62
			MOVLW	0xA
			RETURN
KEYB62:		BTFSC	PORTB, 2 	;Check RB2, if = 0, find code
			BRA		KEYB63
			MOVLW	0x6
			RETURN
KEYB63:		BTFSC	PORTB, 3 	;Check RB3, if = 0, find code
			BRA		COLRB7		;If RB3 = 1, go to next column
			MOVLW	0x2
			RETURN
COLRB7:		MOVLW	0xFF		;Get ready to scan Column RB7
			IORWF	PORTB, F	;All other keys should be 1s
			BCF		PORTB, 7	;Ground Column RB7
KEY70:		BTFSC 	PORTB, 0	;Check RB0, if = 0, find code
			BRA		KEYB71 
			MOVLW	0x0F
			RETURN
KEYB71:		BTFSC	PORTB, 1 	;Check RB1, if = 0, find code
			BRA		KEYB72
			MOVLW	0xB
			RETURN
KEYB72:		BTFSC	PORTB, 2	 ;Check RB2, if = 0, find code
			BRA		KEYB73
			MOVLW	0x7
			RETURN
KEYB73:		BTFSC	PORTB, 3 	;Check RB3, if = 0, find code
			RETURN
			MOVLW	0x3
			RETURN
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: Provides 20 ms delay                                 :
		;Input: A multiplier count in register L2REG                    :
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

DELAY_20ms: 
		
LOOP2:		MOVLW	D'250'		;Load decimal count in W
			MOVWF	L1REG		;Set up Loop1_Register as a counter
LOOP1:		DECF	L1REG, 1	;Decrement count in L1REG 
			NOP
			NOP
			BNZ		LOOP1		;Go back to LOOP1 if L1REG  =/ 0
			DECF 	L2REG,1		;Decrement L2REG
			BNZ		LOOP2 		;Go back to load 250 in L1REG and start LOOP1
			RETURN
			END


