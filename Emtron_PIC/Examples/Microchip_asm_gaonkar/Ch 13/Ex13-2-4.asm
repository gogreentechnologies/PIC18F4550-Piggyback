	Title "Ch13-2-4 Echo"
	List p=18F4520
	#include <p18F452.inc>

	ORG	00

	CALL	EUSART
	CALL	ECHO
HERE	BRA	HERE

EUSART:

	BSF	TRISC, TX			;For 18F4520 RC6 and RC7 are set to 1
	BSF	TRISC, RX			;Control module changes configuration
							;as necessary. For 18F452, pins are set
							;diffrently
	MOVLW	B'00100000'		;Enable transmit, 8 bits, low-speed baud,
	MOVWF	TXSTA			;asynchronous mode
	MOVLW	D'15'			;Byte for 9600 baud
	MOVWF	SPBRG
	MOVLW	B'10010000'		;Enable serial port, 8 bits, receive enable,
	MOVWF	RCSTA			;No CHECK FOR framing or overrun error
	RETURN
ECHO:
RECEIVE: BTFSS PIR1, RCIF	;Check if new data byte arrived in RCREG
	BRA	RECEIVE		;If RCIF flag is not set, go back and wait
	MOVF	RCREG, W		;If a new data byte has arrived, save in W register

TRANSMT:BTFSS PIR1, TXIF	;Check if transmit register is empty
	GOTO	TRANSMT		;If not, wait until it is empty
	MOVWF	TXREG			;Write byte from W register into TXREG
	RETURN

	END
