	Title "Illust10-3"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file 

REG1		EQU	0x01				;Define Registers	
STATUS_TEMP	EQU	0x100
WREG_TEMP	EQU	0x101
	

		ORG		0x00
		GOTO	MAIN

		ORG		0x0008				;High Priority Interrupt Vector
INTCK:	GOTO	INT1_ISR			;Go to ISR

		ORG		0x00018				;Low-priority Interrupt Vector
TIMERCK:BTFSC	PIR1,TMR1IF			;Check Timer1 flag - skip if it is clear
		GOTO	TMR1_ISR			;If Timer1 flag set, go to its ISR
		BTFSC	PIR1,TMR2IF			;Check Timer2 flag - skip if it is clear
		GOTO	TMR2_ISR			;If Timer2 flag set, go to its ISR

MAIN:	MOVLW	B'00111111'			;Binary bits to setup PORTB 
		MOVWF	TRISB				;Intialize Bits 6 & 7 of PORTB as output
		BSF		RCON, 	 IPEN		;Enable priority -RCON <7>
		BSF		INTCON,  GIEH		;Enable global high-priority -INTCON <7>
		BSF		INTCON2, INTEDG1	;Interrupt on rising edge-INTCON2 <5>
		BSF		INTCON3, INT1IP		;Set high priority for INT1-INTCON3 <6>
		BSF		INTCON3, INT1IE		;Enable Interrupt1- INTCON3 <3>

		BSF		INTCON, GIEL		;Enable global low-priority - INTCON ,6>
		BCF		IPR1, TMR1IP		;Set Timer1 as low-priority
		BSF		PIE1, TMR1IE		;Enable Timer1 overflow interrupt		
		BCF		IPR1, TMR2IP		;Set Timer2 as low-priority
		BSF		PIE1, TMR2IE		;Eanable Timer2 match interrupt

		MOVLW	D'10'				;Set up REG1 to count 10
		MOVWF	REG1,0
HERE:	GOTO	HERE				;Wait here for an interrupt

		ORG		0x100
INT1_ISR
		BCF		INTCON3, INT1IF		;Clear INT1 flag
		DECF	REG1,1,0			;Count key press
		BNZ		GOBACK				;If count =/0, goback
		MOVLW	D'10'				;Set counter again at 10
		MOVWF	REG1,0
		BSF		PORTB,7				;Turn on LED
GOBACK:	RETFIE	FAST				;Retrieve registers and go back

TMR1_ISR
		MOVFF	STATUS, STATUS_TEMP	;Save registers
		MOVWF	WREG_TEMP
		BCF		PIR1, TMR1IF			;Clear TMR1 flag
		CALL	TMR1L				;Call service subroutine
		MOVF	WREG_TEMP, W		;Retrieve registers
		MOVFF	STATUS_TEMP,STATUS
		RETFIE						;Go back to main
TMR2_ISR
		MOVFF	STATUS, STATUS_TEMP	;Save registers
		MOVWF	WREG_TEMP
		BCF		PIR1,TMR2IF			;Clear TMR2 flag
		CALL	TMR2				;Call service subroutine
		MOVF	WREG_TEMP, W		;Retrieve registers
		MOVFF	STATUS_TEMP,STATUS
		RETFIE						;Go back to main

TIMER1:	;Timer1 subroutine begins here
		;
TIMER2:	;Timer2 subroutine begins here

		END
