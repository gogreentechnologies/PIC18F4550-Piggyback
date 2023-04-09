;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;This program displays time on the LCD.  The time is stored as ten     :
;ASCII characters in data registers labeled as TIME. The program       :
;initializes the LCD, checks the data line DB7.  When DB7 is low, it   :
;sends out instructions and data for display.                          : 
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	Title "Illust9-6 Interfacing LCD"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	    	;This is a header file that defines                                
									;  SFR register values 
                                
DATAPORT	EQU		PORTD			;Define PORTD as data port	
TEMP		EQU		0x10			;Temprarory register to store values 
DELAY_REG	EQU		0x11			;Register that holds delay count
MSG_COUNTR	EQU		0x12			;Register that holds number of display chracters
CURSOR		EQU		0xC7			;8th Location - 2nd line of DD RAM to start message
COUNT		EQU		D'250'
TIME		SET		0x30			;Data registers where time chracters are stored

#DEFINE		DB7		PORTD, 7		;DB7 is defined to check flag
#DEFINE		E		PORTA, 1		;Enable line 
#DEFINE		RW		PORTA, 2		;Read/Write line - Read high and Write low
#DEFINE		RS		PORTA, 3		;Register select - low for IR and high for DR


			ORG		00				;Reset memory location
			GOTO	0x20			;Main program begins at 000020H
				
			ORG		0x20        	;Assemble at memory location 000020H
MAIN:		CALL	LCD_SETUP		;Initialize LCD parameters	
			MOVLW	CURSOR			;Starting location of the message
			CALL	LCD_CMD			;Place cursor at desired location
			MOVLW	D'05'			;Number of characters to display
			MOVWF	MSG_COUNTR		;Load # in counter
			LFSR	FSR0, TIME		;Set up data pointer
NEXT:		MOVF	POSTINC0,W		;Get character in W and increment pointer
			CALL	LCD_DATA		;Send display character to LCD 
			DECF	MSG_COUNTR,1	;Decrement counter
			BNZ		NEXT			;Is counter = 0? If not, get next chracter
HERE:		BRA		HERE			;Done - stay here

			
LCD_SETUP:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine sends out initial instructions,:     
			;			provides sufficient delay for the LCD to get   : 
			;			ready, and again sends out various instructions:
			;			to set up the LCD parameters such as the number: 
			;			of lines, size of the character, and the cursor: 
			;			increment.                                     :
			;Calls:		Subroutines DELAY, LCD_OUT, AND LCD_CMD        :
			;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
			MOVLW	D'15'			;Count for 1.5 ms delay
			MOVWF	DELAY_REG		;Load count in Delay Register
			CALL	DELAY			;Wait for 1.5 ms 
			MOVLW	B'00110000'		;First instruction to LCD
			MOVWF	TEMP			;  to set up 8-bit mode interface
			CALL	LCD_OUT			;Send instruction
			MOVLW	D'45'			;Count for 4.5 ms delay
			MOVWF	DELAY_REG
			CALL	DELAY			;Wait 4.5 ms 
			MOVF	TEMP,W			;Get same instruction from TEMP 
			CALL	LCD_OUT			;Send it out again
			MOVLW	D'01'			;Count for 100 micro-sec delay
			MOVWF	DELAY_REG
			CALL	DELAY			;Wait for 100 micro-sec
			MOVF	TEMP,W			;Get same instruction from TEMP
			CALL	LCD_OUT			;Send it out again
			MOVLW	B'00111000'		;Code (38H) - 8 bits, 2 lines, and  
			CALL	LCD_CMD			;  5x7 dots				
			MOVLW	B'00001000'		;Code (08H) - Turn off display and 
			CALL	LCD_CMD			;  cursor
			MOVLW	B'00000001'		;Code (01H) - Clear display
			CALL	LCD_CMD
			MOVLW	B'00000110'		;Code (06H) - Entry mode, shift and
			CALL	LCD_CMD			;  increment cursor
			MOVLW	B'00001100'		;Code (0CH) - Turn on display 
			CALL	LCD_CMD			;  without cursor blinking
			RETURN

LCD_CMD:	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine checks DB7 by calling the CHK_FLAG: 
			;			subroutine, and when the DB7 goes low, this       :
			;			subroutine accesses the instruction register and  :
			;			sends out a command.                              :
			;Input:		Command code in W register                        :
			;Calls:		Subroutine CHK_FLAG                               :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::			
			
			MOVWF	TEMP			;Save command code in W register
			CALL	CHK_FLAG		;Check if DB7 is low 
LCD_OUT:	BCF		RS				;Select Instruction Register (IR)
			BCF		RW				;Set /Write low 
			BSF		E				;Set Enable high
			MOVF	TEMP,W			;Get command code in W register
			MOVWF	DATAPORT		;Send command
			BCF		E				;Assert Enable low to latch command in IR
			RETURN

LCD_DATA:	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine checks DB7 by calling the CHK_FLAG: 
			;			subroutine, and when the DB7 goes low, this       : 
			;			subroutine accesses the data register and sends   :
			;			out an ASCII code.                                :
			;Input:		ASCII code in W register                          :
			;Calls:		Subroutine CHK_FLAG                               :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	

			MOVWF	TEMP			;Save ASCII code in W register	
			CALL	CHK_FLAG		;Check if DB7 is low
			BSF		RS				;Select Data Register (DR)
			BCF		RW				;Set Write low
			BSF		E				;Set Enable high
			MOVF	TEMP,W			;Grt ASCII code in W register
			MOVWF	DATAPORT		;Send ASCII code
			BCF		E				;Assert Enable low to latch code
			RETURN	

CHK_FLAG:	;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine initializes PORTD as an input port  :
			;			and checks DB7 to verify whether the LCD 			:
			;			is busy in completing the previous operation.  It   :
			;			continues to check the DB7 until it goes low        :
			;			indicating that the LCD is free to accept the next  :
			;			byte. It reinitializes PORTD as an output port and  :
			;			returns.                                            :
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

			SETF	TRISD			;Set data port PORTD as input
			BCF		RS				;Assert RS low to select Instruction Register
			BSF		RW				;Set R/W high to read DB7 flag
READ:		BSF		E				;Set Enable high
			NOP						;Stretch E pulse with a small delay
			BCF		E				;Question Here: Is bit checking same as reading?
			MOVF	DATAPORT, W
			BTFSC	DB7				;Check if LCD busy
			BRA		READ			;If yes, go back and check again
			CLRF	TRISD			;Set data port PORTD as output		
			RETURN
			
DELAY:		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			;Function:	This subroutine provides multiples of 100 micro-sec :
			;			delay.  The count in DELAY_REG determines the 		:
			;			delay multiples. The clock is assumed to be 10 MHz.	:
			;			Refer Section 5.4 for delay calculations			:
			;Input:		Count in DELAY_REG  								:
			;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

LOOP:		MOVLW	COUNT			;Delay count for 100 micro-second 
LOOP1:		DECF	WREG, 0			;Decrement count
			NOP						;Instruction to increase delay
			BNZ		LOOP1			;Is count = 0? If not, repeat LOOP1
			DECF	DELAY_REG,1		;Decrement delay multiple
			BNZ		LOOP			;Is multiple = 0? If not, repeat.
			RETURN
			END
