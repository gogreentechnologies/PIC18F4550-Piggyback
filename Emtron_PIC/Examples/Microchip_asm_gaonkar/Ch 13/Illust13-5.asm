	Title "PIC18F452 Illust 13-5"
	List p=18F452
	#include <p18F452.inc>	;This is a header file for  and must be included 
							;in the Source Program

;This program copies 16 bytes of data (1 page) from data registers with the 
;starting address 50H into EEPROM with the starting address 0010H
;EEPROM used is 25LC040 - 256x8 - address range - 000 - 1FFH

CSPROM		EQU	0			;RC0 is used as chip select to access EEPROM
OUTREG		EQU	0x20			;Register used to transmit a byte
INREG		EQU	0x21			;Register used to receive a byte 
COUNTER		EQU	0x22			;Number of bytes loaded here
HI_ADDR		EQU	0x00			;EEPROM starting address 0010H
LO_ADDR		EQU	0x10
DATA_REG	EQU	0x50			;Bytes to be copied are stored from 50H to 5FH 

RD_CMD		EQU	B'00000011'		;Read data from memory beginning at selected address
WR_CMD 		EQU	B'00000010'		;Write data to memory beginning at selected address
WRDI_CMD	EQU	B'00000100'		;Disable latch
WREN_CMD	EQU	B'00000110'		;Enable latch
RD_STATUS	EQU	B'00000101'		;Read status register
WIP			EQU	0			;Write-in progress bit in status register

			ORG	00
			GOTO 	MAIN

			ORG	0x20

MAIN:		RCALL	SETUP			;Initialize MSSP in SPI mode
			RCALL	WR_ENABLE		;Enable latch
			RCALL	CHK_STATUS		;Check whether write-in process is on
			LFSR  	FSR0,DATA_REG	;Set up memory pointer for data register
			RCALL	PAGE_WR		;Transfer 16 bytes (one page)
			RCALL	WR_DSABLE		;Disable latch
HERE		BRA		HERE

		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;This subroutine initializes MMSP module in the SPI mode and PORTC    :
		;  pins as inputs and outputs as necessary. It disables global and    :
		;  peripheral interrupts and sets bits in SSPCON1 and SSPSTAT         :               
		;  registers to enable serial communication in the SPI mode           :
 		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

SETUP:	CLRF	PORTC			;Clear any previous settings
		CLRF	PIE1			;Disable peripheral interrupts
		CLRF	INTCON		;Disable all interrupts
		CLRF	SSPCON1		;Clear SSPCON1 and SSPSTAT
		CLRF	SSPSTAT
		BSF	PORTC,CSPROM	;Disable memory access

		MOVLW	B'00010000'		;All bits of PORTC are outputs except 
		MOVWF	TRISC			;  SDI <4>
		MOVLW	B'00110000'		;Enable synchronous serial communication in  
		MOVWF	SSPCON1		;  Master mode, Clock ÿ– idle state high
		MOVLW	B'10000000'		;Sample data at end of pulse, transmit data on  
		MOVWF	SSPSTAT		;  rising edge
		RETURN

		;Function: This subroutine enables the latch.  It sends WREN command   
		;          by calling the subroutine OUT

WR_ENABLE:	
		BCF	PORTC, CSPROM	;Access EEPROM by asserting RC0
		MOVLW	WREN_CMD 		;Copy latch enable command in OUTREG
		MOVWF	OUTREG		
		RCALL	OUT			;Send command to EEPROM
		BSF	PORTC, CSPROM	;Disable EEPROM by asserting RC0 high
		RETURN

		;Function:  This subroutine disables the latch by sending WRDI command
		;		Calls OUT subroutine

WR_DSABLE:	BCF	PORTC, CSPROM 	;Access EEPROM by asserting RC0 low
		MOVLW	WRDI_CMD 		;Copy latch disable command in OUTREG
		MOVWF	OUTREG
		RCALL	OUT			;Send command to EEPROM
		BSF	PORTC, CSPROM	;Disable EEPROM by asserting RC0 high
		RETURN

;Function: This subroutine copies 16 bytes starting from data RAM      ;         (50H)into EEPROM starting from 0010H.  
;Input:   FSR0 as memory pointer to the starting data register (50H)
;	    Calls OUT subroutine

PAGE_WR	BCF	PORTC, CSPROM	;Access EEPROM by asserting RC0 low 
		MOVLW	WR_CMD		;Copy write command in OUTREG
		MOVWF	OUTREG
		RCALL	OUT			;Send write command
		MOVLW	HI_ADDR		;EEPPROM starting address 0010H
		MOVWF	OUTREG
		RCALL	OUT			;Send high address
		MOVLW	LO_ADDR		
		MOVWF	OUTREG
		RCALL	OUT			;Send low address
		MOVLW	D'16'			;Number of bytes
		MOVWF	COUNTER		;Load in the counter
NEXT:		MOVFF	POSTINC0, OUTREG	;Copy data in OUTREG, increment memory, and
		RCALL	OUT			;  send data byte
		DECF	COUNTER,F		;Reduce the count by one
		BNZ	NEXT			;Is COUNTER = 0, if not, go back to copy next data
		BSF	PORTC, CSPROM	;Deselect EEPROM by asserting RC0 high
		RETURN

		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: This subroutine checks the WIP (Write-in Process) bit 
		;	     It reads the status register and checks WIP in SSPBUF
		;	     It stays in the loop until the WIP bit is cleared.
		;	     Calls OUT subroutine	
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CHK_STATUS:	BCF	PORTC, CSPROM	
		MOVLW	RD_STATUS		;Read status
		MOVWF	OUTREG
		RCALL	OUT
		MOVLW	00			;Send a dummy Byte
		MOVWF	OUTREG
		RCALL	OUT
		BSF	PORTC, CSPROM
		BTFSC	SSPBUF,WIP		;Is WIP cleared, if not continue checking
		BRA	CHK_STATUS
		BSF	PORTC, CSPROM
		RETURN

		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: This subroutine sends a byte to EEPROM by loading it in
; 	     SSPBUF register and checks the BF (Buffer Full) flag
;	     in SSPSTAT register.  The subroutine stays in the loop until 
;	     the byte is received and the flag is set.  
;Input:    A byte in W register
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

OUT:		MOVF	OUTREG, W
		MOVWF	SSPBUF
CHK_FLAG	BTFSS	SSPSTAT, BF
		BRA	CHK_FLAG
		MOVF	SSPBUF, W
		MOVWF	INREG			;This is byte received to be ignored
		RETURN
			
		END

