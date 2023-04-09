 
; This program demonstrates basic functionality of the USART.
;
; Port D is connected to 8 LEDs. 
; When the PIC18C452 receives a word of data from
; the USART, the value is displayed on the LEDs and
; is retransmitted to the host computer.
;
; Set terminal program to 9600 baud, 1 stop bit, no parity

#include<p18f4450.inc>

	CONFIG WDT=OFF; disable watchdog timer
	CONFIG MCLRE = ON; MCLEAR Pin on
	CONFIG DEBUG = OFF; Enable Debug Mode
	CONFIG LVP = OFF; Low-Voltage programming disabled (necessary for debugging)
	CONFIG FOSC = INTOSCIO_EC;Internal oscillator, port function (Digital I/O) on RA6 Page 25 (INTIO)
	


;************************************************************
; Reset and Interrupt Vectors

	org	00000h	; Reset Vector
	goto	Start

	org	00008h	; Interrupt vector
	goto	IntVector

;************************************************************
; Program begins here

	org	00020h	; Beginning of program 
	
Start
	clrf	LATD	; Clear PORTD output latches
	clrf	TRISD 	; Config PORTD as all outputs

	bcf	TRISC,6	; Make RC6 an output (TxD Pin)

	movlw	25	; 9600 baud @4MHz Page 246 Baud Rate = FOSC/[16 (n + 1)]
	movwf	SPBRG
	
	bsf	TXSTA,TXEN	; Enable transmit
	bsf	TXSTA,BRGH	; Select high baud rate
	bcf	TXSTA,BRG16	; Select 8-bit baud rate
	
	
	bsf	RCSTA,SPEN	; Enable Serial Port
	bsf	RCSTA,CREN	; Enable continuous reception

	bcf	PIR1,RCIF	; Clear RCIF Interrupt Flag
	bsf	PIE1,RCIE	; Set RCIE Interrupt Enable
	bsf	INTCON,PEIE	; Enable peripheral interrupts
	bsf	INTCON,GIE	; Enable global interrupts

;************************************************************
; Main loop

Main
	goto	Main	; loop to self doing nothing

;************************************************************
; Interrupt Service Routine

IntVector
	; save context (WREG and STATUS registers) if needed.

	btfss	PIR1,RCIF	; Did USART cause interrupt?
	goto	OtherInt	; No, some other interrupt

	movlw	06h		; Mask out unwanted bits
	andwf	RCSTA,W		; Check for errors
	btfss	STATUS,Z	; Was either error status bit set?
	goto	RcvError	; Found error, flag it

	movf	RCREG,W		; Get input data
	movwf	LATD		; Display on LEDs
	movwf	TXREG		; Echo character back
	goto	ISREnd		; go to end of ISR, restore context, return
	
RcvError
	bcf	RCSTA,CREN	; Clear receiver status
	bsf	RCSTA,CREN
	movlw	0FFh		; Light all LEDs
	movwf	PORTD	
	goto	ISREnd	; go to end of ISR, restore context, return

OtherInt
	goto	$	; Find cause of interrupt and service it before returning from
			; interrupt. If not, the same interrupt will re-occur as soon
			; as execution returns to interrupted program.

ISREnd
	; Restore context if needed.
	retfie

	end

