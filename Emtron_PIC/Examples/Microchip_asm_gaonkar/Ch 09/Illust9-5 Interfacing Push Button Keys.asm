;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;This program checks a key closure, debounces multiple key contacts,   :
;and encodes the key in binary digit that represents key's position    :
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	Title "Reading Push Button Keys"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	     	;This is a header file that defines 
								 	;SFR registers  
                                

KYSOPEN		EQU		0x00			;Define data registers used
KYREG 		EQU		0x01
COUNTER		EQU		0x02
SimReg		EQU		0x03
L1REG		EQU		0x10			;Registers for delay
L2REG		EQU		0x11
	
			ORG		00
			GOTO	START 
	
			ORG		0x20            ;Assemble at location 000020H
START:		SETF	TRISB			;Set up PORTB as an input port
			BSF		INTCON2,7,0		;Enable pull-up resistors
			SETF	KYSOPEN,0		;Load FFH, reading when all keys are open
		
NEXT:		CALL	KEYCHK			;Check a key closure
			CALL	KEYCODE 		;Encode the key number
			GOTO	NEXT			;Wait
			
		
KEYCHK:     ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            ;Function:	KEYCHK checks first that all keys are open, then    :
			;			checks a key closure, debounces the key, and saves 	:
			;			the reading in KEYREG								:                                                      :
			;Output: 8-bit reading of a key closure in KEYREG               :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
			MOVF	PORTB,W,0		;Read PORTB		
			CPFSEQ 	KYSOPEN			;Are all keys open?		
			BRA		KEYCHK			;If yes, go back to check again		
			MOVLW	D'40'			;Load 40 multiplier in L2REG to multiply 
			MOVWF	L2REG 			;  500 microsec delay in LOOP1		
			CALL	DELAY_20ms 		;Wait 20 ms to debounce the key
KEYLOW:		MOVF	PORTB,W,0		;Read PORTB to check key closure again
			MOVWF	KYREG,0			;Save the reading 
			CPFSGT 	KYSOPEN 		;Is reading in W less than FFH
			BRA		KEYLOW 			;If no, go back and read again
			MOVLW	D'40'			;If yes, debounce the key - wait 20 ms
			MOVWF	L2REG 
			CALL	DELAY_20ms
			MOVF	PORTB,W,0		;Read PORTB again
			CPFSEQ 	KYREG			;Is it same as before?		
			BRA 	KEYLOW			;If no, it is a false reading		
			RETURN					;If yes, return with a reading	

KEYCODE:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	KEYCODE encodes the key and identify the key position:
			;Input: 	Key closure reading in KEYREG                        :
			;Output: 	Encoded key position in W register                   :
			;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

			SETF 	COUNTER 		;Set Counter to FFH
NEXTKEY:	INCF	COUNTER,1,0		;Begin with 00 count after increment		
			RRCF	KYREG,1,0		;Rotate right input reading through Carry		
			BC		NEXTKEY			;If Bit = 1, rotate again
			MOVF	COUNTER,0,0		;Found zero, save in W
			RETURN

DELAY_20ms:	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function: Provides 20 ms delay                                 :
			;Input: A multiplier count in register L2REG                    :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 		
LOOP2:		MOVLW	D'250'		;Load decimal count in W		
			MOVWF	L1REG		;Set up Loop1_Register as a counter
LOOP1:		DECF	L1REG, 1	;Decrement count in L1REG 
			NOP					;Insructions added to get 
			NOP					;500 micro-sec delay 
			BNZ		LOOP1		;Go back to LOOP1 if L1REG = 0
			DECF 	L2REG,1		;Decrement L2REG
			BNZ		LOOP2 		;Go back to load 250 in L1REG and start LOOP1
			RETURN
			END


		

