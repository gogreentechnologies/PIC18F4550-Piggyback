
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;This is 12-hour clock program, designed to keep track of hours, minutes, and 
;seconds, and stores the decimal values of these variables as ASCII characters in 
;data registers. Timer0 is used to generate an interrupt every second, and the 
;interrupt service routine updates the time which is adjusted for BCD values, and
;equivalent ASCII characters of these BCD values in data registers.
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


	Title "Illust11-5: Designing a Clock" 	
       List p=18F452, f =inhx32	
       #include <p18F452.inc>	;This is a header file

		
SECONDS		RES		1		;Reserve one memory location each
MINUTES		RES		1
HOURS		RES		1

TEMP		EQU		0x00		;Temporary register used in BCDASCII routine
BUFFER0		EQU		0x01		;Registers to save BCD values
BUFFER1		EQU		0x02
TIME0		SET		0x10		;Save ASCII characters for Hours, 
								;Minutes, and Seconds

		ORG		00
		GOTO	MAIN

		ORG		0x08
		GOTO	CLK_ISR			;Go to interrupt service routine 
       							;to attend an interrupt from Timer0
       
       	ORG		0x20
MAIN:	CLRF	SECONDS			;Clear registers		
       	CLRF	MINUTES	
		CLRF	HOURS

		CLRF	INTCON3			;Disable all INT flags		
		CLRF	PIR1			;Clear all internal peripheral flags
		BSF		RCON,IPEN		;Enable priority - RCON <7>
		BSF		INTCON2,TMR0IP	;Set Timer0 as high-priority
		MOVLW	B'11100000'		;Set Timer0:global interrupt, high
		IORWF	INTCON,1		;priority, overflow, interrupt flag 
		MOVLW	B'10000110'		;Enable Timer0: 16-bit, internal clock,
		MOVWF	T0CON			;prescaler- 1:128

DELAY_1s:	;Sets up Timer0 to generate an interrupt every second  

		MOVLW	0xB3			;High count of B3B4H
		MOVWF	TMR0H			;Load high count in Timer0		
		MOVLW	0xB4			;Low count of B3B4H
		MOVWF	TMR0L			;Load low count in Timer0
		BCF 	INTCON, TMR0IF	;Clear TIMR0 overflow flag - Start counter
TIME:	MOVF	HOURS,W			;Converts Hours, Minutes, and Seconds				
		CALL	BCDASCII		;in ASCII characters and saves them in a table		
		MOVFF	BUFFER1,TIME0	;Save Hours in ASCII		
       	MOVFF	BUFFER0,TIME0+1		
       	MOVLW	0x3A			;ASCII for colon
		MOVWF	TIME0+2
		MOVF	MINUTES,W		
       	CALL 	BCDASCII		;ASCII for minutes
		MOVFF	BUFFER1,TIME0+3
		MOVFF	BUFFER0,TIME0+4
		MOVLW	0x3A			;ASCII for colon
		MOVWF	TIME0+5
       	MOVF	SECONDS,W		;ASCII for seconds
		CALL	BCDASCII
		MOVFF	BUFFER1,TIME0+6		
       	MOVFF	BUFFER0,TIME0+7
		BRA		TIME			

BCDASCII:;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function:	This subroutine converts BCD values from 0 to 9 in ASCII
		;			characters.
		;Input:		A packed BCD digit in register TEMP
		;Output:	An equivalent ASCII value in WREG
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
		MOVWF	TEMP		;Converts Hours, Minutes, and Seconds in 
		ANDLW	0x0F		;two ASCII characters each and saves them
		ADDLW	0x30		;in BUFFER0 and BUFFER1
		MOVWF	BUFFER0		
       	SWAPF	TEMP,W
		ANDLW	0x0F
		ADDLW	0x30
		MOVWF	BUFFER1
		RETURN

CLK_ISR:;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
       ;Function:	This is an interrupt service routine to update time. It 
       ;			loads count in TMR0 for one-second delay and updates the 
       ;			values of seconds, minutes, and hours and adjust them for 
       ;			BCD values.
       ;Input:		Time values in WREG
       ;Output:		Updated BCD values of time in WREG
       ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

		MOVLW	0xB3			;High count of B3B4H
		MOVWF	TMR0H			;Load high count in Timer0		
		MOVLW	0xB4			;Low count of B3B4H
		MOVWF	TMR0L			;Load low count in Timer0
		BCF 	INTCON, TMR0IF	;Clear TIMR0 overflow flag - Start counter

CLK_UPDATE:	
		INCF	SECONDS,W	;Update seconds
		DAW					;Adjust for BCD
		MOVWF	SECONDS
		SUBLW	0x60		;Is it 60 seconds?		
       	BTFSS	STATUS, Z	;If yes, go to minutes
		BRA		GOBACK

       	CLRF	SECONDS 	;Clear seconds
		INCF	MINUTES,W	;Update minutes		
       	DAW					;Adjust for BCD		
       	MOVWF	MINUTES 						
       	SUBLW	0x60		;Is it 60 minutes?		
       	BTFSS	STATUS, Z	;If yes, go to hours
		BRA		GOBACK

		CLRF	MINUTES 	;Clear minutes		
       	INCF	HOURS,W		;Update hours		
       	DAW					;Adjust for BCD		
       	MOVWF	HOURS		
       	SUBLW	0x13		;Is it the 13th hour?		
       	BTFSS	STATUS, Z	;If yes, load count 1 in hours		
       	BRA		GOBACK
		MOVLW  1			;Begin at 10 clock		
       	MOVWF  HOURS
GOBACK:	RETFIE   FAST		;Return		
       	END



